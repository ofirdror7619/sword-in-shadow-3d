extends Node3D

const PlayerScript := preload("res://scripts/Player.gd")
const ChestScript := preload("res://scripts/Chest.gd")
const GoldScript := preload("res://scripts/DroppedGold.gd")
const LootDropScript := preload("res://scripts/DroppedLoot.gd")
const LootTableScript := preload("res://scripts/LootTable.gd")
const ScrollScript := preload("res://scripts/Scroll.gd")
const FireStormScript := preload("res://scripts/FireStorm.gd")
const IceSmashScript := preload("res://scripts/IceSmash.gd")
const LightningVortexScript := preload("res://scripts/LightningVortex.gd")
const HudScript := preload("res://scripts/HUD.gd")
const WhisperSystemScript := preload("res://scripts/WhisperSystem.gd")
const WhisperVoiceScript := preload("res://scripts/WhisperVoice.gd")
const MissionSystemScript := preload("res://scripts/MissionSystem.gd")
const EXIT_TEXTURE: Texture2D = preload("res://assets/images/objects/portal.png")
const FLOOR_TEXTURE: Texture2D = preload("res://assets/images/floor/black-vault-stone-floor.png")
const OPENING_LOGO_TEXTURE: Texture2D = preload("res://assets/images/opening/logo.png")
const OPENING_WHISPER_FONT: FontFile = preload("res://assets/fonts/Simbiot.ttf")
const BLACK_VAULT_MUSIC: AudioStreamMP3 = preload("res://assets/audio/music/black-vault.mp3")
const VELMORA_MUSIC: AudioStreamMP3 = preload("res://assets/audio/music/velmora.mp3")
const HOOFGROVE_WILDS_MUSIC: AudioStreamMP3 = preload("res://assets/audio/music/hoofgrove-wilds.mp3")
const OPENING_AURA_SOUND: AudioStreamMP3 = preload("res://assets/audio/sounds/aura.mp3")
const ANGEL_DEAD_SOUND: AudioStream = preload("res://assets/audio/sounds/angel-dead.mp3")
const EXIT_SOUND: AudioStream = preload("res://assets/audio/sounds/exit.mp3")
const FIRE_STORM_SOUND: AudioStream = preload("res://assets/audio/sounds/fire-storm.mp3")
const FIRE_STORM_BOOM_SOUND: AudioStream = preload("res://assets/audio/sounds/fire-storm-boom.mp3")
const ICE_SMASH_SOUND: AudioStream = preload("res://assets/audio/sounds/icesmash.mp3")
const TREASURE_CHEST_SOUND: AudioStream = preload("res://assets/audio/sounds/treasure-chest.mp3")
const PORTAL_FRAME_TEXTURE_PATH := "res://assets/images/objects/PortalFrame.png"
const DIAMOND_ITEM_TEXTURE_PATH := "res://assets/images/objects/diamond-faded.png"
const VENDOR_FRONT_TEXTURE_PATH := "res://assets/images/NPC/vendor-1/vendor-front.png"
const VENDOR_SIDE_TEXTURE_PATH := "res://assets/images/NPC/vendor-1/vendor-side.png"
const VENDOR_BACK_TEXTURE_PATH := "res://assets/images/NPC/vendor-1/vendor-back.png"
const SPELL_SHOP_MODEL_PATH := "res://assets/images/NPC/spell-shop/spell-shop.glb"
const SPELL_SHOP_TEXTURE_PATH := "res://assets/images/NPC/spell-shop/spell-shop.png"
const VELMORA_BARREL_TEXTURE_PATH := "res://assets/images/objects/velmora/barrel.png"
const VELMORA_VENDOR_MAN_TEXTURE_PATH := "res://assets/images/objects/velmora/aldric.png"
const VELMORA_VENDOR_WOMAN_TEXTURE_PATH := "res://assets/images/objects/velmora/syra.png"
const VELMORA_VENDOR_WARLOCK_TEXTURE_PATH := "res://assets/images/objects/velmora/zethyr.png"
const TORREN_BLACKWELL_FRONT_TEXTURE_PATH := "res://assets/images/NPC/Torren-Blackwell/Torren-Blackwell-front.png"
const TORREN_BLACKWELL_SIDE_TEXTURE_PATH := "res://assets/images/NPC/Torren-Blackwell/Torren-Blackwell-side.png"
const TORREN_BLACKWELL_BACK_TEXTURE_PATH := "res://assets/images/NPC/Torren-Blackwell/Torren-Blackwell-back.png"
const TORREN_BLACKWELL_FACE_TEXTURE_PATH := "res://assets/images/NPC/Torren-Blackwell/Torren-Blackwell-face.png"
const VELMORA_VENDOR_MAN_FACE_TEXTURE: Texture2D = preload("res://assets/images/objects/velmora/aldric-face.png")
const VELMORA_VENDOR_WOMAN_FACE_TEXTURE: Texture2D = preload("res://assets/images/objects/velmora/syra-face.png")
const VELMORA_VENDOR_WARLOCK_FACE_TEXTURE: Texture2D = preload("res://assets/images/objects/velmora/zethyr-face.png")
const VELMORA_TREE_TEXTURE_PATHS := [
	"res://assets/images/objects/velmora/tree-1.png",
	"res://assets/images/objects/velmora/tree-2.png",
	"res://assets/images/objects/velmora/tree-3.png",
	"res://assets/images/objects/velmora/tree-4.png"
]
const WHISPER_INTRODUCTION_PATH := "res://theWhisper/introduction.txt"
const WHISPER_AFTER_KILLING_PATH := "res://theWhisper/after-killing.txt"
const WHISPER_WAITING_PATH := "res://theWhisper/waiting.txt"
const SCROLLS_PATH := "res://scrolls/scrolls.txt"
const SCROLLS_FALLBACK_PATH := "res://scrolls/scrollls.txt"
const ALDRIC_FIRST_DIALOGUE_PATH := "res://dialogues/velmora/aldric-first-encounter.txt"
const SYRA_FIRST_DIALOGUE_PATH := "res://dialogues/velmora/syra-first-encounter.txt"
const ZETHYR_FIRST_DIALOGUE_PATH := "res://dialogues/velmora/zethyr-first-encounter.txt"
const TORREN_BLACKWELL_DIALOGUE_PATH := "res://dialogues/velmora/torren-blackwell-first-encounter.txt"
const TORREN_HOOFGROVE_COMPLETE_DIALOGUE_PATH := "res://dialogues/velmora/torren-blackwell-hoofgrove-complete.txt"
const DIALOGUE_ALDRIC_FIRST := "aldric_first_encounter"
const DIALOGUE_SYRA_FIRST := "syra_first_encounter"
const DIALOGUE_ZETHYR_FIRST := "zethyr_first_encounter"
const DIALOGUE_TORREN_BLACKWELL := "torren_blackwell_first_encounter"
const DIALOGUE_TORREN_HOOFGROVE_COMPLETE := "torren_blackwell_hoofgrove_complete"

const ARENA_HALF_SIZE := 34.0
const STAGE_ENEMY_COUNT := 15
const PLAYER_START_POSITION := Vector3(-29.0, 0.1, 29.0)
const CAMERA_FOLLOW_OFFSET := Vector3(15.5, 18.0, 15.5)
const CAMERA_ZOOM_MIN := 0.62
const CAMERA_ZOOM_MAX := 1.45
const CAMERA_ZOOM_STEP := 0.1
const CAMERA_ZOOM_DEFAULT := 1.0
const ICE_SMASH_CAMERA_SHAKE_DURATION := 0.34
const ICE_SMASH_CAMERA_SHAKE_INTENSITY := 0.42
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
const START_IN_VELMORA_FOR_TESTING := false
const START_IN_HOOFGROVE_FOR_TESTING := false
const TEST_VELMORA_START_GOLD := 1000
const TEST_VELMORA_START_DIAMONDS := 0
const VENDOR_SPRITE_GROUND_CLEARANCE := 0.06
const AREA_BLACK_VAULT := "black_vault"
const AREA_VELMORA := "velmora"
const AREA_HOOFGROVE_WILDS := "hoofgrove_wilds"
const MISSION_AREAS := [AREA_BLACK_VAULT, AREA_VELMORA, AREA_HOOFGROVE_WILDS]
const VELMORA_ORIGIN := Vector3(118.0, 0.0, 0.0)
const VELMORA_HALF_SIZE := 26.0
const VELMORA_SPAWN_POSITION := Vector3(118.0, 0.1, 18.0)
const VELMORA_TREE_SIGHT_CLEAR_RADIUS := 3.35
const HOOFGROVE_ORIGIN := Vector3(236.0, 0.0, 0.0)
const HOOFGROVE_HALF_SIZE := 48.0
const HOOFGROVE_SPAWN_POSITION := Vector3(236.0, 0.1, 34.0)
const HOOFGROVE_CENTAUR_COUNT := 9
const HOOFGROVE_WARRIOR_COUNT := 4
const HOOFGROVE_CLERIC_COUNT := 2
const HOOFGROVE_GIANT_COUNT := 1
const HOOFGROVE_CHEST_COUNT := 7
const SCROLL_LEVEL_BLACK_VAULT := 1
const SCROLL_LEVEL_HOOFGROVE_WILDS := 2
const GLOVE_SOCKET_COUNT := 8
const FADED_DIAMOND_CATALOG := [
	{"id": "faded_rush", "icon": "R", "name": "Faded Diamond of Rush", "description": "Increases movement speed.", "gold_cost": 120, "color": Color(1.0, 0.48, 0.12)},
	{"id": "faded_focus", "icon": "Fo", "name": "Faded Diamond of Focus", "description": "Increases attack spell radius.", "gold_cost": 120, "color": Color(0.22, 0.92, 1.0)},
	{"id": "faded_vitality", "icon": "V", "name": "Faded Diamond of Vitality", "description": "Faster healing rate.", "gold_cost": 120, "color": Color(0.0, 0.78, 0.42)},
	{"id": "faded_fortune", "icon": "Ft", "name": "Faded Diamond of Fortune", "description": "Increases luck in loot and gold drops.", "gold_cost": 120, "color": Color(1.0, 0.84, 0.24)},
	{"id": "faded_corruption", "icon": "C", "name": "Faded Diamond of Corruption", "description": "Increases Beyond spell effects.", "gold_cost": 140, "color": Color(0.32, 0.05, 0.72)},
	{"id": "faded_echo", "icon": "E", "name": "Faded Diamond of Echo", "description": "Increases attack spell effects.", "gold_cost": 140, "color": Color(1.0, 0.08, 0.72)},
	{"id": "faded_void", "icon": "Vo", "name": "Faded Diamond of Void", "description": "+1 summoned creature.", "gold_cost": 140, "color": Color(0.06, 0.03, 0.22)},
	{"id": "faded_fury", "icon": "Fu", "name": "Faded Diamond of Fury", "description": "Increases attack spell damage.", "gold_cost": 130, "color": Color(0.92, 0.03, 0.02)},
	{"id": "faded_guardian", "icon": "G", "name": "Faded Diamond of Guardian", "description": "Increases defensive spell effects.", "gold_cost": 130, "color": Color(0.68, 0.92, 1.0)},
	{"id": "faded_flame_ring", "icon": "Fl", "name": "Faded Diamond of Flame Ring", "description": "Increases Flame spell effects.", "gold_cost": 150, "color": Color(1.0, 0.28, 0.06)},
	{"id": "faded_frostbind", "icon": "Fr", "name": "Faded Diamond of Frostbind", "description": "Increases Ice spell effects.", "gold_cost": 150, "color": Color(0.42, 0.82, 1.0)},
	{"id": "faded_storm", "icon": "S", "name": "Faded Diamond of Storm", "description": "Increases Electricity spell effects.", "gold_cost": 150, "color": Color(0.18, 0.58, 1.0)}
]
const RELIC_CATALOG := [
	{
		"id": "teleport_device",
		"name": "Teleport Device",
		"description": "A relic anchor that returns you from Velmora to the Black Vault.",
		"image": "res://assets/images/objects/teleport-device/teleport-device-outer-ring.png",
		"mission_only": true
	},
	{
		"id": "voodoo_doll",
		"name": "Voodoo Doll",
		"description": "A hooked little relic that hums when blood is close.",
		"image": "res://assets/images/objects/relics/voodoo-doll.png",
		"rarity": "rare"
	}
]
const SPELL_CATALOG := [
	# --- Attack ---
	{"id": "fire_storm",       "name": "Firestorm",          "description": "Fire Storm deals 25% more damage.",                    "gold_cost": 1000,  "category": "attack",  "image": "res://assets/images/spells/attack/firestorm.png"},
	{"id": "absolute_zero",      "name": "Absolute Zero",         "description": "Freeze all nearby enemies briefly.",                    "gold_cost": 1000,  "category": "attack",  "image": "res://assets/images/spells/attack/AbsoluteZero.png"},
	{"id": "abyssal_blade",      "name": "Abyssal Blade",         "description": "Shadow slash attack deals dark damage.",                "gold_cost": 1000,  "category": "attack",  "image": "res://assets/images/spells/attack/AbyssalBlade.png"},
	{"id": "call_from_beyond",   "name": "Call From The Beyond",  "description": "Summon a demon ally from the void.",                   "gold_cost": 1000,  "category": "attack",  "image": "res://assets/images/spells/attack/CallFromTheBeyond.png"},
	{"id": "electricity_vortex", "name": "Electricity Vortex",    "description": "Lightning chains between nearby enemies.",              "gold_cost": 1000,  "category": "attack",  "image": "res://assets/images/spells/attack/ElectricityVortex.png"},
	{"id": "icesmash",           "name": "Ice Smash",             "description": "Falling ice crushes enemies below.",                   "gold_cost": 1000,  "category": "attack",  "image": "res://assets/images/spells/attack/Icesmash.png"},
	{"id": "soul_drain",         "name": "Soul Drain",            "description": "Steal HP directly from enemies.",                      "gold_cost": 1000,  "category": "attack",  "image": "res://assets/images/spells/attack/SoulDrain.png"},
	# --- Buff ---
	{"id": "demonic_frenzy",        "name": "Demonic Frenzy",           "description": "Attack speed greatly increased.",                    "gold_cost": 1000,  "category": "buff",    "image": "res://assets/images/spells/buff/DemonicFrenzy.png"},
	{"id": "killing_radius",        "name": "Killing Radius",           "description": "Bigger area of effect on all attacks.",              "gold_cost": 1000,  "category": "buff",    "image": "res://assets/images/spells/buff/KillingRadius.png"},
	{"id": "power_of_underworld",   "name": "Power of the Underworld",  "description": "Significantly increases all damage output.",         "gold_cost": 1000,  "category": "buff",    "image": "res://assets/images/spells/buff/PowerOfTheUnderWorld.png"},
	{"id": "void_infusion",         "name": "Void Infusion",            "description": "Attacks apply shadow damage on hit.",               "gold_cost": 1000,  "category": "buff",    "image": "res://assets/images/spells/buff/VoidInfusion.png"},
	# --- Debuff ---
	{"id": "curse_of_laziness",  "name": "Curse of Laziness",     "description": "Slow all nearby enemies.",                             "gold_cost": 1000,  "category": "debuff",  "image": "res://assets/images/spells/debuff/CurseOfLaziness.png"},
	{"id": "mark_of_weakness",   "name": "Mark of Weakness",      "description": "Marked enemies take increased damage.",                 "gold_cost": 1000,  "category": "debuff",  "image": "res://assets/images/spells/debuff/MarkOfWeakness.png"},
	{"id": "slowly_we_rot",      "name": "Slowly We Rot",         "description": "Applies damage over time to all enemies.",              "gold_cost": 1000,  "category": "debuff",  "image": "res://assets/images/spells/debuff/SlowlyWeRot.png"},
	# --- Defense ---
	{"id": "armor_of_undead",    "name": "Armor of the Undead",   "description": "Absorb a portion of incoming damage.",                  "gold_cost": 1000,  "category": "defense", "image": "res://assets/images/spells/defense/ArmorOfTheUndead.png"},
	{"id": "eclipse_shield",     "name": "Eclipse Shield",        "description": "Reflects part of damage back to attackers.",            "gold_cost": 1000,  "category": "defense", "image": "res://assets/images/spells/defense/EclipseShield.png"},
	{"id": "titanium",           "name": "Titanium",              "description": "Reduced damage taken from all sources.",                "gold_cost": 1000,  "category": "defense", "image": "res://assets/images/spells/defense/Titanium.png"},
	# --- Healing ---
	{"id": "reincarnation",      "name": "Reincarnation",         "description": "Faster healing rate at all times.",                     "gold_cost": 1000,  "category": "healing", "image": "res://assets/images/spells/healing/Reincarnation.png"},
	{"id": "soul_harvest",       "name": "Soul Harvest",          "description": "Heal on each enemy kill.",                              "gold_cost": 1000,  "category": "healing", "image": "res://assets/images/spells/healing/SoulHarvest.png"},
]
const SPELL_THEME_CATEGORY_BY_ID := {
	"fire_storm": "Flame",
	"absolute_zero": "Ice",
	"abyssal_blade": "Beyond",
	"call_from_beyond": "Beyond",
	"electricity_vortex": "Electricity",
	"icesmash": "Ice",
	"soul_drain": "Beyond",
	"demonic_frenzy": "Beyond",
	"killing_radius": "Ice",
	"power_of_underworld": "Beyond",
	"void_infusion": "Beyond",
	"curse_of_laziness": "Ice",
	"mark_of_weakness": "Electricity",
	"slowly_we_rot": "Beyond",
	"armor_of_undead": "Beyond",
	"eclipse_shield": "Flame",
	"titanium": "Ice",
	"reincarnation": "Electricity",
	"soul_harvest": "Beyond"
}

var player: SISPlayer
var camera: Camera3D
var hud: SISHUD
var whisper_system: Node
var whisper_voice: Node
var mission_system: SISMissionSystem
var opening_layer: CanvasLayer
var opening_enter_label: Label
var opening_whisper_label: Label
var opening_active := false
var opening_elapsed := 0.0
var opening_whisper_revealed := false
var music_player: AudioStreamPlayer
var opening_aura_player: AudioStreamPlayer
var audio_woken := false
var enemies: Array[Node3D] = []
var rng := RandomNumberGenerator.new()
var game_level := 2
var kills := 0
var exit_open := false
var exit_directive_completed := false
var black_vault_encounter_spawned := false
var black_vault_chests_spawned := false
var wall_texture: Texture2D
var hoofgrove_floor_texture: Texture2D
var velmora_cobble_texture: Texture2D
var velmora_roof_texture: Texture2D
var velmora_wood_texture: Texture2D
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
var reveal_enemies_on_minimap := true
var possession_fx_played := false
var full_possession_points_awarded := 0
var camera_zoom := CAMERA_ZOOM_DEFAULT
var camera_shake_time := 0.0
var camera_shake_duration := 0.0
var camera_shake_intensity := 0.0
var current_area := AREA_BLACK_VAULT
var velmora_root: Node3D
var velmora_built := false
var hoofgrove_root: Node3D
var hoofgrove_built := false
var hoofgrove_centaurs_spawned := false
var hoofgrove_centaurs_remaining := 0
var hoofgrove_hostiles_remaining := 0
var hoofgrove_chests_spawned := false
var hoofgrove_flying_birds: Array[Dictionary] = []
var active_vendor_id := ""
var vendor_front_texture: Texture2D
var vendor_side_texture: Texture2D
var vendor_back_texture: Texture2D
var diamond_item_texture: Texture2D
var velmora_barrel_texture: Texture2D
var velmora_vendor_man_texture: Texture2D
var velmora_vendor_woman_texture: Texture2D
var velmora_vendor_warlock_texture: Texture2D
var velmora_vendor_man_face_texture: Texture2D
var velmora_vendor_woman_face_texture: Texture2D
var velmora_vendor_warlock_face_texture: Texture2D
var torren_blackwell_front_texture: Texture2D
var torren_blackwell_side_texture: Texture2D
var torren_blackwell_back_texture: Texture2D
var torren_blackwell_face_texture: Texture2D
var torren_blackwell_root: Node3D
var torren_blackwell_area: Area3D
var velmora_tree_textures: Array[Texture2D] = []
var spell_shop_texture: Texture2D
var spell_shop_scene: PackedScene
var vendor_sprites: Array[Dictionary] = []
var owned_faded_diamonds: Dictionary = {}
var socketed_faded_diamonds: Array[String] = []
var owned_relics: Dictionary = {}
var unlocked_maps: Array[String] = []
var dialogue_flags: Dictionary = {}
var mission_given_flags: Dictionary = {}
var active_dialogue_id := ""
var active_dialogue_npc_id := ""

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	rng.randomize()
	dialogue_flags.clear()
	mission_given_flags.clear()
	_load_whisper_texts()
	_load_scroll_texts()
	_make_music_player()
	_make_lighting()
	_make_camera()
	_make_black_vault()
	_make_player()
	_make_exit()
	_make_hud()
	_make_whisper_voice()
	_make_mission_system()
	_make_whisper_system()
	if START_IN_VELMORA_FOR_TESTING:
		player.add_gold(TEST_VELMORA_START_GOLD)
		player.add_diamonds(TEST_VELMORA_START_DIAMONDS)
		_enter_velmora()
	elif START_IN_HOOFGROVE_FOR_TESTING:
		player.add_gold(TEST_VELMORA_START_GOLD)
		player.add_diamonds(TEST_VELMORA_START_DIAMONDS)
		_add_relic("teleport_device")
		_add_map("world-map-velmora-after-torren.png")
		_enter_hoofgrove_wilds()
	else:
		_spawn_encounter()
		_spawn_chests()
		_spawn_scroll_for_game_level(SCROLL_LEVEL_BLACK_VAULT)
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
	_apply_camera_shake(delta)
	camera.look_at(player.global_position + Vector3(0.0, 0.7, 0.0), Vector3.UP)
	if whisper_system != null and not _is_whisper_muted_for_area():
		whisper_system.update(delta, player)
	_animate_exit_fx(delta)
	_animate_hoofgrove_birds(delta)
	_update_vendor_sprites()
	_process_idle_whispers(delta)
	_update_minimap()

func _input(event: InputEvent) -> void:
	if _is_audio_unlock_event(event):
		_wake_audio()
	if not opening_active:
		var block_zoom := hud != null and hud.is_blocking_ui_visible()
		if event is InputEventKey and event.pressed:
			_mark_player_activity()
			if event.keycode == KEY_Z:
				if block_zoom:
					get_viewport().set_input_as_handled()
					return
				_reset_camera_zoom()
				get_viewport().set_input_as_handled()
		elif event is InputEventMouseButton and event.pressed:
			_mark_player_activity()
			if hud != null and hud.handle_spell_store_mouse_wheel(event):
				return
			if hud != null and hud.handle_skill_tree_mouse_wheel(event):
				return
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				if block_zoom:
					get_viewport().set_input_as_handled()
					return
				_adjust_camera_zoom(-CAMERA_ZOOM_STEP)
				get_viewport().set_input_as_handled()
			elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				if block_zoom:
					get_viewport().set_input_as_handled()
					return
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
	player.attack_spell_requested.connect(_on_attack_spell_requested)
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

func _shake_camera(intensity: float, duration: float) -> void:
	camera_shake_intensity = maxf(camera_shake_intensity, intensity)
	camera_shake_duration = maxf(camera_shake_duration, duration)
	camera_shake_time = maxf(camera_shake_time, duration)

