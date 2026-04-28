extends Node3D

const PlayerScript := preload("res://scripts/Player.gd")
const EnemyScript := preload("res://scripts/Enemy.gd")
const ChestScript := preload("res://scripts/Chest.gd")
const GoldScript := preload("res://scripts/DroppedGold.gd")
const ScrollScript := preload("res://scripts/Scroll.gd")
const FireStormScript := preload("res://scripts/FireStorm.gd")
const HudScript := preload("res://scripts/HUD.gd")
const WhisperSystemScript := preload("res://scripts/WhisperSystem.gd")
const EXIT_TEXTURE: Texture2D = preload("res://assets/images/objects/portal.png")
const FLOOR_TEXTURE: Texture2D = preload("res://assets/images/floor/castle-stone-floor.png")
const OPENING_LOGO_TEXTURE: Texture2D = preload("res://assets/images/opening/logo.png")
const OPENING_WHISPER_FONT: FontFile = preload("res://assets/fonts/Simbiot.ttf")
const LEVEL_ONE_MUSIC: AudioStreamMP3 = preload("res://assets/audio/music/music-level-1.mp3")
const TOWN_MUSIC: AudioStreamMP3 = preload("res://assets/audio/music/town.mp3")
const OPENING_AURA_SOUND: AudioStreamMP3 = preload("res://assets/audio/sounds/aura.mp3")
const ANGEL_DEAD_SOUND: AudioStream = preload("res://assets/audio/sounds/angel-dead.mp3")
const EXIT_SOUND: AudioStream = preload("res://assets/audio/sounds/exit.mp3")
const FIRE_STORM_SOUND: AudioStream = preload("res://assets/audio/sounds/fire-storm.mp3")
const FIRE_STORM_BOOM_SOUND: AudioStream = preload("res://assets/audio/sounds/fire-storm-boom.mp3")
const TREASURE_CHEST_SOUND: AudioStream = preload("res://assets/audio/sounds/treasure-chest.mp3")
const PORTAL_FRAME_TEXTURE_PATH := "res://assets/images/objects/PortalFrame.png"
const VENDOR_FRONT_TEXTURE_PATH := "res://assets/images/NPC/vendor-1/vendor-front.png"
const VENDOR_SIDE_TEXTURE_PATH := "res://assets/images/NPC/vendor-1/vendor-side.png"
const VENDOR_BACK_TEXTURE_PATH := "res://assets/images/NPC/vendor-1/vendor-back.png"
const SPELL_SHOP_MODEL_PATH := "res://assets/images/NPC/spell-shop/spell-shop.glb"
const SPELL_SHOP_TEXTURE_PATH := "res://assets/images/NPC/spell-shop/spell-shop.png"
const TOWN_BARREL_TEXTURE_PATH := "res://assets/images/objects/town/barrel.png"
const TOWN_VENDOR_MAN_TEXTURE_PATH := "res://assets/images/objects/town/man-1.png"
const TOWN_VENDOR_WOMAN_TEXTURE_PATH := "res://assets/images/objects/town/woman-1.png"
const TOWN_TREE_TEXTURE_PATHS := [
	"res://assets/images/objects/town/tree-1.png",
	"res://assets/images/objects/town/tree-2.png",
	"res://assets/images/objects/town/tree-3.png",
	"res://assets/images/objects/town/tree-4.png"
]
const WHISPER_INTRODUCTION_PATH := "res://theWhisper/introduction.txt"
const WHISPER_AFTER_KILLING_PATH := "res://theWhisper/after-killing.txt"
const WHISPER_WAITING_PATH := "res://theWhisper/waiting.txt"
const SCROLLS_PATH := "res://scrolls/scrolls.txt"
const SCROLLS_FALLBACK_PATH := "res://scrolls/scrollls.txt"

const ARENA_HALF_SIZE := 34.0
const STAGE_ENEMY_COUNT := 15
const PLAYER_START_POSITION := Vector3(-29.0, 0.1, 29.0)
const CAMERA_FOLLOW_OFFSET := Vector3(15.5, 18.0, 15.5)
const CAMERA_ZOOM_MIN := 0.62
const CAMERA_ZOOM_MAX := 1.45
const CAMERA_ZOOM_STEP := 0.1
const CAMERA_ZOOM_DEFAULT := 1.0
const BRICK_TEXTURE_SIZE := 256
const BRICK_WIDTH := 32
const BRICK_HEIGHT := 16
const MORTAR_SIZE := 3
const WALL_FACE_TEXTURE_DENSITY := 0.5
const OPENING_RED := Color(0.95, 0.02, 0.01, 1.0)
const OPENING_DIM_RED := Color(0.72, 0.02, 0.015, 1.0)
const EXIT_PORTAL_VISUAL_OFFSET := Vector3(0.42, -0.38, 0.0)
const IDLE_WHISPER_DELAY := 8.0
const IDLE_WHISPER_INTERVAL_MIN := 11.0
const IDLE_WHISPER_INTERVAL_MAX := 18.0
const AFTER_KILL_WHISPER_CHANCE := 0.62
const START_IN_TOWN_FOR_TESTING := true
const TEST_TOWN_START_GOLD := 500
const TEST_TOWN_START_DIAMONDS := 10
const AREA_CASTLE := "castle"
const AREA_TOWN := "town"
const TOWN_ORIGIN := Vector3(118.0, 0.0, 0.0)
const TOWN_HALF_SIZE := 26.0
const TOWN_SPAWN_POSITION := Vector3(118.0, 0.1, 18.0)
const DIAMOND_PACKS := [
	{"id": "diamonds_small", "name": "Diamond Pouch", "description": "Receive 3 diamonds for spell purchases.", "gold_cost": 90, "diamonds": 3},
	{"id": "diamonds_large", "name": "Diamond Cache", "description": "Receive 8 diamonds at a better rate.", "gold_cost": 210, "diamonds": 8}
]
const SPELL_CATALOG := [
	{"id": "searing_fire", "name": "Searing Fire", "description": "Fire Storm deals 25% more damage.", "diamond_cost": 4},
	{"id": "wide_flame", "name": "Widened Flame", "description": "Fire Storm covers a wider area and strikes more often.", "diamond_cost": 5},
	{"id": "quickened_ritual", "name": "Quickened Ritual", "description": "Fire Storm cooldown drops to 3.2 seconds.", "diamond_cost": 6},
	{"id": "ember_stride", "name": "Ember Stride", "description": "Move 12% faster while exploring and fighting.", "diamond_cost": 3}
]

var player: SISPlayer
var camera: Camera3D
var hud: SISHUD
var whisper_system: Node
var opening_layer: CanvasLayer
var opening_enter_label: Label
var opening_whisper_label: Label
var opening_active := false
var opening_elapsed := 0.0
var opening_whisper_revealed := false
var music_player: AudioStreamPlayer
var opening_aura_player: AudioStreamPlayer
var enemies: Array[Node3D] = []
var rng := RandomNumberGenerator.new()
var game_level := 1
var kills := 0
var exit_open := false
var exit_directive_completed := false
var wall_texture: Texture2D
var town_cobble_texture: Texture2D
var town_roof_texture: Texture2D
var town_wood_texture: Texture2D
var exit_area: Area3D
var exit_light: OmniLight3D
var exit_sprite: Sprite3D
var exit_swirl_root: Node3D
var exit_sparks: Array[MeshInstance3D] = []
var exit_souls: Array[MeshInstance3D] = []
var exit_smoke_wisps: Array[MeshInstance3D] = []
var introduction_whisper := ""
var after_killing_whispers: Array[String] = []
var waiting_whispers: Array[String] = []
var scroll_entries: Array[Dictionary] = []
var active_scroll: Node3D
var spawned_scroll_game_levels: Array[int] = []
var idle_seconds := 0.0
var idle_whisper_cooldown := 0.0
var reveal_enemies_on_minimap := false
var possession_fx_played := false
var camera_zoom := CAMERA_ZOOM_DEFAULT
var current_area := AREA_CASTLE
var town_root: Node3D
var town_built := false
var active_vendor_id := ""
var vendor_front_texture: Texture2D
var vendor_side_texture: Texture2D
var vendor_back_texture: Texture2D
var town_barrel_texture: Texture2D
var town_vendor_man_texture: Texture2D
var town_vendor_woman_texture: Texture2D
var town_tree_textures: Array[Texture2D] = []
var spell_shop_texture: Texture2D
var spell_shop_scene: PackedScene
var vendor_sprites: Array[Dictionary] = []

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	rng.randomize()
	_load_whisper_texts()
	_load_scroll_texts()
	_make_music_player()
	_make_lighting()
	_make_camera()
	_make_castle()
	_make_player()
	_make_exit()
	_make_hud()
	_make_whisper_system()
	if START_IN_TOWN_FOR_TESTING:
		player.add_gold(TEST_TOWN_START_GOLD)
		player.add_diamonds(TEST_TOWN_START_DIAMONDS)
		_enter_town()
	else:
		_spawn_encounter()
		_spawn_chests()
		_spawn_scroll_for_game_level(game_level)
		_update_objective()
	_make_opening_screen()
	get_tree().paused = true

func _process(delta: float) -> void:
	if opening_active:
		_process_opening(delta)
		return
	if player == null:
		return
	camera.global_position = camera.global_position.lerp(player.global_position + _camera_follow_offset(), 0.12)
	camera.look_at(player.global_position + Vector3(0.0, 0.7, 0.0), Vector3.UP)
	if whisper_system != null:
		whisper_system.update(delta, player)
	_animate_exit_fx(delta)
	_update_vendor_sprites()
	_process_idle_whispers(delta)
	_update_minimap()

func _input(event: InputEvent) -> void:
	if not opening_active:
		if event is InputEventKey and event.pressed:
			_mark_player_activity()
			if event.keycode == KEY_Z:
				_reset_camera_zoom()
				get_viewport().set_input_as_handled()
		elif event is InputEventMouseButton and event.pressed:
			_mark_player_activity()
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				_adjust_camera_zoom(-CAMERA_ZOOM_STEP)
				get_viewport().set_input_as_handled()
			elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				_adjust_camera_zoom(CAMERA_ZOOM_STEP)
				get_viewport().set_input_as_handled()
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		get_viewport().set_input_as_handled()
		_enter_game()

func _exit_tree() -> void:
	if music_player != null:
		music_player.stop()
		music_player.stream = null
	if opening_aura_player != null:
		opening_aura_player.stop()
		opening_aura_player.stream = null
	get_tree().paused = false

func _make_player() -> void:
	player = PlayerScript.new() as SISPlayer
	player.position = PLAYER_START_POSITION
	add_child(player)
	player.setup_camera(camera)
	camera.global_position = player.global_position + _camera_follow_offset()
	camera.look_at(player.global_position + Vector3(0.0, 0.7, 0.0), Vector3.UP)
	player.stats_changed.connect(_on_player_stats_changed)
	player.damaged.connect(_on_player_damaged)
	player.firestorm_requested.connect(_on_firestorm_requested)
	player.died.connect(_on_player_died)

func _make_camera() -> void:
	camera = Camera3D.new()
	camera.fov = 42.0
	camera.near = 0.1
	camera.far = 160.0
	camera.position = PLAYER_START_POSITION + _camera_follow_offset()
	add_child(camera)
	camera.current = true

func _camera_follow_offset() -> Vector3:
	return CAMERA_FOLLOW_OFFSET * camera_zoom

func _adjust_camera_zoom(delta: float) -> void:
	camera_zoom = clampf(camera_zoom + delta, CAMERA_ZOOM_MIN, CAMERA_ZOOM_MAX)

func _reset_camera_zoom() -> void:
	camera_zoom = CAMERA_ZOOM_DEFAULT

func _make_hud() -> void:
	hud = HudScript.new() as SISHUD
	add_child(hud)
	if player != null:
		player.set_mouse_block_check(Callable(hud, "is_mouse_over_character_panel"))
	hud.resurrect_requested.connect(_on_resurrect_requested)
	hud.shop_purchase_requested.connect(_on_shop_purchase_requested)
	hud.shop_closed.connect(_on_shop_closed)
	hud.skill_tree_point_requested.connect(_on_skill_tree_point_requested)
	hud.update_stats(player.get_stats())
	_update_possession()

func _make_whisper_system() -> void:
	whisper_system = WhisperSystemScript.new()
	add_child(whisper_system)
	whisper_system.offer_presented.connect(hud.show_offer)
	whisper_system.offer_closed.connect(hud.hide_offer)
	whisper_system.directive_started.connect(hud.show_directive)
	whisper_system.directive_updated.connect(hud.update_directive)
	whisper_system.directive_closed.connect(hud.hide_directive)
	whisper_system.corruption_changed.connect(_on_corruption_changed)
	whisper_system.reaction_requested.connect(_say_whisper)
	whisper_system.effect_requested.connect(_on_whisper_effect_requested)
	hud.offer_accepted.connect(whisper_system.accept_offer)
	hud.offer_rejected.connect(whisper_system.reject_offer)

func _make_music_player() -> void:
	music_player = AudioStreamPlayer.new()
	music_player.name = "LevelOneMusic"
	_set_background_music(LEVEL_ONE_MUSIC)
	music_player.volume_db = -7.0
	add_child(music_player)

func _set_background_music(track: AudioStreamMP3) -> void:
	if music_player == null:
		return
	var stream_to_use: AudioStream = track
	var looped_track := track.duplicate() as AudioStreamMP3
	if looped_track != null:
		looped_track.loop = true
		stream_to_use = looped_track
	var was_playing := music_player.playing
	music_player.stop()
	music_player.stream = stream_to_use
	if was_playing and DisplayServer.get_name() != "headless":
		music_player.play()

func _make_opening_aura_player() -> void:
	opening_aura_player = AudioStreamPlayer.new()
	opening_aura_player.name = "OpeningAura"
	opening_aura_player.process_mode = Node.PROCESS_MODE_ALWAYS
	var aura_stream := OPENING_AURA_SOUND.duplicate() as AudioStreamMP3
	if aura_stream != null:
		aura_stream.loop = true
		opening_aura_player.stream = aura_stream
	else:
		opening_aura_player.stream = OPENING_AURA_SOUND
	opening_aura_player.pitch_scale = 0.5
	opening_aura_player.volume_db = -5.0
	add_child(opening_aura_player)
	if DisplayServer.get_name() != "headless":
		opening_aura_player.play()

func _play_sound(stream: AudioStream, volume_db: float = 0.0) -> void:
	if DisplayServer.get_name() == "headless":
		return
	var player := AudioStreamPlayer.new()
	player.stream = stream
	player.volume_db = volume_db
	add_child(player)
	player.finished.connect(Callable(player, "queue_free"))
	player.play()

func _load_whisper_texts() -> void:
	introduction_whisper = _load_whisper_file_as_text(WHISPER_INTRODUCTION_PATH)
	after_killing_whispers = _load_whisper_file_lines(WHISPER_AFTER_KILLING_PATH)
	waiting_whispers = _load_whisper_file_lines(WHISPER_WAITING_PATH)

