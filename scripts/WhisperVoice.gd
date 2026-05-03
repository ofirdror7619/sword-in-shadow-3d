extends Node
class_name SISWhisperVoice

const MANIFEST_PATH := "res://assets/audio/whispers/manifest.json"
const BUS_NAME := "WhisperVoice"
const LOW_BUS_NAME := "WhisperVoiceLow"
const HIGH_BUS_NAME := "WhisperVoiceHigh"
const MAIN_VOLUME_DB := -3.5
const LOW_LAYER_VOLUME_DB := -1.0
const HIGH_LAYER_VOLUME_DB := -8.0
const LOW_LAYER_PITCH_SCALE := 0.66
const HIGH_LAYER_PITCH_SCALE := 1.12
const DYNAMIC_CLIP_KEYS := [
	"Done.",
	"Relic gained.",
	"Map revealed.",
	"Spell learned.",
	"Gold gained.",
	"Experience gained.",
	"Diamond gained.",
	"Diamond claimed.",
	"Already etched into you. It became gold."
]

var enabled := true
var voice_volume := 0.82
var echo_amount := 0.75

var _manifest := {}
var _normalized_manifest := {}
var _players: Array[AudioStreamPlayer] = []
var _missing_clip_warnings := {}

func _ready() -> void:
	_ensure_audio_buses()
	_load_manifest()
	for i in range(3):
		var player := AudioStreamPlayer.new()
		player.name = "WhisperVoiceLayer%d" % (i + 1)
		if i == 0:
			player.bus = BUS_NAME
		elif i == 1:
			player.bus = LOW_BUS_NAME
		else:
			player.bus = HIGH_BUS_NAME
		add_child(player)
		_players.append(player)
	_update_player_mix()

func set_enabled(value: bool) -> void:
	enabled = value
	if not enabled:
		stop()

func set_voice_volume(percent: float) -> void:
	voice_volume = clampf(percent / 100.0, 0.0, 1.0)
	_update_player_mix()

func set_echo_amount(percent: float) -> void:
	echo_amount = clampf(percent / 100.0, 0.0, 1.0)
	_update_player_mix()

func speak(text: String) -> void:
	if not enabled or DisplayServer.get_name() == "headless":
		return
	var clean_text := text.strip_edges()
	if clean_text.is_empty():
		return
	var stream := _stream_for_text(clean_text)
	if stream != null:
		stop()
		for player in _players:
			player.stream = stream
			player.pitch_scale = 1.0
		for player in _players:
			player.play()
		return
	_warn_missing_clip(clean_text)

func stop() -> void:
	for player in _players:
		player.stop()

func _load_manifest() -> void:
	_manifest.clear()
	_normalized_manifest.clear()
	if not FileAccess.file_exists(MANIFEST_PATH):
		return
	var json_text := FileAccess.get_file_as_string(MANIFEST_PATH)
	var parsed: Variant = JSON.parse_string(json_text)
	if parsed is Dictionary:
		_manifest = parsed
		for key_variant in _manifest.keys():
			var key := String(key_variant)
			_normalized_manifest[_normalize_text(key)] = String(_manifest[key])

func _stream_for_text(text: String) -> AudioStream:
	var path := _manifest_path_for_text(text)
	if path.is_empty():
		return null
	if not ResourceLoader.exists(path):
		return null
	var stream := ResourceLoader.load(path) as AudioStream
	return stream

func _manifest_path_for_text(text: String) -> String:
	var path := String(_manifest.get(text, ""))
	if not path.is_empty():
		return path
	var normalized_text := _normalize_text(text)
	path = String(_normalized_manifest.get(normalized_text, ""))
	if not path.is_empty():
		return path
	for dynamic_key in DYNAMIC_CLIP_KEYS:
		var key := String(dynamic_key)
		if _matches_dynamic_clip(text, key) or _matches_dynamic_clip(normalized_text, _normalize_text(key)):
			path = String(_manifest.get(key, ""))
			if not path.is_empty():
				return path
			path = String(_normalized_manifest.get(_normalize_text(key), ""))
			if not path.is_empty():
				return path
	return ""

func _matches_dynamic_clip(text: String, key: String) -> bool:
	if key.is_empty():
		return false
	if text == key:
		return true
	if key == "Already etched into you. It became gold.":
		return text.ends_with("was already etched into you. It became gold.") or text.ends_with("was already etched into you. It became gold")
	return text.begins_with("%s " % key)