func _apply_camera_shake(delta: float) -> void:
	if camera == null or camera_shake_time <= 0.0:
		return
	camera_shake_time = maxf(camera_shake_time - delta, 0.0)
	var duration := maxf(camera_shake_duration, 0.001)
	var fade := camera_shake_time / duration
	var strength := camera_shake_intensity * fade * fade
	camera.global_position += Vector3(
		rng.randf_range(-strength, strength),
		rng.randf_range(-strength * 0.5, strength * 0.5),
		rng.randf_range(-strength, strength)
	)
	if camera_shake_time <= 0.0:
		camera_shake_duration = 0.0
		camera_shake_intensity = 0.0

func _make_hud() -> void:
	hud = HudScript.new() as SISHUD
	add_child(hud)
	if player != null:
		player.set_mouse_block_check(Callable(hud, "is_mouse_over_blocking_ui"))
	hud.resurrect_requested.connect(_on_resurrect_requested)
	hud.shop_purchase_requested.connect(_on_shop_purchase_requested)
	hud.shop_closed.connect(_on_shop_closed)
	hud.skill_tree_point_requested.connect(_on_skill_tree_point_requested)
	hud.inventory_socket_drop_requested.connect(_on_inventory_socket_drop_requested)
	hud.inventory_socket_clear_requested.connect(_on_inventory_socket_clear_requested)
	hud.dialogue_finished.connect(_on_dialogue_finished)
	hud.teleport_device_requested.connect(_on_teleport_device_requested)
	hud.teleport_destination_requested.connect(_on_teleport_destination_requested)
	hud.spell_slot_spell_selected.connect(_on_spell_slot_spell_selected)
	hud.whisper_silence_changed.connect(_on_whisper_silence_changed)
	hud.whisper_audio_mix_changed.connect(_on_whisper_audio_mix_changed)
	hud.whisper_voice_requested.connect(_on_hud_whisper_voice_requested)
	hud.update_stats(_stats_for_hud(player.get_stats()))
	_update_possession()

func _make_mission_system() -> void:
	mission_system = MissionSystemScript.new() as SISMissionSystem
	add_child(mission_system)
	mission_system.missions_changed.connect(_on_missions_changed)
	mission_system.mission_completed.connect(_on_mission_completed)
	mission_system.mission_action_requested.connect(_on_mission_action_requested)

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

func _make_whisper_voice() -> void:
	whisper_voice = WhisperVoiceScript.new()
	add_child(whisper_voice)
	if hud != null:
		whisper_voice.set_enabled(not hud.is_whisper_silenced())
		whisper_voice.set_voice_volume(hud.get_chant_volume())
		whisper_voice.set_echo_amount(hud.get_echo_volume())

func _on_whisper_silence_changed(silenced: bool) -> void:
	if whisper_voice != null:
		whisper_voice.set_enabled(not silenced)

func _on_whisper_audio_mix_changed(chant_volume: float, echo_volume: float) -> void:
	if whisper_voice == null:
		return
	whisper_voice.set_voice_volume(chant_volume)
	whisper_voice.set_echo_amount(echo_volume)

func _on_hud_whisper_voice_requested(text: String) -> void:
	if hud == null or whisper_voice == null or text.is_empty() or _is_whisper_muted_for_area():
		return
	if hud.are_whispers_enabled():
		whisper_voice.speak(text)

func _make_music_player() -> void:
	music_player = AudioStreamPlayer.new()
	music_player.name = "BlackVaultMusic"
	_set_background_music(BLACK_VAULT_MUSIC)
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

func _hoofgrove_wilds_music() -> AudioStreamMP3:
	return HOOFGROVE_WILDS_MUSIC if HOOFGROVE_WILDS_MUSIC != null else VELMORA_MUSIC

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
	_wake_audio()
	var player: AudioStreamPlayer = AudioStreamPlayer.new()
	player.stream = stream
	player.volume_db = volume_db
	add_child(player)
	player.finished.connect(Callable(player, "queue_free"))
	player.play()

func _is_audio_unlock_event(event: InputEvent) -> bool:
	if event is InputEventMouseButton:
		return event.pressed
	if event is InputEventKey:
		return event.pressed
	if event is InputEventScreenTouch:
		return event.pressed
	return false

func _wake_audio() -> void:
	if DisplayServer.get_name() == "headless":
		return
	var master_bus := AudioServer.get_bus_index("Master")
	if master_bus >= 0:
		AudioServer.set_bus_mute(master_bus, false)
		AudioServer.set_bus_volume_db(master_bus, 0.0)
	if audio_woken:
		return
	audio_woken = true
	if music_player != null and not opening_active and not music_player.playing:
		music_player.play()

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

func _has_played_dialogue(dialogue_id: String) -> bool:
	return bool(dialogue_flags.get(dialogue_id, false))

func _mark_dialogue_played(dialogue_id: String) -> void:
	if dialogue_id.is_empty():
		return
	dialogue_flags[dialogue_id] = true

func _dialogue_id_for_path(path: String) -> String:
	var file_name := path.strip_edges().get_file().get_basename()
	return file_name.replace("-", "_").replace(" ", "_")

func _resolve_dialogue_path(path: String) -> String:
	var clean_path := path.strip_edges().replace("\\", "/")
	if clean_path.is_empty():
		return ""
	if clean_path.begins_with("res://"):
		return clean_path
	if clean_path.begins_with("dialogues/"):
		return "res://%s" % clean_path
	return "res://dialogues/%s" % clean_path

func _load_dialogue_entries(path: String) -> Array[Dictionary]:
	var entries: Array[Dictionary] = []
	if not FileAccess.file_exists(path):
		push_warning("Missing dialogue file: %s" % path)
		return entries
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_warning("Could not open dialogue file: %s" % path)
		return entries
	var current_speaker := ""
	var current_lines: Array[String] = []
	for raw_line in file.get_as_text().split("\n", false):
		var line := String(raw_line).replace("\r", "").strip_edges()
		if line.is_empty():
			continue
		if line.ends_with(":"):
			_append_dialogue_entry(entries, current_speaker, current_lines)
			current_speaker = line.substr(0, line.length() - 1).strip_edges()
			current_lines.clear()
		else:
			current_lines.append(line)
	_append_dialogue_entry(entries, current_speaker, current_lines)
	return entries

func _random_incomplete_reply(mission: Dictionary) -> String:
	var path := _resolve_dialogue_path(String(mission.get("incomplete_replies_file", "")))
	var lines := _load_dialogue_reply_lines(path)
	if lines.is_empty():
		lines = ["Did you forget what I've asked you?"]
	return lines[rng.randi_range(0, lines.size() - 1)]

func _load_dialogue_reply_lines(path: String) -> Array[String]:
	var lines: Array[String] = []
	if path.is_empty() or not FileAccess.file_exists(path):
		return lines
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_warning("Could not open dialogue reply file: %s" % path)
		return lines
	for raw_line in file.get_as_text().split("\n", false):
		var line := String(raw_line).replace("\r", "").strip_edges()
		if line.is_empty() or line.begins_with("#") or line.begins_with(";"):
			continue
		lines.append(line)
	return lines

func _append_dialogue_entry(entries: Array[Dictionary], speaker: String, lines: Array[String]) -> void:
	if speaker.is_empty() or lines.is_empty():
		return
	entries.append({
		"speaker": speaker,
		"text": "\n".join(lines)
	})

func _on_missions_changed(area: String, missions: Array[Dictionary]) -> void:
	if hud == null:
		_sync_torren_blackwell_visibility()
		return
	if area == current_area:
		hud.set_missions(_mission_area_title(area), _missions_for_display(area, missions))
		_update_objective()
	_sync_torren_blackwell_visibility()

func _on_mission_completed(area: String, mission: Dictionary) -> void:
	var mission_text := String(mission.get("text", ""))
	if area == AREA_BLACK_VAULT and String(mission.get("id", "")) == "clear_black_vault":
		mission_text = _format_black_vault_mission_text(mission_text)
	if mission_text.is_empty():
		return
	_say_whisper("Done. %s" % mission_text)

func _on_mission_action_requested(_area: String, action: Dictionary, _mission: Dictionary) -> void:
	_apply_mission_action(action)

func _apply_mission_action(action: Dictionary) -> bool:
	var action_type := String(action.get("type", "")).to_lower()
	var target := String(action.get("target", ""))
	match action_type:
		"add_relic":
			if _add_relic(target):
				_say_whisper("Relic gained. %s" % _relic_display_name(target))
				return true
		"add_map":
			if _add_map(target):
				_say_whisper("Map revealed. %s" % _map_display_name(target))
				return true
		"add_spell", "learn_spell", "unlock_spell":
			if _learn_spell_reward(target):
				_say_whisper("Spell learned. %s" % _spell_display_name(target))
				return true
		"add_gold", "gold":
			var gold_amount := maxi(0, int(target))
			if gold_amount > 0 and player != null:
				player.add_gold(gold_amount)
				_say_whisper("Gold gained. %s" % gold_amount)
				return true
		"add_xp", "xp", "experience":
			var xp_amount := maxi(0, int(target))
			if xp_amount > 0 and player != null:
				var leveled := player.gain_xp(xp_amount)
				if leveled:
					_say_whisper("Experience gained. %s. Stronger again." % xp_amount)
				else:
					_say_whisper("Experience gained. %s." % xp_amount)
				return true
		"add_diamond", "add_faded_diamond", "diamond":
			if _add_diamond_reward(target):
				_say_whisper("Diamond gained. %s" % _diamond_display_name(target))
				return true
		"unlock_area_mission":
			var parts := target.split(":", false, 1)
			if parts.size() == 2 and mission_system != null:
				mission_system.unlock_mission(String(parts[0]).strip_edges(), String(parts[1]).strip_edges())
				return true
		_:
			pass
	return false

func _mission_area_title(area: String) -> String:
	match area:
		AREA_VELMORA:
			return "Velmora"
		AREA_HOOFGROVE_WILDS:
			return "Hoofgrove Wilds"
		AREA_BLACK_VAULT:
			return "Black Vault"
		_:
			return area.capitalize()

func _set_mission_area(area: String) -> void:
	if mission_system != null:
		mission_system.set_area(area)
	elif hud != null:
		hud.set_missions(_mission_area_title(area), [])

func _active_mission_count(area: String) -> int:
	if mission_system == null:
		return 0
	return mission_system.get_active_missions(area).size()

func _missions_for_display(area: String, missions: Array[Dictionary]) -> Array[Dictionary]:
	var display_missions: Array[Dictionary] = []
	for mission in missions:
		var display_mission := mission.duplicate(true)
		var mission_id := String(display_mission.get("id", ""))
		if area == AREA_BLACK_VAULT and mission_id == "clear_black_vault":
			var formatted_text := _format_black_vault_mission_text(String(display_mission.get("title", display_mission.get("text", ""))))
			display_mission["title"] = formatted_text
			display_mission["text"] = formatted_text
		display_missions.append(display_mission)
	return display_missions

func _mission_text(area: String, mission_id: String, fallback: String) -> String:
	if mission_system == null:
		return fallback
	for mission in mission_system.get_active_missions(area):
		if String(mission.get("id", "")) == mission_id:
			var mission_text := String(mission.get("title", mission.get("text", ""))).strip_edges()
			if not mission_text.is_empty():
				return mission_text
	return fallback

func _format_black_vault_mission_text(template: String) -> String:
	var formatted := template
	var first_placeholder := formatted.find("%s")
	if first_placeholder >= 0:
		formatted = formatted.substr(0, first_placeholder) + str(kills) + formatted.substr(first_placeholder + 2)
	var second_placeholder := formatted.find("%s")
	if second_placeholder >= 0:
		formatted = formatted.substr(0, second_placeholder) + str(STAGE_ENEMY_COUNT) + formatted.substr(second_placeholder + 2)
	return formatted

func _refresh_current_missions_display() -> void:
	if hud == null or mission_system == null:
		return
	hud.set_missions(_mission_area_title(current_area), _missions_for_display(current_area, mission_system.get_active_missions(current_area)))

func _complete_vendor_talk_missions(vendor_id: String) -> void:
	if mission_system == null:
		return
	var npc_name := _vendor_npc_name(vendor_id)
	mission_system.complete_matching(current_area, "talk_to_npc", {
		"vendor_id": vendor_id,
		"npc_id": npc_name,
		"npc_name": npc_name,
		"target": npc_name
	})

func _complete_teleport_destination_missions(area: String, destination_id: String) -> void:
	if mission_system == null:
		return
	mission_system.complete_matching(area, "teleport_to", {
		"destination_id": destination_id,
		"target": destination_id,
		"relic_id": "teleport_device"
	})

func _active_talk_mission_for_vendor(vendor_id: String) -> Dictionary:
	if mission_system == null:
		return {}
	var npc_name := _vendor_npc_name(vendor_id)
	var matches := mission_system.get_active_matching_missions(current_area, "talk_to_npc", {
		"vendor_id": vendor_id,
		"npc_id": npc_name,
		"npc_name": npc_name,
		"target": npc_name
	})
	return matches[0] if not matches.is_empty() else {}

func _active_talk_mission_for_npc(npc_id: String, npc_name: String) -> Dictionary:
	if mission_system == null:
		return {}
	var matches := mission_system.get_active_matching_missions(current_area, "talk_to_npc", {
		"npc_id": npc_id,
		"npc_name": npc_name,
		"target": npc_id
	})
	return matches[0] if not matches.is_empty() else {}

func _active_incomplete_mission_for_giver(npc_id: String) -> Dictionary:
	if mission_system == null:
		return {}
	var wanted_id := _mission_lookup_key(npc_id)
	for area in MISSION_AREAS:
		for mission in mission_system.get_active_missions(String(area)):
			var giver_id := _mission_lookup_key(String(mission.get("giver_npc_id", "")))
			if not giver_id.is_empty() and giver_id == wanted_id:
				return mission
	return {}

func _mission_lookup_key(value: String) -> String:
	return value.strip_edges().to_lower().replace(" ", "_").replace("-", "_")

func _grant_mission_given_items(area: String, mission: Dictionary) -> void:
	if mission.is_empty():
		return
	var grants: Array = mission.get("given", [])
	if grants.is_empty():
		return
	var mission_id := String(mission.get("id", "")).strip_edges()
	if mission_id.is_empty():
		return
	var grant_key := "%s:%s" % [area, mission_id]
	if bool(mission_given_flags.get(grant_key, false)):
		return
	var did_apply := false
	for grant_variant in grants:
		if grant_variant is Dictionary:
			did_apply = _apply_mission_action((grant_variant as Dictionary).duplicate(true)) or did_apply
	if did_apply:
		mission_given_flags[grant_key] = true

func _dialogue_path_for_mission(mission: Dictionary) -> String:
	return _resolve_dialogue_path(String(mission.get("dialogue_file", "")))

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
	if hud == null or text.is_empty() or _is_whisper_muted_for_area():
		return
	hud.whisper(text)
	if whisper_voice != null and hud.are_whispers_enabled():
		whisper_voice.speak(text)
	idle_whisper_cooldown = rng.randf_range(IDLE_WHISPER_INTERVAL_MIN, IDLE_WHISPER_INTERVAL_MAX)

func _is_whisper_muted_for_area() -> bool:
	return current_area == AREA_VELMORA

func _say_random_whisper(lines: Array[String]) -> void:
	if lines.is_empty():
		return
	_say_whisper(lines[rng.randi_range(0, lines.size() - 1)])

func _mark_player_activity() -> void:
	idle_seconds = 0.0

func _process_idle_whispers(delta: float) -> void:
	if _is_whisper_muted_for_area():
		_mark_player_activity()
		return
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

	var shade: ColorRect = ColorRect.new()
	shade.color = Color.BLACK
	shade.set_anchors_preset(Control.PRESET_FULL_RECT)
	shade.mouse_filter = Control.MOUSE_FILTER_STOP
	opening_layer.add_child(shade)

	var logo: TextureRect = TextureRect.new()
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
	var label: Label = Label.new()
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
	var world: WorldEnvironment = WorldEnvironment.new()
	var environment: Environment = Environment.new()
	environment.background_mode = Environment.BG_COLOR
	environment.background_color = Color(0.025, 0.022, 0.032)
	environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	environment.ambient_light_color = Color(0.22, 0.18, 0.16)
	environment.ambient_light_energy = 0.55
	environment.glow_enabled = true
	environment.glow_intensity = 0.5
	world.environment = environment
	add_child(world)

	var moon: DirectionalLight3D = DirectionalLight3D.new()
	moon.rotation_degrees = Vector3(-55.0, -35.0, 0.0)
	moon.light_color = Color(0.65, 0.72, 1.0)
	moon.light_energy = 1.2
	moon.shadow_enabled = true
	add_child(moon)

func _make_black_vault() -> void:
	var floor_body: StaticBody3D = StaticBody3D.new()
	floor_body.name = "BlackVaultFloor"
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
	var body: StaticBody3D = StaticBody3D.new()
	body.position = position
	add_child(body)

	var collider: CollisionShape3D = CollisionShape3D.new()
	var shape: BoxShape3D = BoxShape3D.new()
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
	var root: Node3D = Node3D.new()
	root.name = "WallSpiderWeb"
	root.position = position
	root.rotation_degrees.y = yaw_degrees
	root.scale = Vector3.ONE * web_scale
	add_child(root)

	var web_material: StandardMaterial3D = _decoration_material(Color(0.72, 0.7, 0.66, 0.62), Color(0.03, 0.028, 0.026), 0.05)
	for angle in [0.0, 32.0, 62.0, 90.0, 122.0, 153.0]:
		var strand: MeshInstance3D = _make_decoration_bar(1.18, 0.018, web_material)
		strand.rotation_degrees.z = angle
		root.add_child(strand)

	for ring_index in range(3):
		var radius: float = 0.26 + float(ring_index) * 0.18
		for segment_index in range(6):
			var angle: float = float(segment_index) * TAU / 6.0 + float(ring_index) * 0.18
			var strand: MeshInstance3D = _make_decoration_bar(radius * 0.62, 0.014, web_material)
			strand.position = Vector3(cos(angle) * radius * 0.48, sin(angle) * radius * 0.48, 0.012)
			strand.rotation.z = angle + PI * 0.5
			root.add_child(strand)

func _make_wall_sword_and_shield(position: Vector3, yaw_degrees: float, shield_color: Color) -> void:
	_make_wall_sword(position + Vector3(0.0, 0.05, 0.02), yaw_degrees, 1.0)
	_make_wall_shield(position + Vector3(0.0, -0.06, 0.055), yaw_degrees, shield_color)

func _make_wall_sword(position: Vector3, yaw_degrees: float, sword_scale: float) -> void:
	var root: Node3D = Node3D.new()
	root.name = "WallSword"
	root.position = position
	root.rotation_degrees.y = yaw_degrees
	root.scale = Vector3.ONE * sword_scale
	add_child(root)

	var blade: MeshInstance3D = _make_decoration_bar(0.9, 0.07, _decoration_material(Color(0.55, 0.56, 0.54), Color(0.08, 0.08, 0.075), 0.08))
	blade.rotation_degrees.z = 90.0
	blade.position.y = 0.08
	root.add_child(blade)

	var guard: MeshInstance3D = _make_decoration_bar(0.45, 0.06, _decoration_material(Color(0.46, 0.31, 0.1), Color.BLACK, 0.0))
	guard.position.y = -0.42
	root.add_child(guard)

	var grip: MeshInstance3D = _make_decoration_bar(0.32, 0.07, _decoration_material(Color(0.09, 0.055, 0.035), Color.BLACK, 0.0))
	grip.rotation_degrees.z = 90.0
	grip.position.y = -0.62
	root.add_child(grip)

func _make_wall_shield(position: Vector3, yaw_degrees: float, shield_color: Color) -> void:
	var root: Node3D = Node3D.new()
	root.name = "WallShield"
	root.position = position
	root.rotation_degrees.y = yaw_degrees
	add_child(root)

	var shield: MeshInstance3D = MeshInstance3D.new()
	var shield_mesh: CylinderMesh = CylinderMesh.new()
	shield_mesh.top_radius = 0.34
	shield_mesh.bottom_radius = 0.39
	shield_mesh.height = 0.08
	shield_mesh.radial_segments = 28
	shield.mesh = shield_mesh
	shield.rotation_degrees.x = 90.0
	shield.scale = Vector3(0.86, 1.18, 1.0)
	shield.material_override = _decoration_material(shield_color, Color.BLACK, 0.0)
	root.add_child(shield)

	var boss: MeshInstance3D = MeshInstance3D.new()
	var boss_mesh: SphereMesh = SphereMesh.new()
	boss_mesh.radius = 0.12
	boss_mesh.height = 0.16
	boss_mesh.radial_segments = 14
	boss_mesh.rings = 7
	boss.mesh = boss_mesh
	boss.position.z = 0.06
	boss.material_override = _decoration_material(Color(0.52, 0.38, 0.14), Color(0.08, 0.045, 0.01), 0.08)
	root.add_child(boss)

func _make_bone_pile(position: Vector3, yaw_degrees: float) -> void:
	var root: Node3D = Node3D.new()
	root.name = "BonePile"
	root.position = position
	root.rotation_degrees.y = yaw_degrees
	add_child(root)

	var bone_material: StandardMaterial3D = _decoration_material(Color(0.68, 0.62, 0.48), Color(0.06, 0.05, 0.035), 0.04)
	for i in range(4):
		var bone: MeshInstance3D = MeshInstance3D.new()
		var bone_mesh: CylinderMesh = CylinderMesh.new()
		bone_mesh.top_radius = 0.035
		bone_mesh.bottom_radius = 0.04
		bone_mesh.height = 0.62 + float(i % 2) * 0.16
		bone_mesh.radial_segments = 10
		bone.mesh = bone_mesh
		bone.position = Vector3(float(i - 1) * 0.16, 0.05 + float(i % 2) * 0.035, float(i % 3) * 0.11)
		bone.rotation_degrees = Vector3(82.0, float(i) * 43.0, 62.0 + float(i) * 19.0)
		bone.material_override = bone_material
		root.add_child(bone)

	var skull: MeshInstance3D = MeshInstance3D.new()
	var skull_mesh: SphereMesh = SphereMesh.new()
	skull_mesh.radius = 0.2
	skull_mesh.height = 0.26
	skull_mesh.radial_segments = 16
	skull_mesh.rings = 8
	skull.mesh = skull_mesh
	skull.position = Vector3(0.16, 0.22, -0.08)
	skull.scale = Vector3(1.0, 0.82, 0.9)
	skull.material_override = bone_material
	root.add_child(skull)

	var eye_material: StandardMaterial3D = _decoration_material(Color(0.02, 0.015, 0.01), Color.BLACK, 0.0)
	for x in [-0.07, 0.07]:
		var eye: MeshInstance3D = MeshInstance3D.new()
		var eye_mesh: SphereMesh = SphereMesh.new()
		eye_mesh.radius = 0.035
		eye_mesh.height = 0.04
		eye.mesh = eye_mesh
		eye.position = Vector3(0.16 + x, 0.24, 0.1)
		eye.material_override = eye_material
		root.add_child(eye)