func _load_scroll_texts() -> void:
	var path := SCROLLS_PATH
	if not FileAccess.file_exists(path):
		path = SCROLLS_FALLBACK_PATH
	if not FileAccess.file_exists(path):
		push_warning("Missing scroll text file: %s" % SCROLLS_PATH)
		return
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_warning("Could not open scroll text file: %s" % path)
		return
	scroll_entries = _parse_scroll_entries(file.get_as_text())

func _parse_scroll_entries(text: String) -> Array[Dictionary]:
	var entries: Array[Dictionary] = []
	var current_title := ""
	var current_lines: Array[String] = []
	for raw_line in text.split("\n", false):
		var line := raw_line.replace("\r", "").strip_edges()
		if line.is_empty():
			continue
		if _is_scroll_heading(line):
			_append_scroll_entry(entries, current_title, current_lines)
			current_title = line
			current_lines.clear()
		else:
			current_lines.append(line)
	_append_scroll_entry(entries, current_title, current_lines)
	return entries

func _append_scroll_entry(entries: Array[Dictionary], title: String, lines: Array[String]) -> void:
	if title.is_empty():
		return
	entries.append({
		"title": title,
		"body": "\n".join(lines)
	})

func _is_scroll_heading(line: String) -> bool:
	return line.length() <= 32 and line.contains("Scroll ")

func _load_whisper_file_as_text(path: String) -> String:
	var lines := _load_whisper_file_lines(path)
	var combined := ""
	for line in lines:
		if not combined.is_empty():
			combined += " "
		combined += line
	return combined

func _load_whisper_file_lines(path: String) -> Array[String]:
	var lines: Array[String] = []
	if not FileAccess.file_exists(path):
		push_warning("Missing whisper file: %s" % path)
		return lines
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_warning("Could not open whisper file: %s" % path)
		return lines
	var text := file.get_as_text()
	for raw_line in text.split("\n", false):
		var line := _clean_whisper_line(raw_line)
		if not line.is_empty():
			lines.append(line)
	return lines

func _clean_whisper_line(raw_line: String) -> String:
	var line := raw_line.replace("\r", "").strip_edges()
	var byte_order_mark := String.chr(0xfeff)
	if line.begins_with(byte_order_mark):
		line = line.substr(1).strip_edges()
	return _strip_wrapping_quotes(line)

func _strip_wrapping_quotes(line: String) -> String:
	if line.length() < 2:
		return line
	var first := line.substr(0, 1)
	var last := line.substr(line.length() - 1, 1)
	if first == String.chr(34) and last == String.chr(34):
		return line.substr(1, line.length() - 2).strip_edges()
	if first == String.chr(0x201c) and last == String.chr(0x201d):
		return line.substr(1, line.length() - 2).strip_edges()
	if first == String.chr(0x2018) and last == String.chr(0x2019):
		return line.substr(1, line.length() - 2).strip_edges()
	return line

func _say_whisper(text: String) -> void:
	if hud == null or text.is_empty():
		return
	hud.whisper(text)
	idle_whisper_cooldown = rng.randf_range(IDLE_WHISPER_INTERVAL_MIN, IDLE_WHISPER_INTERVAL_MAX)

func _say_random_whisper(lines: Array[String]) -> void:
	if lines.is_empty():
		return
	_say_whisper(lines[rng.randi_range(0, lines.size() - 1)])

func _mark_player_activity() -> void:
	idle_seconds = 0.0

func _process_idle_whispers(delta: float) -> void:
	if idle_whisper_cooldown > 0.0:
		idle_whisper_cooldown = maxf(idle_whisper_cooldown - delta, 0.0)
	if not _is_player_waiting():
		_mark_player_activity()
		return
	idle_seconds += delta
	if idle_seconds >= IDLE_WHISPER_DELAY and idle_whisper_cooldown <= 0.0:
		_say_random_whisper(waiting_whispers)

func _is_player_waiting() -> bool:
	if player == null or not player.alive or kills <= 0:
		return false
	if player.has_move_target:
		return false
	if Vector2(player.velocity.x, player.velocity.z).length() > 0.12:
		return false
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) or Input.is_key_pressed(KEY_SPACE):
		return false
	return not (Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_D))

func _make_opening_screen() -> void:
	opening_active = true
	opening_elapsed = 0.0
	opening_whisper_revealed = false
	_make_opening_aura_player()
	opening_layer = CanvasLayer.new()
	opening_layer.name = "OpeningScreen"
	opening_layer.layer = 100
	opening_layer.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(opening_layer)

	var shade := ColorRect.new()
	shade.color = Color.BLACK
	shade.set_anchors_preset(Control.PRESET_FULL_RECT)
	shade.mouse_filter = Control.MOUSE_FILTER_STOP
	opening_layer.add_child(shade)

	var logo := TextureRect.new()
	logo.texture = OPENING_LOGO_TEXTURE
	logo.anchor_left = 0.5
	logo.anchor_top = 0.08
	logo.anchor_right = 0.5
	logo.anchor_bottom = 0.08
	logo.offset_left = -560.0
	logo.offset_top = 0.0
	logo.offset_right = 560.0
	logo.offset_bottom = 440.0
	logo.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	logo.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	logo.mouse_filter = Control.MOUSE_FILTER_IGNORE
	opening_layer.add_child(logo)

	opening_enter_label = _make_opening_label("click to enter...", 30, OPENING_DIM_RED)
	opening_enter_label.anchor_top = 0.72
	opening_enter_label.anchor_bottom = 0.84
	opening_layer.add_child(opening_enter_label)

func _make_opening_label(text: String, font_size: int, color: Color) -> Label:
	var label := Label.new()
	label.text = text
	label.anchor_left = 0.0
	label.anchor_right = 1.0
	label.offset_left = 24.0
	label.offset_right = -24.0
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.add_theme_font_override("font", OPENING_WHISPER_FONT)
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_shadow_color", Color(0.0, 0.0, 0.0, 0.9))
	label.add_theme_constant_override("shadow_offset_x", 3)
	label.add_theme_constant_override("shadow_offset_y", 3)
	label.modulate = color
	return label

func _show_opening_whisper() -> void:
	if not opening_active or opening_enter_label == null:
		return
	opening_enter_label.text = "click to enter...   let me in..."
	opening_enter_label.modulate = OPENING_RED
	opening_whisper_revealed = true

func _process_opening(delta: float) -> void:
	opening_elapsed += delta
	if opening_enter_label != null:
		opening_enter_label.modulate.a = _opening_blink_alpha(opening_elapsed, 0.3, 0.9, 5.0)
	if not opening_whisper_revealed and opening_elapsed >= 2.0:
		_show_opening_whisper()

func _opening_blink_alpha(time: float, low_alpha: float, high_alpha: float, pulse_speed: float) -> float:
	var pulse := (sin(time * pulse_speed) + 1.0) * 0.5
	var alpha := lerpf(low_alpha, high_alpha, pulse)
	if sin(time * 43.0) > 0.84:
		alpha *= 0.28
	elif sin(time * 71.0) > 0.94:
		alpha *= 0.08
	return alpha

func _enter_game() -> void:
	opening_active = false
	if player != null:
		player.prepare_clean_start()
	get_tree().paused = false
	if opening_aura_player != null:
		opening_aura_player.stop()
		opening_aura_player.queue_free()
		opening_aura_player = null
	if DisplayServer.get_name() != "headless" and music_player != null:
		music_player.play()
	if opening_layer != null:
		opening_layer.queue_free()
		opening_layer = null

func _make_lighting() -> void:
	var world := WorldEnvironment.new()
	var environment := Environment.new()
	environment.background_mode = Environment.BG_COLOR
	environment.background_color = Color(0.025, 0.022, 0.032)
	environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	environment.ambient_light_color = Color(0.22, 0.18, 0.16)
	environment.ambient_light_energy = 0.55
	environment.glow_enabled = true
	environment.glow_intensity = 0.5
	world.environment = environment
	add_child(world)

	var moon := DirectionalLight3D.new()
	moon.rotation_degrees = Vector3(-55.0, -35.0, 0.0)
	moon.light_color = Color(0.65, 0.72, 1.0)
	moon.light_energy = 1.2
	moon.shadow_enabled = true
	add_child(moon)

func _make_castle() -> void:
	var floor_body := StaticBody3D.new()
	floor_body.name = "CastleFloor"
	add_child(floor_body)

	var floor_collision := CollisionShape3D.new()
	var floor_shape := BoxShape3D.new()
	floor_shape.size = Vector3(ARENA_HALF_SIZE * 2.0, 0.4, ARENA_HALF_SIZE * 2.0)
	floor_collision.shape = floor_shape
	floor_collision.position.y = -0.22
	floor_body.add_child(floor_collision)

	var floor_mesh := MeshInstance3D.new()
	var plane := PlaneMesh.new()
	plane.size = Vector2(ARENA_HALF_SIZE * 2.0, ARENA_HALF_SIZE * 2.0)
	floor_mesh.mesh = plane
	floor_mesh.material_override = _floor_material()
	floor_body.add_child(floor_mesh)

	_make_wall(Vector3(0.0, 2.0, -ARENA_HALF_SIZE), Vector3(ARENA_HALF_SIZE * 2.0, 4.0, 1.2))
	_make_wall(Vector3(0.0, 2.0, ARENA_HALF_SIZE), Vector3(ARENA_HALF_SIZE * 2.0, 4.0, 1.2))
	_make_wall(Vector3(-ARENA_HALF_SIZE, 2.0, 0.0), Vector3(1.2, 4.0, ARENA_HALF_SIZE * 2.0))
	_make_wall(Vector3(ARENA_HALF_SIZE, 2.0, 0.0), Vector3(1.2, 4.0, ARENA_HALF_SIZE * 2.0))

	_make_room_dividers()

	var torch_positions: Array[Vector3] = [
		Vector3(-27.0, 0.0, -27.0), Vector3(0.0, 0.0, -27.0), Vector3(27.0, 0.0, -27.0),
		Vector3(-27.0, 0.0, 0.0), Vector3(27.0, 0.0, 0.0),
		Vector3(0.0, 0.0, 27.0), Vector3(27.0, 0.0, 27.0)
	]
	for torch_position in torch_positions:
		_make_torch(torch_position)

	var column_positions: Array[Vector3] = [
		Vector3(-25.0, 0.0, -25.0), Vector3(25.0, 0.0, -25.0),
		Vector3(25.0, 0.0, 25.0),
		Vector3(-6.0, 0.0, -6.0), Vector3(6.0, 0.0, 6.0)
	]
	for column_position in column_positions:
		_make_column(column_position)

	_make_wall_dressing()

func _make_room_dividers() -> void:
	var wall_height := 3.4
	var wall_y := wall_height * 0.5
	for z in [-13.0, 13.0]:
		_make_wall(Vector3(-25.0, wall_y, z), Vector3(18.0, wall_height, 0.9))
		_make_wall(Vector3(-6.5, wall_y, z), Vector3(5.0, wall_height, 0.9))
		_make_wall(Vector3(6.5, wall_y, z), Vector3(5.0, wall_height, 0.9))
		_make_wall(Vector3(25.0, wall_y, z), Vector3(18.0, wall_height, 0.9))
	for x in [-13.0, 13.0]:
		_make_wall(Vector3(x, wall_y, -25.0), Vector3(0.9, wall_height, 18.0))
		_make_wall(Vector3(x, wall_y, -6.5), Vector3(0.9, wall_height, 5.0))
		_make_wall(Vector3(x, wall_y, 6.5), Vector3(0.9, wall_height, 5.0))
		_make_wall(Vector3(x, wall_y, 25.0), Vector3(0.9, wall_height, 18.0))

func _make_wall(position: Vector3, size: Vector3) -> void:
	var body := StaticBody3D.new()
	body.position = position
	add_child(body)

	var collider := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = size
	collider.shape = shape
	body.add_child(collider)

	var mesh_instance := MeshInstance3D.new()
	var mesh := BoxMesh.new()
	mesh.size = size
	mesh_instance.mesh = mesh
	mesh_instance.material_override = _wall_material(size)
	body.add_child(mesh_instance)

func _make_wall_dressing() -> void:
	_make_wall_web(Vector3(-30.0, 2.95, -33.28), 0.0, 1.15)
	_make_wall_web(Vector3(31.0, 3.0, -33.28), 0.0, 0.9)
	_make_wall_web(Vector3(33.28, 2.65, 24.0), 90.0, 1.0)
	_make_wall_web(Vector3(-33.28, 2.8, -24.0), -90.0, 0.95)
	_make_wall_web(Vector3(13.0, 2.62, -17.8), 90.0, 0.72)
	_make_wall_web(Vector3(22.5, 2.72, 13.0), 0.0, 0.78)

	_make_wall_sword_and_shield(Vector3(-18.5, 2.25, -33.2), 0.0, Color(0.32, 0.05, 0.05))
	_make_wall_sword_and_shield(Vector3(33.2, 2.1, -12.0), 90.0, Color(0.08, 0.11, 0.2))
	_make_wall_sword_and_shield(Vector3(18.0, 2.18, 33.2), 180.0, Color(0.16, 0.13, 0.08))
	_make_wall_sword(Vector3(-33.2, 2.15, 11.0), -90.0, 0.92)
	_make_wall_shield(Vector3(-8.0, 2.05, 13.2), 0.0, Color(0.12, 0.16, 0.12))
	_make_wall_sword(Vector3(13.2, 2.35, 21.0), 90.0, 0.82)

	_make_bone_pile(Vector3(-30.0, 0.12, -29.0), 18.0)
	_make_bone_pile(Vector3(30.0, 0.12, -28.5), -24.0)
	_make_bone_pile(Vector3(-29.0, 0.12, 26.5), 54.0)
	_make_bone_pile(Vector3(20.0, 0.12, 12.0), -8.0)

func _make_wall_web(position: Vector3, yaw_degrees: float, web_scale: float) -> void:
	var root := Node3D.new()
	root.name = "WallSpiderWeb"
	root.position = position
	root.rotation_degrees.y = yaw_degrees
	root.scale = Vector3.ONE * web_scale
	add_child(root)

	var web_material := _decoration_material(Color(0.72, 0.7, 0.66, 0.62), Color(0.03, 0.028, 0.026), 0.05)
	for angle in [0.0, 32.0, 62.0, 90.0, 122.0, 153.0]:
		var strand := _make_decoration_bar(1.18, 0.018, web_material)
		strand.rotation_degrees.z = angle
		root.add_child(strand)

	for ring_index in range(3):
		var radius: float = 0.26 + float(ring_index) * 0.18
		for segment_index in range(6):
			var angle: float = float(segment_index) * TAU / 6.0 + float(ring_index) * 0.18
			var strand := _make_decoration_bar(radius * 0.62, 0.014, web_material)
			strand.position = Vector3(cos(angle) * radius * 0.48, sin(angle) * radius * 0.48, 0.012)
			strand.rotation.z = angle + PI * 0.5
			root.add_child(strand)

func _make_wall_sword_and_shield(position: Vector3, yaw_degrees: float, shield_color: Color) -> void:
	_make_wall_sword(position + Vector3(0.0, 0.05, 0.02), yaw_degrees, 1.0)
	_make_wall_shield(position + Vector3(0.0, -0.06, 0.055), yaw_degrees, shield_color)