func _normalize_text(text: String) -> String:
	var normalized := text.strip_edges()
	normalized = normalized.replace(_mojibake(0x0153), "\"")
	normalized = normalized.replace(_mojibake(0x009d), "\"")
	normalized = normalized.replace(_mojibake(0x2122), "'")
	normalized = normalized.replace(_mojibake(0x02dc), "'")
	normalized = normalized.replace(_mojibake(0x00a6), "...")
	normalized = normalized.replace(_mojibake(0x201d), "-")
	normalized = normalized.replace(_mojibake(0x201c), "-")
	normalized = normalized.replace(String.chr(0x201c), "\"")
	normalized = normalized.replace(String.chr(0x201d), "\"")
	normalized = normalized.replace(String.chr(0x2019), "'")
	normalized = normalized.replace(String.chr(0x2018), "'")
	normalized = normalized.replace(String.chr(0x2026), "...")
	normalized = normalized.replace(String.chr(0x2014), "-")
	normalized = normalized.replace(String.chr(0x2013), "-")
	return normalized.replace("|", "").strip_edges()

func _mojibake(last_codepoint: int) -> String:
	return String.chr(0x00e2) + String.chr(0x20ac) + String.chr(last_codepoint)

func _warn_missing_clip(text: String) -> void:
	if _missing_clip_warnings.has(text):
		return
	_missing_clip_warnings[text] = true
	push_warning("Missing whisper voice clip: %s" % text)

func _update_player_mix() -> void:
	if _players.size() < 3:
		return
	var voice_db := linear_to_db(maxf(voice_volume, 0.001))
	var echo_db := linear_to_db(maxf(echo_amount, 0.001))
	_players[0].volume_db = MAIN_VOLUME_DB + voice_db
	_players[1].volume_db = LOW_LAYER_VOLUME_DB + voice_db + echo_db
	_players[2].volume_db = HIGH_LAYER_VOLUME_DB + voice_db + echo_db

func _ensure_audio_buses() -> void:
	var main_bus := _ensure_bus(BUS_NAME)
	if main_bus >= 0 and AudioServer.get_bus_effect_count(main_bus) == 0:
		AudioServer.add_bus_effect(main_bus, _make_reverb_effect(0.22))
	var low_bus := _ensure_bus(LOW_BUS_NAME)
	if low_bus >= 0 and AudioServer.get_bus_effect_count(low_bus) == 0:
		var low_pitch_shift := AudioEffectPitchShift.new()
		low_pitch_shift.pitch_scale = LOW_LAYER_PITCH_SCALE
		low_pitch_shift.oversampling = 4
		low_pitch_shift.fft_size = AudioEffectPitchShift.FFT_SIZE_2048
		AudioServer.add_bus_effect(low_bus, low_pitch_shift)
		AudioServer.add_bus_effect(low_bus, _make_reverb_effect(0.16))
	var high_bus := _ensure_bus(HIGH_BUS_NAME)
	if high_bus >= 0 and AudioServer.get_bus_effect_count(high_bus) == 0:
		var high_pitch_shift := AudioEffectPitchShift.new()
		high_pitch_shift.pitch_scale = HIGH_LAYER_PITCH_SCALE
		high_pitch_shift.oversampling = 4
		high_pitch_shift.fft_size = AudioEffectPitchShift.FFT_SIZE_2048
		AudioServer.add_bus_effect(high_bus, high_pitch_shift)
		AudioServer.add_bus_effect(high_bus, _make_reverb_effect(0.3))

func _ensure_bus(bus_name: String) -> int:
	var bus_index := AudioServer.get_bus_index(bus_name)
	if bus_index == -1:
		AudioServer.add_bus()
		bus_index = AudioServer.get_bus_count() - 1
		AudioServer.set_bus_name(bus_index, bus_name)
	AudioServer.set_bus_send(bus_index, "Master")
	return bus_index

func _make_reverb_effect(wet: float) -> AudioEffectReverb:
	var reverb := AudioEffectReverb.new()
	reverb.room_size = 0.68
	reverb.damping = 0.52
	reverb.wet = wet
	reverb.dry = 0.88
	return reverb
