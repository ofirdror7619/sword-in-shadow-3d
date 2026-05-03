# Whisper TTS

The game plays pre-generated Whisper voice clips from `assets/audio/whispers/manifest.json`.
Each clip is played in three layers in Godot: one normal voice, one lower pitched echo, and one higher pitched echo so the Whisper feels like a male/female blend.

Generate clips with Coqui TTS from Python 3.10:

```powershell
py -3.10 -m venv .venv-tts
.\.venv-tts\Scripts\python -m pip install --upgrade pip
.\.venv-tts\Scripts\python -m pip install TTS
.\.venv-tts\Scripts\python tools\generate_whisper_tts.py
```

Useful test commands:

```powershell
.\.venv-tts\Scripts\python tools\generate_whisper_tts.py --dry-run
.\.venv-tts\Scripts\python tools\generate_whisper_tts.py --limit 3
.\.venv-tts\Scripts\python tools\generate_whisper_tts.py --force
```

The default model is `tts_models/en/vctk/vits` with speaker `p225`.
Try `--speaker p226` or `--speaker p230` for a different base texture before the in-game pitch layers are applied.