func _make_wall_sword(position: Vector3, yaw_degrees: float, sword_scale: float) -> void:
	var root := Node3D.new()
	root.name = "WallSword"
	root.position = position
	root.rotation_degrees.y = yaw_degrees
	root.scale = Vector3.ONE * sword_scale
	add_child(root)

	var blade := _make_decoration_bar(0.9, 0.07, _decoration_material(Color(0.55, 0.56, 0.54), Color(0.08, 0.08, 0.075), 0.08))
	blade.rotation_degrees.z = 90.0
	blade.position.y = 0.08
	root.add_child(blade)

	var guard := _make_decoration_bar(0.45, 0.06, _decoration_material(Color(0.46, 0.31, 0.1), Color.BLACK, 0.0))
	guard.position.y = -0.42
	root.add_child(guard)

	var grip := _make_decoration_bar(0.32, 0.07, _decoration_material(Color(0.09, 0.055, 0.035), Color.BLACK, 0.0))
	grip.rotation_degrees.z = 90.0
	grip.position.y = -0.62
	root.add_child(grip)

func _make_wall_shield(position: Vector3, yaw_degrees: float, shield_color: Color) -> void:
	var root := Node3D.new()
	root.name = "WallShield"
	root.position = position
	root.rotation_degrees.y = yaw_degrees
	add_child(root)

	var shield := MeshInstance3D.new()
	var shield_mesh := CylinderMesh.new()
	shield_mesh.top_radius = 0.34
	shield_mesh.bottom_radius = 0.39
	shield_mesh.height = 0.08
	shield_mesh.radial_segments = 28
	shield.mesh = shield_mesh
	shield.rotation_degrees.x = 90.0
	shield.scale = Vector3(0.86, 1.18, 1.0)
	shield.material_override = _decoration_material(shield_color, Color.BLACK, 0.0)
	root.add_child(shield)

	var boss := MeshInstance3D.new()
	var boss_mesh := SphereMesh.new()
	boss_mesh.radius = 0.12
	boss_mesh.height = 0.16
	boss_mesh.radial_segments = 14
	boss_mesh.rings = 7
	boss.mesh = boss_mesh
	boss.position.z = 0.06
	boss.material_override = _decoration_material(Color(0.52, 0.38, 0.14), Color(0.08, 0.045, 0.01), 0.08)
	root.add_child(boss)

func _make_bone_pile(position: Vector3, yaw_degrees: float) -> void:
	var root := Node3D.new()
	root.name = "BonePile"
	root.position = position
	root.rotation_degrees.y = yaw_degrees
	add_child(root)

	var bone_material := _decoration_material(Color(0.68, 0.62, 0.48), Color(0.06, 0.05, 0.035), 0.04)
	for i in range(4):
		var bone := MeshInstance3D.new()
		var bone_mesh := CylinderMesh.new()
		bone_mesh.top_radius = 0.035
		bone_mesh.bottom_radius = 0.04
		bone_mesh.height = 0.62 + float(i % 2) * 0.16
		bone_mesh.radial_segments = 10
		bone.mesh = bone_mesh
		bone.position = Vector3(float(i - 1) * 0.16, 0.05 + float(i % 2) * 0.035, float(i % 3) * 0.11)
		bone.rotation_degrees = Vector3(82.0, float(i) * 43.0, 62.0 + float(i) * 19.0)
		bone.material_override = bone_material
		root.add_child(bone)

	var skull := MeshInstance3D.new()
	var skull_mesh := SphereMesh.new()
	skull_mesh.radius = 0.2
	skull_mesh.height = 0.26
	skull_mesh.radial_segments = 16
	skull_mesh.rings = 8
	skull.mesh = skull_mesh
	skull.position = Vector3(0.16, 0.22, -0.08)
	skull.scale = Vector3(1.0, 0.82, 0.9)
	skull.material_override = bone_material
	root.add_child(skull)

	var eye_material := _decoration_material(Color(0.02, 0.015, 0.01), Color.BLACK, 0.0)
	for x in [-0.07, 0.07]:
		var eye := MeshInstance3D.new()
		var eye_mesh := SphereMesh.new()
		eye_mesh.radius = 0.035
		eye_mesh.height = 0.04
		eye.mesh = eye_mesh
		eye.position = Vector3(0.16 + x, 0.24, 0.1)
		eye.material_override = eye_material
		root.add_child(eye)

func _make_decoration_bar(length: float, thickness: float, material: Material) -> MeshInstance3D:
	var bar := MeshInstance3D.new()
	var mesh := BoxMesh.new()
	mesh.size = Vector3(length, thickness, thickness)
	bar.mesh = mesh
	bar.material_override = material
	return bar

func _make_column(position: Vector3) -> void:
	var body := StaticBody3D.new()
	body.position = position + Vector3(0.0, 1.3, 0.0)
	add_child(body)

	var collider := CollisionShape3D.new()
	var shape := CylinderShape3D.new()
	shape.radius = 0.75
	shape.height = 2.6
	collider.shape = shape
	body.add_child(collider)

	var mesh_instance := MeshInstance3D.new()
	var mesh := CylinderMesh.new()
	mesh.top_radius = 0.75
	mesh.bottom_radius = 0.85
	mesh.height = 2.6
	mesh_instance.mesh = mesh
	mesh_instance.material_override = _material(Color(0.21, 0.2, 0.19), Color.BLACK, 0.0)
	body.add_child(mesh_instance)

func _make_torch(position: Vector3) -> void:
	var light := OmniLight3D.new()
	light.position = position + Vector3(0.0, 2.0, 0.0)
	light.light_color = Color(1.0, 0.36, 0.13)
	light.light_energy = 1.9
	light.omni_range = 8.0
	add_child(light)

	var flame := MeshInstance3D.new()
	var mesh := SphereMesh.new()
	mesh.radius = 0.18
	mesh.height = 0.35
	flame.mesh = mesh
	flame.position = position + Vector3(0.0, 1.55, 0.0)
	flame.material_override = _material(Color(1.0, 0.28, 0.04), Color(1.0, 0.24, 0.02), 1.8)
	add_child(flame)

func _make_town() -> void:
	if town_built:
		return
	town_built = true
	_load_vendor_textures()
	town_root = Node3D.new()
	town_root.name = "Town"
	town_root.position = TOWN_ORIGIN
	add_child(town_root)
	_make_town_floor()
	_make_town_walls()
	_make_town_backdrop()
	_make_town_portal_marker(Vector3(0.0, 0.0, 20.0))
	_make_town_store("diamond_vendor", "Diamonds & Gems", Vector3(-14.0, 0.0, 2.5), Color(0.035, 0.09, 0.12), Color(0.1, 0.78, 1.0), 90.0)
	_make_town_store("spell_vendor", "Spells & Rituals", Vector3(14.0, 0.0, 2.0), Color(0.13, 0.035, 0.16), Color(0.76, 0.18, 1.0), -90.0)
	_make_town_store("relic_vendor", "Relic Stall", Vector3(0.0, 0.0, -13.5), Color(0.13, 0.09, 0.035), Color(0.95, 0.66, 0.18), 0.0)
	_make_town_street_dressing()

func _load_vendor_textures() -> void:
	if vendor_front_texture == null and ResourceLoader.exists(VENDOR_FRONT_TEXTURE_PATH):
		vendor_front_texture = load(VENDOR_FRONT_TEXTURE_PATH) as Texture2D
	if vendor_side_texture == null and ResourceLoader.exists(VENDOR_SIDE_TEXTURE_PATH):
		vendor_side_texture = load(VENDOR_SIDE_TEXTURE_PATH) as Texture2D
	if vendor_back_texture == null and ResourceLoader.exists(VENDOR_BACK_TEXTURE_PATH):
		vendor_back_texture = load(VENDOR_BACK_TEXTURE_PATH) as Texture2D
	if town_barrel_texture == null and ResourceLoader.exists(TOWN_BARREL_TEXTURE_PATH):
		town_barrel_texture = load(TOWN_BARREL_TEXTURE_PATH) as Texture2D
	if town_vendor_man_texture == null and ResourceLoader.exists(TOWN_VENDOR_MAN_TEXTURE_PATH):
		town_vendor_man_texture = load(TOWN_VENDOR_MAN_TEXTURE_PATH) as Texture2D
	if town_vendor_woman_texture == null and ResourceLoader.exists(TOWN_VENDOR_WOMAN_TEXTURE_PATH):
		town_vendor_woman_texture = load(TOWN_VENDOR_WOMAN_TEXTURE_PATH) as Texture2D
	if town_tree_textures.is_empty():
		for tree_texture_path in TOWN_TREE_TEXTURE_PATHS:
			if ResourceLoader.exists(tree_texture_path):
				var tree_texture := load(tree_texture_path) as Texture2D
				if tree_texture != null:
					town_tree_textures.append(tree_texture)
	if spell_shop_scene == null and ResourceLoader.exists(SPELL_SHOP_MODEL_PATH):
		spell_shop_scene = load(SPELL_SHOP_MODEL_PATH) as PackedScene
	if spell_shop_texture == null and ResourceLoader.exists(SPELL_SHOP_TEXTURE_PATH):
		spell_shop_texture = load(SPELL_SHOP_TEXTURE_PATH) as Texture2D

func _make_town_floor() -> void:
	var floor_body := StaticBody3D.new()
	floor_body.name = "TownFloor"
	town_root.add_child(floor_body)

	var floor_collision := CollisionShape3D.new()
	var floor_shape := BoxShape3D.new()
	floor_shape.size = Vector3(TOWN_HALF_SIZE * 2.0, 0.35, TOWN_HALF_SIZE * 2.0)
	floor_collision.shape = floor_shape
	floor_collision.position.y = -0.2
	floor_body.add_child(floor_collision)

	var floor_mesh := MeshInstance3D.new()
	var plane := PlaneMesh.new()
	plane.size = Vector2(TOWN_HALF_SIZE * 2.0, TOWN_HALF_SIZE * 2.0)
	floor_mesh.mesh = plane
	floor_mesh.material_override = _town_floor_material()
	floor_body.add_child(floor_mesh)

	var street := MeshInstance3D.new()
	var street_plane := PlaneMesh.new()
	street_plane.size = Vector2(11.0, TOWN_HALF_SIZE * 2.0 - 4.0)
	street.mesh = street_plane
	street.position.y = 0.018
	street.material_override = _town_street_material()
	floor_body.add_child(street)

	for puddle_position in [Vector3(-4.1, 0.025, 9.6), Vector3(3.0, 0.026, -4.4), Vector3(-2.6, 0.027, -14.5)]:
		_make_town_puddle(floor_body, puddle_position)

func _make_town_walls() -> void:
	_make_town_wall(Vector3(0.0, 1.95, -TOWN_HALF_SIZE), Vector3(TOWN_HALF_SIZE * 2.0, 3.9, 1.0))
	_make_town_wall(Vector3(0.0, 1.95, TOWN_HALF_SIZE), Vector3(TOWN_HALF_SIZE * 2.0, 3.9, 1.0))
	_make_town_wall(Vector3(-TOWN_HALF_SIZE, 1.95, 0.0), Vector3(1.0, 3.9, TOWN_HALF_SIZE * 2.0))
	_make_town_wall(Vector3(TOWN_HALF_SIZE, 1.95, 0.0), Vector3(1.0, 3.9, TOWN_HALF_SIZE * 2.0))
	for lamp_position in [Vector3(-5.6, 0.0, 15.0), Vector3(5.6, 0.0, 12.0), Vector3(-6.0, 0.0, -5.5), Vector3(6.0, 0.0, -9.0)]:
		_make_town_lamp(lamp_position)

func _make_town_wall(position: Vector3, size: Vector3) -> void:
	var body := StaticBody3D.new()
	body.position = position
	town_root.add_child(body)

	var collider := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = size
	collider.shape = shape
	body.add_child(collider)

	var mesh_instance := MeshInstance3D.new()
	var mesh := BoxMesh.new()
	mesh.size = size
	mesh_instance.mesh = mesh
	mesh_instance.material_override = _town_wall_material(size)
	body.add_child(mesh_instance)

func _make_town_backdrop() -> void:
	for tower_data in [
		{"position": Vector3(-18.5, 0.0, -22.4), "height": 7.8, "width": 3.2, "accent": Color(0.38, 0.18, 0.75)},
		{"position": Vector3(-8.5, 0.0, -23.2), "height": 9.2, "width": 2.6, "accent": Color(0.95, 0.55, 0.25)},
		{"position": Vector3(9.0, 0.0, -23.0), "height": 8.4, "width": 3.0, "accent": Color(0.12, 0.75, 1.0)},
		{"position": Vector3(19.0, 0.0, -22.0), "height": 6.8, "width": 3.4, "accent": Color(0.75, 0.2, 1.0)}
	]:
		_make_town_tower(tower_data["position"], float(tower_data["height"]), float(tower_data["width"]), tower_data["accent"])
	_make_town_banner_line(Vector3(-20.0, 5.0, -16.5), Vector3(20.0, 4.4, -16.5), Color(0.14, 0.06, 0.16), Color(0.95, 0.65, 0.18))
	_make_town_banner_line(Vector3(-18.0, 4.3, 8.5), Vector3(18.0, 4.8, 8.5), Color(0.05, 0.12, 0.2), Color(0.12, 0.78, 1.0))

func _make_town_tower(position: Vector3, height: float, width: float, accent: Color) -> void:
	var root := Node3D.new()
	root.name = "GothicBackdrop"
	root.position = position
	town_root.add_child(root)

	_make_town_box(root, "TowerBody", Vector3(width, height, width * 0.72), Vector3(0.0, height * 0.5, 0.0), _town_wall_material(Vector3(width, height, width)))
	var roof_material := _town_roof_material()
	_make_town_roof_pair(root, width * 0.78, width * 0.72, Vector3(0.0, height + 0.35, 0.0), roof_material)
	var spire := MeshInstance3D.new()
	var spire_mesh := CylinderMesh.new()
	spire_mesh.top_radius = 0.0
	spire_mesh.bottom_radius = width * 0.24
	spire_mesh.height = 2.2
	spire_mesh.radial_segments = 5
	spire.mesh = spire_mesh
	spire.position = Vector3(0.0, height + 1.35, 0.0)
	spire.material_override = roof_material
	root.add_child(spire)
	for x in [-width * 0.24, width * 0.24]:
		_make_town_window(root, Vector3(x, height * 0.52, width * 0.38), Vector2(0.38, 0.75), accent)
	_make_town_window(root, Vector3(0.0, height * 0.72, width * 0.38), Vector2(0.46, 0.9), accent)