func _make_decoration_bar(length: float, thickness: float, material: Material) -> MeshInstance3D:
	var bar: MeshInstance3D = MeshInstance3D.new()
	var mesh: BoxMesh = BoxMesh.new()
	mesh.size = Vector3(length, thickness, thickness)
	bar.mesh = mesh
	bar.material_override = material
	return bar

func _make_column(position: Vector3) -> void:
	var body: StaticBody3D = StaticBody3D.new()
	body.position = position + Vector3(0.0, 1.3, 0.0)
	add_child(body)

	var collider: CollisionShape3D = CollisionShape3D.new()
	var shape: CylinderShape3D = CylinderShape3D.new()
	shape.radius = 0.75
	shape.height = 2.6
	collider.shape = shape
	body.add_child(collider)

	var mesh_instance: MeshInstance3D = MeshInstance3D.new()
	var mesh: CylinderMesh = CylinderMesh.new()
	mesh.top_radius = 0.75
	mesh.bottom_radius = 0.85
	mesh.height = 2.6
	mesh_instance.mesh = mesh
	mesh_instance.material_override = _material(Color(0.21, 0.2, 0.19), Color.BLACK, 0.0)
	body.add_child(mesh_instance)

func _make_torch(position: Vector3) -> void:
	var light: OmniLight3D = OmniLight3D.new()
	light.position = position + Vector3(0.0, 2.0, 0.0)
	light.light_color = Color(1.0, 0.36, 0.13)
	light.light_energy = 1.9
	light.omni_range = 8.0
	add_child(light)

	var flame: MeshInstance3D = MeshInstance3D.new()
	var mesh: SphereMesh = SphereMesh.new()
	mesh.radius = 0.18
	mesh.height = 0.35
	flame.mesh = mesh
	flame.position = position + Vector3(0.0, 1.55, 0.0)
	flame.material_override = _material(Color(1.0, 0.28, 0.04), Color(1.0, 0.24, 0.02), 1.8)
	add_child(flame)

func _make_velmora() -> void:
	if velmora_built:
		return
	velmora_built = true
	_load_vendor_textures()
	velmora_root = Node3D.new()
	velmora_root.name = "Velmora"
	velmora_root.position = VELMORA_ORIGIN
	add_child(velmora_root)
	_make_velmora_floor()
	_make_velmora_walls()
	_make_velmora_backdrop()
	_make_velmora_portal_marker(Vector3(0.0, 0.0, 20.0))
	_make_velmora_store("diamond_vendor", "Syra's Diamonds", Vector3(-14.0, 0.0, 2.5), Color(0.035, 0.09, 0.12), Color(0.1, 0.78, 1.0), 90.0)
	_make_velmora_store("spell_vendor", "Spells & Rituals", Vector3(14.0, 0.0, 2.0), Color(0.13, 0.035, 0.16), Color(0.76, 0.18, 1.0), -90.0)
	_make_velmora_store("relic_vendor", "Aldric's Stall", Vector3(0.0, 0.0, -13.5), Color(0.13, 0.09, 0.035), Color(0.95, 0.66, 0.18), 0.0)
	_make_torren_blackwell_npc()
	_make_velmora_street_dressing()
	_sync_torren_blackwell_visibility()

func _make_hoofgrove_wilds() -> void:
	if hoofgrove_built:
		return
	hoofgrove_built = true
	_load_vendor_textures()
	hoofgrove_root = Node3D.new()
	hoofgrove_root.name = "HoofgroveWilds"
	hoofgrove_root.position = HOOFGROVE_ORIGIN
	add_child(hoofgrove_root)

	var floor_body := StaticBody3D.new()
	floor_body.name = "HoofgroveFloor"
	hoofgrove_root.add_child(floor_body)

	var floor_collision := CollisionShape3D.new()
	var floor_shape := BoxShape3D.new()
	floor_shape.size = Vector3(HOOFGROVE_HALF_SIZE * 2.0, 0.35, HOOFGROVE_HALF_SIZE * 2.0)
	floor_collision.shape = floor_shape
	floor_collision.position.y = -0.2
	floor_body.add_child(floor_collision)

	var floor_mesh := MeshInstance3D.new()
	var floor_plane := PlaneMesh.new()
	floor_plane.size = Vector2(HOOFGROVE_HALF_SIZE * 2.0, HOOFGROVE_HALF_SIZE * 2.0)
	floor_mesh.mesh = floor_plane
	floor_mesh.material_override = _hoofgrove_floor_material()
	floor_body.add_child(floor_mesh)
	_make_hoofgrove_boundaries()

	var arrival := Node3D.new()
	arrival.name = "HoofgroveArrivalAnchor"
	arrival.position = Vector3(0.0, 0.0, 34.0)
	hoofgrove_root.add_child(arrival)
	var ring := MeshInstance3D.new()
	var ring_mesh := TorusMesh.new()
	ring_mesh.inner_radius = 1.05
	ring_mesh.outer_radius = 1.28
	ring_mesh.ring_segments = 42
	ring_mesh.rings = 8
	ring.mesh = ring_mesh
	ring.position.y = 1.8
	ring.rotation_degrees.x = 90.0
	ring.material_override = _portal_material(Color(0.18, 0.52, 0.18, 0.62), Color(0.45, 0.9, 0.28), 1.4)
	arrival.add_child(ring)

	var light := OmniLight3D.new()
	light.position = Vector3(0.0, 2.0, 34.0)
	light.light_color = Color(0.58, 0.9, 0.36)
	light.light_energy = 2.1
	light.omni_range = 8.0
	hoofgrove_root.add_child(light)

	var canopy_light := DirectionalLight3D.new()
	canopy_light.name = "HoofgroveCanopyLight"
	canopy_light.rotation_degrees = Vector3(-58.0, -28.0, 0.0)
	canopy_light.light_color = Color(0.58, 0.82, 0.48)
	canopy_light.light_energy = 0.42
	hoofgrove_root.add_child(canopy_light)

	_make_velmora_label(hoofgrove_root, "Hoofgrove Wilds", Vector3(0.0, 3.0, 30.5), Color(0.72, 0.92, 0.46), 30)
	_make_hoofgrove_ground_detail()
	_make_hoofgrove_forest()
	_make_hoofgrove_wildlife()

func _make_hoofgrove_boundaries() -> void:
	if hoofgrove_root == null:
		return
	var thickness := 3.0
	var height := 5.2
	var half := HOOFGROVE_HALF_SIZE - 1.25
	_make_hoofgrove_boundary_wall(Vector3(0.0, height * 0.5, -half - thickness * 0.5), Vector3(half * 2.0 + thickness * 2.0, height, thickness))
	_make_hoofgrove_boundary_wall(Vector3(0.0, height * 0.5, half + thickness * 0.5), Vector3(half * 2.0 + thickness * 2.0, height, thickness))
	_make_hoofgrove_boundary_wall(Vector3(-half - thickness * 0.5, height * 0.5, 0.0), Vector3(thickness, height, half * 2.0))
	_make_hoofgrove_boundary_wall(Vector3(half + thickness * 0.5, height * 0.5, 0.0), Vector3(thickness, height, half * 2.0))
	_make_hoofgrove_boundary_treeline()

func _make_hoofgrove_boundary_wall(position: Vector3, size: Vector3) -> void:
	var body := StaticBody3D.new()
	body.name = "HoofgroveTreeWallCollider"
	body.position = position
	hoofgrove_root.add_child(body)

	var collider := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = size
	collider.shape = shape
	body.add_child(collider)

func _make_hoofgrove_boundary_treeline() -> void:
	if velmora_tree_textures.is_empty():
		return
	var inner_half := HOOFGROVE_HALF_SIZE - 2.1
	var mid_half := HOOFGROVE_HALF_SIZE - 0.65
	var outer_half := HOOFGROVE_HALF_SIZE + 0.85
	var step := 2.35
	var row_offsets := [-1.1, 0.35, 1.65]
	var count := int(floor((inner_half * 2.0) / step))
	for i in range(count + 1):
		var coordinate := -inner_half + float(i) * step
		var stagger := 0.55 if i % 2 == 0 else -0.55
		for row_index in range(row_offsets.size()):
			var row_shift: float = float(row_offsets[row_index])
			var scale_value := rng.randf_range(1.5, 2.25) + float(row_index) * 0.14
			_make_hoofgrove_tree_sprite(Vector3(coordinate + stagger, 0.0, -mid_half + row_shift), scale_value)
			_make_hoofgrove_tree_sprite(Vector3(coordinate - stagger, 0.0, mid_half - row_shift), scale_value)
			_make_hoofgrove_tree_sprite(Vector3(-mid_half + row_shift, 0.0, coordinate - stagger), scale_value)
			_make_hoofgrove_tree_sprite(Vector3(mid_half - row_shift, 0.0, coordinate + stagger), scale_value)
	_make_hoofgrove_tree_sprite(Vector3(-outer_half, 0.0, -outer_half), rng.randf_range(2.0, 2.5))
	_make_hoofgrove_tree_sprite(Vector3(outer_half, 0.0, -outer_half), rng.randf_range(2.0, 2.5))
	_make_hoofgrove_tree_sprite(Vector3(-outer_half, 0.0, outer_half), rng.randf_range(2.0, 2.5))
	_make_hoofgrove_tree_sprite(Vector3(outer_half, 0.0, outer_half), rng.randf_range(2.0, 2.5))

func _make_hoofgrove_forest() -> void:
	var fixed_trees := [
		Vector3(-13.0, 0.0, 30.0), Vector3(12.0, 0.0, 29.0),
		Vector3(-22.0, 0.0, 18.0), Vector3(20.0, 0.0, 15.0),
		Vector3(-26.0, 0.0, 0.0), Vector3(25.0, 0.0, -2.0),
		Vector3(-18.0, 0.0, -21.0), Vector3(19.0, 0.0, -24.0),
		Vector3(-5.0, 0.0, -36.0), Vector3(7.0, 0.0, -38.0)
	]
	for position in fixed_trees:
		_make_hoofgrove_tree_sprite(position, rng.randf_range(1.05, 1.45))

	for _i in range(58):
		var position := _random_hoofgrove_tree_position()
		var scale_value := rng.randf_range(0.82, 1.34)
		_make_hoofgrove_tree_sprite(position, scale_value)

	for _i in range(18):
		_make_hoofgrove_underbrush(_random_hoofgrove_tree_position(), rng.randf_range(0.45, 0.95))

func _make_hoofgrove_ground_detail() -> void:
	if hoofgrove_root == null:
		return
	var leaf_materials: Array[StandardMaterial3D] = [
		_material(Color(0.26, 0.18, 0.075), Color.BLACK, 0.0),
		_material(Color(0.18, 0.25, 0.075), Color.BLACK, 0.0),
		_material(Color(0.33, 0.11, 0.04), Color.BLACK, 0.0),
		_material(Color(0.38, 0.29, 0.08), Color.BLACK, 0.0)
	]
	var stone_materials: Array[StandardMaterial3D] = [
		_material(Color(0.18, 0.17, 0.145), Color.BLACK, 0.0),
		_material(Color(0.24, 0.23, 0.2), Color.BLACK, 0.0),
		_material(Color(0.12, 0.13, 0.115), Color.BLACK, 0.0)
	]
	var branch_material := _material(Color(0.13, 0.075, 0.035), Color.BLACK, 0.0)
	var wet_mud_material := _material(Color(0.06, 0.045, 0.03), Color(0.015, 0.012, 0.008), 0.04)

	for _i in range(34):
		_make_hoofgrove_mud_patch(_random_hoofgrove_ground_position(), rng.randf_range(0.75, 1.9), wet_mud_material)
	for _i in range(150):
		var material := leaf_materials[rng.randi_range(0, leaf_materials.size() - 1)]
		_make_hoofgrove_leaf_litter(_random_hoofgrove_ground_position(false), material)
	for _i in range(64):
		var material := stone_materials[rng.randi_range(0, stone_materials.size() - 1)]
		_make_hoofgrove_ground_stone(_random_hoofgrove_ground_position(false), material)
	for _i in range(18):
		var material := stone_materials[rng.randi_range(0, stone_materials.size() - 1)]
		_make_hoofgrove_boulder(_random_hoofgrove_ground_position(), rng.randf_range(0.55, 1.65), material)
	for _i in range(46):
		_make_hoofgrove_ground_branch(_random_hoofgrove_ground_position(false), rng.randf_range(0.55, 1.55), branch_material)

func _random_hoofgrove_ground_position(keep_spawn_clear: bool = true) -> Vector3:
	for _attempt in range(60):
		var position := Vector3(
			rng.randf_range(-HOOFGROVE_HALF_SIZE + 2.0, HOOFGROVE_HALF_SIZE - 2.0),
			0.0,
			rng.randf_range(-HOOFGROVE_HALF_SIZE + 2.0, HOOFGROVE_HALF_SIZE - 2.0)
		)
		if keep_spawn_clear and position.distance_to(Vector3(0.0, 0.0, 34.0)) < 5.0:
			continue
		return position
	return Vector3(rng.randf_range(-34.0, 34.0), 0.0, rng.randf_range(-34.0, 22.0))

func _make_hoofgrove_mud_patch(position: Vector3, scale_value: float, material: Material) -> void:
	var patch := MeshInstance3D.new()
	patch.name = "HoofgroveMudPatch"
	var mesh := CylinderMesh.new()
	mesh.top_radius = 1.0
	mesh.bottom_radius = 1.0
	mesh.height = 0.014
	mesh.radial_segments = 18
	patch.mesh = mesh
	patch.position = position + Vector3(0.0, 0.012, 0.0)
	patch.scale = Vector3(scale_value * rng.randf_range(0.8, 1.55), 1.0, scale_value * rng.randf_range(0.45, 1.0))
	patch.rotation_degrees.y = rng.randf_range(0.0, 360.0)
	patch.material_override = material
	patch.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	hoofgrove_root.add_child(patch)

func _make_hoofgrove_leaf_litter(position: Vector3, material: Material) -> void:
	var leaf := MeshInstance3D.new()
	leaf.name = "HoofgroveLeafLitter"
	var mesh := BoxMesh.new()
	mesh.size = Vector3(rng.randf_range(0.12, 0.32), 0.012, rng.randf_range(0.04, 0.11))
	leaf.mesh = mesh
	leaf.position = position + Vector3(0.0, 0.026, 0.0)
	leaf.rotation_degrees = Vector3(0.0, rng.randf_range(0.0, 360.0), rng.randf_range(-8.0, 8.0))
	leaf.material_override = material
	leaf.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	hoofgrove_root.add_child(leaf)

func _make_hoofgrove_ground_stone(position: Vector3, material: Material) -> void:
	var stone := MeshInstance3D.new()
	stone.name = "HoofgroveGroundStone"
	var mesh := SphereMesh.new()
	mesh.radius = rng.randf_range(0.08, 0.2)
	mesh.height = rng.randf_range(0.08, 0.18)
	stone.mesh = mesh
	stone.position = position + Vector3(0.0, 0.045, 0.0)
	stone.scale = Vector3(rng.randf_range(0.9, 1.45), rng.randf_range(0.28, 0.55), rng.randf_range(0.75, 1.25))
	stone.rotation_degrees.y = rng.randf_range(0.0, 360.0)
	stone.material_override = material
	hoofgrove_root.add_child(stone)

func _make_hoofgrove_boulder(position: Vector3, scale_value: float, material: Material) -> void:
	var boulder := MeshInstance3D.new()
	boulder.name = "HoofgroveBoulder"
	var mesh := SphereMesh.new()
	mesh.radius = 0.55
	mesh.height = 0.72
	mesh.radial_segments = 14
	mesh.rings = 7
	boulder.mesh = mesh
	boulder.position = position + Vector3(0.0, 0.18 * scale_value, 0.0)
	boulder.scale = Vector3(
		scale_value * rng.randf_range(0.9, 1.7),
		scale_value * rng.randf_range(0.34, 0.82),
		scale_value * rng.randf_range(0.75, 1.45)
	)
	boulder.rotation_degrees = Vector3(rng.randf_range(-4.0, 4.0), rng.randf_range(0.0, 360.0), rng.randf_range(-5.0, 5.0))
	boulder.material_override = material
	hoofgrove_root.add_child(boulder)

	if rng.randf() < 0.38:
		var moss := MeshInstance3D.new()
		moss.name = "HoofgroveBoulderMoss"
		var moss_mesh := CylinderMesh.new()
		moss_mesh.top_radius = 0.42
		moss_mesh.bottom_radius = 0.42
		moss_mesh.height = 0.012
		moss_mesh.radial_segments = 12
		moss.mesh = moss_mesh
		moss.position = boulder.position + Vector3(rng.randf_range(-0.16, 0.16), 0.24 * scale_value, rng.randf_range(-0.16, 0.16))
		moss.scale = Vector3(scale_value * rng.randf_range(0.45, 0.95), 1.0, scale_value * rng.randf_range(0.28, 0.65))
		moss.rotation_degrees.y = rng.randf_range(0.0, 360.0)
		moss.material_override = _material(Color(0.055, 0.16, 0.045), Color(0.01, 0.055, 0.012), 0.06)
		moss.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
		hoofgrove_root.add_child(moss)

func _make_hoofgrove_ground_branch(position: Vector3, length: float, material: Material) -> void:
	var branch := _make_decoration_bar(length, rng.randf_range(0.035, 0.065), material)
	branch.name = "HoofgroveFallenBranch"
	branch.position = position + Vector3(0.0, 0.052, 0.0)
	branch.rotation_degrees = Vector3(rng.randf_range(-3.0, 3.0), rng.randf_range(0.0, 360.0), rng.randf_range(-4.0, 4.0))
	branch.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	hoofgrove_root.add_child(branch)
	if rng.randf() < 0.45:
		var twig := _make_decoration_bar(length * rng.randf_range(0.22, 0.42), rng.randf_range(0.02, 0.035), material)
		twig.name = "HoofgroveFallenTwig"
		twig.position = branch.position + Vector3(rng.randf_range(-0.22, 0.22), 0.01, rng.randf_range(-0.22, 0.22))
		twig.rotation_degrees = branch.rotation_degrees + Vector3(0.0, rng.randf_range(35.0, 85.0), 0.0)
		twig.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
		hoofgrove_root.add_child(twig)

func _random_hoofgrove_tree_position() -> Vector3:
	for _attempt in range(80):
		var position := Vector3(
			rng.randf_range(-HOOFGROVE_HALF_SIZE + 3.0, HOOFGROVE_HALF_SIZE - 3.0),
			0.0,
			rng.randf_range(-HOOFGROVE_HALF_SIZE + 3.0, HOOFGROVE_HALF_SIZE - 3.0)
		)
		if position.distance_to(Vector3(0.0, 0.0, 34.0)) < 8.0:
			continue
		if absf(position.x) < 24.0 and absf(position.z) < 30.0:
			continue
		if absf(position.x) < 5.5 and position.z > -10.0 and position.z < 38.0:
			continue
		return position
	return Vector3(rng.randf_range(-35.0, 35.0), 0.0, rng.randf_range(-35.0, -18.0))

func _make_hoofgrove_tree_sprite(position: Vector3, scale_value: float) -> void:
	if hoofgrove_root == null or velmora_tree_textures.is_empty():
		return
	var texture := velmora_tree_textures[rng.randi_range(0, velmora_tree_textures.size() - 1)]
	var sprite := Sprite3D.new()
	sprite.name = "HoofgroveVelmoraTree"
	sprite.texture = texture
	sprite.pixel_size = 0.0072
	sprite.shaded = true
	sprite.double_sided = true
	sprite.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	sprite.texture_filter = BaseMaterial3D.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS
	sprite.alpha_cut = SpriteBase3D.ALPHA_CUT_DISCARD
	sprite.position = position + Vector3(0.0, 1.95 * scale_value, 0.0)
	sprite.scale = Vector3.ONE * scale_value
	sprite.modulate = Color(0.7, 0.86, 0.62, 1.0)
	hoofgrove_root.add_child(sprite)

func _make_hoofgrove_underbrush(position: Vector3, scale_value: float) -> void:
	if hoofgrove_root == null:
		return
	var brush := MeshInstance3D.new()
	brush.name = "HoofgroveUnderbrush"
	var mesh := SphereMesh.new()
	mesh.radius = 0.52
	mesh.height = 0.42
	brush.mesh = mesh
	brush.position = position + Vector3(0.0, 0.22, 0.0)
	brush.scale = Vector3(1.4, 0.45, 0.9) * scale_value
	brush.material_override = _material(Color(0.055, 0.19, 0.06), Color(0.01, 0.08, 0.02), 0.08)
	hoofgrove_root.add_child(brush)

func _make_hoofgrove_wildlife() -> void:
	if hoofgrove_root == null:
		return
	hoofgrove_flying_birds.clear()
	var bird_material := _material(Color(0.018, 0.019, 0.018), Color.BLACK, 0.0)
	var wing_material := _material(Color(0.028, 0.03, 0.028), Color.BLACK, 0.0)
	for _i in range(8):
		var center := Vector3(rng.randf_range(-29.0, 29.0), rng.randf_range(7.0, 10.5), rng.randf_range(-30.0, 24.0))
		_make_hoofgrove_flying_bird(center, rng.randf_range(5.5, 14.0), rng.randf_range(0.18, 0.42), bird_material, wing_material)
	for _i in range(18):
		var position := _random_hoofgrove_tree_position()
		position += Vector3(rng.randf_range(-0.45, 0.45), rng.randf_range(2.6, 4.9), rng.randf_range(-0.28, 0.28))
		_make_hoofgrove_perched_bird(position, rng.randf_range(0.65, 1.15), bird_material, wing_material)

func _make_hoofgrove_flying_bird(center: Vector3, orbit_radius: float, speed: float, bird_material: Material, wing_material: Material) -> void:
	var root := _make_hoofgrove_bird_visual("HoofgroveFlyingBird", bird_material, wing_material, 1.0)
	root.position = center
	hoofgrove_root.add_child(root)
	var left_wing := root.get_node_or_null("LeftWing") as MeshInstance3D
	var right_wing := root.get_node_or_null("RightWing") as MeshInstance3D
	hoofgrove_flying_birds.append({
		"root": root,
		"left_wing": left_wing,
		"right_wing": right_wing,
		"center": center,
		"radius": orbit_radius,
		"speed": speed,
		"phase": rng.randf_range(0.0, TAU),
		"flap": rng.randf_range(0.0, TAU)
	})

func _make_hoofgrove_perched_bird(position: Vector3, scale_value: float, bird_material: Material, wing_material: Material) -> void:
	var root := _make_hoofgrove_bird_visual("HoofgrovePerchedBird", bird_material, wing_material, scale_value)
	root.position = position
	root.rotation_degrees = Vector3(0.0, rng.randf_range(0.0, 360.0), 0.0)
	hoofgrove_root.add_child(root)

	var perch := _make_decoration_bar(rng.randf_range(0.45, 0.9) * scale_value, 0.025 * scale_value, _material(Color(0.11, 0.065, 0.03), Color.BLACK, 0.0))
	perch.name = "HoofgroveBirdPerch"
	perch.position = position + Vector3(0.0, -0.045 * scale_value, 0.0)
	perch.rotation_degrees = Vector3(rng.randf_range(-4.0, 4.0), root.rotation_degrees.y + rng.randf_range(-24.0, 24.0), rng.randf_range(-5.0, 5.0))
	hoofgrove_root.add_child(perch)

