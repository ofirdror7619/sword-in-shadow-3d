from __future__ import annotations

import argparse
import ast
import hashlib
import json
import re
import shutil
import subprocess
import sys
import tempfile
from dataclasses import dataclass
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
OUTPUT_DIR = ROOT / "assets" / "audio" / "whispers"
MANIFEST_PATH = OUTPUT_DIR / "manifest.json"

FALLBACK_VOICE_LINES = (
    "Done.",
    "Relic gained.",
    "Map revealed.",
    "Spell learned.",
    "Gold gained.",
    "Experience gained.",
    "Experience gained. Stronger again.",
    "Diamond gained.",
    "Diamond claimed.",
    "Already etched into you. It became gold.",
    "Disappointing.",
)


@dataclass(frozen=True)
class WhisperLine:
    key_text: str
    spoken_text: str
    source: str


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Generate Coqui TTS clips for The Whisper and process them into game-ready MP3s."
    )
    parser.add_argument("--model", default="tts_models/en/vctk/vits", help="Coqui model name.")
    parser.add_argument("--speaker", default="p225", help="Speaker id for multi-speaker Coqui models.")
    parser.add_argument("--language", default="", help="Optional language id for multilingual models.")
    parser.add_argument("--engine", choices=("auto", "coqui", "sapi"), default="auto", help="TTS engine to use.")
    parser.add_argument("--sapi-voice", default="Microsoft Zira Desktop", help="Windows SAPI voice name.")
    parser.add_argument("--force", action="store_true", help="Regenerate clips even if they already exist.")
    parser.add_argument("--dry-run", action="store_true", help="Only list collected lines.")
    parser.add_argument("--limit", type=int, default=0, help="Generate only the first N lines.")
    args = parser.parse_args()

    lines = collect_whisper_lines()
    if args.limit > 0:
        lines = lines[: args.limit]

    print(f"Collected {len(lines)} whisper lines.")
    if args.dry_run:
        for index, line in enumerate(lines, start=1):
            print(f"{index:03d} [{line.source}] {line.spoken_text}")
        return 0

    if shutil.which("ffmpeg") is None:
        print("ffmpeg was not found on PATH. Install ffmpeg before generating whisper clips.", file=sys.stderr)
        return 2

    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
    tts = None
    engine = args.engine
    if engine in ("auto", "coqui"):
        try:
            from TTS.api import TTS

            tts = TTS(args.model)
            engine = "coqui"
        except Exception as exc:
            if args.engine == "coqui":
                print("Coqui TTS could not be started.", file=sys.stderr)
                print("Recommended setup:", file=sys.stderr)
                print("  py -3.10 -m venv .venv-tts", file=sys.stderr)
                print("  .\\.venv-tts\\Scripts\\python -m pip install --upgrade pip", file=sys.stderr)
                print("  .\\.venv-tts\\Scripts\\python -m pip install TTS", file=sys.stderr)
                print("  .\\.venv-tts\\Scripts\\python tools\\generate_whisper_tts.py", file=sys.stderr)
                print(f"Error: {exc}", file=sys.stderr)
                return 3
            print(f"Coqui TTS unavailable, falling back to Windows SAPI: {exc}")
            engine = "sapi"
    if engine == "sapi" and sys.platform != "win32":
        print("Windows SAPI TTS is only available on Windows.", file=sys.stderr)
        return 4

    manifest: dict[str, str] = {}
    if MANIFEST_PATH.exists():
        manifest = json.loads(MANIFEST_PATH.read_text(encoding="utf-8"))

    generated = 0
    skipped = 0
    with tempfile.TemporaryDirectory(prefix="sworn_whisper_tts_") as temp_name:
        temp_dir = Path(temp_name)
        for line in lines:
            clip_path = OUTPUT_DIR / clip_filename(line.key_text)
            res_path = "res://" + clip_path.relative_to(ROOT).as_posix()
            manifest[line.key_text] = res_path
            if clip_path.exists() and not args.force:
                skipped += 1
                continue

            raw_wav = temp_dir / (clip_path.stem + ".raw.wav")
            print(f"Generating {clip_path.name}: {line.spoken_text}")
            if engine == "coqui":
                kwargs = {"text": line.spoken_text, "file_path": str(raw_wav)}
                if args.speaker:
                    kwargs["speaker"] = args.speaker
                if args.language:
                    kwargs["language"] = args.language
                tts.tts_to_file(**kwargs)
            else:
                synthesize_with_sapi(line.spoken_text, raw_wav, args.sapi_voice)
            process_with_ffmpeg(raw_wav, clip_path)
            generated += 1

    MANIFEST_PATH.write_text(json.dumps(manifest, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    print(f"Generated {generated}, skipped {skipped}.")
    print(f"Wrote {MANIFEST_PATH.relative_to(ROOT)}")
    return 0


def collect_whisper_lines() -> list[WhisperLine]:
    found: dict[str, WhisperLine] = {}

    intro_lines = read_whisper_text_file(ROOT / "theWhisper" / "introduction.txt")
    if intro_lines:
        add_line(found, " ".join(intro_lines), "theWhisper/introduction.txt")

    for name in ("after-killing.txt", "waiting.txt"):
        for line in read_whisper_text_file(ROOT / "theWhisper" / name):
            add_line(found, line, f"theWhisper/{name}")

    for path in (ROOT / "scripts").glob("*.gd"):
        text = path.read_text(encoding="utf-8", errors="replace")
        for literal in extract_signal_reaction_strings(text):
            add_line(found, literal, path.relative_to(ROOT).as_posix())
        for literal in extract_say_whisper_literals(text):
            if "%s" not in literal and "%.0f" not in literal:
                add_line(found, literal, path.relative_to(ROOT).as_posix())
        if path.name == "HUD.gd":
            for literal in extract_corruption_stage_lines(text):
                add_line(found, literal, path.relative_to(ROOT).as_posix())

    for line in FALLBACK_VOICE_LINES:
        add_line(found, line, "tools/generate_whisper_tts.py")

    return sorted(found.values(), key=lambda line: (line.source, line.key_text.lower()))


def read_whisper_text_file(path: Path) -> list[str]:
    if not path.exists():
        return []
    lines: list[str] = []
    for raw_line in path.read_text(encoding="utf-8", errors="replace").splitlines():
        line = clean_wrapped_text(raw_line)
        if line:
            lines.append(line)
    return lines


def extract_say_whisper_literals(text: str) -> list[str]:
    return extract_call_string_literals(text, "_say_whisper")


def extract_signal_reaction_strings(text: str) -> list[str]:
    return extract_call_string_literals(text, "reaction_requested.emit")


def extract_call_string_literals(text: str, call_name: str) -> list[str]:
    escaped = re.escape(call_name)
    pattern = re.compile(rf"{escaped}\(\s*(\"(?:[^\"\\]|\\.)*\")", re.MULTILINE)
    values: list[str] = []
    for match in pattern.finditer(text):
        try:
            values.append(clean_wrapped_text(ast.literal_eval(match.group(1))))
        except Exception:
            continue
    return [value for value in values if value]


def extract_corruption_stage_lines(text: str) -> list[str]:
    match = re.search(r"const\s+CORRUPTION_STAGE_LINES\s*:=\s*\[(.*?)\]", text, re.DOTALL)
    if not match:
        return []
    values: list[str] = []
    for literal in re.findall(r"\"(?:[^\"\\]|\\.)*\"", match.group(1)):
        try:
            values.append(clean_wrapped_text(ast.literal_eval(literal)))
        except Exception:
            continue
    return [value for value in values if value]


def add_line(found: dict[str, WhisperLine], text: str, source: str) -> None:
    key_text = clean_wrapped_text(text)
    if not key_text or key_text in found:
        return
    found[key_text] = WhisperLine(key_text=key_text, spoken_text=clean_for_tts(key_text), source=source)


def clean_wrapped_text(value: str) -> str:
    text = value.replace("\r", "").strip().lstrip("\ufeff").strip()
    if len(text) >= 2 and text[0] == text[-1] and text[0] in {"'", '"'}:
        text = text[1:-1].strip()
    if len(text) >= 2 and ((text[0] == "\u201c" and text[-1] == "\u201d") or (text[0] == "\u2018" and text[-1] == "\u2019")):
        text = text[1:-1].strip()
    return text


def clean_for_tts(value: str) -> str:
    replacements = {
        "\u201c": '"',
        "\u201d": '"',
        "\u2019": "'",
        "\u2018": "'",
        "\u2026": "...",
        "\u2014": "-",
        "\u2013": "-",
        "â€œ": '"',
        "â€\u009d": '"',
        "â€™": "'",
        "â€˜": "'",
        "â€¦": "...",
        "â€”": "-",
        "â€“": "-",
    }
    text = value
    for bad, good in replacements.items():
        text = text.replace(bad, good)
    text = text.replace("|", "")
    return clean_wrapped_text(text)


def clip_filename(text: str) -> str:
    readable = re.sub(r"[^a-z0-9]+", "-", clean_for_tts(text).lower()).strip("-")
    readable = readable[:56].strip("-") or "whisper"
    digest = hashlib.sha1(text.encode("utf-8")).hexdigest()[:10]
    return f"{readable}-{digest}.mp3"


def process_with_ffmpeg(input_wav: Path, output_mp3: Path) -> None:
    output_mp3.parent.mkdir(parents=True, exist_ok=True)
    filters = ",".join(
        [
            "highpass=f=95",
            "lowpass=f=7200",
            "afftdn=nf=-28",
            "aecho=0.58:0.34:38|91:0.18|0.08",
            "loudnorm=I=-21:TP=-2:LRA=9",
        ]
    )
    command = [
        "ffmpeg",
        "-y",
        "-hide_banner",
        "-loglevel",
        "error",
        "-i",
        str(input_wav),
        "-af",
        filters,
        "-codec:a",
        "libmp3lame",
        "-q:a",
        "3",
        str(output_mp3),
    ]
    subprocess.run(command, check=True)


def synthesize_with_sapi(text: str, output_wav: Path, voice_name: str) -> None:
    output_wav.parent.mkdir(parents=True, exist_ok=True)
    with tempfile.NamedTemporaryFile("w", suffix=".txt", delete=False, encoding="utf-8") as text_file:
        text_file.write(text)
        text_path = Path(text_file.name)
    with tempfile.NamedTemporaryFile("w", suffix=".ps1", delete=False, encoding="utf-8") as script_file:
        script_file.write(SAPI_SCRIPT)
        script_path = Path(script_file.name)
    try:
        subprocess.run(
            [
                "powershell",
                "-NoProfile",
                "-ExecutionPolicy",
                "Bypass",
                "-File",
                str(script_path),
                str(text_path),
                str(output_wav),
                voice_name,
            ],
            check=True,
        )
    finally:
        text_path.unlink(missing_ok=True)
        script_path.unlink(missing_ok=True)


SAPI_SCRIPT = r"""
param(
    [string] $TextPath,
    [string] $OutputPath,
    [string] $VoiceName
)
Add-Type -AssemblyName System.Speech
$speaker = New-Object System.Speech.Synthesis.SpeechSynthesizer
if (-not [string]::IsNullOrWhiteSpace($VoiceName)) {
    try { $speaker.SelectVoice($VoiceName) } catch {}
}
$speaker.Rate = -3
$speaker.Volume = 100
$text = Get-Content -LiteralPath $TextPath -Raw -Encoding UTF8
$speaker.SetOutputToWaveFile($OutputPath)
$speaker.Speak($text)
$speaker.Dispose()
"""


if __name__ == "__main__":
    raise SystemExit(main())