func _make_town_lamp(position: Vector3) -> void:
	var post := MeshInstance3D.new()
	var post_mesh := CylinderMesh.new()
	post_mesh.top_radius = 0.08
	post_mesh.bottom_radius = 0.1
	post_mesh.height = 2.5
	post.mesh = post_mesh
	post.position = position + Vector3(0.0, 1.25, 0.0)
	post.material_override = _material(Color(0.07, 0.052, 0.042), Color.BLACK, 0.0)
	town_root.add_child(post)

	var hook := _make_decoration_bar(0.72, 0.045, _decoration_material(Color(0.12, 0.085, 0.055), Color.BLACK, 0.0))
	hook.position = position + Vector3(0.0, 2.42, 0.24)
	hook.rotation_degrees.y = 90.0
	town_root.add_child(hook)

	var light := OmniLight3D.new()
	light.position = position + Vector3(0.0, 2.35, 0.58)
	light.light_color = Color(0.96, 0.58, 0.24)
	light.light_energy = 2.55
	light.omni_range = 9.2
	town_root.add_child(light)

	var flame := MeshInstance3D.new()
	var flame_mesh := SphereMesh.new()
	flame_mesh.radius = 0.2
	flame_mesh.height = 0.34
	flame.mesh = flame_mesh
	flame.position = light.position
	flame.material_override = _material(Color(1.0, 0.42, 0.08), Color(1.0, 0.26, 0.02), 2.1)
	town_root.add_child(flame)

	var cage_material := _decoration_material(Color(0.08, 0.055, 0.035), Color.BLACK, 0.0)
	for x in [-0.16, 0.16]:
		var cage := _make_decoration_bar(0.45, 0.025, cage_material)
		cage.position = light.position + Vector3(x, 0.0, 0.0)
		cage.rotation_degrees.z = 90.0
		town_root.add_child(cage)

func _make_town_portal_marker(position: Vector3) -> void:
	var root := Node3D.new()
	root.name = "TownArrivalPortal"
	root.position = position
	town_root.add_child(root)
	var ring := MeshInstance3D.new()
	var ring_mesh := TorusMesh.new()
	ring_mesh.inner_radius = 1.25
	ring_mesh.outer_radius = 1.48
	ring_mesh.ring_segments = 48
	ring_mesh.rings = 10
	ring.mesh = ring_mesh
	ring.position.y = 2.0
	ring.rotation_degrees.x = 90.0
	ring.material_override = _portal_material(Color(0.08, 0.6, 0.85, 0.62), Color(0.1, 0.85, 1.0), 1.8)
	root.add_child(ring)
	var light := OmniLight3D.new()
	light.position.y = 1.8
	light.light_color = Color(0.1, 0.8, 1.0)
	light.light_energy = 2.8
	light.omni_range = 7.0
	root.add_child(light)

func _make_town_store(vendor_id: String, vendor_name: String, position: Vector3, stall_color: Color, accent: Color, yaw_degrees: float) -> void:
	var root := Node3D.new()
	root.name = vendor_name.replace(" ", "")
	root.position = position
	root.rotation_degrees.y = yaw_degrees
	town_root.add_child(root)

	_make_shopfront(root, vendor_id, vendor_name, stall_color, accent)

	var area := Area3D.new()
	area.name = "%sArea" % vendor_id
	area.position = Vector3(0.0, 0.0, 2.05)
	area.body_entered.connect(_on_vendor_entered.bind(vendor_id))
	area.body_exited.connect(_on_vendor_exited.bind(vendor_id))
	root.add_child(area)

	var shape_node := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = Vector3(7.2, 2.4, 4.6)
	shape_node.shape = shape
	shape_node.position.y = 1.0
	area.add_child(shape_node)

func _make_shopfront(parent: Node3D, vendor_id: String, vendor_name: String, stall_color: Color, accent: Color) -> void:
	var stone_material := _town_wall_material(Vector3(7.2, 3.6, 0.9))
	var wood_material := _town_wood_material()
	var roof_material := _town_roof_material()
	var accent_material := _material(stall_color.lightened(0.08), accent, 0.18)

	_make_town_box(parent, "ShopBackWall", Vector3(7.2, 3.45, 0.72), Vector3(0.0, 1.75, -1.3), stone_material)
	_make_town_box(parent, "ShopCounter", Vector3(5.9, 1.05, 1.35), Vector3(0.0, 0.55, 0.3), accent_material)
	_make_town_box(parent, "ShopLedger", Vector3(4.8, 0.18, 1.18), Vector3(0.0, 1.15, 0.58), wood_material)
	_make_town_box(parent, "ShopSignBoard", Vector3(5.1, 0.76, 0.16), Vector3(0.0, 2.82, 0.92), _material(Color(0.045, 0.034, 0.026), accent, 0.12))
	_make_town_label(parent, vendor_name, Vector3(0.0, 2.82, 1.08), accent, 27)
	_make_town_roof_pair(parent, 7.8, 4.2, Vector3(0.0, 3.58, -0.6), roof_material)

	for x in [-3.05, 3.05]:
		_make_town_box(parent, "ShopPost", Vector3(0.2, 2.65, 0.2), Vector3(x, 1.34, 0.95), wood_material)
		_make_town_box(parent, "ShopBrace", Vector3(1.0, 0.14, 0.18), Vector3(x * 0.92, 2.42, 0.94), wood_material, Vector3(0.0, 0.0, signf(-x) * 24.0))

	for x in [-2.12, 2.12]:
		_make_town_window(parent, Vector3(x, 1.92, 0.98), Vector2(0.92, 1.08), accent)

	match vendor_id:
		"diamond_vendor":
			_make_diamond_shop_details(parent, accent)
		"spell_vendor":
			_make_spell_shop_details(parent, accent)
		"relic_vendor":
			_make_relic_shop_details(parent, accent)
		_:
			pass

	_make_vendor_figure(parent, Vector3(0.0, 0.0, 2.2), accent, vendor_id)

func _make_diamond_shop_details(parent: Node3D, accent: Color) -> void:
	_make_diamond_icon(parent, Vector3(0.0, 3.42, 1.1), 0.78, accent)
	for x in [-1.9, -0.65, 0.65, 1.9]:
		_make_diamond_icon(parent, Vector3(x, 1.42, 1.1), 0.32, accent)
	_make_town_box(parent, "GemCloth", Vector3(4.8, 0.08, 1.0), Vector3(0.0, 1.28, 0.78), _material(Color(0.02, 0.05, 0.085), accent, 0.08))
	var light := OmniLight3D.new()
	light.position = Vector3(0.0, 2.05, 1.15)
	light.light_color = accent
	light.light_energy = 1.4
	light.omni_range = 5.0
	parent.add_child(light)

func _make_spell_shop_details(parent: Node3D, accent: Color) -> void:
	var ring := MeshInstance3D.new()
	var ring_mesh := TorusMesh.new()
	ring_mesh.inner_radius = 0.42
	ring_mesh.outer_radius = 0.48
	ring_mesh.ring_segments = 36
	ring_mesh.rings = 8
	ring.mesh = ring_mesh
	ring.position = Vector3(0.0, 3.42, 1.1)
	ring.rotation_degrees.x = 90.0
	ring.material_override = _portal_material(Color(0.42, 0.08, 0.68, 0.78), accent, 2.4)
	parent.add_child(ring)
	for angle in [0.0, 45.0, 90.0, 135.0]:
		var rune := _make_decoration_bar(1.05, 0.035, _decoration_material(accent, accent, 1.2))
		rune.position = Vector3(0.0, 3.42, 1.12)
		rune.rotation_degrees.z = angle
		parent.add_child(rune)
	if spell_shop_scene != null:
		_make_spell_shop_model(parent, accent)
	elif spell_shop_texture != null:
		_make_spell_shop_image(parent, accent)

func _make_relic_shop_details(parent: Node3D, accent: Color) -> void:
	_make_town_box(parent, "RelicCloth", Vector3(4.9, 0.08, 1.0), Vector3(0.0, 1.28, 0.78), _material(Color(0.12, 0.075, 0.02), accent, 0.08))
	for x in [-1.7, 0.0, 1.7]:
		var relic := MeshInstance3D.new()
		var mesh := CylinderMesh.new()
		mesh.top_radius = 0.24
		mesh.bottom_radius = 0.3
		mesh.height = 0.5
		mesh.radial_segments = 6
		relic.mesh = mesh
		relic.position = Vector3(x, 1.58, 0.9)
		relic.material_override = _material(Color(0.45, 0.34, 0.16), accent, 0.22)
		parent.add_child(relic)

func _make_town_roof_pair(parent: Node3D, width: float, depth: float, position: Vector3, material: Material) -> void:
	for x in [-width * 0.22, width * 0.22]:
		var roof := MeshInstance3D.new()
		var mesh := BoxMesh.new()
		mesh.size = Vector3(width * 0.58, 0.28, depth)
		roof.mesh = mesh
		roof.position = position + Vector3(x, 0.0, 0.0)
		roof.rotation_degrees.z = 23.0 * signf(x)
		roof.material_override = material
		parent.add_child(roof)

func _make_town_window(parent: Node3D, position: Vector3, size: Vector2, accent: Color) -> void:
	_make_town_box(parent, "WindowFrame", Vector3(size.x + 0.18, size.y + 0.18, 0.08), position + Vector3(0.0, 0.0, -0.02), _town_wood_material())
	_make_town_box(parent, "WindowGlow", Vector3(size.x, size.y, 0.09), position, _material(accent.darkened(0.35), accent, 1.25))
	_make_town_box(parent, "WindowMullionV", Vector3(0.055, size.y + 0.08, 0.1), position + Vector3(0.0, 0.0, 0.03), _town_wood_material())
	_make_town_box(parent, "WindowMullionH", Vector3(size.x + 0.08, 0.055, 0.1), position + Vector3(0.0, 0.0, 0.03), _town_wood_material())

func _make_diamond_icon(parent: Node3D, position: Vector3, scale_value: float, accent: Color) -> void:
	var gem := MeshInstance3D.new()
	var mesh := BoxMesh.new()
	mesh.size = Vector3(scale_value, scale_value, 0.08)
	gem.mesh = mesh
	gem.position = position
	gem.rotation_degrees.z = 45.0
	gem.material_override = _material(accent.darkened(0.2), accent, 2.0)
	parent.add_child(gem)
	var glint := _make_decoration_bar(scale_value * 1.05, 0.035, _decoration_material(Color(0.76, 0.95, 1.0), accent, 1.8))
	glint.position = position + Vector3(0.0, 0.0, 0.055)
	glint.rotation_degrees.z = -45.0
	parent.add_child(glint)

func _make_town_street_dressing() -> void:
	for crate_data in [
		{"position": Vector3(-9.4, 0.0, 13.5), "yaw": 14.0},
		{"position": Vector3(9.6, 0.0, 8.5), "yaw": -18.0},
		{"position": Vector3(-10.2, 0.0, -8.0), "yaw": 32.0},
		{"position": Vector3(10.8, 0.0, -14.0), "yaw": -8.0}
	]:
		_make_town_crate(crate_data["position"], float(crate_data["yaw"]))
	for _index in range(16):
		_make_town_barrel(_random_town_decor_position())
	_make_town_banner(Vector3(-22.4, 2.5, 5.0), 90.0, Color(0.16, 0.04, 0.2), Color(0.78, 0.18, 1.0))
	_make_town_banner(Vector3(22.4, 2.7, -6.0), -90.0, Color(0.05, 0.11, 0.18), Color(0.12, 0.78, 1.0))
	_make_town_market_canopy(Vector3(-5.3, 0.0, -16.2), -8.0, Color(0.18, 0.035, 0.045), Color(0.95, 0.36, 0.12))
	_make_town_market_canopy(Vector3(6.4, 0.0, -17.2), 12.0, Color(0.06, 0.1, 0.13), Color(0.15, 0.8, 1.0))
	_make_town_greenery()
	_make_town_fences()

func _make_town_crate(position: Vector3, yaw_degrees: float) -> void:
	var root := Node3D.new()
	root.name = "TownCrate"
	root.position = position
	root.rotation_degrees.y = yaw_degrees
	town_root.add_child(root)
	_make_town_box(root, "Crate", Vector3(0.95, 0.78, 0.95), Vector3(0.0, 0.39, 0.0), _town_wood_material())
	_make_town_box(root, "CrateBandA", Vector3(1.05, 0.11, 0.08), Vector3(0.0, 0.28, 0.5), _material(Color(0.07, 0.052, 0.038), Color.BLACK, 0.0))
	_make_town_box(root, "CrateBandB", Vector3(1.05, 0.11, 0.08), Vector3(0.0, 0.56, 0.5), _material(Color(0.07, 0.052, 0.038), Color.BLACK, 0.0))

func _make_town_barrel(position: Vector3) -> void:
	if town_barrel_texture != null:
		var barrel_sprite := _make_town_billboard_sprite(town_barrel_texture, "TownBarrel", 0.004, Vector3.ONE * rng.randf_range(0.22, 0.34), Color.WHITE)
		barrel_sprite.position = position + Vector3(0.0, 0.2, 0.0)
		barrel_sprite.rotation_degrees.y = rng.randf_range(0.0, 360.0)
		return
	var barrel := MeshInstance3D.new()
	barrel.name = "TownBarrel"
	var mesh := CylinderMesh.new()
	mesh.top_radius = 0.36
	mesh.bottom_radius = 0.42
	mesh.height = 0.92
	mesh.radial_segments = 14
	barrel.mesh = mesh
	barrel.position = position + Vector3(0.0, 0.46, 0.0)
	barrel.material_override = _town_wood_material()
	town_root.add_child(barrel)

func _make_town_banner(position: Vector3, yaw_degrees: float, cloth: Color, accent: Color) -> void:
	var root := Node3D.new()
	root.name = "TownBanner"
	root.position = position
	root.rotation_degrees.y = yaw_degrees
	town_root.add_child(root)
	_make_town_box(root, "BannerRod", Vector3(1.1, 0.06, 0.06), Vector3(0.0, 0.36, 0.0), _town_wood_material())
	_make_town_box(root, "BannerCloth", Vector3(0.92, 1.32, 0.06), Vector3(0.0, -0.33, 0.0), _material(cloth, accent, 0.08))
	_make_diamond_icon(root, Vector3(0.0, -0.18, 0.05), 0.28, accent)

func _make_town_banner_line(start: Vector3, end: Vector3, cloth: Color, accent: Color) -> void:
	var center := (start + end) * 0.5
	var delta := end - start
	var length := Vector2(delta.x, delta.z).length()
	var line := _make_decoration_bar(length, 0.035, _decoration_material(Color(0.1, 0.07, 0.055), Color.BLACK, 0.0))
	line.position = center
	line.rotation_degrees.y = rad_to_deg(atan2(delta.z, delta.x))
	town_root.add_child(line)
	for i in range(7):
		var ratio := float(i) / 6.0
		var flag_position := start.lerp(end, ratio) + Vector3(0.0, -0.28 - float(i % 2) * 0.14, 0.0)
		var flag := MeshInstance3D.new()
		var flag_mesh := BoxMesh.new()
		flag_mesh.size = Vector3(0.62, 0.52, 0.035)
		flag.mesh = flag_mesh
		flag.position = flag_position
		flag.rotation_degrees.y = line.rotation_degrees.y
		flag.material_override = _material(cloth.lerp(accent, float(i % 3) * 0.12), accent, 0.06)
		town_root.add_child(flag)