func _make_hoofgrove_bird_visual(node_name: String, bird_material: Material, wing_material: Material, scale_value: float) -> Node3D:
	var root := Node3D.new()
	root.name = node_name
	root.scale = Vector3.ONE * scale_value

	var body := MeshInstance3D.new()
	body.name = "Body"
	var body_mesh := BoxMesh.new()
	body_mesh.size = Vector3(0.18, 0.065, 0.08)
	body.mesh = body_mesh
	body.material_override = bird_material
	body.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	root.add_child(body)

	var head := MeshInstance3D.new()
	head.name = "Head"
	var head_mesh := SphereMesh.new()
	head_mesh.radius = 0.045
	head_mesh.height = 0.06
	head.mesh = head_mesh
	head.position = Vector3(0.1, 0.025, 0.0)
	head.material_override = bird_material
	head.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	root.add_child(head)

	var left_wing := _make_decoration_bar(0.3, 0.035, wing_material)
	left_wing.name = "LeftWing"
	left_wing.position = Vector3(-0.05, 0.0, -0.085)
	left_wing.rotation_degrees = Vector3(0.0, 0.0, -18.0)
	left_wing.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	root.add_child(left_wing)

	var right_wing := _make_decoration_bar(0.3, 0.035, wing_material)
	right_wing.name = "RightWing"
	right_wing.position = Vector3(-0.05, 0.0, 0.085)
	right_wing.rotation_degrees = Vector3(0.0, 0.0, 18.0)
	right_wing.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	root.add_child(right_wing)
	return root

func _animate_hoofgrove_birds(delta: float) -> void:
	if current_area != AREA_HOOFGROVE_WILDS:
		return
	for i in range(hoofgrove_flying_birds.size()):
		var bird := hoofgrove_flying_birds[i]
		var root := bird["root"] as Node3D
		if root == null:
			continue
		var center: Vector3 = bird["center"]
		var radius: float = float(bird["radius"])
		var speed: float = float(bird["speed"])
		var phase: float = float(bird["phase"]) + delta * speed
		var flap: float = float(bird["flap"]) + delta * 9.5
		bird["phase"] = phase
		bird["flap"] = flap
		var offset := Vector3(cos(phase) * radius, sin(phase * 1.7) * 0.55, sin(phase) * radius * 0.62)
		root.position = center + offset
		var tangent := Vector3(-sin(phase), 0.0, cos(phase) * 0.62)
		if tangent.length_squared() > 0.001:
			root.rotation.y = atan2(tangent.x, tangent.z)
		var flap_angle := 18.0 + sin(flap) * 24.0
		var left_wing := bird["left_wing"] as MeshInstance3D
		var right_wing := bird["right_wing"] as MeshInstance3D
		if left_wing != null:
			left_wing.rotation_degrees.z = -flap_angle
		if right_wing != null:
			right_wing.rotation_degrees.z = flap_angle

func _make_hoofgrove_tree(position: Vector3, scale_value: float) -> void:
	if hoofgrove_root == null:
		return
	var root := Node3D.new()
	root.name = "HoofgroveTree"
	root.position = position
	root.scale = Vector3.ONE * scale_value
	hoofgrove_root.add_child(root)

	var trunk := MeshInstance3D.new()
	var trunk_mesh := CylinderMesh.new()
	trunk_mesh.top_radius = 0.16
	trunk_mesh.bottom_radius = 0.25
	trunk_mesh.height = 2.6
	trunk.mesh = trunk_mesh
	trunk.position.y = 1.3
	trunk.material_override = _material(Color(0.16, 0.09, 0.045), Color.BLACK, 0.0)
	root.add_child(trunk)

	var leaf_material := _material(Color(0.08, 0.28, 0.11), Color(0.02, 0.12, 0.04), 0.16)
	for offset in [Vector3(0.0, 2.65, 0.0), Vector3(0.48, 2.38, 0.1), Vector3(-0.48, 2.34, -0.08)]:
		var leaves := MeshInstance3D.new()
		var leaves_mesh := SphereMesh.new()
		leaves_mesh.radius = 0.72
		leaves_mesh.height = 1.05
		leaves.mesh = leaves_mesh
		leaves.position = offset
		leaves.material_override = leaf_material
		root.add_child(leaves)

func _load_vendor_textures() -> void:
	if vendor_front_texture == null and ResourceLoader.exists(VENDOR_FRONT_TEXTURE_PATH):
		vendor_front_texture = load(VENDOR_FRONT_TEXTURE_PATH) as Texture2D
	if vendor_side_texture == null and ResourceLoader.exists(VENDOR_SIDE_TEXTURE_PATH):
		vendor_side_texture = load(VENDOR_SIDE_TEXTURE_PATH) as Texture2D
	if vendor_back_texture == null and ResourceLoader.exists(VENDOR_BACK_TEXTURE_PATH):
		vendor_back_texture = load(VENDOR_BACK_TEXTURE_PATH) as Texture2D
	if diamond_item_texture == null:
		if ResourceLoader.exists(DIAMOND_ITEM_TEXTURE_PATH):
			diamond_item_texture = load(DIAMOND_ITEM_TEXTURE_PATH) as Texture2D
		else:
			var diamond_image := Image.load_from_file(DIAMOND_ITEM_TEXTURE_PATH)
			if diamond_image != null:
				diamond_item_texture = ImageTexture.create_from_image(diamond_image)
	if velmora_barrel_texture == null and ResourceLoader.exists(VELMORA_BARREL_TEXTURE_PATH):
		velmora_barrel_texture = load(VELMORA_BARREL_TEXTURE_PATH) as Texture2D
	if velmora_vendor_man_texture == null and ResourceLoader.exists(VELMORA_VENDOR_MAN_TEXTURE_PATH):
		velmora_vendor_man_texture = load(VELMORA_VENDOR_MAN_TEXTURE_PATH) as Texture2D
	if velmora_vendor_woman_texture == null and ResourceLoader.exists(VELMORA_VENDOR_WOMAN_TEXTURE_PATH):
		velmora_vendor_woman_texture = load(VELMORA_VENDOR_WOMAN_TEXTURE_PATH) as Texture2D
	if velmora_vendor_warlock_texture == null and ResourceLoader.exists(VELMORA_VENDOR_WARLOCK_TEXTURE_PATH):
		velmora_vendor_warlock_texture = load(VELMORA_VENDOR_WARLOCK_TEXTURE_PATH) as Texture2D
	if velmora_vendor_man_face_texture == null:
		velmora_vendor_man_face_texture = VELMORA_VENDOR_MAN_FACE_TEXTURE
	if velmora_vendor_woman_face_texture == null:
		velmora_vendor_woman_face_texture = VELMORA_VENDOR_WOMAN_FACE_TEXTURE
	if velmora_vendor_warlock_face_texture == null:
		velmora_vendor_warlock_face_texture = VELMORA_VENDOR_WARLOCK_FACE_TEXTURE
	if torren_blackwell_front_texture == null and ResourceLoader.exists(TORREN_BLACKWELL_FRONT_TEXTURE_PATH):
		torren_blackwell_front_texture = load(TORREN_BLACKWELL_FRONT_TEXTURE_PATH) as Texture2D
	if torren_blackwell_side_texture == null and ResourceLoader.exists(TORREN_BLACKWELL_SIDE_TEXTURE_PATH):
		torren_blackwell_side_texture = load(TORREN_BLACKWELL_SIDE_TEXTURE_PATH) as Texture2D
	if torren_blackwell_back_texture == null and ResourceLoader.exists(TORREN_BLACKWELL_BACK_TEXTURE_PATH):
		torren_blackwell_back_texture = load(TORREN_BLACKWELL_BACK_TEXTURE_PATH) as Texture2D
	if torren_blackwell_face_texture == null and ResourceLoader.exists(TORREN_BLACKWELL_FACE_TEXTURE_PATH):
		torren_blackwell_face_texture = load(TORREN_BLACKWELL_FACE_TEXTURE_PATH) as Texture2D
	if velmora_tree_textures.is_empty():
		for tree_texture_path in VELMORA_TREE_TEXTURE_PATHS:
			if ResourceLoader.exists(tree_texture_path):
				var tree_texture := load(tree_texture_path) as Texture2D
				if tree_texture != null:
					velmora_tree_textures.append(tree_texture)
	if spell_shop_scene == null and ResourceLoader.exists(SPELL_SHOP_MODEL_PATH):
		spell_shop_scene = load(SPELL_SHOP_MODEL_PATH) as PackedScene
	if spell_shop_texture == null and ResourceLoader.exists(SPELL_SHOP_TEXTURE_PATH):
		spell_shop_texture = load(SPELL_SHOP_TEXTURE_PATH) as Texture2D

func _make_velmora_floor() -> void:
	var floor_body: StaticBody3D = StaticBody3D.new()
	floor_body.name = "VelmoraFloor"
	velmora_root.add_child(floor_body)

	var floor_collision: CollisionShape3D = CollisionShape3D.new()
	var floor_shape: BoxShape3D = BoxShape3D.new()
	floor_shape.size = Vector3(VELMORA_HALF_SIZE * 2.0, 0.35, VELMORA_HALF_SIZE * 2.0)
	floor_collision.shape = floor_shape
	floor_collision.position.y = -0.2
	floor_body.add_child(floor_collision)

	var floor_mesh: MeshInstance3D = MeshInstance3D.new()
	var plane: PlaneMesh = PlaneMesh.new()
	plane.size = Vector2(VELMORA_HALF_SIZE * 2.0, VELMORA_HALF_SIZE * 2.0)
	floor_mesh.mesh = plane
	floor_mesh.material_override = _velmora_floor_material()
	floor_body.add_child(floor_mesh)

	var street: MeshInstance3D = MeshInstance3D.new()
	var street_plane: PlaneMesh = PlaneMesh.new()
	street_plane.size = Vector2(11.0, VELMORA_HALF_SIZE * 2.0 - 4.0)
	street.mesh = street_plane
	street.position.y = 0.018
	street.material_override = _velmora_street_material()
	floor_body.add_child(street)

	for puddle_position in [Vector3(-4.1, 0.025, 9.6), Vector3(3.0, 0.026, -4.4), Vector3(-2.6, 0.027, -14.5)]:
		_make_velmora_puddle(floor_body, puddle_position)

func _make_velmora_walls() -> void:
	_make_velmora_wall(Vector3(0.0, 1.95, -VELMORA_HALF_SIZE), Vector3(VELMORA_HALF_SIZE * 2.0, 3.9, 1.0))
	_make_velmora_wall(Vector3(0.0, 1.95, VELMORA_HALF_SIZE), Vector3(VELMORA_HALF_SIZE * 2.0, 3.9, 1.0))
	_make_velmora_wall(Vector3(-VELMORA_HALF_SIZE, 1.95, 0.0), Vector3(1.0, 3.9, VELMORA_HALF_SIZE * 2.0))
	_make_velmora_wall(Vector3(VELMORA_HALF_SIZE, 1.95, 0.0), Vector3(1.0, 3.9, VELMORA_HALF_SIZE * 2.0))
	for lamp_position in [Vector3(-5.6, 0.0, 15.0), Vector3(5.6, 0.0, 12.0), Vector3(-6.0, 0.0, -5.5), Vector3(6.0, 0.0, -9.0)]:
		_make_velmora_lamp(lamp_position)

func _make_velmora_wall(position: Vector3, size: Vector3) -> void:
	var body: StaticBody3D = StaticBody3D.new()
	body.position = position
	velmora_root.add_child(body)

	var collider: CollisionShape3D = CollisionShape3D.new()
	var shape: BoxShape3D = BoxShape3D.new()
	shape.size = size
	collider.shape = shape
	body.add_child(collider)

	var mesh_instance: MeshInstance3D = MeshInstance3D.new()
	var mesh: BoxMesh = BoxMesh.new()
	mesh.size = size
	mesh_instance.mesh = mesh
	mesh_instance.material_override = _velmora_wall_material(size)
	body.add_child(mesh_instance)

func _make_velmora_backdrop() -> void:
	for tower_data in [
		{"position": Vector3(-18.5, 0.0, -22.4), "height": 7.8, "width": 3.2, "accent": Color(0.38, 0.18, 0.75)},
		{"position": Vector3(-8.5, 0.0, -23.2), "height": 9.2, "width": 2.6, "accent": Color(0.95, 0.55, 0.25)},
		{"position": Vector3(9.0, 0.0, -23.0), "height": 8.4, "width": 3.0, "accent": Color(0.12, 0.75, 1.0)},
		{"position": Vector3(19.0, 0.0, -22.0), "height": 6.8, "width": 3.4, "accent": Color(0.75, 0.2, 1.0)}
	]:
		_make_velmora_tower(tower_data["position"], float(tower_data["height"]), float(tower_data["width"]), tower_data["accent"])
	_make_velmora_banner_line(Vector3(-20.0, 5.0, -16.5), Vector3(20.0, 4.4, -16.5), Color(0.14, 0.06, 0.16), Color(0.95, 0.65, 0.18))
	_make_velmora_banner_line(Vector3(-18.0, 4.3, 8.5), Vector3(18.0, 4.8, 8.5), Color(0.05, 0.12, 0.2), Color(0.12, 0.78, 1.0))

func _make_velmora_tower(position: Vector3, height: float, width: float, accent: Color) -> void:
	var root: Node3D = Node3D.new()
	root.name = "GothicBackdrop"
	root.position = position
	velmora_root.add_child(root)

	_make_velmora_box(root, "TowerBody", Vector3(width, height, width * 0.72), Vector3(0.0, height * 0.5, 0.0), _velmora_wall_material(Vector3(width, height, width)))
	var roof_material: StandardMaterial3D = _velmora_roof_material()
	_make_velmora_roof_pair(root, width * 0.78, width * 0.72, Vector3(0.0, height + 0.35, 0.0), roof_material)
	var spire: MeshInstance3D = MeshInstance3D.new()
	var spire_mesh: CylinderMesh = CylinderMesh.new()
	spire_mesh.top_radius = 0.0
	spire_mesh.bottom_radius = width * 0.24
	spire_mesh.height = 2.2
	spire_mesh.radial_segments = 5
	spire.mesh = spire_mesh
	spire.position = Vector3(0.0, height + 1.35, 0.0)
	spire.material_override = roof_material
	root.add_child(spire)
	for x in [-width * 0.24, width * 0.24]:
		_make_velmora_window(root, Vector3(x, height * 0.52, width * 0.38), Vector2(0.38, 0.75), accent)
	_make_velmora_window(root, Vector3(0.0, height * 0.72, width * 0.38), Vector2(0.46, 0.9), accent)

func _make_velmora_lamp(position: Vector3) -> void:
	var post: MeshInstance3D = MeshInstance3D.new()
	var post_mesh: CylinderMesh = CylinderMesh.new()
	post_mesh.top_radius = 0.08
	post_mesh.bottom_radius = 0.1
	post_mesh.height = 2.5
	post.mesh = post_mesh
	post.position = position + Vector3(0.0, 1.25, 0.0)
	post.material_override = _material(Color(0.07, 0.052, 0.042), Color.BLACK, 0.0)
	velmora_root.add_child(post)

	var hook: MeshInstance3D = _make_decoration_bar(0.72, 0.045, _decoration_material(Color(0.12, 0.085, 0.055), Color.BLACK, 0.0))
	hook.position = position + Vector3(0.0, 2.42, 0.24)
	hook.rotation_degrees.y = 90.0
	velmora_root.add_child(hook)

	var light: OmniLight3D = OmniLight3D.new()
	light.position = position + Vector3(0.0, 2.35, 0.58)
	light.light_color = Color(0.96, 0.58, 0.24)
	light.light_energy = 2.55
	light.omni_range = 9.2
	velmora_root.add_child(light)

	var flame: MeshInstance3D = MeshInstance3D.new()
	var flame_mesh: SphereMesh = SphereMesh.new()
	flame_mesh.radius = 0.2
	flame_mesh.height = 0.34
	flame.mesh = flame_mesh
	flame.position = light.position
	flame.material_override = _material(Color(1.0, 0.42, 0.08), Color(1.0, 0.26, 0.02), 2.1)
	velmora_root.add_child(flame)

	var cage_material: StandardMaterial3D = _decoration_material(Color(0.08, 0.055, 0.035), Color.BLACK, 0.0)
	for x in [-0.16, 0.16]:
		var cage: MeshInstance3D = _make_decoration_bar(0.45, 0.025, cage_material)
		cage.position = light.position + Vector3(x, 0.0, 0.0)
		cage.rotation_degrees.z = 90.0
		velmora_root.add_child(cage)

func _make_velmora_portal_marker(position: Vector3) -> void:
	var root: Node3D = Node3D.new()
	root.name = "VelmoraArrivalPortal"
	root.position = position
	velmora_root.add_child(root)
	var ring: MeshInstance3D = MeshInstance3D.new()
	var ring_mesh: TorusMesh = TorusMesh.new()
	ring_mesh.inner_radius = 1.25
	ring_mesh.outer_radius = 1.48
	ring_mesh.ring_segments = 48
	ring_mesh.rings = 10
	ring.mesh = ring_mesh
	ring.position.y = 2.0
	ring.rotation_degrees.x = 90.0
	ring.material_override = _portal_material(Color(0.08, 0.6, 0.85, 0.62), Color(0.1, 0.85, 1.0), 1.8)
	root.add_child(ring)
	var light: OmniLight3D = OmniLight3D.new()
	light.position.y = 1.8
	light.light_color = Color(0.1, 0.8, 1.0)
	light.light_energy = 2.8
	light.omni_range = 7.0
	root.add_child(light)

func _make_velmora_store(vendor_id: String, vendor_name: String, position: Vector3, stall_color: Color, accent: Color, yaw_degrees: float) -> void:
	var root: Node3D = Node3D.new()
	root.name = vendor_name.replace(" ", "")
	root.position = position
	root.rotation_degrees.y = yaw_degrees
	velmora_root.add_child(root)

	_make_shopfront(root, vendor_id, vendor_name, stall_color, accent)

	var area: Area3D = Area3D.new()
	area.name = "%sArea" % vendor_id
	area.position = Vector3(0.0, 0.0, 2.05)
	area.body_entered.connect(_on_vendor_entered.bind(vendor_id))
	area.body_exited.connect(_on_vendor_exited.bind(vendor_id))
	root.add_child(area)

	var shape_node: CollisionShape3D = CollisionShape3D.new()
	var shape: BoxShape3D = BoxShape3D.new()
	shape.size = Vector3(7.2, 2.4, 4.6)
	shape_node.shape = shape
	shape_node.position.y = 1.0
	area.add_child(shape_node)

func _make_shopfront(parent: Node3D, vendor_id: String, vendor_name: String, stall_color: Color, accent: Color) -> void:
	var stone_material := _velmora_wall_material(Vector3(7.2, 3.6, 0.9))
	var wood_material := _velmora_wood_material()
	var roof_material := _velmora_roof_material()
	var accent_material := _material(stall_color.lightened(0.08), accent, 0.18)

	_make_velmora_box(parent, "ShopBackWall", Vector3(7.2, 3.45, 0.72), Vector3(0.0, 1.75, -1.3), stone_material)
	_make_velmora_box(parent, "ShopCounter", Vector3(5.9, 1.05, 1.35), Vector3(0.0, 0.55, 0.3), accent_material)
	_make_velmora_box(parent, "ShopLedger", Vector3(4.8, 0.18, 1.18), Vector3(0.0, 1.15, 0.58), wood_material)
	_make_velmora_box(parent, "ShopSignBoard", Vector3(5.1, 0.76, 0.16), Vector3(0.0, 2.82, 0.92), _material(Color(0.045, 0.034, 0.026), accent, 0.12))
	_make_velmora_label(parent, vendor_name, Vector3(0.0, 2.82, 1.08), accent, 27)
	_make_velmora_roof_pair(parent, 7.8, 4.2, Vector3(0.0, 3.58, -0.6), roof_material)

	for x in [-3.05, 3.05]:
		_make_velmora_box(parent, "ShopPost", Vector3(0.2, 2.65, 0.2), Vector3(x, 1.34, 0.95), wood_material)
		_make_velmora_box(parent, "ShopBrace", Vector3(1.0, 0.14, 0.18), Vector3(x * 0.92, 2.42, 0.94), wood_material, Vector3(0.0, 0.0, signf(-x) * 24.0))

	for x in [-2.12, 2.12]:
		_make_velmora_window(parent, Vector3(x, 1.92, 0.98), Vector2(0.92, 1.08), accent)

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
	if diamond_item_texture != null:
		_make_colored_diamond_sprite(parent, Vector3(0.0, 3.42, 1.1), 0.0042, Vector3.ONE * 0.72, Color(0.68, 0.92, 1.0))
		var showcase := [
			{"x": -2.15, "color": Color(1.0, 0.48, 0.12)},
			{"x": -1.29, "color": Color(0.22, 0.92, 1.0)},
			{"x": -0.43, "color": Color(0.0, 0.78, 0.42)},
			{"x": 0.43, "color": Color(0.32, 0.05, 0.72)},
			{"x": 1.29, "color": Color(1.0, 0.28, 0.06)},
			{"x": 2.15, "color": Color(0.18, 0.58, 1.0)}
		]
		for gem_data in showcase:
			_make_colored_diamond_sprite(parent, Vector3(float(gem_data["x"]), 1.48, 1.1), 0.0032, Vector3.ONE * 0.34, gem_data["color"])
	else:
		_make_diamond_icon(parent, Vector3(0.0, 3.42, 1.1), 0.78, accent)
		for x in [-1.9, -0.65, 0.65, 1.9]:
			_make_diamond_icon(parent, Vector3(x, 1.42, 1.1), 0.32, accent)
	_make_velmora_box(parent, "GemCloth", Vector3(4.8, 0.08, 1.0), Vector3(0.0, 1.28, 0.78), _material(Color(0.02, 0.05, 0.085), accent, 0.08))
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
	_make_velmora_box(parent, "RelicCloth", Vector3(4.9, 0.08, 1.0), Vector3(0.0, 1.28, 0.78), _material(Color(0.12, 0.075, 0.02), accent, 0.08))
	for x in [-1.7, 0.0, 1.7]:
		var relic: MeshInstance3D = MeshInstance3D.new()
		var mesh: CylinderMesh = CylinderMesh.new()
		mesh.top_radius = 0.24
		mesh.bottom_radius = 0.3
		mesh.height = 0.5
		mesh.radial_segments = 6
		relic.mesh = mesh
		relic.position = Vector3(x, 1.58, 0.9)
		relic.material_override = _material(Color(0.45, 0.34, 0.16), accent, 0.22)
		parent.add_child(relic)

func _make_velmora_roof_pair(parent: Node3D, width: float, depth: float, position: Vector3, material: Material) -> void:
	for x in [-width * 0.22, width * 0.22]:
		var roof: MeshInstance3D = MeshInstance3D.new()
		var mesh: BoxMesh = BoxMesh.new()
		mesh.size = Vector3(width * 0.58, 0.28, depth)
		roof.mesh = mesh
		roof.position = position + Vector3(x, 0.0, 0.0)
		roof.rotation_degrees.z = 23.0 * signf(x)
		roof.material_override = material
		parent.add_child(roof)