func _make_town_market_canopy(position: Vector3, yaw_degrees: float, cloth: Color, accent: Color) -> void:
	var root := Node3D.new()
	root.name = "MarketCanopy"
	root.position = position
	root.rotation_degrees.y = yaw_degrees
	town_root.add_child(root)
	_make_town_box(root, "CanopyTable", Vector3(3.8, 0.65, 1.25), Vector3(0.0, 0.33, 0.0), _town_wood_material())
	_make_town_box(root, "CanopyCloth", Vector3(4.3, 0.18, 2.0), Vector3(0.0, 2.08, -0.1), _material(cloth, accent, 0.1))
	for x in [-1.85, 1.85]:
		_make_town_box(root, "CanopyPost", Vector3(0.13, 2.1, 0.13), Vector3(x, 1.05, 0.65), _town_wood_material())
	for x in [-1.1, 0.0, 1.1]:
		_make_diamond_icon(root, Vector3(x, 0.86, 0.68), 0.24, accent)

func _populate_town_people(count: int) -> void:
	var outfit_accents := [
		Color(0.58, 0.22, 0.14),
		Color(0.12, 0.28, 0.52),
		Color(0.42, 0.35, 0.16),
		Color(0.2, 0.42, 0.26),
		Color(0.36, 0.2, 0.46)
	]
	for i in range(count):
		var citizen := Node3D.new()
		citizen.name = "TownCitizen%s" % i
		citizen.position = _random_town_citizen_position()
		citizen.rotation_degrees.y = rng.randf_range(0.0, 360.0)
		town_root.add_child(citizen)
		var accent: Color = outfit_accents[rng.randi_range(0, outfit_accents.size() - 1)]
		_make_town_citizen_figure(citizen, accent)

func _random_town_citizen_position() -> Vector3:
	var position := Vector3(0.0, 0.0, 0.0)
	for _attempt in range(20):
		position = Vector3(rng.randf_range(-18.0, 18.0), 0.0, rng.randf_range(-18.0, 18.0))
		if abs(position.x) < 4.2:
			continue
		if position.distance_to(Vector3(0.0, 0.0, 20.0)) < 4.2:
			continue
		if position.distance_to(Vector3(-14.0, 0.0, 2.5)) < 4.5:
			continue
		if position.distance_to(Vector3(14.0, 0.0, 2.0)) < 4.5:
			continue
		if position.distance_to(Vector3(0.0, 0.0, -13.5)) < 4.8:
			continue
		break
	return position

func _make_town_citizen_figure(parent: Node3D, accent: Color) -> void:
	var skin := _material(Color(0.58, 0.44, 0.35), Color.BLACK, 0.0)
	var cloth := _material(accent.darkened(0.2), accent, 0.05)
	var cloth_dark := _material(accent.darkened(0.42), accent.darkened(0.2), 0.0)
	_make_town_box(parent, "CitizenBody", Vector3(0.46, 0.84, 0.32), Vector3(0.0, 0.92, 0.0), cloth)
	_make_town_box(parent, "CitizenHead", Vector3(0.28, 0.28, 0.28), Vector3(0.0, 1.52, 0.0), skin)
	for x in [-0.14, 0.14]:
		_make_town_box(parent, "CitizenLeg", Vector3(0.12, 0.7, 0.14), Vector3(x, 0.35, 0.0), cloth_dark)
	if vendor_front_texture != null:
		var cloak := Sprite3D.new()
		cloak.texture = vendor_front_texture
		cloak.pixel_size = 0.0045
		cloak.double_sided = true
		cloak.shaded = true
		cloak.billboard = BaseMaterial3D.BILLBOARD_ENABLED
		cloak.texture_filter = BaseMaterial3D.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS
		cloak.alpha_cut = SpriteBase3D.ALPHA_CUT_DISCARD
		cloak.position = Vector3(0.0, 1.0, 0.18)
		cloak.scale = Vector3.ONE * 0.48
		cloak.modulate = Color(1.0, 1.0, 1.0, 0.68).lerp(accent, 0.18)
		parent.add_child(cloak)

func _make_town_greenery() -> void:
	if town_tree_textures.is_empty():
		for tree_data in [
			{"position": Vector3(-21.0, 0.0, 16.5), "scale": 1.0},
			{"position": Vector3(21.5, 0.0, 14.0), "scale": 1.08},
			{"position": Vector3(-20.5, 0.0, -14.8), "scale": 0.92},
			{"position": Vector3(20.8, 0.0, -17.0), "scale": 1.14},
			{"position": Vector3(-12.8, 0.0, 21.4), "scale": 0.88},
			{"position": Vector3(13.0, 0.0, 21.6), "scale": 0.9}
		]:
			_make_town_tree(tree_data["position"], float(tree_data["scale"]))
		return

	for _index in range(52):
		var tree_texture := town_tree_textures[rng.randi_range(0, town_tree_textures.size() - 1)]
		var tree_scale := rng.randf_range(0.9, 1.45)
		var tree_sprite := _make_town_billboard_sprite(tree_texture, "TownTree", 0.0068, Vector3.ONE * tree_scale, Color.WHITE)
		tree_sprite.position = _random_town_decor_position(5.4) + Vector3(0.0, 1.95 * tree_scale, 0.0)
		tree_sprite.rotation_degrees.y = rng.randf_range(0.0, 360.0)

func _random_town_decor_position(street_half_width: float = 3.6) -> Vector3:
	var position := Vector3.ZERO
	for _attempt in range(35):
		position = Vector3(
			rng.randf_range(-TOWN_HALF_SIZE + 2.0, TOWN_HALF_SIZE - 2.0),
			0.0,
			rng.randf_range(-TOWN_HALF_SIZE + 2.0, TOWN_HALF_SIZE - 2.0)
		)
		if absf(position.x) < street_half_width:
			continue
		if position.distance_to(Vector3(0.0, 0.0, 20.0)) < 4.8:
			continue
		if position.distance_to(Vector3(-14.0, 0.0, 2.5)) < 8.5:
			continue
		if position.distance_to(Vector3(14.0, 0.0, 2.0)) < 8.5:
			continue
		if position.distance_to(Vector3(0.0, 0.0, -13.5)) < 8.5:
			continue
		break
	return position

func _make_town_billboard_sprite(texture: Texture2D, sprite_name: String, pixel_size: float, sprite_scale: Vector3, tint: Color) -> Sprite3D:
	var sprite := Sprite3D.new()
	sprite.name = sprite_name
	sprite.texture = texture
	sprite.pixel_size = pixel_size
	sprite.shaded = true
	sprite.double_sided = true
	sprite.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	sprite.texture_filter = BaseMaterial3D.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS
	sprite.alpha_cut = SpriteBase3D.ALPHA_CUT_DISCARD
	sprite.scale = sprite_scale
	sprite.modulate = tint
	town_root.add_child(sprite)
	return sprite

func _make_town_tree(position: Vector3, scale_value: float) -> void:
	var root := Node3D.new()
	root.name = "TownTree"
	root.position = position
	root.scale = Vector3.ONE * scale_value
	town_root.add_child(root)

	var trunk := MeshInstance3D.new()
	var trunk_mesh := CylinderMesh.new()
	trunk_mesh.top_radius = 0.18
	trunk_mesh.bottom_radius = 0.24
	trunk_mesh.height = 2.4
	trunk.mesh = trunk_mesh
	trunk.position = Vector3(0.0, 1.2, 0.0)
	trunk.material_override = _town_wood_material()
	root.add_child(trunk)

	var leaf_material := _material(Color(0.1, 0.28, 0.15), Color(0.04, 0.09, 0.05), 0.06)
	for offset in [Vector3(0.0, 2.38, 0.0), Vector3(0.58, 2.22, 0.08), Vector3(-0.55, 2.16, -0.12), Vector3(0.0, 2.75, 0.35)]:
		var leaves := MeshInstance3D.new()
		var leaves_mesh := SphereMesh.new()
		leaves_mesh.radius = 0.72
		leaves_mesh.height = 1.1
		leaves.mesh = leaves_mesh
		leaves.position = offset
		leaves.material_override = leaf_material
		root.add_child(leaves)

func _make_town_fences() -> void:
	_make_town_fence_row(Vector3(-17.5, 0.0, 18.8), Vector3(-6.0, 0.0, 18.8), 8)
	_make_town_fence_row(Vector3(6.0, 0.0, 18.8), Vector3(17.5, 0.0, 18.8), 8)
	_make_town_fence_row(Vector3(-22.0, 0.0, -11.5), Vector3(-22.0, 0.0, 6.0), 9)
	_make_town_fence_row(Vector3(22.0, 0.0, -10.0), Vector3(22.0, 0.0, 7.5), 9)

func _make_town_fence_row(start: Vector3, end: Vector3, segments: int) -> void:
	var fence_material := _town_wood_material()
	var rail_height := [0.55, 0.9]
	for i in range(segments + 1):
		var t := float(i) / float(maxi(segments, 1))
		var post_position := start.lerp(end, t)
		_make_town_box(town_root, "FencePost", Vector3(0.11, 1.05, 0.11), post_position + Vector3(0.0, 0.52, 0.0), fence_material)
	for i in range(segments):
		var from := start.lerp(end, float(i) / float(maxi(segments, 1)))
		var to := start.lerp(end, float(i + 1) / float(maxi(segments, 1)))
		var center := (from + to) * 0.5
		var direction := to - from
		var length := Vector2(direction.x, direction.z).length()
		if length <= 0.001:
			continue
		var yaw := rad_to_deg(atan2(direction.z, direction.x))
		for y in rail_height:
			var rail := _make_decoration_bar(length, 0.075, fence_material)
			rail.position = center + Vector3(0.0, y, 0.0)
			rail.rotation_degrees.y = yaw
			town_root.add_child(rail)

func _make_town_puddle(parent: Node3D, position: Vector3) -> void:
	var puddle := MeshInstance3D.new()
	puddle.name = "TownPuddle"
	var mesh := CylinderMesh.new()
	mesh.top_radius = 0.7
	mesh.bottom_radius = 0.7
	mesh.height = 0.01
	mesh.radial_segments = 28
	puddle.mesh = mesh
	puddle.position = position
	puddle.scale = Vector3(1.45, 1.0, 0.55)
	puddle.material_override = _portal_smoke_material(Color(0.04, 0.07, 0.085, 0.42), Color(0.02, 0.08, 0.11), 0.16)
	parent.add_child(puddle)

func _make_town_box(parent: Node3D, name: String, size: Vector3, position: Vector3, material: Material, rotation_degrees_value: Vector3 = Vector3.ZERO) -> MeshInstance3D:
	var box := MeshInstance3D.new()
	box.name = name
	var mesh := BoxMesh.new()
	mesh.size = size
	box.mesh = mesh
	box.position = position
	box.rotation_degrees = rotation_degrees_value
	box.material_override = material
	parent.add_child(box)
	return box

func _make_spell_shop_model(parent: Node3D, accent: Color) -> void:
	var shadow := MeshInstance3D.new()
	shadow.name = "SpellShopModelShadow"
	var shadow_mesh := CylinderMesh.new()
	shadow_mesh.top_radius = 2.45
	shadow_mesh.bottom_radius = 2.45
	shadow_mesh.height = 0.012
	shadow_mesh.radial_segments = 40
	shadow.mesh = shadow_mesh
	shadow.position = Vector3(0.0, 0.025, 0.68)
	shadow.scale = Vector3(1.35, 1.0, 0.58)
	shadow.material_override = _portal_smoke_material(Color(0.0, 0.0, 0.0, 0.36), Color.BLACK, 0.0)
	shadow.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	parent.add_child(shadow)

	var model := spell_shop_scene.instantiate() as Node3D
	if model == null:
		return
	model.name = "SpellShopModel"
	model.position = Vector3(0.0, 0.02, 0.72)
	model.rotation_degrees.y = 180.0
	model.scale = Vector3.ONE * 1.45
	parent.add_child(model)
	_prepare_spell_shop_model_materials(model, accent)

	var light := OmniLight3D.new()
	light.name = "SpellShopModelLight"
	light.position = Vector3(0.0, 2.0, 1.15)
	light.light_color = accent
	light.light_energy = 1.55
	light.omni_range = 5.8
	parent.add_child(light)

func _prepare_spell_shop_model_materials(node: Node, accent: Color) -> void:
	var mesh_instance := node as MeshInstance3D
	if mesh_instance != null and mesh_instance.mesh != null:
		for surface_index in range(mesh_instance.mesh.get_surface_count()):
			var source_material := mesh_instance.get_surface_override_material(surface_index)
			if source_material == null:
				source_material = mesh_instance.mesh.surface_get_material(surface_index)
			var material := source_material as StandardMaterial3D
			if material == null:
				continue
			var visible_material := material.duplicate() as StandardMaterial3D
			visible_material.cull_mode = BaseMaterial3D.CULL_DISABLED
			visible_material.roughness = maxf(visible_material.roughness, 0.72)
			if visible_material.emission_enabled:
				visible_material.emission = visible_material.emission.lerp(accent, 0.22)
				visible_material.emission_energy_multiplier = maxf(visible_material.emission_energy_multiplier, 0.65)
			mesh_instance.set_surface_override_material(surface_index, visible_material)
	for child in node.get_children():
		_prepare_spell_shop_model_materials(child, accent)

func _make_spell_shop_image(parent: Node3D, accent: Color) -> void:
	var shadow := MeshInstance3D.new()
	shadow.name = "SpellShopShadow"
	var shadow_mesh := CylinderMesh.new()
	shadow_mesh.top_radius = 2.15
	shadow_mesh.bottom_radius = 2.15
	shadow_mesh.height = 0.012
	shadow_mesh.radial_segments = 32
	shadow.mesh = shadow_mesh
	shadow.position = Vector3(0.0, 0.02, 0.02)
	shadow.scale = Vector3(1.2, 1.0, 0.42)
	shadow.material_override = _portal_smoke_material(Color(0.0, 0.0, 0.0, 0.38), Color.BLACK, 0.0)
	shadow.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	parent.add_child(shadow)

	var sprite := Sprite3D.new()
	sprite.name = "SpellShopSprite"
	sprite.texture = spell_shop_texture
	sprite.pixel_size = 0.018
	sprite.shaded = true
	sprite.double_sided = true
	sprite.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	sprite.texture_filter = BaseMaterial3D.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS
	sprite.alpha_cut = SpriteBase3D.ALPHA_CUT_DISCARD
	sprite.position = Vector3(0.0, 1.62, 1.05)
	sprite.scale = Vector3.ONE * 0.8
	sprite.modulate = Color(1.02, 0.98, 0.92, 1.0).lerp(accent, 0.05)
	parent.add_child(sprite)

func _make_vendor_figure(parent: Node3D, position: Vector3, accent: Color, vendor_id: String = "") -> void:
	var vendor_texture := _town_vendor_texture_for(vendor_id)
	if vendor_texture != null:
		var shadow := MeshInstance3D.new()
		shadow.name = "VendorShadow"
		var shadow_mesh := CylinderMesh.new()
		shadow_mesh.top_radius = 0.58
		shadow_mesh.bottom_radius = 0.58
		shadow_mesh.height = 0.012
		shadow_mesh.radial_segments = 24
		shadow.mesh = shadow_mesh
		shadow.position = position + Vector3(0.0, 0.02, 0.0)
		shadow.scale = Vector3(1.25, 1.0, 0.56)
		shadow.material_override = _portal_smoke_material(Color(0.0, 0.0, 0.0, 0.34), Color.BLACK, 0.0)
		shadow.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
		parent.add_child(shadow)

		var sprite := Sprite3D.new()
		sprite.name = "VendorSprite"
		sprite.texture = vendor_texture
		sprite.pixel_size = 0.003
		sprite.shaded = false
		sprite.double_sided = true
		sprite.billboard = BaseMaterial3D.BILLBOARD_FIXED_Y
		sprite.texture_filter = BaseMaterial3D.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS
		sprite.alpha_cut = SpriteBase3D.ALPHA_CUT_DISCARD
		sprite.position = position + Vector3(0.0, 0.88, 0.0)
		sprite.scale = Vector3.ONE
		sprite.modulate = Color(1.0, 1.0, 1.0, 1.0)
		parent.add_child(sprite)
		if vendor_texture == vendor_front_texture and vendor_side_texture != null and vendor_back_texture != null:
			vendor_sprites.append({
				"sprite": sprite,
				"parent": parent
			})
		return

	var body := MeshInstance3D.new()
	var body_mesh := CylinderMesh.new()
	body_mesh.top_radius = 0.34
	body_mesh.bottom_radius = 0.44
	body_mesh.height = 1.15
	body.mesh = body_mesh
	body.position = position
	body.material_override = _material(Color(0.12, 0.09, 0.08), accent, 0.16)
	parent.add_child(body)

	var head := MeshInstance3D.new()
	var head_mesh := SphereMesh.new()
	head_mesh.radius = 0.28
	head_mesh.height = 0.36
	head_mesh.radial_segments = 18
	head_mesh.rings = 8
	head.mesh = head_mesh
	head.position = position + Vector3(0.0, 0.78, 0.0)
	head.material_override = _material(Color(0.62, 0.48, 0.34), Color.BLACK, 0.0)
	parent.add_child(head)

func _town_vendor_texture_for(vendor_id: String) -> Texture2D:
	match vendor_id:
		"diamond_vendor":
			if town_vendor_man_texture != null:
				return town_vendor_man_texture
		"spell_vendor":
			if town_vendor_woman_texture != null:
				return town_vendor_woman_texture
		"relic_vendor":
			if town_vendor_woman_texture != null:
				return town_vendor_woman_texture
	if vendor_front_texture != null:
		return vendor_front_texture
	return null

func _update_vendor_sprites() -> void:
	if camera == null or vendor_sprites.is_empty():
		return
	for vendor_data in vendor_sprites:
		var sprite := vendor_data["sprite"] as Sprite3D
		var parent := vendor_data["parent"] as Node3D
		if sprite == null or parent == null or not is_instance_valid(sprite) or not is_instance_valid(parent):
			continue
		var local_camera := parent.to_local(camera.global_position)
		local_camera.y = 0.0
		if local_camera.length_squared() <= 0.001:
			continue
		if local_camera.z >= absf(local_camera.x) * 0.72:
			sprite.texture = vendor_front_texture
			sprite.flip_h = false
		elif local_camera.z <= -absf(local_camera.x) * 0.72:
			sprite.texture = vendor_back_texture
			sprite.flip_h = false
		else:
			sprite.texture = vendor_side_texture
			sprite.flip_h = local_camera.x < 0.0

func _make_town_label(parent: Node3D, text: String, position: Vector3, color: Color, font_size: int = 34) -> void:
	var label := Label3D.new()
	label.text = text
	label.position = position
	label.font_size = font_size
	label.modulate = color.lightened(0.35)
	label.outline_modulate = Color(0.0, 0.0, 0.0, 0.95)
	label.outline_size = 8
	label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	parent.add_child(label)

func _make_exit_fx() -> void:
	exit_swirl_root = Node3D.new()
	exit_swirl_root.position = Vector3(0.0, 2.08, 0.5) + EXIT_PORTAL_VISUAL_OFFSET
	exit_area.add_child(exit_swirl_root)
	exit_sparks.clear()
	exit_souls.clear()
	exit_smoke_wisps.clear()

	for i in range(22):
		var wisp: MeshInstance3D = _make_portal_smoke_wisp(i)
		exit_smoke_wisps.append(wisp)
		exit_swirl_root.add_child(wisp)

	for i in range(16):
		var spark: MeshInstance3D = _make_portal_spark(i)
		exit_sparks.append(spark)
		exit_swirl_root.add_child(spark)

	for i in range(6):
		var soul: MeshInstance3D = _make_portal_soul(i)
		exit_souls.append(soul)
		exit_swirl_root.add_child(soul)

func _make_portal_smoke_wisp(index: int) -> MeshInstance3D:
	var wisp := MeshInstance3D.new()
	wisp.name = "PortalSmokeWisp"
	var mesh := SphereMesh.new()
	mesh.radius = 0.26
	mesh.height = 0.36
	mesh.radial_segments = 16
	mesh.rings = 8
	wisp.mesh = mesh
	var heat := float(index % 4) * 0.035
	var alpha := 0.22 + float(index % 5) * 0.035
	var tint := Color(0.12 + heat, 0.075 + heat * 0.7, 0.09 + heat, alpha)
	wisp.material_override = _portal_smoke_material(tint, Color(0.34, 0.045, 0.035), 0.42)
	return wisp

func _make_portal_spark(index: int) -> MeshInstance3D:
	var spark := MeshInstance3D.new()
	spark.name = "PortalSpark"
	var mesh := SphereMesh.new()
	mesh.radius = 0.08
	mesh.height = 0.12
	mesh.radial_segments = 8
	mesh.rings = 4
	spark.mesh = mesh
	var ember_tint := Color(1.0, 0.38 + float(index % 3) * 0.14, 0.08, 0.92)
	spark.material_override = _portal_material(ember_tint, Color(1.0, 0.32, 0.04), 2.6)
	return spark

func _make_portal_soul(index: int) -> MeshInstance3D:
	var soul := MeshInstance3D.new()
	soul.name = "PortalSoul"
	var mesh := SphereMesh.new()
	mesh.radius = 0.18
	mesh.height = 0.28
	mesh.radial_segments = 16
	mesh.rings = 8
	soul.mesh = mesh
	var tint := Color(0.08, 0.02 + float(index % 2) * 0.05, 0.12, 0.32)
	soul.material_override = _portal_smoke_material(tint, Color(0.28, 0.04, 0.36), 0.7)
	return soul

func _animate_exit_fx(delta: float) -> void:
	if exit_swirl_root == null:
		return
	var energy: float = 1.0
	if exit_open:
		energy = 1.7
	exit_swirl_root.rotation_degrees.z += delta * 48.0 * energy
	var pulse: float = 1.0 + sin(Time.get_ticks_msec() * 0.006) * 0.08 * energy
	var time: float = Time.get_ticks_msec() * 0.001
	for i in range(exit_smoke_wisps.size()):
		var wisp: MeshInstance3D = exit_smoke_wisps[i]
		var progress: float = float(i) / max(1.0, float(exit_smoke_wisps.size() - 1))
		var arm_offset: float = float(i % 3) * TAU / 3.0
		var curl: float = -time * 2.1 * energy + progress * 5.9 + arm_offset
		var radius: float = 0.12 + progress * 0.72 + sin(time * 1.9 + float(i)) * 0.035
		var oval_y: float = 0.72
		wisp.position = Vector3(cos(curl) * radius, sin(curl) * radius * oval_y, 0.08 + progress * 0.02)
		wisp.rotation_degrees.z = rad_to_deg(curl) + 32.0
		var drift: float = 1.0 + sin(time * 2.3 + float(i) * 0.71) * 0.18
		wisp.scale = Vector3(0.34 + progress * 0.48, 0.13 + progress * 0.24, 0.055) * drift * pulse
	for i in range(exit_sparks.size()):
		var spark: MeshInstance3D = exit_sparks[i]
		var angle: float = time * 1.8 * energy + float(i) * 1.83
		var radius: float = 0.45 + float(i % 5) * 0.18 + sin(angle * 1.7) * 0.05
		spark.position = Vector3(cos(angle) * radius, sin(angle * 1.34) * radius * 0.76, 0.12 + sin(angle) * 0.05)
		spark.scale = Vector3.ONE * (0.035 + 0.018 * sin(angle * 3.0))
	for i in range(exit_souls.size()):
		var soul: MeshInstance3D = exit_souls[i]
		var angle: float = time * 0.8 * energy + float(i) * 2.1
		var radius: float = 0.22 + float(i % 3) * 0.28
		soul.position = Vector3(cos(angle) * radius, sin(angle * 0.9) * 0.82, -0.05)
		soul.scale = Vector3.ONE * (0.18 + 0.04 * sin(angle * 2.4))
	if exit_light != null:
		exit_light.light_energy = 0.9 + sin(Time.get_ticks_msec() * 0.005) * 0.25
		if exit_open:
			exit_light.light_energy = 3.0 + sin(Time.get_ticks_msec() * 0.008) * 0.75

func _make_exit() -> void:
	exit_area = Area3D.new()
	exit_area.name = "ExitDoor"
	exit_area.position = Vector3(0.0, 0.0, -31.8)
	exit_area.body_entered.connect(_on_exit_entered)
	add_child(exit_area)

	var collider := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = Vector3(5.0, 3.5, 1.2)
	collider.shape = shape
	collider.position.y = 1.5
	exit_area.add_child(collider)

	var portal_back: MeshInstance3D = MeshInstance3D.new()
	var back_mesh: BoxMesh = BoxMesh.new()
	back_mesh.size = Vector3(4.75, 4.15, 0.75)
	portal_back.mesh = back_mesh
	portal_back.position = Vector3(0.0, 2.0, -0.28)
	portal_back.material_override = _material(Color(0.08, 0.055, 0.05), Color(0.28, 0.015, 0.04), 0.28)
	exit_area.add_child(portal_back)

	var left_pillar: MeshInstance3D = _make_exit_block(Vector3(0.34, 3.95, 0.7), Color(0.12, 0.11, 0.105))
	left_pillar.position = Vector3(-2.32, 2.0, -0.15)
	exit_area.add_child(left_pillar)

	var right_pillar: MeshInstance3D = _make_exit_block(Vector3(0.34, 3.95, 0.7), Color(0.12, 0.11, 0.105))
	right_pillar.position = Vector3(2.32, 2.0, -0.15)
	exit_area.add_child(right_pillar)

	var top_cap: MeshInstance3D = _make_exit_block(Vector3(4.8, 0.34, 0.7), Color(0.14, 0.13, 0.12))
	top_cap.position = Vector3(0.0, 3.98, -0.15)
	exit_area.add_child(top_cap)

	exit_sprite = _make_exit_sprite()
	exit_sprite.position = Vector3(0.0, 2.05, 0.32) + EXIT_PORTAL_VISUAL_OFFSET
	exit_area.add_child(exit_sprite)

	exit_light = OmniLight3D.new()
	exit_light.light_color = Color(0.75, 0.02, 0.12)
	exit_light.light_energy = 0.8
	exit_light.omni_range = 6.0
	exit_light.position.y = 2.1
	exit_area.add_child(exit_light)
	_make_exit_fx()

func _spawn_encounter() -> void:
	current_area = AREA_CASTLE
	_set_background_music(LEVEL_ONE_MUSIC)
	if player != null:
		player.set_attacks_enabled(true)
	if hud != null:
		hud.set_minimap_visible(true)
	var spawn_points: Array[Vector3] = _enemy_spawn_points()
	for i in range(spawn_points.size()):
		var enemy_kind := SISEnemy.ENEMY_KIND_ANGEL
		if i % 2 == 1:
			enemy_kind = SISEnemy.ENEMY_KIND_KNIGHT
		_spawn_enemy_at(spawn_points[i], i >= spawn_points.size() - 3, enemy_kind)
	_spawn_enemy_at(Vector3(-4.2, 0.1, -27.5), false, SISEnemy.ENEMY_KIND_CLERIC)
	_spawn_enemy_at(Vector3(4.2, 0.1, -27.5), false, SISEnemy.ENEMY_KIND_CLERIC)

func _spawn_enemy_at(spawn_position: Vector3, elite: bool = false, enemy_kind: StringName = SISEnemy.ENEMY_KIND_ANGEL) -> void:
	var enemy: SISEnemy = EnemyScript.new() as SISEnemy
	enemy.position = spawn_position
	enemy.enemy_kind = enemy_kind
	add_child(enemy)
	enemy.configure(player, player.level, elite, enemy_kind)
	enemy.killed.connect(_on_enemy_killed)
	enemies.append(enemy)

func _spawn_chests() -> void:
	var chest_points: Array[Vector3] = [
		Vector3(23.0, 0.1, 23.0),
		Vector3(-23.0, 0.1, 0.0),
		Vector3(23.0, 0.1, 0.0),
		Vector3(-23.0, 0.1, -23.0),
		Vector3(23.0, 0.1, -23.0),
		Vector3(0.0, 0.1, -23.0)
	]
	for chest_point in chest_points:
		var chest: SISChest = ChestScript.new() as SISChest
		chest.position = chest_point
		chest.rotation.y = rng.randf_range(0.0, TAU)
		add_child(chest)
		chest.configure(player)
		chest.opened.connect(_on_chest_opened)

func _spawn_scroll_for_game_level(scroll_level: int) -> void:
	if scroll_level < 1 or scroll_level > scroll_entries.size():
		return
	if spawned_scroll_game_levels.has(scroll_level):
		return
	if active_scroll != null and is_instance_valid(active_scroll):
		return
	var scroll := ScrollScript.new()
	scroll.scroll_level = scroll_level
	scroll.position = _random_scroll_position()
	scroll.rotation.y = rng.randf_range(0.0, TAU)
	add_child(scroll)
	scroll.read_requested.connect(_on_scroll_read_requested)
	active_scroll = scroll
	spawned_scroll_game_levels.append(scroll_level)

func _random_scroll_position() -> Vector3:
	var anchors := _scroll_spawn_anchors()
	var best_position := anchors[rng.randi_range(0, anchors.size() - 1)]
	for attempt in range(18):
		var anchor: Vector3 = anchors[rng.randi_range(0, anchors.size() - 1)]
		var position := anchor + Vector3(rng.randf_range(-3.2, 3.2), 0.0, rng.randf_range(-3.2, 3.2))
		position.x = clampf(position.x, -ARENA_HALF_SIZE + 3.0, ARENA_HALF_SIZE - 3.0)
		position.z = clampf(position.z, -ARENA_HALF_SIZE + 3.0, ARENA_HALF_SIZE - 3.0)
		if player != null and position.distance_to(player.global_position) < 7.0:
			continue
		if position.distance_to(exit_area.global_position) < 6.0:
			continue
		best_position = position
		break
	best_position.y = 0.12
	return best_position

func _scroll_spawn_anchors() -> Array[Vector3]:
	return [
		Vector3(23.0, 0.1, 23.0),
		Vector3(-23.0, 0.1, 0.0),
		Vector3(23.0, 0.1, 0.0),
		Vector3(-23.0, 0.1, -23.0),
		Vector3(23.0, 0.1, -23.0),
		Vector3(0.0, 0.1, 22.0),
		Vector3(22.0, 0.1, 6.0),
		Vector3(-22.0, 0.1, -6.0),
		Vector3(0.0, 0.1, -22.0),
		Vector3(-6.0, 0.1, 0.0),
		Vector3(6.0, 0.1, 0.0)
	]