func _make_velmora_window(parent: Node3D, position: Vector3, size: Vector2, accent: Color) -> void:
	_make_velmora_box(parent, "WindowFrame", Vector3(size.x + 0.18, size.y + 0.18, 0.08), position + Vector3(0.0, 0.0, -0.02), _velmora_wood_material())
	_make_velmora_box(parent, "WindowGlow", Vector3(size.x, size.y, 0.09), position, _material(accent.darkened(0.35), accent, 1.25))
	_make_velmora_box(parent, "WindowMullionV", Vector3(0.055, size.y + 0.08, 0.1), position + Vector3(0.0, 0.0, 0.03), _velmora_wood_material())
	_make_velmora_box(parent, "WindowMullionH", Vector3(size.x + 0.08, 0.055, 0.1), position + Vector3(0.0, 0.0, 0.03), _velmora_wood_material())

func _make_diamond_icon(parent: Node3D, position: Vector3, scale_value: float, accent: Color) -> void:
	var gem: MeshInstance3D = MeshInstance3D.new()
	var mesh: BoxMesh = BoxMesh.new()
	mesh.size = Vector3(scale_value, scale_value, 0.08)
	gem.mesh = mesh
	gem.position = position
	gem.rotation_degrees.z = 45.0
	gem.material_override = _material(accent.darkened(0.2), accent, 2.0)
	parent.add_child(gem)
	var glint: MeshInstance3D = _make_decoration_bar(scale_value * 1.05, 0.035, _decoration_material(Color(0.76, 0.95, 1.0), accent, 1.8))
	glint.position = position + Vector3(0.0, 0.0, 0.055)
	glint.rotation_degrees.z = -45.0
	parent.add_child(glint)

func _make_colored_diamond_sprite(parent: Node3D, position: Vector3, pixel_size: float, sprite_scale: Vector3, tint: Color) -> void:
	if diamond_item_texture == null:
		return
	var sprite: Sprite3D = Sprite3D.new()
	sprite.name = "DiamondSprite"
	sprite.texture = diamond_item_texture
	sprite.pixel_size = pixel_size
	sprite.shaded = false
	sprite.double_sided = true
	sprite.billboard = BaseMaterial3D.BILLBOARD_FIXED_Y
	sprite.texture_filter = BaseMaterial3D.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS
	sprite.alpha_cut = SpriteBase3D.ALPHA_CUT_DISCARD
	sprite.position = position
	sprite.scale = sprite_scale
	sprite.modulate = tint
	parent.add_child(sprite)

func _make_torren_blackwell_npc() -> void:
	if velmora_root == null or torren_blackwell_root != null:
		return
	var root := Node3D.new()
	root.name = "TorrenBlackwell"
	root.position = Vector3(-7.0, 0.0, -5.5)
	root.rotation_degrees.y = 18.0
	root.visible = false
	velmora_root.add_child(root)
	torren_blackwell_root = root

	var accent := Color(0.95, 0.62, 0.24)
	var shadow: MeshInstance3D = MeshInstance3D.new()
	shadow.name = "TorrenShadow"
	var shadow_mesh: CylinderMesh = CylinderMesh.new()
	shadow_mesh.top_radius = 0.72
	shadow_mesh.bottom_radius = 0.72
	shadow_mesh.height = 0.012
	shadow_mesh.radial_segments = 28
	shadow.mesh = shadow_mesh
	shadow.position = Vector3(0.0, 0.025, 0.0)
	shadow.scale = Vector3(1.15, 1.0, 0.58)
	shadow.material_override = _portal_smoke_material(Color(0.0, 0.0, 0.0, 0.36), Color.BLACK, 0.0)
	shadow.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	root.add_child(shadow)

	var sprite_texture := torren_blackwell_front_texture if torren_blackwell_front_texture != null else vendor_front_texture
	if sprite_texture != null:
		var sprite := Sprite3D.new()
		sprite.name = "TorrenSprite"
		sprite.texture = sprite_texture
		sprite.pixel_size = 0.0048
		sprite.shaded = false
		sprite.double_sided = true
		sprite.billboard = BaseMaterial3D.BILLBOARD_FIXED_Y
		sprite.texture_filter = BaseMaterial3D.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS
		sprite.alpha_cut = SpriteBase3D.ALPHA_CUT_DISCARD
		var sprite_height_world := float(sprite_texture.get_height()) * sprite.pixel_size * absf(sprite.scale.y)
		sprite.position = Vector3(0.0, sprite_height_world * 0.5 + VENDOR_SPRITE_GROUND_CLEARANCE, 0.0)
		root.add_child(sprite)
		_register_directional_sprite(sprite, root, torren_blackwell_front_texture, torren_blackwell_side_texture, torren_blackwell_back_texture)
	else:
		_make_vendor_figure(root, Vector3.ZERO, accent)

	_make_velmora_label(root, "Torren Blackwell", Vector3(0.0, 2.82, 0.0), accent, 22)

	var area := Area3D.new()
	area.name = "TorrenBlackwellArea"
	area.body_entered.connect(_on_torren_blackwell_entered)
	area.body_exited.connect(_on_torren_blackwell_exited)
	root.add_child(area)
	torren_blackwell_area = area

	var shape_node := CollisionShape3D.new()
	var shape := SphereShape3D.new()
	shape.radius = 1.75
	shape_node.shape = shape
	shape_node.position.y = 1.0
	area.add_child(shape_node)

func _sync_torren_blackwell_visibility() -> void:
	if torren_blackwell_root == null:
		return
	var should_show := current_area == AREA_VELMORA and _is_torren_blackwell_available()
	torren_blackwell_root.visible = should_show
	if torren_blackwell_area != null:
		torren_blackwell_area.monitoring = should_show
		torren_blackwell_area.monitorable = should_show

func _is_torren_blackwell_available() -> bool:
	return _is_torren_blackwell_mission_active() or not _active_incomplete_mission_for_giver("Torren_Blackwell").is_empty()

func _is_torren_blackwell_mission_active() -> bool:
	return (
		_is_mission_active(AREA_VELMORA, "talk_to_Torren_Blackwell")
		or _is_mission_active(AREA_VELMORA, "talk_to_torren_after_clearing_forest")
	)

func _is_mission_active(area: String, mission_id: String) -> bool:
	if mission_system == null:
		return false
	for mission in mission_system.get_active_missions(area):
		if String(mission.get("id", "")) == mission_id:
			return true
	return false

func _make_velmora_street_dressing() -> void:
	for crate_data in [
		{"position": Vector3(-9.4, 0.0, 13.5), "yaw": 14.0},
		{"position": Vector3(9.6, 0.0, 8.5), "yaw": -18.0},
		{"position": Vector3(-10.2, 0.0, -8.0), "yaw": 32.0},
		{"position": Vector3(10.8, 0.0, -14.0), "yaw": -8.0}
	]:
		_make_velmora_crate(crate_data["position"], float(crate_data["yaw"]))
	for _index in range(16):
		_make_velmora_barrel(_random_velmora_decor_position())
	_make_velmora_banner(Vector3(-22.4, 2.5, 5.0), 90.0, Color(0.16, 0.04, 0.2), Color(0.78, 0.18, 1.0))
	_make_velmora_banner(Vector3(22.4, 2.7, -6.0), -90.0, Color(0.05, 0.11, 0.18), Color(0.12, 0.78, 1.0))
	_make_velmora_market_canopy(Vector3(-5.3, 0.0, -16.2), -8.0, Color(0.18, 0.035, 0.045), Color(0.95, 0.36, 0.12))
	_make_velmora_market_canopy(Vector3(6.4, 0.0, -17.2), 12.0, Color(0.06, 0.1, 0.13), Color(0.15, 0.8, 1.0))
	_make_velmora_greenery()
	_make_velmora_fences()

func _make_velmora_crate(position: Vector3, yaw_degrees: float) -> void:
	var root: Node3D = Node3D.new()
	root.name = "VelmoraCrate"
	root.position = position
	root.rotation_degrees.y = yaw_degrees
	velmora_root.add_child(root)
	_make_velmora_box(root, "Crate", Vector3(0.95, 0.78, 0.95), Vector3(0.0, 0.39, 0.0), _velmora_wood_material())
	_make_velmora_box(root, "CrateBandA", Vector3(1.05, 0.11, 0.08), Vector3(0.0, 0.28, 0.5), _material(Color(0.07, 0.052, 0.038), Color.BLACK, 0.0))
	_make_velmora_box(root, "CrateBandB", Vector3(1.05, 0.11, 0.08), Vector3(0.0, 0.56, 0.5), _material(Color(0.07, 0.052, 0.038), Color.BLACK, 0.0))

func _make_velmora_barrel(position: Vector3) -> void:
	if velmora_barrel_texture != null:
		var barrel_sprite := _make_velmora_billboard_sprite(velmora_barrel_texture, "VelmoraBarrel", 0.004, Vector3.ONE * rng.randf_range(0.22, 0.34), Color.WHITE)
		barrel_sprite.position = position + Vector3(0.0, 0.2, 0.0)
		barrel_sprite.rotation_degrees.y = rng.randf_range(0.0, 360.0)
		return
	var barrel: MeshInstance3D = MeshInstance3D.new()
	barrel.name = "VelmoraBarrel"
	var mesh: CylinderMesh = CylinderMesh.new()
	mesh.top_radius = 0.36
	mesh.bottom_radius = 0.42
	mesh.height = 0.92
	mesh.radial_segments = 14
	barrel.mesh = mesh
	barrel.position = position + Vector3(0.0, 0.46, 0.0)
	barrel.material_override = _velmora_wood_material()
	velmora_root.add_child(barrel)

func _make_velmora_banner(position: Vector3, yaw_degrees: float, cloth: Color, accent: Color) -> void:
	var root: Node3D = Node3D.new()
	root.name = "VelmoraBanner"
	root.position = position
	root.rotation_degrees.y = yaw_degrees
	velmora_root.add_child(root)
	_make_velmora_box(root, "BannerRod", Vector3(1.1, 0.06, 0.06), Vector3(0.0, 0.36, 0.0), _velmora_wood_material())
	_make_velmora_box(root, "BannerCloth", Vector3(0.92, 1.32, 0.06), Vector3(0.0, -0.33, 0.0), _material(cloth, accent, 0.08))
	_make_diamond_icon(root, Vector3(0.0, -0.18, 0.05), 0.28, accent)

func _make_velmora_banner_line(start: Vector3, end: Vector3, cloth: Color, accent: Color) -> void:
	var center := (start + end) * 0.5
	var delta := end - start
	var length := Vector2(delta.x, delta.z).length()
	var line: MeshInstance3D = _make_decoration_bar(length, 0.035, _decoration_material(Color(0.1, 0.07, 0.055), Color.BLACK, 0.0))
	line.position = center
	line.rotation_degrees.y = rad_to_deg(atan2(delta.z, delta.x))
	velmora_root.add_child(line)
	for i in range(7):
		var ratio := float(i) / 6.0
		var flag_position := start.lerp(end, ratio) + Vector3(0.0, -0.28 - float(i % 2) * 0.14, 0.0)
		var flag: MeshInstance3D = MeshInstance3D.new()
		var flag_mesh: BoxMesh = BoxMesh.new()
		flag_mesh.size = Vector3(0.62, 0.52, 0.035)
		flag.mesh = flag_mesh
		flag.position = flag_position
		flag.rotation_degrees.y = line.rotation_degrees.y
		flag.material_override = _material(cloth.lerp(accent, float(i % 3) * 0.12), accent, 0.06)
		velmora_root.add_child(flag)

func _make_velmora_market_canopy(position: Vector3, yaw_degrees: float, cloth: Color, accent: Color) -> void:
	var root: Node3D = Node3D.new()
	root.name = "MarketCanopy"
	root.position = position
	root.rotation_degrees.y = yaw_degrees
	velmora_root.add_child(root)
	_make_velmora_box(root, "CanopyTable", Vector3(3.8, 0.65, 1.25), Vector3(0.0, 0.33, 0.0), _velmora_wood_material())
	_make_velmora_box(root, "CanopyCloth", Vector3(4.3, 0.18, 2.0), Vector3(0.0, 2.08, -0.1), _material(cloth, accent, 0.1))
	for x in [-1.85, 1.85]:
		_make_velmora_box(root, "CanopyPost", Vector3(0.13, 2.1, 0.13), Vector3(x, 1.05, 0.65), _velmora_wood_material())
	for x in [-1.1, 0.0, 1.1]:
		_make_diamond_icon(root, Vector3(x, 0.86, 0.68), 0.24, accent)

func _populate_velmora_people(count: int) -> void:
	var outfit_accents := [
		Color(0.58, 0.22, 0.14),
		Color(0.12, 0.28, 0.52),
		Color(0.42, 0.35, 0.16),
		Color(0.2, 0.42, 0.26),
		Color(0.36, 0.2, 0.46)
	]
	for i in range(count):
		var citizen := Node3D.new()
		citizen.name = "VelmoraCitizen%s" % i
		citizen.position = _random_velmora_citizen_position()
		citizen.rotation_degrees.y = rng.randf_range(0.0, 360.0)
		velmora_root.add_child(citizen)
		var accent: Color = outfit_accents[rng.randi_range(0, outfit_accents.size() - 1)]
		_make_velmora_citizen_figure(citizen, accent)

func _random_velmora_citizen_position() -> Vector3:
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

func _make_velmora_citizen_figure(parent: Node3D, accent: Color) -> void:
	var skin := _material(Color(0.58, 0.44, 0.35), Color.BLACK, 0.0)
	var cloth := _material(accent.darkened(0.2), accent, 0.05)
	var cloth_dark := _material(accent.darkened(0.42), accent.darkened(0.2), 0.0)
	_make_velmora_box(parent, "CitizenBody", Vector3(0.46, 0.84, 0.32), Vector3(0.0, 0.92, 0.0), cloth)
	_make_velmora_box(parent, "CitizenHead", Vector3(0.28, 0.28, 0.28), Vector3(0.0, 1.52, 0.0), skin)
	for x in [-0.14, 0.14]:
		_make_velmora_box(parent, "CitizenLeg", Vector3(0.12, 0.7, 0.14), Vector3(x, 0.35, 0.0), cloth_dark)
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

func _make_velmora_greenery() -> void:
	if velmora_tree_textures.is_empty():
		for tree_data in [
			{"position": Vector3(-21.0, 0.0, 16.5), "scale": 1.0},
			{"position": Vector3(21.5, 0.0, 14.0), "scale": 1.08},
			{"position": Vector3(-20.5, 0.0, -14.8), "scale": 0.92},
			{"position": Vector3(20.8, 0.0, -17.0), "scale": 1.14},
			{"position": Vector3(-12.8, 0.0, 21.4), "scale": 0.88},
			{"position": Vector3(13.0, 0.0, 21.6), "scale": 0.9}
		]:
			_make_velmora_tree(tree_data["position"], float(tree_data["scale"]))
		return

	for _index in range(52):
		var tree_texture := velmora_tree_textures[rng.randi_range(0, velmora_tree_textures.size() - 1)]
		var tree_scale := rng.randf_range(0.9, 1.45)
		var tree_sprite := _make_velmora_billboard_sprite(tree_texture, "VelmoraTree", 0.0068, Vector3.ONE * tree_scale, Color.WHITE)
		tree_sprite.position = _random_velmora_tree_position(tree_scale) + Vector3(0.0, 1.95 * tree_scale, 0.0)
		tree_sprite.rotation_degrees.y = rng.randf_range(0.0, 360.0)

func _random_velmora_tree_position(tree_scale: float) -> Vector3:
	var position := Vector3.ZERO
	for _attempt in range(140):
		position = Vector3(
			rng.randf_range(-VELMORA_HALF_SIZE + 2.0, VELMORA_HALF_SIZE - 2.0),
			0.0,
			rng.randf_range(-VELMORA_HALF_SIZE + 2.0, VELMORA_HALF_SIZE - 2.0)
		)
		if _is_velmora_tree_position_clear(position, tree_scale):
			return position

	for fallback_position in [
		Vector3(-22.0, 0.0, 18.0),
		Vector3(22.0, 0.0, 17.0),
		Vector3(-22.0, 0.0, -18.5),
		Vector3(22.0, 0.0, -20.0),
		Vector3(-14.0, 0.0, 22.0),
		Vector3(14.0, 0.0, 22.0),
		Vector3(-22.0, 0.0, 0.0),
		Vector3(22.0, 0.0, -1.0)
	]:
		if _is_velmora_tree_position_clear(fallback_position, tree_scale):
			return fallback_position

	return Vector3(-22.0, 0.0, 22.0)

func _is_velmora_tree_position_clear(position: Vector3, tree_scale: float) -> bool:
	if absf(position.x) < 5.4:
		return false
	if position.distance_to(Vector3(0.0, 0.0, 20.0)) < 4.8 + VELMORA_TREE_SIGHT_CLEAR_RADIUS * tree_scale:
		return false
	if position.distance_to(Vector3(-14.0, 0.0, 2.5)) < 8.5 + VELMORA_TREE_SIGHT_CLEAR_RADIUS * tree_scale:
		return false
	if position.distance_to(Vector3(14.0, 0.0, 2.0)) < 8.5 + VELMORA_TREE_SIGHT_CLEAR_RADIUS * tree_scale:
		return false
	if position.distance_to(Vector3(0.0, 0.0, -13.5)) < 8.5 + VELMORA_TREE_SIGHT_CLEAR_RADIUS * tree_scale:
		return false
	return not _velmora_tree_intrudes_on_shop_sight(position, tree_scale)

func _velmora_tree_intrudes_on_shop_sight(position: Vector3, tree_scale: float) -> bool:
	var tree_footprint := VELMORA_TREE_SIGHT_CLEAR_RADIUS * tree_scale
	var tree_ground_position := Vector2(position.x, position.z)
	for clear_zone in _velmora_shop_tree_clear_zones():
		if clear_zone.grow(tree_footprint).has_point(tree_ground_position):
			return true
	return false

func _velmora_shop_tree_clear_zones() -> Array[Rect2]:
	return [
		Rect2(Vector2(-18.6, -4.3), Vector2(15.0, 13.2)),
		Rect2(Vector2(3.6, -4.3), Vector2(15.0, 13.2)),
		Rect2(Vector2(-8.3, -18.8), Vector2(16.6, 14.6))
	]