func _enemy_spawn_points() -> Array[Vector3]:
	return [
		Vector3(0.0, 0.1, 22.0), Vector3(22.0, 0.1, 22.0),
		Vector3(-22.0, 0.1, 6.0), Vector3(22.0, 0.1, 6.0),
		Vector3(-6.0, 0.1, 0.0), Vector3(6.0, 0.1, 0.0),
		Vector3(-22.0, 0.1, -6.0), Vector3(22.0, 0.1, -6.0),
		Vector3(-22.0, 0.1, -22.0), Vector3(0.0, 0.1, -22.0), Vector3(22.0, 0.1, -22.0),
		Vector3(-6.0, 0.1, -25.0), Vector3(6.0, 0.1, -25.0)
	]

func _on_firestorm_requested(target_position: Vector3) -> void:
	if current_area == AREA_TOWN:
		return
	_play_sound(FIRE_STORM_SOUND, -2.0)
	_play_firestorm_impact_sequence()
	var storm: SISFireStorm = FireStormScript.new() as SISFireStorm
	add_child(storm)
	storm.configure(target_position, enemies, player.level)
	storm.radius += player.get_skill_radius_bonus()
	if player.has_spell("wide_flame"):
		storm.radius += 1.35
		storm.strikes += 4
	storm.damage = int(round(float(storm.damage) * player.get_damage_multiplier()))
	if player.has_spell("searing_fire"):
		storm.damage = int(round(float(storm.damage) * 1.25))
	storm.damage = int(round(float(storm.damage) * player.get_skill_damage_multiplier()))
	storm.enemy_hit.connect(_on_firestorm_enemy_hit)
	_say_whisper("Yes. Let the ceiling learn to burn.")

func _play_firestorm_impact_sequence() -> void:
	var boom_delays := [0.24, 0.42, 0.60, 0.78, 1.04, 1.30, 1.48]
	for delay in boom_delays:
		var boom_timer := get_tree().create_timer(delay)
		boom_timer.timeout.connect(func() -> void:
			_play_sound(FIRE_STORM_BOOM_SOUND, -8.5)
		)

func _on_firestorm_enemy_hit(enemy: Node3D, damage: int) -> void:
	if is_instance_valid(enemy) and enemy.has_method("take_damage"):
		enemy.take_damage(damage)

func _on_enemy_killed(enemy: Node3D) -> void:
	if enemy.get("enemy_kind") == SISEnemy.ENEMY_KIND_ANGEL:
		_play_sound(ANGEL_DEAD_SOUND, -1.5)
	kills += 1
	var first_kill := kills == 1
	if first_kill:
		hud.set_whispers_enabled(true)
	enemies.erase(enemy)
	var xp_reward: int = int(enemy.get("xp_reward"))
	var gold_reward: int = int(enemy.get("gold_reward"))
	var leveled_up := player.gain_xp(xp_reward)
	player.notify_kill()
	var kill_streak := 1
	if whisper_system != null:
		whisper_system.record_kill(kills, player)
		kill_streak = int(whisper_system.kill_streak)
	if hud != null:
		hud.notify_kill_feedback(kill_streak)
	_spawn_gold(enemy.global_position, gold_reward + rng.randi_range(0, 8))
	var opened_exit := false
	if kills >= STAGE_ENEMY_COUNT and not exit_open:
		exit_open = true
		opened_exit = true
		exit_light.light_color = Color(0.15, 0.85, 1.0)
		exit_light.light_energy = 3.4
		if exit_sprite != null:
			exit_sprite.modulate = Color(0.82, 1.12, 1.25, 1.0)
	if opened_exit:
		_say_whisper("The door yields. Leave, if leaving is still your idea.")
	elif first_kill:
		if introduction_whisper.is_empty():
			_say_whisper("There. Now I can hear you.")
		else:
			_say_whisper(introduction_whisper)
	elif leveled_up:
		_say_whisper("Stronger. Louder. Do you feel me taking root?")
	else:
		_maybe_say_after_kill_whisper()
	_update_objective()
	_update_possession()

func _maybe_say_after_kill_whisper() -> void:
	if rng.randf() <= AFTER_KILL_WHISPER_CHANCE:
		_say_random_whisper(after_killing_whispers)

func _on_chest_opened(chest: Node3D) -> void:
	_play_sound(TREASURE_CHEST_SOUND, -1.0)
	_spawn_gold(chest.global_position + Vector3(0.0, 0.4, 0.0), rng.randi_range(18, 38))
	if rng.randf() < 0.45:
		_say_whisper("Tribute in a box. How thoughtful of the dead.")

func _on_scroll_read_requested(scroll: Node3D) -> void:
	var scroll_level: int = int(scroll.get("scroll_level"))
	var scroll_entry := _scroll_entry_for_level(scroll_level)
	hud.show_scroll(scroll_entry["title"], scroll_entry["body"])
	active_scroll = null

func _scroll_entry_for_level(scroll_level: int) -> Dictionary:
	if scroll_entries.is_empty():
		return {
			"title": "Scroll",
			"body": "The parchment is blank."
		}
	var entry_index: int = clampi(scroll_level - 1, 0, scroll_entries.size() - 1)
	return scroll_entries[entry_index]

func _spawn_gold(position: Vector3, amount: int) -> void:
	var gold: SISDroppedGold = GoldScript.new() as SISDroppedGold
	gold.amount = amount
	gold.position = position + Vector3(rng.randf_range(-0.6, 0.6), 0.55, rng.randf_range(-0.6, 0.6))
	add_child(gold)
	gold.picked_up.connect(_on_gold_picked_up)

func _on_gold_picked_up(amount: int) -> void:
	_play_sound(TREASURE_CHEST_SOUND, -5.0)
	player.add_gold(amount)

func _on_player_stats_changed(stats: Dictionary) -> void:
	if hud != null:
		hud.update_stats(stats)
		if whisper_system != null:
			hud.set_corruption_ui(float(whisper_system.corruption), _current_hp_percent())

func _on_player_damaged(amount: int) -> void:
	if whisper_system != null:
		whisper_system.record_player_damage(amount, player)

func _on_player_died() -> void:
	hud.show_death()
	_say_whisper("Rest. I will remember the shape of your fear.")

func _on_resurrect_requested() -> void:
	if player == null or player.alive:
		return
	var spawn_position := PLAYER_START_POSITION
	if current_area == AREA_TOWN:
		spawn_position = TOWN_SPAWN_POSITION
	player.resurrect_at(spawn_position)
	hud.hide_death()
	camera.global_position = player.global_position + _camera_follow_offset()
	camera.look_at(player.global_position + Vector3(0.0, 0.7, 0.0), Vector3.UP)
	_say_whisper("Again, then. Bring me what remains.")

func _on_exit_entered(body: Node3D) -> void:
	if body.name != "Player":
		return
	if exit_open:
		_play_sound(EXIT_SOUND, -1.0)
		if not exit_directive_completed:
			exit_directive_completed = true
			_update_possession()
		_enter_town()
	else:
		_say_whisper("Locked. The castle wants blood before it opens.")

func _enter_town() -> void:
	_make_town()
	current_area = AREA_TOWN
	_set_background_music(TOWN_MUSIC)
	active_vendor_id = ""
	if hud != null:
		hud.hide_shop()
		hud.set_minimap_visible(false)
	if player != null:
		player.set_attacks_enabled(false)
	player.teleport_to(TOWN_SPAWN_POSITION)
	camera.global_position = player.global_position + _camera_follow_offset()
	camera.look_at(player.global_position + Vector3(0.0, 0.7, 0.0), Vector3.UP)
	hud.set_objective("Town reached. Visit vendors to buy diamonds and spells.")
	_say_whisper("A door behind us. A market ahead. Spend wisely.")

func _on_vendor_entered(body: Node3D, vendor_id: String) -> void:
	if body.name != "Player" or current_area != AREA_TOWN:
		return
	active_vendor_id = vendor_id
	_show_vendor_shop(vendor_id, _vendor_greeting(vendor_id))

func _on_vendor_exited(body: Node3D, vendor_id: String) -> void:
	if body.name != "Player" or active_vendor_id != vendor_id:
		return
	active_vendor_id = ""
	if hud != null:
		hud.hide_shop()

func _show_vendor_shop(vendor_id: String, status_text: String) -> void:
	if hud == null:
		return
	hud.show_shop(_vendor_title(vendor_id), _shop_items_for_vendor(vendor_id), status_text, _wallet_text())

func _vendor_title(vendor_id: String) -> String:
	match vendor_id:
		"diamond_vendor":
			return "Diamond Broker"
		"spell_vendor":
			return "Spell Vendor"
		"relic_vendor":
			return "Relic Stall"
		_:
			return "Vendor"

func _vendor_greeting(vendor_id: String) -> String:
	match vendor_id:
		"diamond_vendor":
			return "Trade castle gold for diamonds. Spell vendors prefer cleaner currency."
		"spell_vendor":
			return "Spend diamonds to bind permanent spell upgrades."
		"relic_vendor":
			return "This stall is still being stocked. The vendor gestures apologetically."
		_:
			return "The vendor waits."

func _shop_items_for_vendor(vendor_id: String) -> Array[Dictionary]:
	var items: Array[Dictionary] = []
	match vendor_id:
		"diamond_vendor":
			for pack in DIAMOND_PACKS:
				items.append({
					"id": String(pack["id"]),
					"name": String(pack["name"]),
					"description": String(pack["description"]),
					"price": "%s gold" % int(pack["gold_cost"])
				})
		"spell_vendor":
			for spell in SPELL_CATALOG:
				var description := String(spell["description"])
				if player.has_spell(String(spell["id"])):
					description += " Learned."
				items.append({
					"id": String(spell["id"]),
					"name": String(spell["name"]),
					"description": description,
					"price": "%s diamonds" % int(spell["diamond_cost"])
				})
		"relic_vendor":
			items.append({
				"id": "relic_pending",
				"name": "Coming Soon",
				"description": "The relic vendor will stock equipment later.",
				"price": "-"
			})
	return items

func _wallet_text() -> String:
	return "Gold %s    Diamonds %s" % [player.gold, player.diamonds]

func _on_shop_purchase_requested(item_id: String) -> void:
	if active_vendor_id.is_empty() or player == null:
		return
	var status_text := "Nothing happens."
	if active_vendor_id == "diamond_vendor":
		status_text = _buy_diamond_pack(item_id)
	elif active_vendor_id == "spell_vendor":
		status_text = _buy_spell(item_id)
	else:
		status_text = "The stall has nothing for sale yet."
	_show_vendor_shop(active_vendor_id, status_text)

func _buy_diamond_pack(item_id: String) -> String:
	for pack in DIAMOND_PACKS:
		if String(pack["id"]) != item_id:
			continue
		var cost := int(pack["gold_cost"])
		if not player.spend_gold(cost):
			return "Not enough gold."
		player.add_diamonds(int(pack["diamonds"]))
		return "Purchased %s diamonds." % int(pack["diamonds"])
	return "The broker does not recognize that bundle."

func _buy_spell(item_id: String) -> String:
	for spell in SPELL_CATALOG:
		if String(spell["id"]) != item_id:
			continue
		if player.has_spell(item_id):
			return "Already learned."
		var cost := int(spell["diamond_cost"])
		if not player.spend_diamonds(cost):
			return "Not enough diamonds."
		player.learn_spell(item_id)
		return "Learned %s." % String(spell["name"])
	return "The spell vendor cannot teach that."

func _on_shop_closed() -> void:
	pass

func _on_skill_tree_point_requested(node_key: String) -> void:
	if player == null:
		return
	player.unlock_skill_node(node_key)

func _update_objective() -> void:
	if current_area == AREA_TOWN:
		hud.set_objective("Town reached. Visit vendors to buy diamonds and spells.")
		return
	if exit_open:
		hud.set_objective("Enter the portal. Leave the dead behind.")
	else:
		hud.set_objective("Slay everyone in the castle: %s/%s lives taken. Crack open their chests." % [kills, STAGE_ENEMY_COUNT])

func _update_possession() -> void:
	if hud == null:
		return
	var directive_steps := 0
	if exit_open:
		directive_steps += 1
	if exit_directive_completed:
		directive_steps += 1
	var max_possession_steps := STAGE_ENEMY_COUNT + 2
	hud.set_possession_ratio(float(kills + directive_steps) / float(max_possession_steps))

func _update_minimap() -> void:
	if hud == null or player == null:
		return
	var enemy_positions: Array[Vector3] = []
	if current_area == AREA_TOWN:
		hud.set_minimap_visible(false)
		hud.update_minimap(player.global_position - TOWN_ORIGIN, enemy_positions, TOWN_HALF_SIZE)
		return
	hud.set_minimap_visible(true)
	var can_see_enemies := reveal_enemies_on_minimap
	if whisper_system != null and whisper_system.corruption >= 70.0:
		can_see_enemies = true
	if can_see_enemies:
		for enemy in enemies:
			if is_instance_valid(enemy):
				enemy_positions.append(enemy.global_position)
	hud.update_minimap(player.global_position, enemy_positions, ARENA_HALF_SIZE)

func _on_corruption_changed(corruption: float, ratio: float) -> void:
	if hud == null:
		return
	_update_possession()
	hud.set_corruption_ui(corruption, _current_hp_percent())
	if corruption >= 100.0 and not possession_fx_played:
		possession_fx_played = true
		if player != null:
			player.flash_possession_red()

func _current_hp_percent() -> float:
	if player == null:
		return 1.0
	return float(player.life) / maxf(float(player.max_life), 1.0)

func _on_whisper_effect_requested(effect_id: String, data: Dictionary) -> void:
	match effect_id:
		"blood_surge":
			player.apply_timed_damage_multiplier(1.3, 10.0)
			player.reduce_max_life_percent(0.05)
		"shared_sight":
			reveal_enemies_on_minimap = true
			hud.set_corruption_distortion(minf(1.0, whisper_system.get_corruption_ratio() + 0.2))
		"hunger_unbound":
			player.enable_hunger_unbound()
		"borrowed_life":
			player.heal_full()
			player.reduce_max_life(maxi(4, int(round(float(player.max_life) * 0.06))))
		"relentless_reward":
			player.apply_timed_damage_multiplier(1.28, 10.0)
		"relentless_fail":
			player.apply_timed_damage_multiplier(0.72, 10.0)
		"no_mercy_reward":
			player.heal(maxi(12, int(round(float(player.max_life) * 0.22))))
			player.add_shield(maxi(10, int(round(float(player.max_life) * 0.18))))
		"no_mercy_fail":
			player.apply_timed_slow(0.72, 5.0)
		"gluttony_reward":
			player.apply_lifesteal(0.7, 14.0)
		"gluttony_fail":
			player.take_damage(maxi(8, int(round(float(player.max_life) * 0.12))))
		"obedience_reward":
			player.apply_timed_damage_multiplier(1.6, 8.0)
		"obedience_fail":
			pass
		"control_lapse":
			player.apply_control_lapse(float(data.get("duration", 0.8)))
		_:
			pass

func _make_exit_block(size: Vector3, color: Color) -> MeshInstance3D:
	var block: MeshInstance3D = MeshInstance3D.new()
	var mesh: BoxMesh = BoxMesh.new()
	mesh.size = size
	block.mesh = mesh
	block.material_override = _material(color, Color.BLACK, 0.0)
	return block

func _make_exit_sprite() -> Sprite3D:
	var sprite: Sprite3D = Sprite3D.new()
	if ResourceLoader.exists(PORTAL_FRAME_TEXTURE_PATH):
		sprite.texture = load(PORTAL_FRAME_TEXTURE_PATH) as Texture2D
	else:
		sprite.texture = EXIT_TEXTURE
	sprite.pixel_size = 0.0114
	sprite.shaded = true
	sprite.double_sided = true
	sprite.texture_filter = BaseMaterial3D.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS
	sprite.alpha_cut = SpriteBase3D.ALPHA_CUT_DISCARD
	sprite.modulate = Color(1.0, 1.0, 1.0, 1.0)
	return sprite

func _floor_material() -> StandardMaterial3D:
	var material: StandardMaterial3D = StandardMaterial3D.new()
	material.albedo_texture = FLOOR_TEXTURE
	material.albedo_color = Color(0.78, 0.78, 0.78)
	material.roughness = 0.88
	material.texture_repeat = true
	material.uv1_scale = Vector3(9.0, 9.0, 1.0)
	return material

func _town_floor_material() -> StandardMaterial3D:
	if town_cobble_texture == null:
		town_cobble_texture = _make_town_cobble_texture()
	var material: StandardMaterial3D = StandardMaterial3D.new()
	material.albedo_texture = town_cobble_texture
	material.albedo_color = Color(0.22, 0.205, 0.185)
	material.emission_enabled = true
	material.emission = Color(0.035, 0.025, 0.018)
	material.emission_energy_multiplier = 0.12
	material.roughness = 0.92
	material.texture_repeat = true
	material.uv1_scale = Vector3(7.0, 7.0, 1.0)
	return material

func _town_street_material() -> StandardMaterial3D:
	if town_cobble_texture == null:
		town_cobble_texture = _make_town_cobble_texture()
	var material := StandardMaterial3D.new()
	material.albedo_texture = town_cobble_texture
	material.albedo_color = Color(0.34, 0.32, 0.3)
	material.emission_enabled = true
	material.emission = Color(0.04, 0.033, 0.03)
	material.emission_energy_multiplier = 0.16
	material.roughness = 0.96
	material.texture_repeat = true
	material.uv1_scale = Vector3(2.3, 10.0, 1.0)
	return material

func _town_wall_material(size: Vector3) -> StandardMaterial3D:
	if wall_texture == null:
		wall_texture = _make_brick_texture()
	var horizontal_repeats: float = max(size.x, size.z) * 0.42
	var vertical_repeats: float = max(size.y * 0.8, 2.6)
	var material := StandardMaterial3D.new()
	material.albedo_texture = wall_texture
	material.albedo_color = Color(0.43, 0.37, 0.34)
	material.emission_enabled = true
	material.emission = Color(0.035, 0.03, 0.04)
	material.emission_texture = wall_texture
	material.emission_energy_multiplier = 0.14
	material.roughness = 1.0
	material.texture_repeat = true
	material.uv1_scale = Vector3(horizontal_repeats, vertical_repeats, 1.0)
	return material

func _town_roof_material() -> StandardMaterial3D:
	if town_roof_texture == null:
		town_roof_texture = _make_town_roof_texture()
	var material := StandardMaterial3D.new()
	material.albedo_texture = town_roof_texture
	material.albedo_color = Color(0.26, 0.24, 0.31)
	material.emission_enabled = true
	material.emission = Color(0.025, 0.018, 0.04)
	material.emission_energy_multiplier = 0.1
	material.roughness = 0.94
	material.texture_repeat = true
	material.uv1_scale = Vector3(4.0, 3.0, 1.0)
	return material

func _town_wood_material() -> StandardMaterial3D:
	if town_wood_texture == null:
		town_wood_texture = _make_town_wood_texture()
	var material := StandardMaterial3D.new()
	material.albedo_texture = town_wood_texture
	material.albedo_color = Color(0.33, 0.21, 0.13)
	material.emission_enabled = true
	material.emission = Color(0.035, 0.022, 0.014)
	material.emission_energy_multiplier = 0.08
	material.roughness = 0.9
	material.texture_repeat = true
	material.uv1_scale = Vector3(2.4, 2.4, 1.0)
	return material

func _make_town_cobble_texture() -> Texture2D:
	var image := Image.create(BRICK_TEXTURE_SIZE, BRICK_TEXTURE_SIZE, false, Image.FORMAT_RGBA8)
	var mortar := Color(0.035, 0.034, 0.038)
	var stone_dark := Color(0.12, 0.105, 0.105)
	var stone_mid := Color(0.26, 0.235, 0.215)
	var stone_warm := Color(0.38, 0.32, 0.27)
	var moss := Color(0.065, 0.105, 0.075)
	var cell_size := 31

	for y in BRICK_TEXTURE_SIZE:
		for x in BRICK_TEXTURE_SIZE:
			var cell_x := int(x / cell_size)
			var cell_y := int(y / cell_size)
			var jitter_x := int((_brick_hash(cell_x, cell_y, 41) - 0.5) * 9.0)
			var jitter_y := int((_brick_hash(cell_x, cell_y, 43) - 0.5) * 8.0)
			var local_x := posmod(x + jitter_x, cell_size)
			var local_y := posmod(y + jitter_y, cell_size)
			var oval_edge := pow((float(local_x) - 15.5) / 15.5, 2.0) + pow((float(local_y) - 15.5) / 13.0, 2.0)
			var chipped := _brick_noise(x, y, 47) > 0.9 and (local_x < 6 or local_y < 6)
			if oval_edge > 0.86 or local_x < 2 or local_y < 2 or chipped:
				image.set_pixel(x, y, mortar.lerp(moss, _brick_noise(x, y, 49) * 0.26))
				continue
			var seed := _brick_hash(cell_x, cell_y, 51)
			var grain := _brick_noise(x, y, 53)
			var color := stone_mid.lerp(stone_warm, seed * 0.5).lerp(stone_dark, grain * 0.22)
			if _brick_noise(x / 2, y / 2, 55) > 0.91:
				color = color.lerp(mortar, 0.5)
			image.set_pixel(x, y, color)

	image.generate_mipmaps()
	return ImageTexture.create_from_image(image)

func _make_town_roof_texture() -> Texture2D:
	var image := Image.create(BRICK_TEXTURE_SIZE, BRICK_TEXTURE_SIZE, false, Image.FORMAT_RGBA8)
	var slate_dark := Color(0.065, 0.065, 0.09)
	var slate_mid := Color(0.15, 0.14, 0.19)
	var slate_cold := Color(0.22, 0.22, 0.3)
	for y in BRICK_TEXTURE_SIZE:
		var row := int(y / 18)
		for x in BRICK_TEXTURE_SIZE:
			var stagger := (row % 2) * 12
			var local_x := posmod(x + stagger, 36)
			var local_y := y % 18
			var gap := local_y < 2 or local_x < 2
			var color := slate_mid.lerp(slate_cold, _brick_hash(int((x + stagger) / 36), row, 61) * 0.42)
			color = color.lerp(slate_dark, _brick_noise(x, y, 63) * 0.34)
			if gap:
				color = slate_dark
			image.set_pixel(x, y, color)
	image.generate_mipmaps()
	return ImageTexture.create_from_image(image)

func _make_town_wood_texture() -> Texture2D:
	var image := Image.create(BRICK_TEXTURE_SIZE, BRICK_TEXTURE_SIZE, false, Image.FORMAT_RGBA8)
	var wood_dark := Color(0.12, 0.07, 0.04)
	var wood_mid := Color(0.28, 0.16, 0.085)
	var wood_gold := Color(0.42, 0.25, 0.12)
	for y in BRICK_TEXTURE_SIZE:
		for x in BRICK_TEXTURE_SIZE:
			var plank := int(x / 28)
			var grain := sin(float(y) * 0.18 + _brick_hash(plank, 0, 71) * 6.0) * 0.5 + 0.5
			var seam := posmod(x, 28) < 2
			var color := wood_mid.lerp(wood_gold, grain * 0.26).lerp(wood_dark, _brick_noise(x, y, 73) * 0.22)
			if seam:
				color = wood_dark
			if _brick_noise(x / 3, y, 75) > 0.94:
				color = color.lerp(Color(0.03, 0.02, 0.015), 0.45)
			image.set_pixel(x, y, color)
	image.generate_mipmaps()
	return ImageTexture.create_from_image(image)

func _wall_material(size: Vector3) -> StandardMaterial3D:
	if wall_texture == null:
		wall_texture = _make_brick_texture()

	var horizontal_repeats: float = max(size.x, size.z) * WALL_FACE_TEXTURE_DENSITY
	var vertical_repeats: float = max(size.y * 0.88, 2.8)
	var material: StandardMaterial3D = StandardMaterial3D.new()
	material.albedo_texture = wall_texture
	material.albedo_color = Color(0.74, 0.68, 0.61)
	material.emission_enabled = true
	material.emission = Color(0.055, 0.045, 0.06)
	material.emission_texture = wall_texture
	material.emission_energy_multiplier = 0.16
	material.roughness = 1.0
	material.texture_repeat = true
	material.uv1_scale = Vector3(horizontal_repeats, vertical_repeats, 1.0)
	return material

func _make_brick_texture() -> Texture2D:
	var image := Image.create(BRICK_TEXTURE_SIZE, BRICK_TEXTURE_SIZE, false, Image.FORMAT_RGBA8)
	var mortar := Color(0.045, 0.045, 0.048)
	var mortar_light := Color(0.12, 0.115, 0.105)
	var stone_dark := Color(0.095, 0.08, 0.072)
	var stone_mid := Color(0.27, 0.205, 0.16)
	var stone_warm := Color(0.42, 0.29, 0.2)
	var moss := Color(0.08, 0.12, 0.075)

	for y in BRICK_TEXTURE_SIZE:
		var row: int = int(y / BRICK_HEIGHT)
		var row_height: int = BRICK_HEIGHT + int(_brick_hash(row, 4, 0) * 5.0) - 2
		var row_offset: int = (row % 2) * int(BRICK_WIDTH * 0.5) + int((_brick_hash(row, 8, 0) - 0.5) * 10.0)
		var local_y: int = y % BRICK_HEIGHT
		for x in BRICK_TEXTURE_SIZE:
			var brick_column: int = int((x + row_offset) / BRICK_WIDTH)
			var brick_width: int = BRICK_WIDTH + int(_brick_hash(brick_column, row, 1) * 15.0) - 6
			var shifted_x: int = posmod(x + row_offset + int(_brick_hash(brick_column, row, 2) * 7.0), BRICK_TEXTURE_SIZE)
			var local_x: int = shifted_x % maxi(brick_width, 18)
			var uneven_mortar: int = MORTAR_SIZE + int(_brick_hash(brick_column, row, 3) * 3.0)
			var edge_chip: bool = _brick_noise(x, y, 13) > 0.86 and (local_x < uneven_mortar + 4 or local_y < uneven_mortar + 3)
			var broken_cut: bool = _brick_noise(x / 2, y / 2, 31) > 0.93 and local_x > brick_width - 8
			var horizontal_gap: bool = local_y < uneven_mortar or local_y > row_height - uneven_mortar
			var vertical_gap: bool = local_x < uneven_mortar or local_x > brick_width - uneven_mortar
			if horizontal_gap or vertical_gap or edge_chip or broken_cut:
				var mortar_color: Color = mortar.lerp(mortar_light, _brick_noise(x, y, 4) * 0.45)
				if _brick_noise(x, y, 19) > 0.9:
					mortar_color = mortar_color.lerp(moss, 0.55)
				image.set_pixel(x, y, mortar_color)
				continue

			var brick_seed: float = _brick_hash(brick_column, row, 5)
			var grain: float = _brick_noise(x, y, 7)
			var pit: float = _brick_noise(x / 2, y / 2, 11)
			var crack: bool = absf(float((x + row * 9 + int(brick_seed * 24.0)) % 29) - float((y + brick_column * 5) % 29)) < 1.15
			var edge_darkening: float = 0.0
			if local_x < uneven_mortar + 5 or local_y < uneven_mortar + 4:
				edge_darkening = 0.28
			var color: Color = stone_mid.lerp(stone_warm, brick_seed * 0.58)
			color = color.lerp(stone_dark, edge_darkening + grain * 0.22)
			if pit > 0.78:
				color = color.lerp(stone_dark, 0.42)
			if crack and _brick_noise(x, y, 23) > 0.38:
				color = color.lerp(mortar, 0.82)
			if _brick_noise(x, y, 29) > 0.94:
				color = color.lerp(moss, 0.5)
			image.set_pixel(x, y, color)

	image.generate_mipmaps()
	return ImageTexture.create_from_image(image)

func _brick_hash(x: int, y: int, salt: int) -> float:
	var value := (x * 73856093) ^ (y * 19349663) ^ (salt * 83492791)
	value = abs(value % 9973)
	return float(value) / 9972.0

func _brick_noise(x: int, y: int, salt: int) -> float:
	return _brick_hash(x + int(_brick_hash(y, salt, x) * 23.0), y, salt)

func _portal_material(albedo: Color, emission: Color, emission_energy: float) -> StandardMaterial3D:
	var material: StandardMaterial3D = StandardMaterial3D.new()
	material.albedo_color = albedo
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	material.blend_mode = BaseMaterial3D.BLEND_MODE_ADD
	material.emission_enabled = true
	material.emission = emission
	material.emission_energy_multiplier = emission_energy
	return material

func _portal_smoke_material(albedo: Color, emission: Color, emission_energy: float) -> StandardMaterial3D:
	var material: StandardMaterial3D = StandardMaterial3D.new()
	material.albedo_color = albedo
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	material.blend_mode = BaseMaterial3D.BLEND_MODE_MIX
	material.emission_enabled = true
	material.emission = emission
	material.emission_energy_multiplier = emission_energy
	material.roughness = 1.0
	return material

func _decoration_material(albedo: Color, emission: Color, emission_energy: float) -> StandardMaterial3D:
	var material: StandardMaterial3D = StandardMaterial3D.new()
	material.albedo_color = albedo
	if albedo.a < 1.0:
		material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		material.blend_mode = BaseMaterial3D.BLEND_MODE_MIX
	if emission_energy > 0.0:
		material.emission_enabled = true
		material.emission = emission
		material.emission_energy_multiplier = emission_energy
	material.roughness = 0.92
	return material

func _material(albedo: Color, emission: Color, emission_energy: float) -> StandardMaterial3D:
	var material: StandardMaterial3D = StandardMaterial3D.new()
	material.albedo_color = albedo
	if emission_energy > 0.0:
		material.emission_enabled = true
		material.emission = emission
		material.emission_energy_multiplier = emission_energy
	return material