func _random_velmora_decor_position(street_half_width: float = 3.6) -> Vector3:
	var position := Vector3.ZERO
	for _attempt in range(35):
		position = Vector3(
			rng.randf_range(-VELMORA_HALF_SIZE + 2.0, VELMORA_HALF_SIZE - 2.0),
			0.0,
			rng.randf_range(-VELMORA_HALF_SIZE + 2.0, VELMORA_HALF_SIZE - 2.0)
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

func _make_velmora_billboard_sprite(texture: Texture2D, sprite_name: String, pixel_size: float, sprite_scale: Vector3, tint: Color) -> Sprite3D:
	var sprite: Sprite3D = Sprite3D.new()
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
	velmora_root.add_child(sprite)
	return sprite

func _make_velmora_tree(position: Vector3, scale_value: float) -> void:
	var root := Node3D.new()
	root.name = "VelmoraTree"
	root.position = position
	root.scale = Vector3.ONE * scale_value
	velmora_root.add_child(root)

	var trunk: MeshInstance3D = MeshInstance3D.new()
	var trunk_mesh: CylinderMesh = CylinderMesh.new()
	trunk_mesh.top_radius = 0.18
	trunk_mesh.bottom_radius = 0.24
	trunk_mesh.height = 2.4
	trunk.mesh = trunk_mesh
	trunk.position = Vector3(0.0, 1.2, 0.0)
	trunk.material_override = _velmora_wood_material()
	root.add_child(trunk)

	var leaf_material: StandardMaterial3D = _material(Color(0.1, 0.28, 0.15), Color(0.04, 0.09, 0.05), 0.06)
	for offset in [Vector3(0.0, 2.38, 0.0), Vector3(0.58, 2.22, 0.08), Vector3(-0.55, 2.16, -0.12), Vector3(0.0, 2.75, 0.35)]:
		var leaves: MeshInstance3D = MeshInstance3D.new()
		var leaves_mesh: SphereMesh = SphereMesh.new()
		leaves_mesh.radius = 0.72
		leaves_mesh.height = 1.1
		leaves.mesh = leaves_mesh
		leaves.position = offset
		leaves.material_override = leaf_material
		root.add_child(leaves)

func _make_velmora_fences() -> void:
	_make_velmora_fence_row(Vector3(-17.5, 0.0, 18.8), Vector3(-6.0, 0.0, 18.8), 8)
	_make_velmora_fence_row(Vector3(6.0, 0.0, 18.8), Vector3(17.5, 0.0, 18.8), 8)
	_make_velmora_fence_row(Vector3(-22.0, 0.0, -11.5), Vector3(-22.0, 0.0, 6.0), 9)
	_make_velmora_fence_row(Vector3(22.0, 0.0, -10.0), Vector3(22.0, 0.0, 7.5), 9)

func _make_velmora_fence_row(start: Vector3, end: Vector3, segments: int) -> void:
	var fence_material := _velmora_wood_material()
	var rail_height := [0.55, 0.9]
	for i in range(segments + 1):
		var t := float(i) / float(maxi(segments, 1))
		var post_position := start.lerp(end, t)
		_make_velmora_box(velmora_root, "FencePost", Vector3(0.11, 1.05, 0.11), post_position + Vector3(0.0, 0.52, 0.0), fence_material)
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
			velmora_root.add_child(rail)

func _make_velmora_puddle(parent: Node3D, position: Vector3) -> void:
	var puddle: MeshInstance3D = MeshInstance3D.new()
	puddle.name = "VelmoraPuddle"
	var mesh: CylinderMesh = CylinderMesh.new()
	mesh.top_radius = 0.7
	mesh.bottom_radius = 0.7
	mesh.height = 0.01
	mesh.radial_segments = 28
	puddle.mesh = mesh
	puddle.position = position
	puddle.scale = Vector3(1.45, 1.0, 0.55)
	puddle.material_override = _portal_smoke_material(Color(0.04, 0.07, 0.085, 0.42), Color(0.02, 0.08, 0.11), 0.16)
	parent.add_child(puddle)

func _make_velmora_box(parent: Node3D, name: String, size: Vector3, position: Vector3, material: Material, rotation_degrees_value: Vector3 = Vector3.ZERO) -> MeshInstance3D:
	var box: MeshInstance3D = MeshInstance3D.new()
	box.name = name
	var mesh: BoxMesh = BoxMesh.new()
	mesh.size = size
	box.mesh = mesh
	box.position = position
	box.rotation_degrees = rotation_degrees_value
	box.material_override = material
	parent.add_child(box)
	return box

func _make_spell_shop_model(parent: Node3D, accent: Color) -> void:
	var shadow: MeshInstance3D = MeshInstance3D.new()
	shadow.name = "SpellShopModelShadow"
	var shadow_mesh: CylinderMesh = CylinderMesh.new()
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

	var model: Node3D = spell_shop_scene.instantiate() as Node3D
	if model == null:
		return
	model.name = "SpellShopModel"
	model.position = Vector3(0.0, 0.02, 0.72)
	model.rotation_degrees.y = 180.0
	model.scale = Vector3.ONE * 1.45
	parent.add_child(model)
	_prepare_spell_shop_model_materials(model, accent)

	var light: OmniLight3D = OmniLight3D.new()
	light.name = "SpellShopModelLight"
	light.position = Vector3(0.0, 2.0, 1.15)
	light.light_color = accent
	light.light_energy = 1.55
	light.omni_range = 5.8
	parent.add_child(light)

func _prepare_spell_shop_model_materials(node: Node, accent: Color) -> void:
	var mesh_instance: MeshInstance3D = node as MeshInstance3D
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
	var shadow: MeshInstance3D = MeshInstance3D.new()
	shadow.name = "SpellShopShadow"
	var shadow_mesh: CylinderMesh = CylinderMesh.new()
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

	var sprite: Sprite3D = Sprite3D.new()
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
	var vendor_texture: Texture2D = _velmora_vendor_texture_for(vendor_id)
	if vendor_texture != null:
		var shadow: MeshInstance3D = MeshInstance3D.new()
		shadow.name = "VendorShadow"
		var shadow_mesh: CylinderMesh = CylinderMesh.new()
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

		var sprite: Sprite3D = Sprite3D.new()
		sprite.name = "VendorSprite"
		sprite.texture = vendor_texture
		sprite.pixel_size = 0.0048
		sprite.shaded = false
		sprite.double_sided = true
		sprite.billboard = BaseMaterial3D.BILLBOARD_FIXED_Y
		sprite.texture_filter = BaseMaterial3D.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS
		sprite.alpha_cut = SpriteBase3D.ALPHA_CUT_DISCARD
		sprite.scale = Vector3.ONE
		var sprite_height_world: float = float(vendor_texture.get_height()) * sprite.pixel_size * absf(sprite.scale.y)
		sprite.position = position + Vector3(0.0, sprite_height_world * 0.5 + VENDOR_SPRITE_GROUND_CLEARANCE, 0.0)
		sprite.modulate = Color(1.0, 1.0, 1.0, 1.0)
		parent.add_child(sprite)
		if vendor_texture == vendor_front_texture and vendor_side_texture != null and vendor_back_texture != null:
			_register_directional_sprite(sprite, parent, vendor_front_texture, vendor_side_texture, vendor_back_texture)
		return

	var body: MeshInstance3D = MeshInstance3D.new()
	var body_mesh: CylinderMesh = CylinderMesh.new()
	body_mesh.top_radius = 0.34
	body_mesh.bottom_radius = 0.44
	body_mesh.height = 1.15
	body.mesh = body_mesh
	body.position = position
	body.material_override = _material(Color(0.12, 0.09, 0.08), accent, 0.16)
	parent.add_child(body)

	var head: MeshInstance3D = MeshInstance3D.new()
	var head_mesh: SphereMesh = SphereMesh.new()
	head_mesh.radius = 0.28
	head_mesh.height = 0.36
	head_mesh.radial_segments = 18
	head_mesh.rings = 8
	head.mesh = head_mesh
	head.position = position + Vector3(0.0, 0.78, 0.0)
	head.material_override = _material(Color(0.62, 0.48, 0.34), Color.BLACK, 0.0)
	parent.add_child(head)

func _velmora_vendor_texture_for(vendor_id: String) -> Texture2D:
	match vendor_id:
		"diamond_vendor":
			if velmora_vendor_woman_texture != null:
				return velmora_vendor_woman_texture
		"spell_vendor":
			if velmora_vendor_warlock_texture != null:
				return velmora_vendor_warlock_texture
		"relic_vendor":
			if velmora_vendor_man_texture != null:
				return velmora_vendor_man_texture
	if vendor_front_texture != null:
		return vendor_front_texture
	return null

func _register_directional_sprite(sprite: Sprite3D, parent: Node3D, front_texture: Texture2D, side_texture: Texture2D, back_texture: Texture2D) -> void:
	if sprite == null or parent == null or front_texture == null or side_texture == null or back_texture == null:
		return
	vendor_sprites.append({
		"sprite": sprite,
		"parent": parent,
		"front_texture": front_texture,
		"side_texture": side_texture,
		"back_texture": back_texture
	})

func _update_vendor_sprites() -> void:
	if camera == null or vendor_sprites.is_empty():
		return
	for vendor_data in vendor_sprites:
		var sprite: Sprite3D = vendor_data["sprite"] as Sprite3D
		var parent: Node3D = vendor_data["parent"] as Node3D
		if sprite == null or parent == null or not is_instance_valid(sprite) or not is_instance_valid(parent):
			continue
		var front_texture := vendor_data.get("front_texture") as Texture2D
		var side_texture := vendor_data.get("side_texture") as Texture2D
		var back_texture := vendor_data.get("back_texture") as Texture2D
		if front_texture == null or side_texture == null or back_texture == null:
			continue
		var local_camera := parent.to_local(camera.global_position)
		local_camera.y = 0.0
		if local_camera.length_squared() <= 0.001:
			continue
		if local_camera.z >= absf(local_camera.x) * 0.72:
			sprite.texture = front_texture
			sprite.flip_h = false
		elif local_camera.z <= -absf(local_camera.x) * 0.72:
			sprite.texture = back_texture
			sprite.flip_h = false
		else:
			sprite.texture = side_texture
			sprite.flip_h = local_camera.x < 0.0

func _make_velmora_label(parent: Node3D, text: String, position: Vector3, color: Color, font_size: int = 34) -> void:
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
	var wisp: MeshInstance3D = MeshInstance3D.new()
	wisp.name = "PortalSmokeWisp"
	var mesh: SphereMesh = SphereMesh.new()
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
	var spark: MeshInstance3D = MeshInstance3D.new()
	spark.name = "PortalSpark"
	var mesh: SphereMesh = SphereMesh.new()
	mesh.radius = 0.08
	mesh.height = 0.12
	mesh.radial_segments = 8
	mesh.rings = 4
	spark.mesh = mesh
	var ember_tint := Color(1.0, 0.38 + float(index % 3) * 0.14, 0.08, 0.92)
	spark.material_override = _portal_material(ember_tint, Color(1.0, 0.32, 0.04), 2.6)
	return spark

func _make_portal_soul(index: int) -> MeshInstance3D:
	var soul: MeshInstance3D = MeshInstance3D.new()
	soul.name = "PortalSoul"
	var mesh: SphereMesh = SphereMesh.new()
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
	current_area = AREA_BLACK_VAULT
	_set_mission_area(AREA_BLACK_VAULT)
	_set_background_music(BLACK_VAULT_MUSIC)
	if player != null:
		player.set_attacks_enabled(true)
	if hud != null:
		hud.set_minimap_visible(true)
	if black_vault_encounter_spawned:
		return
	black_vault_encounter_spawned = true
	var spawn_points: Array[Vector3] = _enemy_spawn_points()
	for i in range(spawn_points.size()):
		var enemy_kind := SISEnemy.ENEMY_KIND_ANGEL
		if i % 2 == 1:
			enemy_kind = SISEnemy.ENEMY_KIND_KNIGHT
		_spawn_enemy_at(spawn_points[i], i >= spawn_points.size() - 3, enemy_kind)
	_spawn_enemy_at(Vector3(-4.2, 0.1, -27.5), false, SISEnemy.ENEMY_KIND_CLERIC)
	_spawn_enemy_at(Vector3(4.2, 0.1, -27.5), false, SISEnemy.ENEMY_KIND_CLERIC)

func _spawn_enemy_at(spawn_position: Vector3, elite: bool = false, enemy_kind: StringName = SISEnemy.ENEMY_KIND_ANGEL) -> void:
	var enemy: SISEnemy = SISEnemy.new()
	enemy.position = spawn_position
	enemy.enemy_kind = enemy_kind
	add_child(enemy)
	enemy.configure(player, player.level, elite, enemy_kind)
	enemy.killed.connect(_on_enemy_killed)
	enemies.append(enemy)

func _spawn_chests() -> void:
	if black_vault_chests_spawned:
		return
	black_vault_chests_spawned = true
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

func _spawn_hoofgrove_chests() -> void:
	if hoofgrove_chests_spawned or hoofgrove_root == null or player == null:
		return
	hoofgrove_chests_spawned = true
	var local_positions: Array[Vector3] = []
	for _i in range(HOOFGROVE_CHEST_COUNT):
		local_positions.append(_random_hoofgrove_chest_position(local_positions))
	for local_position in local_positions:
		var chest: SISChest = ChestScript.new() as SISChest
		chest.position = local_position + Vector3(0.0, 0.1, 0.0)
		chest.rotation.y = rng.randf_range(0.0, TAU)
		hoofgrove_root.add_child(chest)
		chest.configure(player)
		chest.opened.connect(_on_chest_opened)
		_make_hoofgrove_chest_glint(local_position)

func _random_hoofgrove_chest_position(existing_positions: Array[Vector3]) -> Vector3:
	for _attempt in range(120):
		var position := Vector3(
			rng.randf_range(-HOOFGROVE_HALF_SIZE + 7.0, HOOFGROVE_HALF_SIZE - 7.0),
			0.0,
			rng.randf_range(-HOOFGROVE_HALF_SIZE + 7.0, HOOFGROVE_HALF_SIZE - 7.0)
		)
		if position.distance_to(HOOFGROVE_SPAWN_POSITION - HOOFGROVE_ORIGIN) < 12.0:
			continue
		if absf(position.x) < 5.0 and position.z > -12.0 and position.z < 39.0:
			continue
		var too_close := false
		for existing in existing_positions:
			if position.distance_to(existing) < 9.0:
				too_close = true
				break
		if too_close:
			continue
		return position
	return _random_hoofgrove_ground_position()

func _make_hoofgrove_chest_glint(local_position: Vector3) -> void:
	if hoofgrove_root == null:
		return
	var glint := OmniLight3D.new()
	glint.name = "HoofgroveChestGlint"
	glint.position = local_position + Vector3(0.0, 0.85, 0.0)
	glint.light_color = Color(1.0, 0.72, 0.34)
	glint.light_energy = 0.45
	glint.omni_range = 2.4
	hoofgrove_root.add_child(glint)

func _spawn_scroll_for_game_level(scroll_level: int) -> void:
	if scroll_level < 1 or scroll_level > scroll_entries.size():
		return
	if spawned_scroll_game_levels.has(scroll_level):
		return
	var scroll := ScrollScript.new()
	scroll.scroll_level = scroll_level
	scroll.position = _scroll_spawn_position_for_level(scroll_level)
	scroll.rotation.y = rng.randf_range(0.0, TAU)
	_scroll_parent_for_level(scroll_level).add_child(scroll)
	scroll.read_requested.connect(_on_scroll_read_requested)
	active_scroll = scroll
	spawned_scroll_game_levels.append(scroll_level)

func _scroll_parent_for_level(scroll_level: int) -> Node:
	if scroll_level == SCROLL_LEVEL_HOOFGROVE_WILDS and hoofgrove_root != null:
		return hoofgrove_root
	return self

func _scroll_spawn_position_for_level(scroll_level: int) -> Vector3:
	match scroll_level:
		SCROLL_LEVEL_HOOFGROVE_WILDS:
			return _random_hoofgrove_scroll_position()
		_:
			return _random_scroll_position()

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

func _random_hoofgrove_scroll_position() -> Vector3:
	var anchors := _hoofgrove_scroll_spawn_anchors()
	var best_position := anchors[rng.randi_range(0, anchors.size() - 1)]
	for attempt in range(18):
		var local_anchor: Vector3 = anchors[rng.randi_range(0, anchors.size() - 1)]
		var local_position := local_anchor + Vector3(rng.randf_range(-4.0, 4.0), 0.0, rng.randf_range(-4.0, 4.0))
		local_position.x = clampf(local_position.x, -HOOFGROVE_HALF_SIZE + 5.0, HOOFGROVE_HALF_SIZE - 5.0)
		local_position.z = clampf(local_position.z, -HOOFGROVE_HALF_SIZE + 5.0, HOOFGROVE_HALF_SIZE - 5.0)
		var world_position := HOOFGROVE_ORIGIN + local_position
		if player != null and world_position.distance_to(player.global_position) < 9.0:
			continue
		best_position = local_position
		break
	best_position.y = 0.12
	return best_position

func _hoofgrove_scroll_spawn_anchors() -> Array[Vector3]:
	return [
		Vector3(-34.0, 0.1, 16.0),
		Vector3(34.0, 0.1, 12.0),
		Vector3(-30.0, 0.1, -18.0),
		Vector3(30.0, 0.1, -20.0),
		Vector3(-13.0, 0.1, -35.0),
		Vector3(13.0, 0.1, -35.0)
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

func _on_attack_spell_requested(target_position: Vector3) -> void:
	if current_area == AREA_VELMORA:
		return
	match player.get_active_attack_spell_id():
		"icesmash":
			_cast_icesmash(target_position)
		"electricity_vortex":
			_cast_electricity_vortex(target_position)
		_:
			_cast_firestorm(target_position)

func _cast_firestorm(target_position: Vector3) -> void:
	_play_sound(FIRE_STORM_SOUND, -2.0)
	_play_firestorm_impact_sequence()
	var storm: SISFireStorm = FireStormScript.new() as SISFireStorm
	add_child(storm)
	storm.configure(target_position, enemies, player.level)
	storm.radius += player.get_skill_radius_bonus()
	storm.radius += player.get_socket_attack_radius_bonus()
	if player.has_spell("wide_flame"):
		storm.radius += 1.35
		storm.strikes += 4
	storm.radius *= player.get_socket_spell_effect_multiplier(player.get_active_attack_spell_id())
	storm.impact_radius += minf(storm.radius * 0.055, 0.45)
	storm.damage = player.get_active_attack_spell_damage()
	storm.enemy_hit.connect(_on_firestorm_enemy_hit)
	_say_whisper("Yes. Let the ceiling learn to burn.")

func _cast_icesmash(target_position: Vector3) -> void:
	_play_sound(ICE_SMASH_SOUND, 3.5)
	var smash := IceSmashScript.new()
	smash.configure(target_position, enemies, player.level)
	smash.radius += player.get_skill_radius_bonus()
	smash.radius += player.get_socket_attack_radius_bonus()
	smash.radius *= player.get_socket_spell_effect_multiplier(player.get_active_attack_spell_id())
	smash.damage = player.get_active_attack_spell_damage()
	add_child(smash)
	smash.enemy_hit.connect(_on_firestorm_enemy_hit)
	smash.impact_landed.connect(_on_icesmash_impact_landed)
	_say_whisper("Good. Make the sky remember winter.")

func _on_icesmash_impact_landed(impact_position: Vector3, impact_radius: float) -> void:
	_shake_camera(ICE_SMASH_CAMERA_SHAKE_INTENSITY + impact_radius * 0.012, ICE_SMASH_CAMERA_SHAKE_DURATION)
	for enemy in enemies:
		if not is_instance_valid(enemy):
			continue
		if enemy.global_position.distance_to(impact_position) <= impact_radius * 1.08 and enemy.has_method("apply_chill"):
			enemy.call("apply_chill", 2.4, 0.42)

func _cast_electricity_vortex(target_position: Vector3) -> void:
	var vortex := LightningVortexScript.new()
	vortex.configure(target_position, Vector3.ZERO, 0.0, player.get_active_attack_spell_damage(), false, enemies)
	add_child(vortex)
	vortex.enemy_hit.connect(_on_firestorm_enemy_hit)
	_say_whisper("Let their bones learn the shape of lightning.")

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
	var enemy_kind: StringName = enemy.get("enemy_kind")
	if enemy_kind == SISEnemy.ENEMY_KIND_ANGEL:
		_play_sound(ANGEL_DEAD_SOUND, -1.5)
	if current_area == AREA_HOOFGROVE_WILDS and enemy_kind == SISEnemy.ENEMY_KIND_CENTAUR:
		hoofgrove_centaurs_remaining = maxi(0, hoofgrove_centaurs_remaining - 1)
	if current_area == AREA_HOOFGROVE_WILDS and _is_hoofgrove_mission_enemy(enemy_kind):
		hoofgrove_hostiles_remaining = maxi(0, hoofgrove_hostiles_remaining - 1)
	kills += 1
	var first_kill := kills == 1
	if first_kill:
		hud.set_whispers_enabled(true)
	enemies.erase(enemy)
	var xp_reward: int = int(enemy.get("xp_reward"))
	var leveled_up := player.gain_xp(xp_reward)
	player.notify_kill()
	var kill_streak := 1
	if whisper_system != null:
		whisper_system.record_kill(kills, player)
		kill_streak = int(whisper_system.kill_streak)
	if hud != null:
		hud.notify_kill_feedback(kill_streak)
	var loot_drops := LootTableScript.roll_enemy_loot(rng, player, enemy, FADED_DIAMOND_CATALOG, RELIC_CATALOG, SPELL_CATALOG)
	_spawn_loot_drops(enemy.global_position, loot_drops)
	var opened_exit := false
	if current_area == AREA_BLACK_VAULT and kills >= STAGE_ENEMY_COUNT and not exit_open:
		exit_open = true
		opened_exit = true
		exit_light.light_color = Color(0.15, 0.85, 1.0)
		exit_light.light_energy = 3.4
		if exit_sprite != null:
			exit_sprite.modulate = Color(0.82, 1.12, 1.25, 1.0)
	if mission_system != null:
		mission_system.complete_matching(current_area, "kill", {
			"kills": kills,
			"required": STAGE_ENEMY_COUNT,
			"area": current_area,
			"enemy_kind": String(enemy_kind),
			"remaining": hoofgrove_hostiles_remaining if current_area == AREA_HOOFGROVE_WILDS else 1
		})
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

func _is_hoofgrove_mission_enemy(enemy_kind: StringName) -> bool:
	return enemy_kind == SISEnemy.ENEMY_KIND_CENTAUR \
		or enemy_kind == SISEnemy.ENEMY_KIND_HUMAN_WARRIOR \
		or enemy_kind == SISEnemy.ENEMY_KIND_CLERIC \
		or enemy_kind == SISEnemy.ENEMY_KIND_GIANT

func _maybe_say_after_kill_whisper() -> void:
	if rng.randf() <= AFTER_KILL_WHISPER_CHANCE:
		_say_random_whisper(after_killing_whispers)

func _on_chest_opened(chest: Node3D) -> void:
	_play_sound(TREASURE_CHEST_SOUND, -1.0)
	var chest_gold := rng.randi_range(28, 58)
	if player != null:
		var loot_luck := player.get_socket_loot_luck_bonus()
		if loot_luck > 0.0 and rng.randf() < loot_luck:
			chest_gold += rng.randi_range(12, 24)
	_spawn_gold(chest.global_position + Vector3(0.0, 0.4, 0.0), chest_gold)
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

func _spawn_loot_drops(position: Vector3, drops: Array[Dictionary]) -> void:
	for drop in drops:
		var drop_type := String(drop.get("type", ""))
		if drop_type == LootTableScript.TYPE_GOLD:
			_spawn_gold(position, int(drop.get("amount", 1)))
		else:
			_spawn_loot_item(position, drop)

func _spawn_loot_item(position: Vector3, drop: Dictionary) -> void:
	var pickup := LootDropScript.new()
	pickup.configure(drop)
	pickup.position = position + Vector3(rng.randf_range(-0.75, 0.75), 0.7, rng.randf_range(-0.75, 0.75))
	add_child(pickup)
	pickup.picked_up.connect(_on_loot_item_picked_up)

func _on_gold_picked_up(amount: int) -> void:
	_play_sound(TREASURE_CHEST_SOUND, -5.0)
	var multiplier := 1.0
	if player != null:
		multiplier = player.get_gold_gain_multiplier()
	var payout := maxi(1, int(round(float(amount) * multiplier)))
	player.add_gold(payout)

func _on_loot_item_picked_up(drop: Dictionary) -> void:
	_play_sound(TREASURE_CHEST_SOUND, -4.5)
	if player == null:
		return
	var drop_type := String(drop.get("type", ""))
	var item_id := String(drop.get("id", ""))
	var display_name := String(drop.get("display_name", item_id.replace("_", " ").capitalize()))
	match drop_type:
		LootTableScript.TYPE_DIAMOND:
			if item_id.is_empty():
				return
			owned_faded_diamonds[item_id] = int(owned_faded_diamonds.get(item_id, 0)) + 1
			_apply_socketed_diamond_bonuses()
			if hud != null:
				hud.update_stats(_stats_for_hud(player.get_stats()))
			_say_whisper("Diamond claimed. %s." % display_name)
		LootTableScript.TYPE_RELIC:
			if _add_relic(item_id):
				_say_whisper("Relic gained. %s." % _relic_display_name(item_id))
		LootTableScript.TYPE_SPELL:
			if _learn_spell_reward(item_id):
				_say_whisper("Spell learned. %s." % _spell_display_name(item_id))
			else:
				player.add_gold(120)
				_say_whisper("%s was already etched into you. It became gold." % display_name)

func _on_player_stats_changed(stats: Dictionary) -> void:
	if hud != null:
		hud.update_stats(_stats_for_hud(stats))
		if whisper_system != null:
			hud.set_corruption_ui(float(whisper_system.corruption), _current_hp_percent())

func _stats_for_hud(base_stats: Dictionary) -> Dictionary:
	var payload := base_stats.duplicate(true)
	_ensure_faded_socket_size()
	payload["faded_owned"] = owned_faded_diamonds.duplicate(true)
	payload["faded_sockets"] = socketed_faded_diamonds.duplicate()
	payload["faded_catalog"] = _faded_catalog_for_hud()
	payload["faded_bonus_summary"] = _socketed_diamond_bonus_summary()
	payload["relic_owned"] = owned_relics.duplicate(true)
	payload["relic_catalog"] = _relic_catalog_for_hud()
	payload["unlocked_maps"] = unlocked_maps.duplicate()
	payload["current_area"] = current_area
	return payload

func _faded_catalog_for_hud() -> Array[Dictionary]:
	var list: Array[Dictionary] = []
	for tier in LootTableScript.DIAMOND_TIERS:
		var tier_id := String(tier["id"])
		var tier_name := String(tier["name"])
		for diamond in FADED_DIAMOND_CATALOG:
			var base_id := _diamond_base_id(String(diamond["id"]))
			var diamond_id := "%s_%s" % [tier_id, base_id]
			var base_name := String(diamond["name"]).replace("Faded ", "")
			list.append({
				"id": diamond_id,
				"icon": String(diamond["icon"]),
				"name": "%s %s" % [tier_name, base_name],
				"bonus": _diamond_bonus_text(diamond_id),
				"color": diamond["color"]
			})
	return list

func _relic_catalog_for_hud() -> Array[Dictionary]:
	var list: Array[Dictionary] = []
	for relic in RELIC_CATALOG:
		list.append({
			"id": String(relic["id"]),
			"name": String(relic["name"]),
			"description": String(relic["description"]),
			"image": String(relic["image"])
		})
	return list

func _add_relic(relic_id: String) -> bool:
	var clean_id := relic_id.strip_edges()
	if clean_id.is_empty():
		return false
	owned_relics[clean_id] = int(owned_relics.get(clean_id, 0)) + 1
	if hud != null and player != null:
		hud.update_stats(_stats_for_hud(player.get_stats()))
	return true

func _has_relic(relic_id: String) -> bool:
	return int(owned_relics.get(relic_id, 0)) > 0

func _add_map(map_id: String) -> bool:
	var clean_id := map_id.strip_edges()
	if clean_id.is_empty() or unlocked_maps.has(clean_id):
		return false
	unlocked_maps.append(clean_id)
	if hud != null and player != null:
		hud.update_stats(_stats_for_hud(player.get_stats()))
	return true

func _add_diamond_reward(diamond_id: String) -> bool:
	var clean_id := diamond_id.strip_edges()
	if clean_id.is_empty():
		return false
	owned_faded_diamonds[clean_id] = int(owned_faded_diamonds.get(clean_id, 0)) + 1
	_apply_socketed_diamond_bonuses()
	if hud != null and player != null:
		hud.update_stats(_stats_for_hud(player.get_stats()))
	return true

func _learn_spell_reward(spell_id: String) -> bool:
	if player == null:
		return false
	var clean_id := spell_id.strip_edges()
	if clean_id.is_empty():
		return false
	var learned := player.learn_spell(clean_id)
	if learned and hud != null:
		hud.update_stats(_stats_for_hud(player.get_stats()))
	return learned

func _map_display_name(map_id: String) -> String:
	var clean_id := map_id.get_file().get_basename().replace("-", " ").replace("_", " ")
	return _mission_title_case(clean_id)

func _mission_title_case(text: String) -> String:
	var result := ""
	var at_word_start := true
	for i in range(text.length()):
		var character := text.substr(i, 1)
		var is_letter := character.to_lower() != character.to_upper()
		var is_digit := character >= "0" and character <= "9"
		if is_letter:
			if at_word_start:
				result += character.to_upper()
			else:
				result += character.to_lower()
			at_word_start = false
		else:
			result += character
			if not is_digit:
				at_word_start = true
	return result

func _relic_display_name(relic_id: String) -> String:
	for relic in RELIC_CATALOG:
		if String(relic["id"]) == relic_id:
			return String(relic["name"])
	return relic_id.replace("_", " ").capitalize()

func _spell_display_name(spell_id: String) -> String:
	for spell in SPELL_CATALOG:
		if String(spell["id"]) == spell_id:
			return String(spell["name"])
	return spell_id.replace("_", " ").capitalize()

func _diamond_display_name(diamond_id: String) -> String:
	var clean_id := diamond_id.strip_edges()
	for tier in LootTableScript.DIAMOND_TIERS:
		var tier_id := String(tier["id"])
		var base_id := clean_id
		if clean_id.begins_with("%s_" % tier_id):
			base_id = clean_id.substr(("%s_" % tier_id).length())
		for diamond in FADED_DIAMOND_CATALOG:
			var source_id := String(diamond["id"])
			var source_base_id := source_id
			if source_id.begins_with("faded_"):
				source_base_id = source_id.substr("faded_".length())
			if base_id == source_base_id:
				return "%s %s" % [String(tier["name"]), String(diamond["name"]).replace("Faded ", "")]
	return clean_id.replace("_", " ").capitalize()

func _ensure_faded_socket_size() -> void:
	while socketed_faded_diamonds.size() < GLOVE_SOCKET_COUNT:
		socketed_faded_diamonds.append("")
	if socketed_faded_diamonds.size() > GLOVE_SOCKET_COUNT:
		socketed_faded_diamonds.resize(GLOVE_SOCKET_COUNT)

func _socketed_count(diamond_id: String) -> int:
	var count := 0
	for socket_id in socketed_faded_diamonds:
		if socket_id == diamond_id:
			count += 1
	return count

func _available_faded_diamond_count(diamond_id: String) -> int:
	var owned := int(owned_faded_diamonds.get(diamond_id, 0))
	return maxi(0, owned - _socketed_count(diamond_id))

func _diamond_catalog_entry(diamond_id: String) -> Dictionary:
	var tier_id := _diamond_tier_id(diamond_id)
	var base_id := _diamond_base_id(diamond_id)
	for diamond in FADED_DIAMOND_CATALOG:
		if _diamond_base_id(String(diamond["id"])) == base_id:
			var entry: Dictionary = diamond.duplicate(true)
			entry["id"] = "%s_%s" % [tier_id, base_id]
			entry["name"] = "%s %s" % [_diamond_tier_name(tier_id), String(diamond["name"]).replace("Faded ", "")]
			return entry
	return {}

func _diamond_socket_bonus(diamond_id: String) -> Dictionary:
	var multiplier := _diamond_tier_bonus_multiplier(_diamond_tier_id(diamond_id))
	var base_id := "%s_%s" % [LootTableScript.TIER_FADED, _diamond_base_id(diamond_id)]
	var bonus := {}
	match base_id:
		"faded_rush":
			bonus = {"move_speed": 0.1}
		"faded_focus":
			bonus = {"attack_radius": 0.6}
		"faded_vitality":
			bonus = {"healing_rate": 0.2}
		"faded_fortune":
			bonus = {"gold": 0.12, "loot_luck": 0.12}
		"faded_corruption":
			bonus = {"beyond_effect": 0.1}
		"faded_echo":
			bonus = {"attack_effect": 0.08}
		"faded_void":
			bonus = {"summon_slots": 1.0}
		"faded_fury":
			bonus = {"attack_damage": 0.1}
		"faded_guardian":
			bonus = {"defense_effect": 0.1}
		"faded_flame_ring":
			bonus = {"flame_effect": 0.1}
		"faded_frostbind":
			bonus = {"ice_effect": 0.1}
		"faded_storm":
			bonus = {"electricity_effect": 0.1}
	return _scale_diamond_bonus(bonus, multiplier)

func _diamond_tier_id(diamond_id: String) -> String:
	var clean_id := diamond_id.strip_edges().to_lower()
	for tier in LootTableScript.DIAMOND_TIERS:
		var tier_id := String(tier["id"])
		if clean_id.begins_with("%s_" % tier_id):
			return tier_id
	return LootTableScript.TIER_FADED

func _diamond_base_id(diamond_id: String) -> String:
	var clean_id := diamond_id.strip_edges().to_lower()
	for tier in LootTableScript.DIAMOND_TIERS:
		var prefix := "%s_" % String(tier["id"])
		if clean_id.begins_with(prefix):
			return clean_id.substr(prefix.length())
	return clean_id

func _diamond_tier_name(tier_id: String) -> String:
	for tier in LootTableScript.DIAMOND_TIERS:
		if String(tier["id"]) == tier_id:
			return String(tier["name"])
	return "Faded"

func _diamond_tier_bonus_multiplier(tier_id: String) -> float:
	match tier_id:
		LootTableScript.TIER_WHISPERING:
			return 1.45
		LootTableScript.TIER_CORRUPTED:
			return 2.05
		LootTableScript.TIER_ABYSSAL:
			return 3.1
		LootTableScript.TIER_DIVINE:
			return 4.8
		_:
			return 1.0

func _scale_diamond_bonus(bonus: Dictionary, multiplier: float) -> Dictionary:
	if bonus.is_empty() or is_equal_approx(multiplier, 1.0):
		return bonus
	var scaled := {}
	for key in bonus:
		scaled[key] = float(bonus[key]) * multiplier
	return scaled

func _diamond_bonus_text(diamond_id: String) -> String:
	var lines := _diamond_bonus_lines(_diamond_socket_bonus(diamond_id))
	if lines.is_empty():
		return "No active socket bonus."
	return "Socket bonus: %s." % ", ".join(lines)

func _diamond_bonus_lines(bonus: Dictionary) -> Array[String]:
	var lines: Array[String] = []
	var damage_bonus := float(bonus.get("damage_bonus", bonus.get("damage", 0.0)))
	var attack_damage_bonus := float(bonus.get("attack_damage_bonus", bonus.get("attack_damage", 0.0)))
	var move_speed_bonus := float(bonus.get("move_speed_bonus", bonus.get("move_speed", 0.0)))
	var cooldown_reduction := float(bonus.get("cooldown_reduction", bonus.get("cooldown", 0.0)))
	var gold_gain_bonus := float(bonus.get("gold_gain_bonus", bonus.get("gold", 0.0)))
	var attack_radius_bonus := float(bonus.get("attack_radius_bonus", bonus.get("attack_radius", 0.0)))
	var healing_rate_bonus := float(bonus.get("healing_rate_bonus", bonus.get("healing_rate", 0.0)))
	var loot_luck_bonus := float(bonus.get("loot_luck_bonus", bonus.get("loot_luck", 0.0)))
	var attack_effect_bonus := float(bonus.get("attack_effect_bonus", bonus.get("attack_effect", 0.0)))
	var beyond_effect_bonus := float(bonus.get("beyond_effect_bonus", bonus.get("beyond_effect", 0.0)))
	var defense_effect_bonus := float(bonus.get("defense_effect_bonus", bonus.get("defense_effect", 0.0)))
	var flame_effect_bonus := float(bonus.get("flame_effect_bonus", bonus.get("flame_effect", 0.0)))
	var ice_effect_bonus := float(bonus.get("ice_effect_bonus", bonus.get("ice_effect", 0.0)))
	var electricity_effect_bonus := float(bonus.get("electricity_effect_bonus", bonus.get("electricity_effect", 0.0)))
	var summon_slots_bonus := int(round(float(bonus.get("summon_slots_bonus", bonus.get("summon_slots", 0.0)))))
	if damage_bonus > 0.0:
		lines.append("+%d%% damage" % int(round(damage_bonus * 100.0)))
	if attack_damage_bonus > 0.0:
		lines.append("+%d%% attack spell damage" % int(round(attack_damage_bonus * 100.0)))
	if move_speed_bonus > 0.0:
		lines.append("+%d%% movement speed" % int(round(move_speed_bonus * 100.0)))
	if cooldown_reduction > 0.0:
		lines.append("-%s sec ability cooldown" % _format_bonus_decimal(cooldown_reduction))
	if gold_gain_bonus > 0.0:
		lines.append("+%d%% gold gained" % int(round(gold_gain_bonus * 100.0)))
	if attack_radius_bonus > 0.0:
		lines.append("+%s attack spell radius" % _format_bonus_decimal(attack_radius_bonus))
	if healing_rate_bonus > 0.0:
		lines.append("+%d%% healing rate" % int(round(healing_rate_bonus * 100.0)))
	if loot_luck_bonus > 0.0:
		lines.append("+%d%% loot luck" % int(round(loot_luck_bonus * 100.0)))
	if attack_effect_bonus > 0.0:
		lines.append("+%d%% attack spell effect" % int(round(attack_effect_bonus * 100.0)))
	if beyond_effect_bonus > 0.0:
		lines.append("+%d%% Beyond spell effect" % int(round(beyond_effect_bonus * 100.0)))
	if defense_effect_bonus > 0.0:
		lines.append("+%d%% defensive spell effect" % int(round(defense_effect_bonus * 100.0)))
	if flame_effect_bonus > 0.0:
		lines.append("+%d%% Flame spell effect" % int(round(flame_effect_bonus * 100.0)))
	if ice_effect_bonus > 0.0:
		lines.append("+%d%% Ice spell effect" % int(round(ice_effect_bonus * 100.0)))
	if electricity_effect_bonus > 0.0:
		lines.append("+%d%% Electricity spell effect" % int(round(electricity_effect_bonus * 100.0)))
	if summon_slots_bonus > 0:
		lines.append("+%d summoned creature" % summon_slots_bonus)
	return lines

func _socketed_diamond_bonus_totals() -> Dictionary:
	_ensure_faded_socket_size()
	var total_damage_bonus := 0.0
	var total_attack_damage_bonus := 0.0
	var total_move_speed_bonus := 0.0
	var total_cooldown_reduction := 0.0
	var total_gold_bonus := 0.0
	var total_attack_radius_bonus := 0.0
	var total_healing_rate_bonus := 0.0
	var total_loot_luck_bonus := 0.0
	var total_attack_effect_bonus := 0.0
	var total_beyond_effect_bonus := 0.0
	var total_defense_effect_bonus := 0.0
	var total_flame_effect_bonus := 0.0
	var total_ice_effect_bonus := 0.0
	var total_electricity_effect_bonus := 0.0
	var total_summon_slots_bonus := 0
	for diamond_id in socketed_faded_diamonds:
		if diamond_id.is_empty():
			continue
		var bonus := _diamond_socket_bonus(diamond_id)
		total_damage_bonus += float(bonus.get("damage", 0.0))
		total_attack_damage_bonus += float(bonus.get("attack_damage", 0.0))
		total_move_speed_bonus += float(bonus.get("move_speed", 0.0))
		total_cooldown_reduction += float(bonus.get("cooldown", 0.0))
		total_gold_bonus += float(bonus.get("gold", 0.0))
		total_attack_radius_bonus += float(bonus.get("attack_radius", 0.0))
		total_healing_rate_bonus += float(bonus.get("healing_rate", 0.0))
		total_loot_luck_bonus += float(bonus.get("loot_luck", 0.0))
		total_attack_effect_bonus += float(bonus.get("attack_effect", 0.0))
		total_beyond_effect_bonus += float(bonus.get("beyond_effect", 0.0))
		total_defense_effect_bonus += float(bonus.get("defense_effect", 0.0))
		total_flame_effect_bonus += float(bonus.get("flame_effect", 0.0))
		total_ice_effect_bonus += float(bonus.get("ice_effect", 0.0))
		total_electricity_effect_bonus += float(bonus.get("electricity_effect", 0.0))
		total_summon_slots_bonus += int(round(float(bonus.get("summon_slots", 0.0))))
	return {
		"damage_bonus": total_damage_bonus,
		"attack_damage_bonus": total_attack_damage_bonus,
		"move_speed_bonus": total_move_speed_bonus,
		"cooldown_reduction": total_cooldown_reduction,
		"gold_gain_bonus": total_gold_bonus,
		"attack_radius_bonus": total_attack_radius_bonus,
		"healing_rate_bonus": total_healing_rate_bonus,
		"loot_luck_bonus": total_loot_luck_bonus,
		"attack_effect_bonus": total_attack_effect_bonus,
		"beyond_effect_bonus": total_beyond_effect_bonus,
		"defense_effect_bonus": total_defense_effect_bonus,
		"flame_effect_bonus": total_flame_effect_bonus,
		"ice_effect_bonus": total_ice_effect_bonus,
		"electricity_effect_bonus": total_electricity_effect_bonus,
		"summon_slots_bonus": total_summon_slots_bonus
	}

func _socketed_diamond_bonus_summary() -> Array[String]:
	return _diamond_bonus_lines(_socketed_diamond_bonus_totals())

func _format_bonus_decimal(value: float) -> String:
	var rounded := snappedf(value, 0.01)
	if is_equal_approx(rounded, round(rounded)):
		return str(int(round(rounded)))
	return "%.2f" % rounded

func _apply_socketed_diamond_bonuses() -> void:
	var totals := _socketed_diamond_bonus_totals()
	if player != null:
		player.set_faded_diamond_bonuses(totals)

func _on_inventory_socket_drop_requested(slot_index: int, diamond_id: String, source_slot_index: int) -> void:
	if player == null:
		return
	_ensure_faded_socket_size()
	if slot_index < 0 or slot_index >= GLOVE_SOCKET_COUNT:
		return
	if _diamond_catalog_entry(diamond_id).is_empty():
		return
	if source_slot_index >= 0 and source_slot_index < GLOVE_SOCKET_COUNT:
		if socketed_faded_diamonds[source_slot_index] != diamond_id:
			return
		if source_slot_index == slot_index:
			return
		var target_id := socketed_faded_diamonds[slot_index]
		socketed_faded_diamonds[slot_index] = diamond_id
		socketed_faded_diamonds[source_slot_index] = target_id
	else:
		if _available_faded_diamond_count(diamond_id) <= 0:
			return
		socketed_faded_diamonds[slot_index] = diamond_id
	_apply_socketed_diamond_bonuses()

func _on_inventory_socket_clear_requested(slot_index: int) -> void:
	if player == null:
		return
	_ensure_faded_socket_size()
	if slot_index < 0 or slot_index >= GLOVE_SOCKET_COUNT:
		return
	if socketed_faded_diamonds[slot_index].is_empty():
		return
	socketed_faded_diamonds[slot_index] = ""
	_apply_socketed_diamond_bonuses()

func _on_spell_slot_spell_selected(category: String, spell_id: String) -> void:
	if player == null:
		return
	player.set_active_spell(category, spell_id)
	if hud != null:
		hud.update_stats(_stats_for_hud(player.get_stats()))

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
	if current_area == AREA_VELMORA:
		spawn_position = VELMORA_SPAWN_POSITION
	elif current_area == AREA_HOOFGROVE_WILDS:
		spawn_position = HOOFGROVE_SPAWN_POSITION
	player.resurrect_at(spawn_position)
	hud.hide_death()
	camera.global_position = player.global_position + _camera_follow_offset()
	camera.look_at(player.global_position + Vector3(0.0, 0.7, 0.0), Vector3.UP)
	_say_whisper("Again, then. Bring me what remains.")

func _on_exit_entered(body: Node3D) -> void:
	if body.name != "Player":
		return
	if exit_open:
		if _is_mission_active(AREA_BLACK_VAULT, "return_to_velmora_with_teleport"):
			_say_whisper("The portal has gone cold. Use the device.")
			return
		_play_sound(EXIT_SOUND, -1.0)
		if not exit_directive_completed:
			exit_directive_completed = true
			_update_possession()
		if mission_system != null:
			mission_system.complete_matching(current_area, "enter_the_portal_in_the_black_vault", {
				"area": current_area,
				"target": "black_vault_portal"
			})
		_enter_velmora()
	else:
		_say_whisper("Locked. The Black Vault wants blood before it opens.")

func _on_teleport_device_requested() -> void:
	if player == null:
		return
	if not _has_relic("teleport_device"):
		_say_whisper("No relic answers from your pack yet.")
		return
	if current_area != AREA_VELMORA:
		_say_whisper("The anchor is already biting Black Vault stone.")
		return
	_complete_teleport_destination_missions(current_area, AREA_BLACK_VAULT)
	_enter_black_vault_from_velmora()

func _on_teleport_destination_requested(destination_id: String) -> void:
	if player == null:
		return
	if not _has_relic("teleport_device"):
		_say_whisper("No relic answers from your pack yet.")
		return
	match destination_id:
		"black_vault":
			if current_area == AREA_BLACK_VAULT:
				_say_whisper("The Black Vault is already under your feet.")
				return
			_complete_teleport_destination_missions(current_area, AREA_BLACK_VAULT)
			_enter_black_vault_from_velmora()
		"velmora":
			if current_area == AREA_VELMORA:
				_say_whisper("Velmora already has you.")
				return
			if current_area == AREA_HOOFGROVE_WILDS and _is_mission_active(AREA_HOOFGROVE_WILDS, "clear_hoofgrove_wilds"):
				_say_whisper("Hoofgrove still has teeth standing.")
				return
			_complete_teleport_destination_missions(current_area, AREA_VELMORA)
			_enter_velmora()
		"hoofgrove_wilds":
			if current_area == AREA_HOOFGROVE_WILDS:
				_say_whisper("Hoofgrove already has your scent.")
				return
			_complete_teleport_destination_missions(current_area, AREA_HOOFGROVE_WILDS)
			_enter_hoofgrove_wilds()
		_:
			_say_whisper("That anchor is still dark.")

func _enter_black_vault_from_velmora() -> void:
	active_vendor_id = ""
	active_dialogue_id = ""
	active_dialogue_npc_id = ""
	if hud != null:
		hud.hide_character_panel()
		hud.hide_dialogue()
		hud.hide_shop()
		hud.hide_diamond_store()
		hud.hide_spell_store()
		hud.set_minimap_visible(true)
	_spawn_encounter()
	_spawn_chests()
	_spawn_scroll_for_game_level(SCROLL_LEVEL_BLACK_VAULT)
	player.teleport_to(PLAYER_START_POSITION)
	camera.global_position = player.global_position + _camera_follow_offset()
	camera.look_at(player.global_position + Vector3(0.0, 0.7, 0.0), Vector3.UP)
	_update_objective()
	_update_minimap()
	if hud != null:
		hud.update_stats(_stats_for_hud(player.get_stats()))
	_say_whisper("Back to the stone and screaming.")

func _enter_velmora() -> void:
	_make_velmora()
	current_area = AREA_VELMORA
	_set_mission_area(AREA_VELMORA)
	_sync_torren_blackwell_visibility()
	_set_background_music(VELMORA_MUSIC)
	active_vendor_id = ""
	active_dialogue_id = ""
	active_dialogue_npc_id = ""
	if hud != null:
		hud.hide_character_panel()
		hud.hide_shop()
		hud.hide_diamond_store()
		hud.hide_spell_store()
		hud.set_minimap_visible(false)
	if player != null:
		player.set_attacks_enabled(false)
	player.teleport_to(VELMORA_SPAWN_POSITION)
	camera.global_position = player.global_position + _camera_follow_offset()
	camera.look_at(player.global_position + Vector3(0.0, 0.7, 0.0), Vector3.UP)
	_update_objective()
	if hud != null:
		hud.update_stats(_stats_for_hud(player.get_stats()))
	_say_whisper("A door behind us. A market ahead. Spend wisely.")

func _enter_hoofgrove_wilds() -> void:
	_make_hoofgrove_wilds()
	current_area = AREA_HOOFGROVE_WILDS
	_set_mission_area(AREA_HOOFGROVE_WILDS)
	_set_background_music(_hoofgrove_wilds_music())
	active_vendor_id = ""
	active_dialogue_id = ""
	active_dialogue_npc_id = ""
	if hud != null:
		hud.hide_character_panel()
		hud.hide_dialogue()
		hud.hide_shop()
		hud.hide_diamond_store()
		hud.hide_spell_store()
		hud.set_minimap_visible(false)
	if player != null:
		player.set_attacks_enabled(true)
		player.teleport_to(HOOFGROVE_SPAWN_POSITION)
	_spawn_hoofgrove_centaurs()
	_spawn_hoofgrove_chests()
	_spawn_scroll_for_game_level(SCROLL_LEVEL_HOOFGROVE_WILDS)
	camera.global_position = player.global_position + _camera_follow_offset()
	camera.look_at(player.global_position + Vector3(0.0, 0.7, 0.0), Vector3.UP)
	_update_objective()
	_refresh_current_missions_display()
	if hud != null:
		hud.update_stats(_stats_for_hud(player.get_stats()))
	_say_whisper("Hoofgrove Wilds. New soil. Old hunger.")

func _spawn_hoofgrove_centaurs() -> void:
	if hoofgrove_centaurs_spawned or player == null:
		return
	hoofgrove_centaurs_spawned = true
	hoofgrove_centaurs_remaining = HOOFGROVE_CENTAUR_COUNT
	hoofgrove_hostiles_remaining = HOOFGROVE_CENTAUR_COUNT + HOOFGROVE_WARRIOR_COUNT + HOOFGROVE_CLERIC_COUNT + HOOFGROVE_GIANT_COUNT
	var local_points := [
		Vector3(-11.0, 0.1, 21.0),
		Vector3(12.0, 0.1, 18.0),
		Vector3(-18.0, 0.1, 8.0),
		Vector3(17.0, 0.1, 5.0),
		Vector3(-15.0, 0.1, -8.0),
		Vector3(14.0, 0.1, -10.0),
		Vector3(-8.0, 0.1, -22.0),
		Vector3(8.0, 0.1, -24.0),
		Vector3(-24.0, 0.1, -25.0),
		Vector3(24.0, 0.1, -25.0),
		Vector3(-2.0, 0.1, -34.0),
		Vector3(3.0, 0.1, 0.0),
		Vector3(-30.0, 0.1, 4.0),
		Vector3(30.0, 0.1, -4.0),
		Vector3(-12.0, 0.1, -36.0),
		Vector3(12.0, 0.1, -36.0)
	]
	for index in range(mini(HOOFGROVE_CENTAUR_COUNT, local_points.size())):
		_spawn_enemy_at(HOOFGROVE_ORIGIN + local_points[index], false, SISEnemy.ENEMY_KIND_CENTAUR)
	var warrior_start := HOOFGROVE_CENTAUR_COUNT
	for index in range(HOOFGROVE_WARRIOR_COUNT):
		var point_index := warrior_start + index
		if point_index < local_points.size():
			_spawn_enemy_at(HOOFGROVE_ORIGIN + local_points[point_index], false, SISEnemy.ENEMY_KIND_HUMAN_WARRIOR)
	var cleric_start := warrior_start + HOOFGROVE_WARRIOR_COUNT
	for index in range(HOOFGROVE_CLERIC_COUNT):
		var point_index := cleric_start + index
		if point_index < local_points.size():
			_spawn_enemy_at(HOOFGROVE_ORIGIN + local_points[point_index], false, SISEnemy.ENEMY_KIND_CLERIC)
	_spawn_enemy_at(HOOFGROVE_ORIGIN + Vector3(0.0, 0.1, -40.0), false, SISEnemy.ENEMY_KIND_GIANT)

func _on_vendor_entered(body: Node3D, vendor_id: String) -> void:
	if body.name != "Player" or current_area != AREA_VELMORA:
		return
	active_vendor_id = vendor_id
	var mission := _active_talk_mission_for_vendor(vendor_id)
	if not mission.is_empty():
		var dialogue_path := _dialogue_path_for_mission(mission)
		var dialogue_id := _dialogue_id_for_path(dialogue_path)
		if not dialogue_path.is_empty() and not _has_played_dialogue(dialogue_id):
			_start_vendor_dialogue(dialogue_id, dialogue_path, _vendor_face_texture(vendor_id), mission)
			return
		_complete_vendor_talk_missions(vendor_id)
		_show_vendor_shop(vendor_id, _vendor_greeting(vendor_id))
		return
	_complete_vendor_talk_missions(vendor_id)
	_show_vendor_shop(vendor_id, _vendor_greeting(vendor_id))

func _on_vendor_exited(body: Node3D, vendor_id: String) -> void:
	if body.name != "Player" or active_vendor_id != vendor_id:
		return
	active_vendor_id = ""
	active_dialogue_id = ""
	active_dialogue_npc_id = ""
	if hud != null:
		hud.hide_dialogue()
		hud.hide_shop()
		hud.hide_diamond_store()
		hud.hide_spell_store()

func _on_torren_blackwell_entered(body: Node3D) -> void:
	if body.name != "Player" or current_area != AREA_VELMORA:
		return
	if not _is_torren_blackwell_available():
		return
	active_vendor_id = ""
	var mission := _active_talk_mission_for_npc("Torren_Blackwell", "Torren Blackwell")
	if not mission.is_empty():
		var dialogue_path := _dialogue_path_for_mission(mission)
		var dialogue_id := _dialogue_id_for_path(dialogue_path)
		if not dialogue_path.is_empty() and not _has_played_dialogue(dialogue_id):
			_start_torren_blackwell_dialogue(dialogue_id, dialogue_path, mission)
			return
		_complete_torren_blackwell_mission()
		return
	var incomplete_mission := _active_incomplete_mission_for_giver("Torren_Blackwell")
	if not incomplete_mission.is_empty():
		_start_torren_blackwell_incomplete_reply(incomplete_mission)

func _on_torren_blackwell_exited(body: Node3D) -> void:
	if body.name != "Player" or not active_dialogue_npc_id.begins_with("Torren_Blackwell"):
		return
	active_dialogue_id = ""
	active_dialogue_npc_id = ""
	if hud != null:
		hud.hide_dialogue()

func _start_vendor_dialogue(dialogue_id: String, path: String, npc_face_texture: Texture2D, mission: Dictionary = {}) -> void:
	if hud == null:
		return
	var entries := _load_dialogue_entries(path)
	if entries.is_empty():
		_mark_dialogue_played(dialogue_id)
		_complete_vendor_talk_missions(active_vendor_id)
		_show_vendor_shop(active_vendor_id, _vendor_greeting(active_vendor_id))
		return
	_grant_mission_given_items(current_area, mission)
	active_dialogue_id = dialogue_id
	active_dialogue_npc_id = _vendor_npc_name(active_vendor_id)
	hud.show_dialogue(entries, npc_face_texture)

func _start_torren_blackwell_dialogue(dialogue_id: String = DIALOGUE_TORREN_BLACKWELL, path: String = TORREN_BLACKWELL_DIALOGUE_PATH, mission: Dictionary = {}) -> void:
	if hud == null:
		return
	var entries := _load_dialogue_entries(path)
	if entries.is_empty():
		_complete_torren_blackwell_mission()
		return
	_grant_mission_given_items(current_area, mission)
	active_dialogue_id = dialogue_id
	active_dialogue_npc_id = "Torren_Blackwell"
	hud.hide_shop()
	hud.hide_diamond_store()
	hud.hide_spell_store()
	hud.show_dialogue(entries, torren_blackwell_face_texture)

func _start_torren_blackwell_incomplete_reply(mission: Dictionary) -> void:
	if hud == null:
		return
	var reply := _random_incomplete_reply(mission)
	if reply.is_empty():
		return
	active_dialogue_id = ""
	active_dialogue_npc_id = "Torren_Blackwell_Reminder"
	hud.hide_shop()
	hud.hide_diamond_store()
	hud.hide_spell_store()
	hud.show_dialogue([{
		"speaker": "Torren",
		"text": reply
	}], torren_blackwell_face_texture)

func _on_dialogue_finished() -> void:
	var completed_dialogue_id := active_dialogue_id
	var completed_dialogue_npc_id := active_dialogue_npc_id
	active_dialogue_id = ""
	active_dialogue_npc_id = ""
	_mark_dialogue_played(completed_dialogue_id)
	if completed_dialogue_npc_id == "Torren_Blackwell":
		_complete_torren_blackwell_mission()
		return
	if not active_vendor_id.is_empty():
		_complete_vendor_talk_missions(active_vendor_id)
		_show_vendor_shop(active_vendor_id, _vendor_greeting(active_vendor_id))
	if completed_dialogue_id == DIALOGUE_ALDRIC_FIRST and not _has_relic("teleport_device"):
		_add_relic("teleport_device")
		_say_whisper("Relic gained. %s" % _relic_display_name("teleport_device"))

func _complete_torren_blackwell_mission() -> void:
	if mission_system == null:
		return
	mission_system.complete_matching(current_area, "talk_to_npc", {
		"npc_id": "Torren_Blackwell",
		"npc_name": "Torren Blackwell",
		"target": "Torren_Blackwell"
	})
	_sync_torren_blackwell_visibility()

func _show_vendor_shop(vendor_id: String, status_text: String) -> void:
	if hud == null:
		return
	match vendor_id:
		"diamond_vendor":
			hud.show_diamond_store(_vendor_title(vendor_id), _diamond_store_items(), _gold_wallet_text(), status_text, velmora_vendor_woman_face_texture)
		"spell_vendor":
			hud.show_spell_store(_vendor_title(vendor_id), _spell_store_items(), _gold_wallet_text(), status_text, velmora_vendor_warlock_face_texture)
		_:
			hud.show_shop(_vendor_title(vendor_id), _shop_items_for_vendor(vendor_id), status_text, _wallet_text(), velmora_vendor_man_face_texture)

func _vendor_face_texture(vendor_id: String) -> Texture2D:
	match vendor_id:
		"diamond_vendor":
			return velmora_vendor_woman_face_texture
		"spell_vendor":
			return velmora_vendor_warlock_face_texture
		_:
			return velmora_vendor_man_face_texture

func _vendor_npc_name(vendor_id: String) -> String:
	match vendor_id:
		"diamond_vendor":
			return "Syra"
		"spell_vendor":
			return "Zethyr"
		"relic_vendor":
			return "Aldric"
		_:
			return ""

func _vendor_title(vendor_id: String) -> String:
	match vendor_id:
		"diamond_vendor":
			return "Syra — Diamond Broker"
		"spell_vendor":
			return "Zethyr — Spells & Rituals"
		"relic_vendor":
			return "Aldric — Curiosities"
		_:
			return "Vendor"

func _vendor_greeting(vendor_id: String) -> String:
	match vendor_id:
		"diamond_vendor":
			if game_level <= 1:
				return "Syra smiles. Faded diamonds unlock after the Black Vault. Return with more blood on your hands."
			return "Syra opens a case of faded diamonds. Each color bends your build in a different direction."
		"spell_vendor":
			return "Zethyr watches you carefully. Spend gold to bind permanent spell upgrades."
		"relic_vendor":
			return "Aldric leans on the counter. More stock is on its way. Come back soon."
		_:
			return "The vendor waits."

func _shop_items_for_vendor(vendor_id: String) -> Array[Dictionary]:
	var items: Array[Dictionary] = []
	match vendor_id:
		"diamond_vendor":
			if game_level <= 1:
				items.append({
					"id": "faded_locked",
					"name": "Faded Diamonds (Locked)",
					"description": "Clear the Black Vault to unlock Syra's full faded catalog.",
					"price": "-"
				})
			else:
				for diamond in FADED_DIAMOND_CATALOG:
					var item_id := String(diamond["id"])
					var owned_count := int(owned_faded_diamonds.get(item_id, 0))
					var socketed_count := _socketed_count(item_id)
					var available_count := _available_faded_diamond_count(item_id)
					var description := _diamond_bonus_text(item_id)
					if owned_count > 0:
						description += " Owned: %s (Socketed: %s, Available: %s)" % [owned_count, socketed_count, available_count]
					items.append({
						"id": item_id,
						"name": "%s %s" % [String(diamond["icon"]), String(diamond["name"])],
						"description": description,
						"price": "%s gold" % int(diamond["gold_cost"]),
						"color": diamond["color"]
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
					"price": "%s gold" % int(spell["gold_cost"])
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

func _gold_wallet_text() -> String:
	return "Gold %s" % player.gold

func _diamond_store_items() -> Array[Dictionary]:
	var items: Array[Dictionary] = []
	if game_level <= 1:
		items.append({
			"id": "faded_locked",
			"name": "Faded Diamonds (Locked)",
			"description": "Clear the Black Vault to unlock Syra's full faded catalog.",
			"price": "—",
			"color": Color(0.5, 0.5, 0.5),
			"owned_count": 0
		})
		return items
	for diamond in FADED_DIAMOND_CATALOG:
		var item_id := String(diamond["id"])
		var owned_count := int(owned_faded_diamonds.get(item_id, 0))
		var socketed_count := _socketed_count(item_id)
		var available_count := _available_faded_diamond_count(item_id)
		var description := _diamond_bonus_text(item_id)
		if owned_count > 0:
			description += "\nOwned: %s  |  Socketed: %s  |  Available: %s" % [owned_count, socketed_count, available_count]
		items.append({
			"id": item_id,
			"name": String(diamond["name"]),
			"description": description,
			"price": "%s gold" % int(diamond["gold_cost"]),
			"color": diamond["color"],
			"owned_count": owned_count
		})
	return items

func _spell_store_items() -> Array[Dictionary]:
	var items: Array[Dictionary] = []
	for spell in SPELL_CATALOG:
		var spell_id := String(spell["id"])
		items.append({
			"id": spell_id,
			"name": String(spell["name"]),
			"description": String(spell["description"]),
			"category": String(spell.get("category", "attack")),
			"spell_category": _spell_theme_category_for_id(spell_id),
			"image": String(spell.get("image", "")),
			"gold_cost": int(spell["gold_cost"]),
			"learned": player.has_spell(spell_id)
		})
	return items

func _spell_theme_category_for_id(spell_id: String) -> String:
	if SPELL_THEME_CATEGORY_BY_ID.has(spell_id):
		return String(SPELL_THEME_CATEGORY_BY_ID[spell_id])
	return "Beyond"

func _on_shop_purchase_requested(item_id: String) -> void:
	if active_vendor_id.is_empty() or player == null:
		return
	var status_text := "Nothing happens."
	if active_vendor_id == "diamond_vendor":
		status_text = _buy_faded_diamond(item_id)
	elif active_vendor_id == "spell_vendor":
		status_text = _buy_spell(item_id)
	else:
		status_text = "The stall has nothing for sale yet."
	_show_vendor_shop(active_vendor_id, status_text)

func _buy_faded_diamond(item_id: String) -> String:
	if game_level <= 1:
		return "Syra will only sell faded diamonds after the Black Vault."
	for diamond in FADED_DIAMOND_CATALOG:
		if String(diamond["id"]) != item_id:
			continue
		var cost := int(diamond["gold_cost"])
		if not player.spend_gold(cost):
			return "Not enough gold."
		owned_faded_diamonds[item_id] = int(owned_faded_diamonds.get(item_id, 0)) + 1
		_apply_socketed_diamond_bonuses()
		return "Purchased %s." % String(diamond["name"])
	return "Syra does not offer that diamond."

func _buy_spell(item_id: String) -> String:
	for spell in SPELL_CATALOG:
		if String(spell["id"]) != item_id:
			continue
		if player.has_spell(item_id):
			return "Already learned."
		var cost := int(spell["gold_cost"])
		if not player.spend_gold(cost):
			return "Not enough gold."
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
	if current_area == AREA_VELMORA:
		var active_missions := mission_system.get_active_missions(AREA_VELMORA) if mission_system != null else []
		if not active_missions.is_empty():
			var mission := active_missions[0] as Dictionary
			hud.set_objective(String(mission.get("title", mission.get("text", "Velmora has work waiting."))))
		else:
			hud.set_objective("Velmora reached. Upgrade, choose a destination, then hunt again.")
		_refresh_current_missions_display()
		return
	if current_area == AREA_HOOFGROVE_WILDS:
		if _is_mission_active(AREA_HOOFGROVE_WILDS, "clear_hoofgrove_wilds"):
			hud.set_objective("Clear Hoofgrove Wilds: %s hostiles remain." % hoofgrove_hostiles_remaining)
		elif _is_mission_active(AREA_HOOFGROVE_WILDS, "return_to_velmora_with_teleport"):
			hud.set_objective("Talk to Torren Blackwell in Velmora.")
		elif _is_mission_active(AREA_VELMORA, "talk_to_torren_after_clearing_forest"):
			hud.set_objective("Talk to Torren Blackwell in Velmora.")
		else:
			hud.set_objective("Hoofgrove Wilds reached. The road ahead is waking.")
		_refresh_current_missions_display()
		return
	if _is_mission_active(AREA_BLACK_VAULT, "return_to_velmora_with_teleport"):
		hud.set_objective("Use the Teleport Device to return to Velmora.")
		_refresh_current_missions_display()
		return
	if exit_open:
		hud.set_objective("Enter the portal. Leave the dead behind.")
	else:
		var objective_template := _mission_text(
			AREA_BLACK_VAULT,
			"clear_black_vault",
			"Slay everyone in the Black Vault: %s/%s lives taken. Crack open their chests."
		)
		hud.set_objective(_format_black_vault_mission_text(objective_template))
	_refresh_current_missions_display()

func _update_possession() -> void:
	if hud == null:
		return
	if whisper_system != null:
		hud.set_possession_ratio(whisper_system.get_corruption_ratio())
		return
	hud.set_possession_ratio(0.0)

func _update_minimap() -> void:
	if hud == null or player == null:
		return
	var enemy_positions: Array[Vector3] = []
	if current_area == AREA_VELMORA:
		hud.set_minimap_visible(false)
		hud.update_minimap(player.global_position - VELMORA_ORIGIN, enemy_positions, VELMORA_HALF_SIZE)
		return
	if current_area == AREA_HOOFGROVE_WILDS:
		hud.set_minimap_visible(false)
		hud.update_minimap(player.global_position - HOOFGROVE_ORIGIN, enemy_positions, HOOFGROVE_HALF_SIZE)
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
	_award_possession_points(corruption)
	hud.set_corruption_ui(corruption, _current_hp_percent())
	if corruption >= 100.0 and not possession_fx_played:
		possession_fx_played = true
		if player != null:
			player.flash_possession_red()

func _award_possession_points(corruption: float) -> void:
	if player == null:
		return
	var earned_points := 1 if corruption >= 100.0 else 0
	if earned_points <= full_possession_points_awarded:
		return
	var gained := earned_points - full_possession_points_awarded
	full_possession_points_awarded = earned_points
	player.add_possession_points(gained)
	if hud != null:
		hud.flash_possession_point()
	call_deferred("_say_whisper", "A piece of you opens. Spend it where I can reach.")

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
		"borrowed_hands":
			player.apply_timed_damage_multiplier(1.45, 12.0)
			player.apply_control_lapse(1.15)
			player.reduce_max_life_percent(0.03)
		"open_wound":
			player.apply_lifesteal(0.9, 12.0)
			player.take_damage(maxi(6, int(round(float(player.max_life) * 0.14))))
			player.reduce_max_life_percent(0.04)
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
		"martyr_mark_reward":
			player.apply_timed_damage_multiplier(1.38, 9.0)
			player.reduce_max_life_percent(0.025)
		"martyr_mark_fail":
			player.apply_timed_slow(0.82, 4.0)
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

func _hoofgrove_floor_material() -> StandardMaterial3D:
	if hoofgrove_floor_texture == null:
		hoofgrove_floor_texture = _make_hoofgrove_floor_texture()
	var material: StandardMaterial3D = StandardMaterial3D.new()
	material.albedo_texture = hoofgrove_floor_texture
	material.albedo_color = Color(0.58, 0.52, 0.42)
	material.emission_enabled = true
	material.emission = Color(0.018, 0.026, 0.012)
	material.emission_texture = hoofgrove_floor_texture
	material.emission_energy_multiplier = 0.11
	material.roughness = 1.0
	material.texture_repeat = true
	material.uv1_scale = Vector3(13.0, 13.0, 1.0)
	return material

func _velmora_floor_material() -> StandardMaterial3D:
	if velmora_cobble_texture == null:
		velmora_cobble_texture = _make_velmora_cobble_texture()
	var material: StandardMaterial3D = StandardMaterial3D.new()
	material.albedo_texture = velmora_cobble_texture
	material.albedo_color = Color(0.22, 0.205, 0.185)
	material.emission_enabled = true
	material.emission = Color(0.035, 0.025, 0.018)
	material.emission_energy_multiplier = 0.12
	material.roughness = 0.92
	material.texture_repeat = true
	material.uv1_scale = Vector3(7.0, 7.0, 1.0)
	return material

func _velmora_street_material() -> StandardMaterial3D:
	if velmora_cobble_texture == null:
		velmora_cobble_texture = _make_velmora_cobble_texture()
	var material: StandardMaterial3D = StandardMaterial3D.new()
	material.albedo_texture = velmora_cobble_texture
	material.albedo_color = Color(0.34, 0.32, 0.3)
	material.emission_enabled = true
	material.emission = Color(0.04, 0.033, 0.03)
	material.emission_energy_multiplier = 0.16
	material.roughness = 0.96
	material.texture_repeat = true
	material.uv1_scale = Vector3(2.3, 10.0, 1.0)
	return material

func _velmora_wall_material(size: Vector3) -> StandardMaterial3D:
	if wall_texture == null:
		wall_texture = _make_brick_texture()
	var horizontal_repeats: float = max(size.x, size.z) * 0.42
	var vertical_repeats: float = max(size.y * 0.8, 2.6)
	var material: StandardMaterial3D = StandardMaterial3D.new()
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

func _velmora_roof_material() -> StandardMaterial3D:
	if velmora_roof_texture == null:
		velmora_roof_texture = _make_velmora_roof_texture()
	var material: StandardMaterial3D = StandardMaterial3D.new()
	material.albedo_texture = velmora_roof_texture
	material.albedo_color = Color(0.26, 0.24, 0.31)
	material.emission_enabled = true
	material.emission = Color(0.025, 0.018, 0.04)
	material.emission_energy_multiplier = 0.1
	material.roughness = 0.94
	material.texture_repeat = true
	material.uv1_scale = Vector3(4.0, 3.0, 1.0)
	return material

func _velmora_wood_material() -> StandardMaterial3D:
	if velmora_wood_texture == null:
		velmora_wood_texture = _make_velmora_wood_texture()
	var material: StandardMaterial3D = StandardMaterial3D.new()
	material.albedo_texture = velmora_wood_texture
	material.albedo_color = Color(0.33, 0.21, 0.13)
	material.emission_enabled = true
	material.emission = Color(0.035, 0.022, 0.014)
	material.emission_energy_multiplier = 0.08
	material.roughness = 0.9
	material.texture_repeat = true
	material.uv1_scale = Vector3(2.4, 2.4, 1.0)
	return material

func _make_hoofgrove_floor_texture() -> Texture2D:
	var image := Image.create(BRICK_TEXTURE_SIZE, BRICK_TEXTURE_SIZE, false, Image.FORMAT_RGBA8)
	var dirt_dark := Color(0.055, 0.04, 0.027)
	var dirt_mid := Color(0.16, 0.105, 0.058)
	var mud := Color(0.075, 0.058, 0.038)
	var leaf_green := Color(0.095, 0.17, 0.052)
	var leaf_gold := Color(0.27, 0.19, 0.06)
	var dead_leaf := Color(0.22, 0.095, 0.035)
	var stone := Color(0.25, 0.235, 0.2)
	var wood := Color(0.13, 0.075, 0.034)

	for y in BRICK_TEXTURE_SIZE:
		for x in BRICK_TEXTURE_SIZE:
			var coarse := _brick_noise(int(x / 5), int(y / 5), 101)
			var fine := _brick_noise(x, y, 103)
			var wet := _brick_noise(int(x / 13), int(y / 13), 105)
			var color: Color = dirt_mid.lerp(dirt_dark, coarse * 0.38).lerp(mud, wet * 0.34)
			color = color.lerp(Color(0.045, 0.082, 0.035), _brick_noise(int(x / 9), int(y / 9), 106) * 0.22)

			var leaf_seed := _brick_noise(x, y, 107)
			if leaf_seed > 0.88:
				var leaf_color: Color = leaf_green.lerp(leaf_gold, _brick_noise(x, y, 108))
				leaf_color = leaf_color.lerp(dead_leaf, _brick_noise(x, y, 109) * 0.55)
				color = color.lerp(leaf_color, 0.72)

			var pebble_seed := _brick_noise(int(x / 2), int(y / 2), 111)
			if pebble_seed > 0.955:
				color = color.lerp(stone, 0.82)

			var branch_wave := absf(sin(float(x) * 0.12 + float(y) * 0.055 + _brick_hash(int(x / 18), int(y / 18), 113) * 4.0))
			if branch_wave < 0.035 and _brick_noise(int(x / 4), int(y / 4), 115) > 0.72:
				color = color.lerp(wood, 0.78)

			if fine > 0.91:
				color = color.lightened(0.08)
			elif fine < 0.1:
				color = color.darkened(0.12)
			image.set_pixel(x, y, color)

	image.generate_mipmaps()
	return ImageTexture.create_from_image(image)

func _make_velmora_cobble_texture() -> Texture2D:
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

func _make_velmora_roof_texture() -> Texture2D:
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

func _make_velmora_wood_texture() -> Texture2D:
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
