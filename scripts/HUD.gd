extends CanvasLayer
class_name SISHUD

signal resurrect_requested
signal offer_accepted
signal offer_rejected
signal shop_purchase_requested(item_id: String)
signal shop_closed
signal skill_tree_point_requested(node_key: String)
signal inventory_socket_drop_requested(slot_index: int, diamond_id: String, source_slot_index: int)
signal inventory_socket_clear_requested(slot_index: int)
signal dialogue_finished
signal teleport_device_requested
signal teleport_destination_requested(destination_id: String)
signal spell_slot_spell_selected(category: String, spell_id: String)
signal whisper_silence_changed(silenced: bool)
signal whisper_audio_mix_changed(chant_volume: float, echo_volume: float)
signal whisper_voice_requested(text: String)

const FIRESTORM_TEXTURE: Texture2D = preload("res://assets/images/spells/attack/firestorm.png")
const LIFE_BAR_TEXTURE: Texture2D = preload("res://assets/images/hud/health-bar.png")
const LIFE_FILL_TEXTURE: Texture2D = preload("res://assets/images/hud/life-bar.png")
const SPELL_SLOT_TEXTURE: Texture2D = preload("res://assets/images/hud/spell-slot-new.png")
const POSSESSION_BAR_TEXTURE: Texture2D = preload("res://assets/images/hud/possession-bar.png")
const POSSESSION_FILL_TEXTURE: Texture2D = preload("res://assets/images/hud/possessing-bar.png")
const EXP_BAR_TEXTURE: Texture2D = preload("res://assets/images/hud/exp-bar.png")
const EXP_FILL_TEXTURE: Texture2D = preload("res://assets/images/hud/exp-actual-bar.png")
const MINIMAP_TEXTURE: Texture2D = preload("res://assets/images/hud/minimap.png")
const DEMON_MENU_TEXTURE: Texture2D = preload("res://assets/images/hud/demon.png")
const LEVEL_UP_WHISPER_SOUND: AudioStream = preload("res://assets/audio/sounds/levelling-whisper.mp3")
const CONFIG_MENU_TEXTURE: Texture2D = preload("res://assets/images/config/config.png")
const RITUAL_MENU_TEXTURE: Texture2D = preload("res://assets/images/hud/ritual-button.png")
const EQUIP_TEXTURE: Texture2D = preload("res://assets/images/hud/equip/equip.png")
const RELIC_EQUIP_TEXTURE: Texture2D = preload("res://assets/images/hud/equip/gloves-for-relics.png")
const DIAMOND_TEXTURE: Texture2D = preload("res://assets/images/objects/diamond.png")
const DIAMOND_UP_TEXTURE: Texture2D = preload("res://assets/images/objects/diamond-up.png")
const DIAMOND_FADED_TEXTURE_PATH := "res://assets/images/objects/diamond-faded.png"
const DIAMOND_WHISPERING_TEXTURE_PATH := "res://assets/images/objects/diamond-whispering.png"
const DIAMOND_CORRUPTED_TEXTURE_PATH := "res://assets/images/objects/diamond-corrupted.png"
const DIAMOND_ABYSSAL_TEXTURE_PATH := "res://assets/images/objects/diamond-abyssal.png"
const DIAMOND_DIVINE_TEXTURE_PATH := "res://assets/images/objects/diamond-divine.png"
const SCROLL_OPEN_TEXTURE: Texture2D = preload("res://assets/images/objects/scroll-open.png")
const WHISPER_FONT: FontFile = preload("res://assets/fonts/Simbiot.ttf")
const DIALOGUE_PLAYER_FACE_TEXTURE: Texture2D = preload("res://assets/images/demon/demon-face.png")
const DIALOGUE_BOX_TEXTURE_PATH := "res://assets/images/dialogue/dialogue-box.png"
const DIALOGUE_FACE_FRAME_TEXTURE_PATH := "res://assets/images/dialogue/dialogue-face.png"
const TELEPORT_DEVICE_OUTER_RING_PATH := "res://assets/images/objects/teleport-device/teleport-device-outer-ring.png"
const TELEPORT_DEVICE_INNER_VORTEX_PATH := "res://assets/images/objects/teleport-device/teleport-device-inner-vortex.png"
const TELEPORT_DEVICE_STONE_RING_PATH := "res://assets/images/objects/teleport-device/teleport-device-stone-ring.png"
const WORLD_MAP_FIRST_VELMORA_PATH := "res://assets/images/objects/world-map/world-map-first-velmora.png"
const HUD_BOTTOM_MARGIN := 4.0
const HUD_CLUSTER_SIZE := Vector2(770.0, 205.0)
const LIFE_BAR_SIZE := Vector2(404.0, 134.0)
const LIFE_BAR_POSITION := Vector2(0.0, HUD_CLUSTER_SIZE.y - LIFE_BAR_SIZE.y - HUD_BOTTOM_MARGIN)
const LIFE_FILL_POSITION := Vector2(111.0, 64.0)
const LIFE_FILL_SIZE := Vector2(241.0, 18.0)
const EXP_BAR_SOURCE_RECT := Rect2(20.0, 288.0, 1496.0, 360.0)
const EXP_FILL_SOURCE_RECT := Rect2(0.0, 0.0, 363.0, 20.0)
const EXP_BAR_SIZE := Vector2(520.0, 125.0)
const EXP_FILL_POSITION := Vector2(50.0, 75.0)
const EXP_FILL_SIZE := Vector2(402.0, 20.0)
const EXP_BAR_SLOT_GAP := 2.0
const SPELL_SLOT_SOURCE_SIZE := Vector2(573.0, 97.0)
const SPELL_SLOT_SIZE := Vector2(400.0, 68.0)
const SPELL_SLOT_BOTTOM_MARGIN := 15.0
const FIRESTORM_SLOT_CENTER_SOURCE := Vector2(57.5, 48.5)
const FIRESTORM_ICON_SIZE := Vector2(50.0, 50.0)
const SPELL_SLOT_HOVER_FONT_SIZE := 15
const SPELL_SLOT_HOVER_REGION_SIZE := Vector2(74.0, 58.0)
const SPELL_SLOT_TOOLTIP_SIZE := Vector2(220.0, 46.0)
const SPELL_SLOT_PICKER_SIZE := Vector2(300.0, 106.0)
const SPELL_SLOT_PICKER_ICON_SIZE := Vector2(48.0, 48.0)
const SPELL_SLOT_HOVER_CENTER_SOURCES := [
	Vector2(57.5, 48.5),
	Vector2(172.0, 48.5),
	Vector2(286.5, 48.5),
	Vector2(401.0, 48.5),
	Vector2(515.5, 48.5)
]
const SPELL_SLOT_HOVER_CATEGORIES := ["attack", "defense", "healing", "buff", "debuff"]
const SPELL_SLOT_HOVER_LABELS := {
	"attack": "Attack",
	"defense": "Defense",
	"healing": "Healing",
	"buff": "Buff",
	"debuff": "Debuff"
}
const SPELL_GROUP_CATEGORY_BY_ID := {
	"fire_storm": "attack",
	"absolute_zero": "attack",
	"abyssal_blade": "attack",
	"call_from_beyond": "attack",
	"electricity_vortex": "attack",
	"icesmash": "attack",
	"soul_drain": "attack",
	"demonic_frenzy": "buff",
	"killing_radius": "buff",
	"power_of_underworld": "buff",
	"void_infusion": "buff",
	"curse_of_laziness": "debuff",
	"mark_of_weakness": "debuff",
	"slowly_we_rot": "debuff",
	"armor_of_undead": "defense",
	"eclipse_shield": "defense",
	"titanium": "defense",
	"reincarnation": "healing",
	"soul_harvest": "healing"
}
const SPELL_THEME_CATEGORY_BY_ID := {
	"fire_storm": "Flame",
	"wide_flame": "Flame",
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
const SPELL_ID_TO_DISPLAY_NAME := {
	"fire_storm": "Firestorm",
	"absolute_zero": "Absolute Zero",
	"abyssal_blade": "Abyssal Blade",
	"call_from_beyond": "Call From The Beyond",
	"electricity_vortex": "Electricity Vortex",
	"icesmash": "Ice Smash",
	"soul_drain": "Soul Drain",
	"demonic_frenzy": "Demonic Frenzy",
	"killing_radius": "Killing Radius",
	"power_of_underworld": "Power of the Underworld",
	"void_infusion": "Void Infusion",
	"curse_of_laziness": "Curse of Laziness",
	"mark_of_weakness": "Mark of Weakness",
	"slowly_we_rot": "Slowly We Rot",
	"armor_of_undead": "Armor of the Undead",
	"eclipse_shield": "Eclipse Shield",
	"titanium": "Titanium",
	"reincarnation": "Reincarnation",
	"soul_harvest": "Soul Harvest",
	"wide_flame": "Widened Flame",
	"quickened_ritual": "Quickened Ritual",
	"ember_stride": "Ember Stride"
}
const SPELL_ICON_PATH_BY_ID := {
	"fire_storm": "res://assets/images/spells/attack/firestorm.png",
	"absolute_zero": "res://assets/images/spells/attack/AbsoluteZero.png",
	"abyssal_blade": "res://assets/images/spells/attack/AbyssalBlade.png",
	"call_from_beyond": "res://assets/images/spells/attack/CallFromTheBeyond.png",
	"electricity_vortex": "res://assets/images/spells/attack/ElectricityVortex.png",
	"icesmash": "res://assets/images/spells/attack/Icesmash.png",
	"soul_drain": "res://assets/images/spells/attack/SoulDrain.png",
	"demonic_frenzy": "res://assets/images/spells/buff/DemonicFrenzy.png",
	"killing_radius": "res://assets/images/spells/buff/KillingRadius.png",
	"power_of_underworld": "res://assets/images/spells/buff/PowerOfTheUnderWorld.png",
	"void_infusion": "res://assets/images/spells/buff/VoidInfusion.png",
	"curse_of_laziness": "res://assets/images/spells/debuff/CurseOfLaziness.png",
	"mark_of_weakness": "res://assets/images/spells/debuff/MarkOfWeakness.png",
	"slowly_we_rot": "res://assets/images/spells/debuff/SlowlyWeRot.png",
	"armor_of_undead": "res://assets/images/spells/defense/ArmorOfTheUndead.png",
	"eclipse_shield": "res://assets/images/spells/defense/EclipseShield.png",
	"titanium": "res://assets/images/spells/defense/Titanium.png",
	"reincarnation": "res://assets/images/spells/healing/Reincarnation.png",
	"soul_harvest": "res://assets/images/spells/healing/SoulHarvest.png"
}
const SKILL_COOLDOWN_FONT_SIZE := 20
const POSSESSION_BAR_SIZE := Vector2(392.0, 134.0)
const POSSESSION_FILL_POSITION := Vector2(35.0, 65.0)
const POSSESSION_FILL_SIZE := Vector2(246.0, 15.0)
const WHISPER_COLOR := Color(0.95, 0.05, 0.03, 1.0)
const WHISPER_FONT_SIZE := 18
const WHISPER_TOP_OFFSET := -260.0
const WHISPER_BOTTOM_OFFSET := -212.0
const WHISPER_VISIBLE_SECONDS := 6.4
const WHISPER_FADE_SECONDS := 1.6
const OBJECTIVE_FONT_SIZE := 22
const MISSION_TITLE_FONT_SIZE := 16
const MISSION_LIST_FONT_SIZE := 15
const MISSION_PANEL_SIZE := Vector2(560.0, 148.0)
const MISSION_PANEL_ANCHOR := Vector2(0.02, 0.025)
const MISSION_TEXT_POSITION := Vector2(14.0, 12.0)
const MINIMAP_SIZE := Vector2(210.0, 140.0)
const MINIMAP_DOT_SIZE := 6.0
const MINIMAP_PLAYER_DOT_SIZE := 8.0
const MINIMAP_HOLE_SHADE_ALPHA := 0.56
const WHISPER_PANEL_SIZE := Vector2(430.0, 205.0)
const DIRECTIVE_PANEL_SIZE := Vector2(360.0, 92.0)
const SHOP_PANEL_SIZE := Vector2(520.0, 410.0)
const DIAMOND_STORE_PANEL_SIZE := Vector2(700.0, 540.0)
const DIAMOND_STORE_BODY_SIZE := Vector2(672.0, 516.0)
const DIAMOND_STORE_CELL_SIZE := Vector2(100.0, 104.0)
const DIAMOND_STORE_VISUAL_SIZE := Vector2(76.0, 52.0)
const DIAMOND_STORE_NAME_BLOCK_HEIGHT := 26.0
const DIAMOND_STORE_PRICE_BLOCK_HEIGHT := 16.0
const SPELL_STORE_PANEL_SIZE := Vector2(860.0, 660.0)
const SPELL_STORE_CELL_SIZE := Vector2(112.0, 166.0)
const SPELL_STORE_SIGIL_SLOT_HEIGHT := 96.0
const SPELL_STORE_SIGIL_ICON_SIZE := Vector2(92.0, 92.0)
const SPELL_STORE_NAME_BLOCK_HEIGHT := 30.0
const SPELL_STORE_PRICE_BLOCK_HEIGHT := 16.0
const INVENTORY_DIAMOND_ICON_SIZE := Vector2(42.0, 42.0)
const INVENTORY_DIAMOND_VISUAL_SIZE := Vector2(62.0, 42.0)
const INVENTORY_DIAMOND_CELL_SIZE := Vector2(72.0, 78.0)
const INVENTORY_DIAMOND_GRID_COLUMNS := 5
const INVENTORY_DIAMOND_GRID_H_SEPARATION := 8
const INVENTORY_DIAMOND_GRID_V_SEPARATION := 8
const INVENTORY_DIAMOND_SCROLL_HEIGHT := 252.0
const INVENTORY_DIAMOND_EMPTY_SLOT_COUNT := 20
const INVENTORY_DRAG_ICON_SIZE := Vector2(30.0, 30.0)
const INVENTORY_GLOVE_FRAME_SIZE := Vector2(520.0, 560.0)
const RELIC_GRID_ICON_SIZE := Vector2(42.0, 42.0)
const RELIC_GRID_CELL_SIZE := Vector2(72.0, 78.0)
const RELIC_GRID_EMPTY_SLOT_COUNT := 20
const INVENTORY_SOCKET_COUNT := 8
const INVENTORY_SOCKET_HITBOX_SIZE := Vector2(34.0, 34.0)
const INVENTORY_SOCKET_ICON_SIZE := Vector2(24.0, 24.0)
const INVENTORY_SOCKET_CORNER_RADIUS := 17
const INVENTORY_SOCKET_POSITIONS := [
	Vector2(70.0, 172.0),
	Vector2(91.0, 126.0),
	Vector2(126.0, 116.0),
	Vector2(160.0, 114.0),
	Vector2(321.0, 111.0),
	Vector2(355.0, 112.0),
	Vector2(385.0, 121.0),
	Vector2(410.0, 160.0)
]
const INVENTORY_SOCKET_DIAMOND_OFFSETS := {
	"faded_rush": Vector2.ZERO,
	"faded_focus": Vector2.ZERO,
	"faded_vitality": Vector2.ZERO,
	"faded_fortune": Vector2.ZERO,
	"faded_corruption": Vector2.ZERO,
	"faded_echo": Vector2.ZERO,
	"faded_void": Vector2.ZERO,
	"faded_fury": Vector2.ZERO,
	"faded_guardian": Vector2.ZERO,
	"faded_flame_ring": Vector2.ZERO,
	"faded_frostbind": Vector2.ZERO,
	"faded_storm": Vector2.ZERO
}
const HUD_CANVAS_LAYER := 50
const DEMON_MENU_BUTTON_SIZE := Vector2(106.0, 106.0)
const DEMON_MENU_LEFT_OFFSET := 8.0
const DEMON_MENU_HEALTH_TOP_OVERLAP := 2.0
const DEMON_MENU_BOTTOM_OFFSET := -(HUD_BOTTOM_MARGIN + LIFE_BAR_SIZE.y - DEMON_MENU_HEALTH_TOP_OVERLAP)
const DEMON_MENU_TOP_OFFSET := DEMON_MENU_BOTTOM_OFFSET - DEMON_MENU_BUTTON_SIZE.y
const DEMON_MENU_PANEL_GAP := 14.0
const DEMON_LEVEL_LABEL_SIZE := Vector2(260.0, 48.0)
const DEMON_LEVEL_LABEL_GAP := 10.0
const DEMON_MENU_Z_INDEX := 1000
const CONFIG_MENU_BUTTON_SIZE := Vector2(172.0, 104.0)
const CONFIG_MENU_RIGHT_OFFSET := -8.0
const CONFIG_MENU_LEFT_OFFSET := CONFIG_MENU_RIGHT_OFFSET - CONFIG_MENU_BUTTON_SIZE.x
const CONFIG_MENU_BOTTOM_OFFSET := -POSSESSION_BAR_SIZE.y - 10.0
const CONFIG_MENU_TOP_OFFSET := CONFIG_MENU_BOTTOM_OFFSET - CONFIG_MENU_BUTTON_SIZE.y
const CONFIG_MENU_Z_INDEX := DEMON_MENU_Z_INDEX - 1
const CONFIG_PANEL_SIZE := Vector2(1080.0, 646.0)
const CONFIG_PANEL_TAB_AUDIO := "audio"
const CONFIG_PANEL_TAB_CONTROLS := "controls"
const CONFIG_PANEL_TAB_GRAPHICS := "graphics"
const CONFIG_PANEL_TAB_GAMEPLAY := "gameplay"
const CHARACTER_PANEL_SIZE := Vector2(1000.0, 700.0)
const CHARACTER_PANEL_BODY_SIZE := Vector2(972.0, 676.0)
const CHARACTER_PANEL_TAB_STATS := "stats"
const CHARACTER_PANEL_TAB_SPELLS := "spells"
const CHARACTER_PANEL_TAB_INVENTORY := "inventory"
const CHARACTER_PANEL_TAB_RELICS := "relics"
const CHARACTER_PANEL_TAB_MAP := "map"
const CHARACTER_PANEL_TAB_SKILL_TREE := "skill_tree"
const MAP_DEVICE_CARD_SIZE := Vector2(320.0, 442.0)
const MAP_DEVICE_STAGE_SIZE := Vector2(238.0, 292.0)
const MAP_DEVICE_INNER_CENTER := Vector2(121.0, 119.0)
const MAP_DEVICE_OUTER_SIZE := Vector2(174.0, 292.0)
const MAP_DEVICE_VORTEX_SIZE := Vector2(106.0, 106.0)
const MAP_DEVICE_STONE_RING_SIZE := Vector2(163.0, 115.0)
const MAP_DEVICE_VORTEX_ROTATION_SPEED := -0.14
const MAP_DEVICE_STONE_RING_ROTATION_SPEED := 0.11
const MAP_DEVICE_VORTEX_PULSE_SPEED := PI
const MAP_DEVICE_VORTEX_PULSE_AMOUNT := 0.05
const WORLD_MAP_PANEL_SIZE := Vector2(548.0, 442.0)
const WORLD_MAP_VIEW_SIZE := Vector2(512.0, 386.0)
const MAP_DESTINATION_BLACK_VAULT := "black_vault"
const MAP_DESTINATION_VELMORA := "velmora"
const MAP_DESTINATION_HOOFGROVE_WILDS := "hoofgrove_wilds"
const MAP_HOOFGROVE_UNLOCK_ID := "world-map-velmora-after-torren.png"
const LEVEL_UP_BLINK_SPEED := 0.35
const LEVEL_UP_FEEDBACK_SECONDS := 2.5
const LEVEL_UP_LABEL_FADE_SECONDS := 0.45
const CORRUPTION_STAGE_LINES := [
	"I am only near you.",
	"We are learning the same rhythm.",
	"Your hands answer faster than your thoughts.",
	"Do not call this control. Call it surrender.",
	"At last. No space between us."
]
const POSSESSION_FULL_FX_SECONDS := 3.0
const HEARTBEAT_MIX_RATE := 22050
const HEARTBEAT_SECONDS := 0.26
const DIALOGUE_OVERLAY_SIZE := Vector2(860.0, 370.0)
const DIALOGUE_FACE_SIZE := Vector2(132.0, 148.0)
const DIALOGUE_PORTRAIT_INSET := Vector2(22.0, 24.0)
const DIALOGUE_PORTRAIT_OFFSET := Vector2(0.0, 7.0)
const DIALOGUE_BOX_SIZE := Vector2(600.0, 142.0)
const DIALOGUE_TEXT_MARGIN := Vector2(34.0, 24.0)
const DIALOGUE_TEXT_SPEED := 18.0
const DIALOGUE_BOTTOM_CLEARANCE := 170.0
const DIALOGUE_SKIP_BUTTON_SIZE := Vector2(82.0, 30.0)
const DIALOGUE_SKIP_BUTTON_GAP := 10.0
const HOVER_READABLE_ALPHA := 0.96
const TOOLTIP_READABLE_ALPHA := 0.97

var _root_control: Control
var _hud_cluster: Control
var _spell_cluster: Control
var _skill_slot: Control
var _life_fill_clip: Control
var _life_fill_texture: TextureRect
var _life_hover_region: Button
var _exp_fill_clip: Control
var _possession_fill_clip: Control
var _possession_fill_texture: TextureRect
var _possession_hover_region: Button
var _possession_cluster: Control
var _skill_icon: TextureRect
var _skill_fallback_label: Label
var _skill_cooldown_label: Label
var _objective_label: Label
var _mission_panel: VBoxContainer
var _mission_title_label: Label
var _mission_list_label: Label
var _whisper_label: Label
var _minimap_cluster: Control
var _minimap_frame: TextureRect
var _minimap_marker_layer: Control
var _minimap_player_dot: Panel
var _minimap_enemy_dots: Array[Panel] = []
var _death_panel: PanelContainer
var _scroll_panel: PanelContainer
var _scroll_title_label: Label
var _scroll_body_label: Label
var _offer_panel: PanelContainer
var _offer_title_label: Label
var _offer_description_label: Label
var _offer_reward_label: Label
var _offer_cost_label: Label
var _shop_panel: PanelContainer
var _shop_title_label: Label
var _shop_wallet_label: Label
var _shop_status_label: Label
var _shop_items: VBoxContainer
var _shop_face: TextureRect
var _diamond_store_panel: PanelContainer
var _diamond_store_title_label: Label
var _diamond_store_wallet_label: Label
var _diamond_store_status_label: Label
var _diamond_store_grid: GridContainer
var _diamond_store_face: TextureRect
var _spell_store_panel: PanelContainer
var _spell_store_title_label: Label
var _spell_store_wallet_label: Label
var _spell_store_status_label: Label
var _spell_store_scroll: ScrollContainer
var _spell_store_content: VBoxContainer
var _spell_store_face: TextureRect
var _directive_panel: PanelContainer
var _directive_text_label: Label
var _directive_progress_label: Label
var _directive_time_fill: ColorRect
var _demon_menu_button: Button
var _demon_menu_image: TextureRect
var _demon_level_label: Label
var _config_menu_button: Button
var _config_menu_image: TextureRect
var _config_menu_label: Label
var _config_panel: PanelContainer
var _config_tab_content: VBoxContainer
var _config_tab_buttons := {}
var _config_panel_tab := CONFIG_PANEL_TAB_AUDIO
var _config_menu_hovered := false
var _config_silence_whisper := false
var _config_chant_volume := 80.0
var _config_echo_volume := 75.0
var _character_panel: PanelContainer
var _character_content_label: Label
var _spells_view: Control
var _spells_hover_label: Label
var _inventory_view: Control
var _inventory_status_label: Label
var _inventory_diamond_list: VBoxContainer
var _inventory_diamond_grid: GridContainer
var _inventory_bonus_list: VBoxContainer
var _inventory_socket_nodes: Array[Panel] = []
var _inventory_socket_icons: Array[TextureRect] = []
var _inventory_socket_ids: Array[String] = []
var _inventory_catalog_by_id := {}
var _inventory_drag_preview: TextureRect
var _inventory_dragging_diamond_id := ""
var _inventory_dragging_source_slot := -1
var _inventory_hovered_socket := -1
var _diamond_vfx_overlays: Array[Control] = []
var _diamond_tier_texture_cache := {}
var _relics_view: Control
var _relics_status_label: Label
var _relics_grid: GridContainer
var _map_view: Control
var _map_status_label: Label
var _map_teleport_device_button: Button
var _map_device_inner_vortex: TextureRect
var _map_device_stone_ring: TextureRect
var _world_map_image: TextureRect
var _map_destination_buttons := {}
var _map_destination_glows := {}
var _map_selecting_destination := false
var _skill_tree_view: SkillTreeView
var _character_tab_buttons := {}
var _spell_category_rows := {}
var _spells_view_signature := "__uninitialized__"
var _spells_hovered_name := ""
var _distortion_overlay: ColorRect
var _vignette_overlay: ColorRect
var _chromatic_flash_overlay: ColorRect
var _level_up_pulse_overlay: ColorRect
var _level_up_ember_layer: Control
var _vein_cracks_overlay: Control
var _heartbeat_pulse_overlay: ColorRect
var _screen_noise_overlay: ColorRect
var _heartbeat_player: AudioStreamPlayer
var _level_up_player: AudioStreamPlayer
var _whisper_tween: Tween
var _whispers_enabled := false
var _corruption := 0.0
var _corruption_ratio := 0.0
var _corruption_stage := -1
var _hp_percent := 1.0
var _ui_time := 0.0
var _passive_whisper_timer := 9.0
var _chromatic_flash_timer := 0.0
var _vein_flash_timer := 0.0
var _full_possession_timer := 0.0
var _possession_gain_timer := 0.0
var _minimap_blink_timer := 0.0
var _next_minimap_blink := 7.0
var _skill_glitch_timer := 0.0
var _heartbeat_timer := 0.0
var _skill_slot_base_position := Vector2.ZERO
var _latest_stats := {}
var _character_panel_tab := CHARACTER_PANEL_TAB_STATS
var _demon_menu_hovered := false
var _level_up_pending_ack := false
var _level_up_feedback_timer := 0.0
var _last_displayed_level := -1
var _possession_ratio := 0.0
var _rng: RandomNumberGenerator = RandomNumberGenerator.new()
var _spell_slot_hover_regions: Array[Control] = []
var _spell_slot_hover_tooltip: PanelContainer
var _spell_slot_hover_tooltip_label: Label
var _spell_slot_hovered_index := -1
var _spell_slot_picker_panel: PanelContainer
var _spell_slot_picker_title_label: Label
var _spell_slot_picker_row: HFlowContainer
var _spell_slot_picker_category := ""
var _dialogue_overlay: Control
var _dialogue_rows: VBoxContainer
var _dialogue_player_row: HBoxContainer
var _dialogue_npc_row: HBoxContainer
var _dialogue_player_label: Label
var _dialogue_npc_label: Label
var _dialogue_npc_face: TextureRect
var _dialogue_entries: Array[Dictionary] = []
var _dialogue_entry_index := -1
var _dialogue_active_label: Label
var _dialogue_active_full_text := ""
var _dialogue_visible_characters := 0.0
var _dialogue_line_complete := true
var _dialogue_auto_advance_pending := false

func _ready() -> void:
	layer = HUD_CANVAS_LAYER
	_rng.randomize()
	_make_ui()

func _process(delta: float) -> void:
	_lock_config_panel_rect()
	_update_corruption_fx(delta)
	_update_level_up_feedback(delta)
	_update_diamond_micro_vfx()
	_update_inventory_socket_glow()
	if not _inventory_dragging_diamond_id.is_empty() and not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		_finish_inventory_drag()
	_update_inventory_drag_preview()
	_update_map_tab_animation(delta)
	_update_dialogue_typewriter(delta)

func _input(event: InputEvent) -> void:
	_close_spell_slot_picker_from_outside_click(event)

func _unhandled_input(event: InputEvent) -> void:
	if _handle_config_panel_key(event):
		return
	if _is_dialogue_visible():
		if event is InputEventKey:
			var key_event := event as InputEventKey
			if key_event.pressed and not key_event.echo and (key_event.keycode == KEY_ENTER or key_event.keycode == KEY_KP_ENTER or key_event.is_action_pressed("ui_accept")):
				_advance_dialogue_click()
				var viewport := get_viewport()
				if viewport != null:
					viewport.set_input_as_handled()
				return
	if _handle_spell_slot_picker_global_click(event):
		return
	if _inventory_dragging_diamond_id.is_empty():
		return
	if event is InputEventMouseButton:
		var mouse_event := event as InputEventMouseButton
		if mouse_event.button_index == MOUSE_BUTTON_LEFT and not mouse_event.pressed:
			_finish_inventory_drag()

func update_stats(stats: Dictionary) -> void:
	if _life_fill_clip == null:
		return
	_latest_stats = stats.duplicate(true)
	var max_life: float = float(stats.get("max_life", 100))
	var life: float = float(stats.get("life", 100))
	_hp_percent = life / maxf(max_life, 1.0)
	_set_life_ratio(_hp_percent)
	var xp: float = float(stats.get("xp", 0))
	var xp_to_next: float = float(stats.get("xp_to_next", 100))
	_set_exp_ratio(xp / maxf(xp_to_next, 1.0))
	var next_level: int = int(stats.get("level", 1))
	if _last_displayed_level < 0:
		_last_displayed_level = next_level
	elif next_level > _last_displayed_level:
		_trigger_level_up_feedback(next_level - _last_displayed_level)
		_last_displayed_level = next_level
	else:
		_last_displayed_level = next_level
	var cooldown: float = float(stats.get("firestorm_cooldown", 0.0))
	if cooldown <= 0.05:
		_skill_icon.modulate = Color(1.0, 1.0, 1.0, 1.0)
		_skill_cooldown_label.text = ""
	else:
		_skill_icon.modulate = Color(1.0, 1.0, 1.0, 0.82)
		_skill_cooldown_label.text = "%.1f" % cooldown
	_refresh_bar_tooltips()
	if _character_panel != null and _character_panel.visible:
		_sync_character_panel()
	if _shop_panel != null and _shop_panel.visible:
		_shop_wallet_label.text = "Gold %s    Diamonds %s" % [stats.get("gold", 0), stats.get("diamonds", 0)]
	if _diamond_store_panel != null and _diamond_store_panel.visible:
		_diamond_store_wallet_label.text = "Gold %s" % stats.get("gold", 0)
	if _spell_store_panel != null and _spell_store_panel.visible:
		_spell_store_wallet_label.text = "Gold %s" % stats.get("gold", 0)
	if _spell_slot_hovered_index >= 0:
		_refresh_spell_slot_tooltip()
	if _spell_slot_picker_panel != null and _spell_slot_picker_panel.visible:
		_refresh_spell_slot_picker()
	_refresh_active_spell_slot_icons()

func set_objective(text: String) -> void:
	if _objective_label != null:
		_objective_label.text = _mission_title_case(text)

func set_missions(area_title: String, missions: Array[Dictionary]) -> void:
	if _mission_panel == null or _mission_title_label == null or _mission_list_label == null:
		return
	if missions.is_empty():
		_mission_panel.visible = false
		_mission_list_label.text = ""
		return
	_mission_title_label.text = "%s Missions" % area_title
	var lines: Array[String] = []
	for mission in missions:
		var text := _mission_title_case(String(mission.get("title", mission.get("text", ""))))
		lines.append("- %s" % text)
	_mission_list_label.text = "\n".join(lines)
	_mission_panel.visible = true

func set_possession_ratio(ratio: float) -> void:
	_possession_ratio = clampf(ratio, 0.0, 1.0)
	_set_possession_ratio(_possession_ratio)
	_refresh_bar_tooltips()
	if _character_panel != null and _character_panel.visible and _character_panel_tab == CHARACTER_PANEL_TAB_STATS:
		_sync_character_panel()

func set_corruption_ui(corruption: float, hp_percent: float = -1.0) -> void:
	var previous_corruption := _corruption
	_corruption = clampf(corruption, 0.0, 100.0)
	_corruption_ratio = _corruption / 100.0
	if _corruption > previous_corruption + 0.2:
		_possession_gain_timer = maxf(_possession_gain_timer, 0.24)
	if hp_percent >= 0.0:
		_hp_percent = clampf(hp_percent, 0.0, 1.0)
	_apply_corruption_stage()
	_update_static_corruption_layers()

func notify_kill_feedback(kill_streak: int) -> void:
	if _corruption >= 25.0:
		_minimap_blink_timer = maxf(_minimap_blink_timer, 0.16)
	if _corruption >= 25.0 and kill_streak >= 3:
		_chromatic_flash_timer = maxf(_chromatic_flash_timer, 0.34)
	if _corruption >= 50.0:
		_skill_glitch_timer = maxf(_skill_glitch_timer, 0.24)
	if _corruption >= 75.0 and kill_streak >= 4:
		_full_possession_timer = maxf(_full_possession_timer, 0.22)

func flash_offer_acceptance() -> void:
	_vein_flash_timer = maxf(_vein_flash_timer, 0.62)
	_chromatic_flash_timer = maxf(_chromatic_flash_timer, 0.18)
	_possession_gain_timer = maxf(_possession_gain_timer, 0.42)

func flash_possession_point() -> void:
	_vein_flash_timer = maxf(_vein_flash_timer, 0.9)
	_chromatic_flash_timer = maxf(_chromatic_flash_timer, 0.36)
	_possession_gain_timer = maxf(_possession_gain_timer, 0.74)

func update_minimap(player_position: Vector3, enemy_positions: Array[Vector3], arena_half_size: float) -> void:
	if _minimap_marker_layer == null or _minimap_player_dot == null:
		return
	var center := MINIMAP_SIZE * 0.5
	var radius := minf(MINIMAP_SIZE.x, MINIMAP_SIZE.y) * 0.32
	_place_minimap_dot(_minimap_player_dot, player_position, arena_half_size, center, radius, MINIMAP_PLAYER_DOT_SIZE)
	while _minimap_enemy_dots.size() < enemy_positions.size():
		var dot := _make_minimap_dot(Color(0.05, 0.58, 1.0, 1.0), MINIMAP_DOT_SIZE)
		_minimap_enemy_dots.append(dot)
		_minimap_marker_layer.add_child(dot)
	for i in range(_minimap_enemy_dots.size()):
		var dot := _minimap_enemy_dots[i]
		dot.visible = i < enemy_positions.size()
		if dot.visible:
			_place_minimap_dot(dot, enemy_positions[i], arena_half_size, center, radius, MINIMAP_DOT_SIZE)

func set_minimap_visible(visible: bool) -> void:
	if _minimap_cluster == null:
		return
	_minimap_cluster.visible = visible

func set_whispers_enabled(enabled: bool) -> void:
	_whispers_enabled = enabled
	if not enabled and _whisper_label != null:
		if _whisper_tween != null:
			_whisper_tween.kill()
			_whisper_tween = null
		_whisper_label.text = ""
		_whisper_label.modulate.a = 0.0

func whisper(text: String) -> void:
	if not _whispers_enabled:
		return
	_show_whisper(text)

func are_whispers_enabled() -> bool:
	return _whispers_enabled

func is_whisper_silenced() -> bool:
	return _config_silence_whisper

func get_chant_volume() -> float:
	return _config_chant_volume

func get_echo_volume() -> float:
	return _config_echo_volume

func _show_whisper(text: String) -> void:
	if _whisper_tween != null:
		_whisper_tween.kill()
	_whisper_label.text = "\"%s\"" % text
	_whisper_label.modulate = WHISPER_COLOR
	_whisper_tween = create_tween()
	_whisper_tween.tween_interval(WHISPER_VISIBLE_SECONDS)
	_whisper_tween.tween_property(_whisper_label, "modulate:a", 0.0, WHISPER_FADE_SECONDS)
	_whisper_tween.tween_callback(Callable(self, "_clear_whisper_text"))

func _clear_whisper_text() -> void:
	if _whisper_label != null:
		_whisper_label.text = ""
	_whisper_tween = null

func _show_voiced_whisper(text: String) -> void:
	_show_whisper(text)
	whisper_voice_requested.emit(text)

func show_death() -> void:
	_death_panel.visible = true

func hide_death() -> void:
	_death_panel.visible = false

func show_scroll(title: String, body: String) -> void:
	if _scroll_panel == null:
		return
	_scroll_title_label.text = title
	_scroll_body_label.text = body
	_scroll_panel.visible = true

func hide_scroll() -> void:
	if _scroll_panel != null:
		_scroll_panel.visible = false

func show_offer(offer: Dictionary) -> void:
	if _offer_panel == null:
		return
	_offer_title_label.text = String(offer.get("title", "Whisper"))
	_offer_description_label.text = "\"%s\"" % String(offer.get("description", "Take it."))
	_offer_reward_label.text = String(offer.get("reward", "Power."))
	_offer_cost_label.text = String(offer.get("cost_hint", "...you will not remain unchanged."))
	_offer_panel.visible = true

func hide_offer() -> void:
	if _offer_panel != null:
		_offer_panel.visible = false

func show_dialogue(entries: Array[Dictionary], npc_face_texture: Texture2D = null) -> void:
	if _dialogue_overlay == null or entries.is_empty():
		return
	_hide_config_panel()
	_hide_spell_slot_picker()
	hide_shop()
	hide_diamond_store()
	hide_spell_store()
	_dialogue_entries = entries.duplicate(true)
	_dialogue_entry_index = -1
	_dialogue_active_label = null
	_dialogue_active_full_text = ""
	_dialogue_visible_characters = 0.0
	_dialogue_line_complete = true
	_dialogue_auto_advance_pending = false
	_dialogue_player_label.text = ""
	_dialogue_npc_label.text = ""
	if _dialogue_npc_face != null:
		_dialogue_npc_face.texture = npc_face_texture
	_arrange_dialogue_rows_for_entries(_dialogue_entries)
	_dialogue_overlay.visible = true
	_dialogue_overlay.move_to_front()
	_advance_dialogue_line()

func hide_dialogue() -> void:
	if _dialogue_overlay != null:
		_dialogue_overlay.visible = false
	_dialogue_entries.clear()
	_dialogue_entry_index = -1
	_dialogue_active_label = null
	_dialogue_active_full_text = ""
	_dialogue_line_complete = true
	_dialogue_auto_advance_pending = false

func _update_dialogue_typewriter(delta: float) -> void:
	if _dialogue_overlay == null or not _dialogue_overlay.visible:
		return
	if _dialogue_line_complete:
		if _dialogue_auto_advance_pending:
			_dialogue_auto_advance_pending = false
			_advance_dialogue_line()
		return
	if _dialogue_active_label == null:
		return
	_dialogue_visible_characters += DIALOGUE_TEXT_SPEED * delta
	var next_count := mini(_dialogue_active_full_text.length(), int(_dialogue_visible_characters))
	_dialogue_active_label.visible_characters = next_count
	if next_count >= _dialogue_active_full_text.length():
		_complete_dialogue_line()

func _on_dialogue_box_gui_input(event: InputEvent) -> void:
	if not (event is InputEventMouseButton):
		return
	var mouse_event := event as InputEventMouseButton
	if mouse_event.button_index != MOUSE_BUTTON_LEFT or not mouse_event.pressed:
		return
	_advance_dialogue_click()
	var viewport := get_viewport()
	if viewport != null:
		viewport.set_input_as_handled()

func _advance_dialogue_click() -> void:
	if _dialogue_overlay == null or not _dialogue_overlay.visible:
		return
	if not _dialogue_line_complete:
		_complete_dialogue_line()

func _skip_dialogue() -> void:
	if not _is_dialogue_visible():
		return
	hide_dialogue()
	dialogue_finished.emit()

func _is_dialogue_visible() -> bool:
	return _dialogue_overlay != null and _dialogue_overlay.visible

func _advance_dialogue_line() -> void:
	_dialogue_entry_index += 1
	if _dialogue_entry_index >= _dialogue_entries.size():
		hide_dialogue()
		dialogue_finished.emit()
		return
	var entry: Dictionary = _dialogue_entries[_dialogue_entry_index]
	var speaker := String(entry.get("speaker", "")).strip_edges().to_lower()
	var text := String(entry.get("text", ""))
	if speaker.begins_with("player"):
		_dialogue_active_label = _dialogue_player_label
	else:
		_dialogue_active_label = _dialogue_npc_label
	if _dialogue_active_label == null:
		return
	_dialogue_active_full_text = text
	_dialogue_visible_characters = 0.0
	_dialogue_line_complete = false
	_dialogue_auto_advance_pending = false
	_dialogue_active_label.text = text
	_dialogue_active_label.visible_characters = 0

func _complete_dialogue_line() -> void:
	if _dialogue_active_label == null:
		return
	_dialogue_active_label.visible_characters = -1
	_dialogue_line_complete = true
	_dialogue_auto_advance_pending = true

func _arrange_dialogue_rows_for_entries(entries: Array[Dictionary]) -> void:
	if _dialogue_rows == null or _dialogue_player_row == null or _dialogue_npc_row == null:
		return
	if entries.is_empty():
		return
	var first_speaker := String(entries[0].get("speaker", "")).strip_edges().to_lower()
	if first_speaker.begins_with("player"):
		_dialogue_rows.move_child(_dialogue_player_row, 0)
		_dialogue_rows.move_child(_dialogue_npc_row, 1)
	else:
		_dialogue_rows.move_child(_dialogue_npc_row, 0)
		_dialogue_rows.move_child(_dialogue_player_row, 1)

func show_shop(title: String, items: Array[Dictionary], status_text: String, wallet_text: String, face_texture: Texture2D = null) -> void:
	if _shop_panel == null:
		return
	_hide_config_panel()
	_hide_spell_slot_picker()
	_shop_title_label.text = title
	_shop_wallet_label.text = wallet_text
	_shop_status_label.text = status_text
	if _shop_face != null:
		if face_texture != null:
			_shop_face.texture = face_texture
			_shop_face.visible = true
		else:
			_shop_face.visible = false
	for child in _shop_items.get_children():
		_shop_items.remove_child(child)
		child.queue_free()
	for item in items:
		_shop_items.add_child(_make_shop_item_button(item))
	_shop_panel.visible = true
	_shop_panel.move_to_front()

func hide_shop() -> void:
	if _shop_panel != null:
		_shop_panel.visible = false
	hide_diamond_store()
	hide_spell_store()
	shop_closed.emit()

func hide_character_panel() -> void:
	_set_character_panel_visible(false)

func is_mouse_over_character_panel() -> bool:
	if _character_panel == null or not _character_panel.visible:
		return false
	var viewport := get_viewport()
	if viewport == null:
		return false
	return _character_panel.get_global_rect().has_point(viewport.get_mouse_position())

func is_mouse_over_blocking_ui() -> bool:
	var viewport := get_viewport()
	if viewport == null:
		return false
	var mouse_position := viewport.get_mouse_position()
	if _character_panel != null and _character_panel.visible and _character_panel.get_global_rect().has_point(mouse_position):
		return true
	if _config_panel != null and _config_panel.visible and _config_panel.get_global_rect().has_point(mouse_position):
		return true
	if _shop_panel != null and _shop_panel.visible and _shop_panel.get_global_rect().has_point(mouse_position):
		return true
	if _diamond_store_panel != null and _diamond_store_panel.visible and _diamond_store_panel.get_global_rect().has_point(mouse_position):
		return true
	if _spell_store_panel != null and _spell_store_panel.visible and _spell_store_panel.get_global_rect().has_point(mouse_position):
		return true
	if _offer_panel != null and _offer_panel.visible and _offer_panel.get_global_rect().has_point(mouse_position):
		return true
	if _scroll_panel != null and _scroll_panel.visible and _scroll_panel.get_global_rect().has_point(mouse_position):
		return true
	if _death_panel != null and _death_panel.visible and _death_panel.get_global_rect().has_point(mouse_position):
		return true
	if _directive_panel != null and _directive_panel.visible and _directive_panel.get_global_rect().has_point(mouse_position):
		return true
	if _dialogue_overlay != null and _dialogue_overlay.visible and _dialogue_overlay.get_global_rect().has_point(mouse_position):
		return true
	return false

func handle_spell_store_mouse_wheel(event: InputEvent) -> bool:
	if not (event is InputEventMouseButton):
		return false
	var mouse_event := event as InputEventMouseButton
	if not mouse_event.pressed:
		return false
	if mouse_event.button_index != MOUSE_BUTTON_WHEEL_UP and mouse_event.button_index != MOUSE_BUTTON_WHEEL_DOWN:
		return false
	if _spell_store_panel == null or not _spell_store_panel.visible:
		return false
	var viewport := get_viewport()
	if viewport == null:
		return false
	var mouse_position := viewport.get_mouse_position()
	if not _spell_store_panel.get_global_rect().has_point(mouse_position):
		return false
	if _spell_store_scroll == null:
		viewport.set_input_as_handled()
		return true
	var vertical_bar := _spell_store_scroll.get_v_scroll_bar()
	if vertical_bar == null:
		viewport.set_input_as_handled()
		return true
	if vertical_bar.max_value <= 0.0:
		viewport.set_input_as_handled()
		return true
	var delta := -56 if mouse_event.button_index == MOUSE_BUTTON_WHEEL_UP else 56
	_spell_store_scroll.scroll_vertical = int(clampf(float(_spell_store_scroll.scroll_vertical + delta), 0.0, vertical_bar.max_value))
	viewport.set_input_as_handled()
	return true

func handle_skill_tree_mouse_wheel(event: InputEvent) -> bool:
	if not (event is InputEventMouseButton):
		return false
	var mouse_event := event as InputEventMouseButton
	if not mouse_event.pressed:
		return false
	if mouse_event.button_index != MOUSE_BUTTON_WHEEL_UP and mouse_event.button_index != MOUSE_BUTTON_WHEEL_DOWN:
		return false
	if _character_panel == null or not _character_panel.visible:
		return false
	if _character_panel_tab != CHARACTER_PANEL_TAB_SKILL_TREE:
		return false
	if _skill_tree_view == null or not _skill_tree_view.visible:
		return false
	var viewport := get_viewport()
	if viewport == null:
		return false
	var handled := _skill_tree_view.handle_mouse_wheel(viewport.get_mouse_position(), mouse_event.button_index, mouse_event.factor)
	if handled:
		viewport.set_input_as_handled()
	return handled

func is_blocking_ui_visible() -> bool:
	if _character_panel != null and _character_panel.visible:
		return true
	if _config_panel != null and _config_panel.visible:
		return true
	if _shop_panel != null and _shop_panel.visible:
		return true
	if _diamond_store_panel != null and _diamond_store_panel.visible:
		return true
	if _spell_store_panel != null and _spell_store_panel.visible:
		return true
	if _offer_panel != null and _offer_panel.visible:
		return true
	if _scroll_panel != null and _scroll_panel.visible:
		return true
	if _death_panel != null and _death_panel.visible:
		return true
	if _directive_panel != null and _directive_panel.visible:
		return true
	if _dialogue_overlay != null and _dialogue_overlay.visible:
		return true
	return false

func show_directive(directive: Dictionary) -> void:
	if _directive_panel == null:
		return
	_directive_text_label.text = String(directive.get("text", "Obey."))
	_directive_progress_label.text = ""
	_directive_time_fill.size.x = DIRECTIVE_PANEL_SIZE.x - 36.0
	_directive_panel.visible = true

func update_directive(progress_text: String, time_ratio: float) -> void:
	if _directive_panel == null:
		return
	_directive_progress_label.text = "Progress: %s" % progress_text
	_directive_time_fill.size.x = (DIRECTIVE_PANEL_SIZE.x - 36.0) * clampf(time_ratio, 0.0, 1.0)

func hide_directive() -> void:
	if _directive_panel != null:
		_directive_panel.visible = false

func set_corruption_distortion(ratio: float) -> void:
	if _distortion_overlay == null:
		return
	var alpha := clampf((ratio - 0.35) * 0.2, 0.0, 0.13)
	if ratio > _corruption_ratio:
		_chromatic_flash_timer = maxf(_chromatic_flash_timer, 0.22)
	_distortion_overlay.color = Color(0.52, 0.0, 0.04, alpha)

func _make_ui() -> void:
	var root: Control = Control.new()
	root.set_anchors_preset(Control.PRESET_FULL_RECT)
	root.theme = _hud_tooltip_theme()
	add_child(root)
	_root_control = root
	_make_corruption_fx_layers(root)

	var hud_cluster: Control = Control.new()
	hud_cluster.anchor_left = 0.0
	hud_cluster.anchor_top = 1.0
	hud_cluster.anchor_right = 0.0
	hud_cluster.anchor_bottom = 1.0
	hud_cluster.offset_left = 0.0
	hud_cluster.offset_top = -HUD_CLUSTER_SIZE.y
	hud_cluster.offset_right = HUD_CLUSTER_SIZE.x
	hud_cluster.offset_bottom = 0.0
	root.add_child(hud_cluster)
	_hud_cluster = hud_cluster

	var life_plate: Control = Control.new()
	life_plate.position = LIFE_BAR_POSITION
	life_plate.size = LIFE_BAR_SIZE
	hud_cluster.add_child(life_plate)

	var life_image: TextureRect = TextureRect.new()
	life_image.texture = LIFE_BAR_TEXTURE
	life_image.set_anchors_preset(Control.PRESET_FULL_RECT)
	life_image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	life_image.stretch_mode = TextureRect.STRETCH_SCALE
	life_plate.add_child(life_image)

	_life_fill_clip = Control.new()
	_life_fill_clip.position = LIFE_FILL_POSITION
	_life_fill_clip.size = LIFE_FILL_SIZE
	_life_fill_clip.clip_contents = true
	life_plate.add_child(_life_fill_clip)

	_life_fill_texture = TextureRect.new()
	_life_fill_texture.texture = LIFE_FILL_TEXTURE
	_life_fill_texture.position = Vector2.ZERO
	_life_fill_texture.size = LIFE_FILL_SIZE
	_life_fill_texture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_life_fill_texture.stretch_mode = TextureRect.STRETCH_SCALE
	_life_fill_clip.add_child(_life_fill_texture)

	_life_hover_region = _make_hover_region()
	_life_hover_region.set_anchors_preset(Control.PRESET_FULL_RECT)
	life_plate.add_child(_life_hover_region)

	var spell_cluster: Control = Control.new()
	spell_cluster.anchor_left = 0.5
	spell_cluster.anchor_top = 1.0
	spell_cluster.anchor_right = 0.5
	spell_cluster.anchor_bottom = 1.0
	spell_cluster.offset_left = -SPELL_SLOT_SIZE.x * 0.5
	spell_cluster.offset_top = -SPELL_SLOT_SIZE.y - SPELL_SLOT_BOTTOM_MARGIN
	spell_cluster.offset_right = SPELL_SLOT_SIZE.x * 0.5
	spell_cluster.offset_bottom = -SPELL_SLOT_BOTTOM_MARGIN
	root.add_child(spell_cluster)
	_spell_cluster = spell_cluster

	var exp_bar_texture: AtlasTexture = AtlasTexture.new()
	exp_bar_texture.atlas = EXP_BAR_TEXTURE
	exp_bar_texture.region = EXP_BAR_SOURCE_RECT

	var exp_fill_texture: AtlasTexture = AtlasTexture.new()
	exp_fill_texture.atlas = EXP_FILL_TEXTURE
	exp_fill_texture.region = EXP_FILL_SOURCE_RECT

	var exp_cluster: Control = Control.new()
	exp_cluster.anchor_left = 0.5
	exp_cluster.anchor_top = 1.0
	exp_cluster.anchor_right = 0.5
	exp_cluster.anchor_bottom = 1.0
	exp_cluster.offset_left = -EXP_BAR_SIZE.x * 0.5
	exp_cluster.offset_top = -SPELL_SLOT_BOTTOM_MARGIN - SPELL_SLOT_SIZE.y - EXP_BAR_SLOT_GAP - EXP_BAR_SIZE.y
	exp_cluster.offset_right = EXP_BAR_SIZE.x * 0.5
	exp_cluster.offset_bottom = -SPELL_SLOT_BOTTOM_MARGIN - SPELL_SLOT_SIZE.y - EXP_BAR_SLOT_GAP
	root.add_child(exp_cluster)

	var exp_bar: TextureRect = TextureRect.new()
	exp_bar.texture = exp_bar_texture
	exp_bar.set_anchors_preset(Control.PRESET_FULL_RECT)
	exp_bar.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	exp_bar.stretch_mode = TextureRect.STRETCH_SCALE
	exp_cluster.add_child(exp_bar)

	_exp_fill_clip = Control.new()
	_exp_fill_clip.position = EXP_FILL_POSITION
	_exp_fill_clip.size = Vector2.ZERO
	_exp_fill_clip.clip_contents = true
	exp_bar.add_child(_exp_fill_clip)

	var exp_fill: TextureRect = TextureRect.new()
	exp_fill.texture = exp_fill_texture
	exp_fill.position = Vector2.ZERO
	exp_fill.size = EXP_FILL_SIZE
	exp_fill.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	exp_fill.stretch_mode = TextureRect.STRETCH_SCALE
	_exp_fill_clip.add_child(exp_fill)

	var spell_slots: TextureRect = TextureRect.new()
	spell_slots.texture = SPELL_SLOT_TEXTURE
	spell_slots.set_anchors_preset(Control.PRESET_FULL_RECT)
	spell_slots.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	spell_slots.stretch_mode = TextureRect.STRETCH_SCALE
	spell_cluster.add_child(spell_slots)
	_make_spell_slot_hover_ui(spell_cluster)

	var skill_slot: Control = Control.new()
	skill_slot.position = _spell_slot_source_to_local(FIRESTORM_SLOT_CENTER_SOURCE) - FIRESTORM_ICON_SIZE * 0.5
	skill_slot.size = FIRESTORM_ICON_SIZE
	spell_cluster.add_child(skill_slot)
	_skill_slot = skill_slot
	_skill_slot_base_position = skill_slot.position

	_skill_icon = TextureRect.new()
	_skill_icon.texture = FIRESTORM_TEXTURE
	_skill_icon.set_anchors_preset(Control.PRESET_FULL_RECT)
	_skill_icon.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	_skill_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	_skill_icon.mouse_filter = Control.MOUSE_FILTER_STOP
	_skill_icon.mouse_entered.connect(_on_spell_slot_mouse_entered.bind(0))
	_skill_icon.mouse_exited.connect(_on_spell_slot_mouse_exited.bind(0))
	_skill_icon.gui_input.connect(_on_spell_slot_gui_input.bind(0))
	skill_slot.add_child(_skill_icon)

	_skill_fallback_label = _label("", 14)
	_skill_fallback_label.set_anchors_preset(Control.PRESET_FULL_RECT)
	_skill_fallback_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_skill_fallback_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_skill_fallback_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_skill_fallback_label.add_theme_color_override("font_color", Color(1.0, 0.9, 0.72))
	_skill_fallback_label.add_theme_color_override("font_outline_color", Color(0.0, 0.0, 0.0, 0.95))
	_skill_fallback_label.add_theme_constant_override("outline_size", 2)
	skill_slot.add_child(_skill_fallback_label)

	_skill_cooldown_label = _label("", SKILL_COOLDOWN_FONT_SIZE)
	_skill_cooldown_label.set_anchors_preset(Control.PRESET_FULL_RECT)
	_skill_cooldown_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	_skill_cooldown_label.vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM
	_skill_cooldown_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_skill_cooldown_label.add_theme_color_override("font_color", Color(1.0, 0.84, 0.62))
	skill_slot.add_child(_skill_cooldown_label)

	_make_mission_panel(root)

	_make_character_menu(root)
	_make_ritual_menu(root)

	var minimap_cluster: Control = Control.new()
	minimap_cluster.anchor_left = 1.0
	minimap_cluster.anchor_top = 0.0
	minimap_cluster.anchor_right = 1.0
	minimap_cluster.anchor_bottom = 0.0
	minimap_cluster.offset_left = -MINIMAP_SIZE.x - 14.0
	minimap_cluster.offset_top = 12.0
	minimap_cluster.offset_right = -14.0
	minimap_cluster.offset_bottom = MINIMAP_SIZE.y + 12.0
	root.add_child(minimap_cluster)
	_minimap_cluster = minimap_cluster
	_minimap_cluster.pivot_offset = MINIMAP_SIZE * 0.5

	var minimap_hole_shade: ColorRect = ColorRect.new()
	minimap_hole_shade.set_anchors_preset(Control.PRESET_FULL_RECT)
	minimap_hole_shade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	minimap_hole_shade.material = _shader_material("""
shader_type canvas_item;
uniform vec4 shade_color : source_color = vec4(0.01, 0.01, 0.01, 0.34);
uniform vec2 hole_center = vec2(0.5, 0.5);
uniform vec2 hole_radius = vec2(0.29, 0.44);
uniform float feather = 0.04;
void fragment() {
	vec2 normalized = (UV - hole_center) / hole_radius;
	float dist = length(normalized);
	float mask = 1.0 - smoothstep(1.0 - feather, 1.0, dist);
	COLOR = vec4(shade_color.rgb, shade_color.a * mask);
}
""")
	var minimap_hole_shade_material := minimap_hole_shade.material as ShaderMaterial
	if minimap_hole_shade_material != null:
		minimap_hole_shade_material.set_shader_parameter("shade_color", Color(0.01, 0.01, 0.01, MINIMAP_HOLE_SHADE_ALPHA))
	minimap_cluster.add_child(minimap_hole_shade)

	_minimap_marker_layer = Control.new()
	_minimap_marker_layer.set_anchors_preset(Control.PRESET_FULL_RECT)
	_minimap_marker_layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	minimap_cluster.add_child(_minimap_marker_layer)

	_minimap_player_dot = _make_minimap_dot(Color(1.0, 0.04, 0.02, 1.0), MINIMAP_PLAYER_DOT_SIZE)
	_minimap_marker_layer.add_child(_minimap_player_dot)

	var minimap_frame: TextureRect = TextureRect.new()
	minimap_frame.texture = MINIMAP_TEXTURE
	minimap_frame.set_anchors_preset(Control.PRESET_FULL_RECT)
	minimap_frame.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	minimap_frame.stretch_mode = TextureRect.STRETCH_SCALE
	minimap_frame.mouse_filter = Control.MOUSE_FILTER_IGNORE
	minimap_cluster.add_child(minimap_frame)
	_minimap_frame = minimap_frame
	_minimap_frame.pivot_offset = MINIMAP_SIZE * 0.5

	_whisper_label = _label("", WHISPER_FONT_SIZE)
	_whisper_label.add_theme_font_override("font", WHISPER_FONT)
	_whisper_label.anchor_left = 0.22
	_whisper_label.anchor_top = 1.0
	_whisper_label.anchor_right = 0.78
	_whisper_label.anchor_bottom = 1.0
	_whisper_label.offset_top = WHISPER_TOP_OFFSET
	_whisper_label.offset_bottom = WHISPER_BOTTOM_OFFSET
	_whisper_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_whisper_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_whisper_label.modulate = Color(WHISPER_COLOR.r, WHISPER_COLOR.g, WHISPER_COLOR.b, 0.0)
	root.add_child(_whisper_label)

	_make_offer_panel(root)
	_make_directive_panel(root)
	_make_shop_panel(root)
	_make_diamond_store_panel(root)
	_make_spell_store_panel(root)
	_make_dialogue_overlay(root)

	var possession_cluster: Control = Control.new()
	possession_cluster.anchor_left = 1.0
	possession_cluster.anchor_top = 1.0
	possession_cluster.anchor_right = 1.0
	possession_cluster.anchor_bottom = 1.0
	possession_cluster.offset_left = -POSSESSION_BAR_SIZE.x - 8.0
	possession_cluster.offset_top = -POSSESSION_BAR_SIZE.y - 4.0
	possession_cluster.offset_right = -8.0
	possession_cluster.offset_bottom = -4.0
	root.add_child(possession_cluster)
	_possession_cluster = possession_cluster
	_possession_cluster.pivot_offset = POSSESSION_BAR_SIZE * 0.5

	var possession_image: TextureRect = TextureRect.new()
	possession_image.texture = POSSESSION_BAR_TEXTURE
	possession_image.set_anchors_preset(Control.PRESET_FULL_RECT)
	possession_image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	possession_image.stretch_mode = TextureRect.STRETCH_SCALE
	possession_cluster.add_child(possession_image)

	_possession_fill_clip = Control.new()
	_possession_fill_clip.position = Vector2(POSSESSION_FILL_POSITION.x + POSSESSION_FILL_SIZE.x, POSSESSION_FILL_POSITION.y)
	_possession_fill_clip.size = Vector2.ZERO
	_possession_fill_clip.clip_contents = true
	possession_cluster.add_child(_possession_fill_clip)

	_possession_fill_texture = TextureRect.new()
	_possession_fill_texture.texture = POSSESSION_FILL_TEXTURE
	_possession_fill_texture.position = Vector2.ZERO
	_possession_fill_texture.size = POSSESSION_FILL_SIZE
	_possession_fill_texture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_possession_fill_texture.stretch_mode = TextureRect.STRETCH_SCALE
	_possession_fill_clip.add_child(_possession_fill_texture)

	_possession_hover_region = _make_hover_region()
	_possession_hover_region.set_anchors_preset(Control.PRESET_FULL_RECT)
	possession_cluster.add_child(_possession_hover_region)

	_death_panel = PanelContainer.new()
	_death_panel.visible = false
	_death_panel.anchor_left = 0.36
	_death_panel.anchor_top = 0.36
	_death_panel.anchor_right = 0.64
	_death_panel.anchor_bottom = 0.55
	_death_panel.add_theme_stylebox_override("panel", _panel_style(Color(0.04, 0.025, 0.03, 0.95)))
	root.add_child(_death_panel)

	var death_content: VBoxContainer = VBoxContainer.new()
	death_content.add_theme_constant_override("separation", 14)
	_death_panel.add_child(death_content)

	var death_label := _label("The Whisper keeps what remains.", 24)
	death_label.custom_minimum_size = Vector2(0.0, 78.0)
	death_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	death_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	death_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	death_content.add_child(death_label)

	var resurrect_button: Button = Button.new()
	resurrect_button.text = "Resurrect"
	resurrect_button.custom_minimum_size = Vector2(190.0, 42.0)
	resurrect_button.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	resurrect_button.focus_mode = Control.FOCUS_NONE
	resurrect_button.add_theme_font_size_override("font_size", 20)
	resurrect_button.add_theme_color_override("font_color", Color(1.0, 0.86, 0.66))
	resurrect_button.add_theme_stylebox_override("normal", _button_style(Color(0.27, 0.055, 0.04, 0.95)))
	resurrect_button.add_theme_stylebox_override("hover", _hover_button_style(Color(0.42, 0.09, 0.055, 0.98)))
	resurrect_button.add_theme_stylebox_override("pressed", _button_style(Color(0.18, 0.03, 0.025, 1.0)))
	resurrect_button.pressed.connect(_on_resurrect_button_pressed)
	death_content.add_child(resurrect_button)

	_scroll_panel = PanelContainer.new()
	_scroll_panel.visible = false
	_scroll_panel.anchor_left = 0.18
	_scroll_panel.anchor_top = 0.02
	_scroll_panel.anchor_right = 0.82
	_scroll_panel.anchor_bottom = 0.98
	_scroll_panel.add_theme_stylebox_override("panel", _scroll_panel_style())
	root.add_child(_scroll_panel)

	var scroll_content: VBoxContainer = VBoxContainer.new()
	scroll_content.add_theme_constant_override("separation", 10)
	_scroll_panel.add_child(scroll_content)

	_scroll_title_label = _label("", 28)
	_scroll_title_label.add_theme_color_override("font_color", Color(0.28, 0.08, 0.035))
	_scroll_title_label.add_theme_color_override("font_shadow_color", Color(1.0, 0.82, 0.48, 0.42))
	_scroll_title_label.add_theme_constant_override("shadow_offset_x", 1)
	_scroll_title_label.add_theme_constant_override("shadow_offset_y", 1)
	_scroll_title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_scroll_title_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_scroll_title_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_scroll_title_label.custom_minimum_size = Vector2(0.0, 54.0)
	scroll_content.add_child(_scroll_title_label)

	_scroll_body_label = _label("", 20)
	_scroll_body_label.add_theme_color_override("font_color", Color(0.16, 0.075, 0.035))
	_scroll_body_label.add_theme_color_override("font_shadow_color", Color(1.0, 0.86, 0.58, 0.35))
	_scroll_body_label.add_theme_constant_override("shadow_offset_x", 1)
	_scroll_body_label.add_theme_constant_override("shadow_offset_y", 1)
	_scroll_body_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_scroll_body_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_scroll_body_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_scroll_body_label.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll_content.add_child(_scroll_body_label)

	var close_scroll_button: Button = Button.new()
	close_scroll_button.text = "Close"
	close_scroll_button.custom_minimum_size = Vector2(150.0, 40.0)
	close_scroll_button.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	close_scroll_button.focus_mode = Control.FOCUS_NONE
	close_scroll_button.add_theme_font_size_override("font_size", 18)
	close_scroll_button.add_theme_color_override("font_color", Color(0.2, 0.06, 0.025))
	close_scroll_button.add_theme_stylebox_override("normal", _button_style(Color(0.78, 0.48, 0.22, 0.72)))
	close_scroll_button.add_theme_stylebox_override("hover", _hover_button_style(Color(0.92, 0.6, 0.28, 0.82)))
	close_scroll_button.add_theme_stylebox_override("pressed", _button_style(Color(0.58, 0.32, 0.14, 0.9)))
	close_scroll_button.pressed.connect(hide_scroll)
	scroll_content.add_child(close_scroll_button)

	_distortion_overlay = ColorRect.new()
	_distortion_overlay.color = Color(0.52, 0.0, 0.04, 0.0)
	_distortion_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	_distortion_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	root.add_child(_distortion_overlay)
	_whisper_label.move_to_front()
	_offer_panel.move_to_front()
	_directive_panel.move_to_front()
	_shop_panel.move_to_front()
	_death_panel.move_to_front()
	_scroll_panel.move_to_front()
	_demon_menu_button.move_to_front()
	_config_menu_button.move_to_front()
	_character_panel.move_to_front()
	_config_panel.move_to_front()

func _make_corruption_fx_layers(root: Control) -> void:
	_vignette_overlay = ColorRect.new()
	_vignette_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	_vignette_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_vignette_overlay.material = _shader_material("""
shader_type canvas_item;
uniform float strength = 0.0;
uniform vec4 tint : source_color = vec4(0.02, 0.0, 0.015, 1.0);
void fragment() {
	vec2 centered = UV * 2.0 - vec2(1.0);
	centered.x *= 1.18;
	float edge = smoothstep(0.48, 1.08, length(centered));
	COLOR = vec4(tint.rgb, edge * strength);
}
""")
	root.add_child(_vignette_overlay)

	_chromatic_flash_overlay = ColorRect.new()
	_chromatic_flash_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	_chromatic_flash_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_chromatic_flash_overlay.color = Color(0.0, 0.62, 1.0, 0.0)
	root.add_child(_chromatic_flash_overlay)

	_level_up_pulse_overlay = ColorRect.new()
	_level_up_pulse_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	_level_up_pulse_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_level_up_pulse_overlay.color = Color(0.42, 0.0, 0.0, 0.0)
	root.add_child(_level_up_pulse_overlay)

	_level_up_ember_layer = Control.new()
	_level_up_ember_layer.set_anchors_preset(Control.PRESET_FULL_RECT)
	_level_up_ember_layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	root.add_child(_level_up_ember_layer)

	_vein_cracks_overlay = Control.new()
	_vein_cracks_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	_vein_cracks_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	root.add_child(_vein_cracks_overlay)
	_make_vein_crack_lines()

	_heartbeat_pulse_overlay = ColorRect.new()
	_heartbeat_pulse_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	_heartbeat_pulse_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_heartbeat_pulse_overlay.color = Color(0.82, 0.0, 0.04, 0.0)
	root.add_child(_heartbeat_pulse_overlay)

	_screen_noise_overlay = ColorRect.new()
	_screen_noise_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	_screen_noise_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_screen_noise_overlay.material = _shader_material("""
shader_type canvas_item;
uniform float intensity = 0.0;
uniform float noise_time = 0.0;
float hash(vec2 p) {
	return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}
void fragment() {
	float grain = hash(floor(UV * vec2(360.0, 210.0)) + noise_time);
	float spark = step(0.965, grain);
	vec3 color = mix(vec3(0.05, 0.42, 0.72), vec3(0.86, 0.02, 0.03), step(0.5, grain));
	COLOR = vec4(color, spark * intensity);
}
""")
	root.add_child(_screen_noise_overlay)

	_heartbeat_player = AudioStreamPlayer.new()
	_heartbeat_player.stream = _make_heartbeat_stream()
	_heartbeat_player.volume_db = -18.0
	add_child(_heartbeat_player)

	_level_up_player = AudioStreamPlayer.new()
	_level_up_player.stream = LEVEL_UP_WHISPER_SOUND
	_level_up_player.volume_db = -4.0
	add_child(_level_up_player)

func _make_vein_crack_lines() -> void:
	var crack_sets := [
		[Vector2(0.0, 92.0), Vector2(86.0, 116.0), Vector2(126.0, 174.0), Vector2(216.0, 196.0)],
		[Vector2(1280.0, 76.0), Vector2(1190.0, 108.0), Vector2(1162.0, 168.0), Vector2(1086.0, 196.0)],
		[Vector2(44.0, 720.0), Vector2(94.0, 650.0), Vector2(144.0, 614.0), Vector2(182.0, 548.0)],
		[Vector2(1280.0, 628.0), Vector2(1218.0, 590.0), Vector2(1196.0, 536.0), Vector2(1126.0, 508.0)],
		[Vector2(640.0, 0.0), Vector2(616.0, 48.0), Vector2(650.0, 102.0), Vector2(626.0, 146.0)]
	]
	for points in crack_sets:
		var line: Line2D = Line2D.new()
		line.points = PackedVector2Array(points)
		line.width = 2.0
		line.default_color = Color(0.78, 0.0, 0.035, 0.0)
		line.joint_mode = Line2D.LINE_JOINT_SHARP
		_vein_cracks_overlay.add_child(line)
		for i in range(1, points.size() - 1):
			var branch: Line2D = Line2D.new()
			var start: Vector2 = points[i]
			var direction := Vector2(-18.0 + float(i) * 31.0, -52.0 + float(i) * 14.0)
			branch.points = PackedVector2Array([start, start + direction])
			branch.width = 1.2
			branch.default_color = Color(0.95, 0.05, 0.02, 0.0)
			branch.joint_mode = Line2D.LINE_JOINT_SHARP
			_vein_cracks_overlay.add_child(branch)

func _shader_material(shader_code: String) -> ShaderMaterial:
	var shader: Shader = Shader.new()
	shader.code = shader_code
	var material: ShaderMaterial = ShaderMaterial.new()
	material.shader = shader
	return material

func _make_heartbeat_stream() -> AudioStreamWAV:
	var stream: AudioStreamWAV = AudioStreamWAV.new()
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.mix_rate = HEARTBEAT_MIX_RATE
	stream.stereo = false
	var frames := int(float(HEARTBEAT_MIX_RATE) * HEARTBEAT_SECONDS)
	var bytes := PackedByteArray()
	for i in range(frames):
		var t := float(i) / float(HEARTBEAT_MIX_RATE)
		var envelope := exp(-t * 18.0)
		var second_bump := exp(-pow((t - 0.12) * 34.0, 2.0)) * 0.42
		var sample_value := (sin(TAU * 54.0 * t) * envelope + sin(TAU * 93.0 * t) * second_bump) * 0.38
		var sample := int(clampf(sample_value, -1.0, 1.0) * 32767.0)
		if sample < 0:
			sample = 65536 + sample
		bytes.append(sample & 0xff)
		bytes.append((sample >> 8) & 0xff)
	stream.data = bytes
	return stream

func _make_offer_panel(root: Control) -> void:
	_offer_panel = PanelContainer.new()
	_offer_panel.visible = false
	_offer_panel.anchor_left = 0.5
	_offer_panel.anchor_top = 0.5
	_offer_panel.anchor_right = 0.5
	_offer_panel.anchor_bottom = 0.5
	_offer_panel.offset_left = -WHISPER_PANEL_SIZE.x * 0.5
	_offer_panel.offset_top = -WHISPER_PANEL_SIZE.y * 0.5
	_offer_panel.offset_right = WHISPER_PANEL_SIZE.x * 0.5
	_offer_panel.offset_bottom = WHISPER_PANEL_SIZE.y * 0.5
	_offer_panel.add_theme_stylebox_override("panel", _panel_style(Color(0.035, 0.012, 0.018, 0.96)))
	root.add_child(_offer_panel)

	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", 8)
	_offer_panel.add_child(content)

	_offer_title_label = _label("Whisper", 27)
	_offer_title_label.add_theme_font_override("font", WHISPER_FONT)
	_offer_title_label.add_theme_color_override("font_color", WHISPER_COLOR)
	_offer_title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	content.add_child(_offer_title_label)

	_offer_description_label = _label("", 20)
	_offer_description_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_offer_description_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	content.add_child(_offer_description_label)

	_offer_reward_label = _label("", 16)
	_offer_reward_label.add_theme_color_override("font_color", Color(1.0, 0.76, 0.42))
	_offer_reward_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_offer_reward_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	content.add_child(_offer_reward_label)

	_offer_cost_label = _label("", 15)
	_offer_cost_label.add_theme_color_override("font_color", Color(0.76, 0.48, 0.48))
	_offer_cost_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_offer_cost_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	content.add_child(_offer_cost_label)

	var buttons: HBoxContainer = HBoxContainer.new()
	buttons.alignment = BoxContainer.ALIGNMENT_CENTER
	buttons.add_theme_constant_override("separation", 18)
	content.add_child(buttons)

	var accept_button := _whisper_button("Accept", Color(0.34, 0.035, 0.035, 0.96))
	accept_button.pressed.connect(_on_offer_accept_pressed)
	buttons.add_child(accept_button)

	var reject_button := _whisper_button("Refuse", Color(0.075, 0.07, 0.08, 0.96))
	reject_button.pressed.connect(_on_offer_reject_pressed)
	buttons.add_child(reject_button)

func _make_directive_panel(root: Control) -> void:
	_directive_panel = PanelContainer.new()
	_directive_panel.visible = false
	_directive_panel.anchor_left = 0.5
	_directive_panel.anchor_top = 0.0
	_directive_panel.anchor_right = 0.5
	_directive_panel.anchor_bottom = 0.0
	_directive_panel.offset_left = -DIRECTIVE_PANEL_SIZE.x * 0.5
	_directive_panel.offset_top = 20.0
	_directive_panel.offset_right = DIRECTIVE_PANEL_SIZE.x * 0.5
	_directive_panel.offset_bottom = 20.0 + DIRECTIVE_PANEL_SIZE.y
	_directive_panel.add_theme_stylebox_override("panel", _panel_style(Color(0.025, 0.018, 0.024, 0.9)))
	root.add_child(_directive_panel)

	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", 6)
	_directive_panel.add_child(content)

	_directive_text_label = _label("", 20)
	_directive_text_label.add_theme_font_override("font", WHISPER_FONT)
	_directive_text_label.add_theme_color_override("font_color", WHISPER_COLOR)
	_directive_text_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_directive_text_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	content.add_child(_directive_text_label)

	_directive_progress_label = _label("", 15)
	_directive_progress_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	content.add_child(_directive_progress_label)

	var time_back: ColorRect = ColorRect.new()
	time_back.color = Color(0.11, 0.075, 0.08, 0.86)
	time_back.custom_minimum_size = Vector2(DIRECTIVE_PANEL_SIZE.x - 36.0, 6.0)
	content.add_child(time_back)

	_directive_time_fill = ColorRect.new()
	_directive_time_fill.color = Color(0.9, 0.04, 0.03, 0.92)
	_directive_time_fill.size = Vector2(DIRECTIVE_PANEL_SIZE.x - 36.0, 6.0)
	time_back.add_child(_directive_time_fill)

func _make_shop_panel(root: Control) -> void:
	_shop_panel = PanelContainer.new()
	_shop_panel.visible = false
	_shop_panel.anchor_left = 0.5
	_shop_panel.anchor_top = 0.5
	_shop_panel.anchor_right = 0.5
	_shop_panel.anchor_bottom = 0.5
	_shop_panel.offset_left = -SHOP_PANEL_SIZE.x * 0.5
	_shop_panel.offset_top = -SHOP_PANEL_SIZE.y * 0.5
	_shop_panel.offset_right = SHOP_PANEL_SIZE.x * 0.5
	_shop_panel.offset_bottom = SHOP_PANEL_SIZE.y * 0.5
	_shop_panel.add_theme_stylebox_override("panel", _panel_style(Color(0.026, 0.018, 0.024, 0.97)))
	root.add_child(_shop_panel)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 18)
	margin.add_theme_constant_override("margin_top", 14)
	margin.add_theme_constant_override("margin_right", 18)
	margin.add_theme_constant_override("margin_bottom", 16)
	_shop_panel.add_child(margin)

	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", 6)
	margin.add_child(content)

	var header := HBoxContainer.new()
	header.add_theme_constant_override("separation", 8)
	content.add_child(header)

	_shop_title_label = _label("Vendor", 26)
	_shop_title_label.add_theme_color_override("font_color", Color(1.0, 0.72, 0.35))
	_shop_title_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header.add_child(_shop_title_label)

	_shop_face = TextureRect.new()
	_shop_face.custom_minimum_size = Vector2(64.0, 64.0)
	_shop_face.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	_shop_face.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	_shop_face.visible = false
	header.add_child(_shop_face)

	var close_button := Button.new()
	close_button.text = "X"
	close_button.custom_minimum_size = Vector2(34.0, 30.0)
	close_button.focus_mode = Control.FOCUS_NONE
	close_button.add_theme_font_size_override("font_size", 14)
	close_button.add_theme_color_override("font_color", Color(1.0, 0.86, 0.66))
	close_button.add_theme_stylebox_override("normal", _button_style(Color(0.12, 0.045, 0.04, 0.92)))
	close_button.add_theme_stylebox_override("hover", _hover_button_style(Color(0.25, 0.075, 0.055, 0.98)))
	close_button.add_theme_stylebox_override("pressed", _button_style(Color(0.075, 0.026, 0.026, 1.0)))
	close_button.pressed.connect(hide_shop)
	header.add_child(close_button)

	_shop_wallet_label = _label("", 17)
	_shop_wallet_label.add_theme_color_override("font_color", Color(0.76, 0.9, 1.0))
	content.add_child(_shop_wallet_label)

	_shop_status_label = _label("", 16)
	_shop_status_label.add_theme_color_override("font_color", Color(0.94, 0.82, 0.66))
	_shop_status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_shop_status_label.custom_minimum_size = Vector2(0.0, 46.0)
	content.add_child(_shop_status_label)

	var divider: ColorRect = ColorRect.new()
	divider.color = Color(0.95, 0.18, 0.045, 0.62)
	divider.custom_minimum_size = Vector2(0.0, 2.0)
	content.add_child(divider)

	_shop_items = VBoxContainer.new()
	_shop_items.add_theme_constant_override("separation", 8)
	_shop_items.size_flags_vertical = Control.SIZE_EXPAND_FILL
	content.add_child(_shop_items)

func _make_shop_item_button(item: Dictionary) -> Button:
	var button := Button.new()
	var label := "%s  -  %s" % [String(item.get("name", "Item")), String(item.get("price", ""))]
	var details := String(item.get("description", ""))
	if not details.is_empty():
		label += "\n%s" % details
	button.text = label
	button.custom_minimum_size = Vector2(0.0, 58.0)
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button.focus_mode = Control.FOCUS_NONE
	button.alignment = HORIZONTAL_ALIGNMENT_LEFT
	button.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	button.add_theme_font_size_override("font_size", 16)
	var item_color: Color = item.get("color", Color(1.0, 0.86, 0.66))
	if item_color is Color:
		button.add_theme_color_override("font_color", item_color)
	else:
		button.add_theme_color_override("font_color", Color(1.0, 0.86, 0.66))
	button.add_theme_stylebox_override("normal", _button_style(Color(0.055, 0.052, 0.058, 0.96)))
	button.add_theme_stylebox_override("hover", _hover_button_style(Color(0.16, 0.08, 0.07, 0.98)))
	button.add_theme_stylebox_override("pressed", _button_style(Color(0.04, 0.032, 0.038, 1.0)))
	button.pressed.connect(_on_shop_item_pressed.bind(String(item.get("id", ""))))
	return button

func _make_dialogue_overlay(root: Control) -> void:
	_dialogue_overlay = Control.new()
	_dialogue_overlay.visible = false
	_dialogue_overlay.anchor_left = 0.5
	_dialogue_overlay.anchor_top = 1.0
	_dialogue_overlay.anchor_right = 0.5
	_dialogue_overlay.anchor_bottom = 1.0
	_dialogue_overlay.offset_left = -DIALOGUE_OVERLAY_SIZE.x * 0.5
	_dialogue_overlay.offset_top = -DIALOGUE_OVERLAY_SIZE.y - DIALOGUE_BOTTOM_CLEARANCE
	_dialogue_overlay.offset_right = DIALOGUE_OVERLAY_SIZE.x * 0.5
	_dialogue_overlay.offset_bottom = -DIALOGUE_BOTTOM_CLEARANCE
	_dialogue_overlay.custom_minimum_size = DIALOGUE_OVERLAY_SIZE
	_dialogue_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	_dialogue_overlay.gui_input.connect(_on_dialogue_box_gui_input)
	root.add_child(_dialogue_overlay)

	var rows := VBoxContainer.new()
	rows.set_anchors_preset(Control.PRESET_FULL_RECT)
	rows.offset_top = DIALOGUE_SKIP_BUTTON_SIZE.y + DIALOGUE_SKIP_BUTTON_GAP
	rows.add_theme_constant_override("separation", 10)
	rows.alignment = BoxContainer.ALIGNMENT_CENTER
	_dialogue_overlay.add_child(rows)
	_dialogue_rows = rows

	var player_row := HBoxContainer.new()
	player_row.add_theme_constant_override("separation", 12)
	player_row.alignment = BoxContainer.ALIGNMENT_CENTER
	rows.add_child(player_row)
	_dialogue_player_row = player_row
	player_row.add_child(_make_dialogue_face(DIALOGUE_PLAYER_FACE_TEXTURE, false))
	_dialogue_player_label = _make_dialogue_box(player_row)

	var npc_row := HBoxContainer.new()
	npc_row.add_theme_constant_override("separation", 12)
	npc_row.alignment = BoxContainer.ALIGNMENT_CENTER
	rows.add_child(npc_row)
	_dialogue_npc_row = npc_row
	_dialogue_npc_label = _make_dialogue_box(npc_row)
	var npc_face_slot := _make_dialogue_face(null, true)
	npc_row.add_child(npc_face_slot)

	var skip_button := Button.new()
	skip_button.text = "Skip"
	skip_button.anchor_left = 0.5
	skip_button.anchor_top = 0.0
	skip_button.anchor_right = 0.5
	skip_button.anchor_bottom = 0.0
	skip_button.offset_left = -DIALOGUE_SKIP_BUTTON_SIZE.x * 0.5
	skip_button.offset_top = 0.0
	skip_button.offset_right = DIALOGUE_SKIP_BUTTON_SIZE.x * 0.5
	skip_button.offset_bottom = DIALOGUE_SKIP_BUTTON_SIZE.y
	skip_button.custom_minimum_size = DIALOGUE_SKIP_BUTTON_SIZE
	skip_button.focus_mode = Control.FOCUS_NONE
	skip_button.add_theme_font_size_override("font_size", 14)
	skip_button.add_theme_color_override("font_color", Color(1.0, 0.86, 0.66))
	skip_button.add_theme_stylebox_override("normal", _button_style(Color(0.12, 0.045, 0.04, 0.92)))
	skip_button.add_theme_stylebox_override("hover", _hover_button_style(Color(0.25, 0.075, 0.055, 0.98)))
	skip_button.add_theme_stylebox_override("pressed", _button_style(Color(0.075, 0.026, 0.026, 1.0)))
	skip_button.pressed.connect(_skip_dialogue)
	_dialogue_overlay.add_child(skip_button)

func _make_dialogue_face(face_texture: Texture2D, remember_as_npc: bool) -> Control:
	var frame := Control.new()
	frame.custom_minimum_size = DIALOGUE_FACE_SIZE
	frame.clip_contents = true
	frame.mouse_filter = Control.MOUSE_FILTER_IGNORE

	var frame_texture := TextureRect.new()
	frame_texture.texture = _texture_from_path(DIALOGUE_FACE_FRAME_TEXTURE_PATH)
	frame_texture.set_anchors_preset(Control.PRESET_FULL_RECT)
	frame_texture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	frame_texture.stretch_mode = TextureRect.STRETCH_SCALE
	frame_texture.mouse_filter = Control.MOUSE_FILTER_IGNORE
	frame_texture.z_index = 0
	frame.add_child(frame_texture)

	var portrait := TextureRect.new()
	portrait.set_anchors_preset(Control.PRESET_FULL_RECT)
	portrait.offset_left = DIALOGUE_PORTRAIT_INSET.x + DIALOGUE_PORTRAIT_OFFSET.x
	portrait.offset_top = DIALOGUE_PORTRAIT_INSET.y + DIALOGUE_PORTRAIT_OFFSET.y
	portrait.offset_right = -DIALOGUE_PORTRAIT_INSET.x + DIALOGUE_PORTRAIT_OFFSET.x
	portrait.offset_bottom = -DIALOGUE_PORTRAIT_INSET.y + DIALOGUE_PORTRAIT_OFFSET.y
	portrait.texture = face_texture
	portrait.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	portrait.mouse_filter = Control.MOUSE_FILTER_IGNORE
	portrait.z_index = 10
	frame.add_child(portrait)
	portrait.move_to_front()
	if remember_as_npc:
		_dialogue_npc_face = portrait
	return frame

func _make_dialogue_box(parent: Control) -> Label:
	var box := TextureRect.new()
	box.texture = _texture_from_path(DIALOGUE_BOX_TEXTURE_PATH)
	box.custom_minimum_size = DIALOGUE_BOX_SIZE
	box.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	box.stretch_mode = TextureRect.STRETCH_SCALE
	box.mouse_filter = Control.MOUSE_FILTER_STOP
	box.gui_input.connect(_on_dialogue_box_gui_input)
	parent.add_child(box)

	var label := _label("", 18)
	label.set_anchors_preset(Control.PRESET_FULL_RECT)
	label.offset_left = DIALOGUE_TEXT_MARGIN.x
	label.offset_top = DIALOGUE_TEXT_MARGIN.y
	label.offset_right = -DIALOGUE_TEXT_MARGIN.x
	label.offset_bottom = -DIALOGUE_TEXT_MARGIN.y
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_color_override("font_color", Color(0.95, 0.87, 0.72))
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	box.add_child(label)
	return label

# ─── Diamond Store ────────────────────────────────────────────────────────────

func _make_diamond_store_panel(root: Control) -> void:
	_diamond_store_panel = PanelContainer.new()
	_diamond_store_panel.visible = false
	_diamond_store_panel.anchor_left = 0.5
	_diamond_store_panel.anchor_top = 0.5
	_diamond_store_panel.anchor_right = 0.5
	_diamond_store_panel.anchor_bottom = 0.5
	_diamond_store_panel.offset_left = -DIAMOND_STORE_PANEL_SIZE.x * 0.5
	_diamond_store_panel.offset_top = -DIAMOND_STORE_PANEL_SIZE.y * 0.5
	_diamond_store_panel.offset_right = DIAMOND_STORE_PANEL_SIZE.x * 0.5
	_diamond_store_panel.offset_bottom = DIAMOND_STORE_PANEL_SIZE.y * 0.5
	_diamond_store_panel.custom_minimum_size = DIAMOND_STORE_PANEL_SIZE
	_diamond_store_panel.clip_contents = true
	_diamond_store_panel.add_theme_stylebox_override("panel", _panel_style(Color(0.026, 0.018, 0.024, 0.97)))
	root.add_child(_diamond_store_panel)

	var fixed_body := Control.new()
	fixed_body.custom_minimum_size = DIAMOND_STORE_BODY_SIZE
	fixed_body.clip_contents = true
	fixed_body.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	fixed_body.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_diamond_store_panel.add_child(fixed_body)

	var margin := MarginContainer.new()
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 18)
	margin.add_theme_constant_override("margin_top", 14)
	margin.add_theme_constant_override("margin_right", 18)
	margin.add_theme_constant_override("margin_bottom", 16)
	fixed_body.add_child(margin)

	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", 10)
	margin.add_child(content)

	var header := HBoxContainer.new()
	header.add_theme_constant_override("separation", 8)
	content.add_child(header)

	_diamond_store_title_label = _label("Diamond Broker", 26)
	_diamond_store_title_label.add_theme_color_override("font_color", Color(1.0, 0.72, 0.35))
	_diamond_store_title_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header.add_child(_diamond_store_title_label)

	_diamond_store_face = TextureRect.new()
	_diamond_store_face.custom_minimum_size = Vector2(64.0, 64.0)
	_diamond_store_face.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	_diamond_store_face.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	_diamond_store_face.visible = false
	header.add_child(_diamond_store_face)

	var close_btn := Button.new()
	close_btn.text = "X"
	close_btn.custom_minimum_size = Vector2(34.0, 30.0)
	close_btn.focus_mode = Control.FOCUS_NONE
	close_btn.add_theme_font_size_override("font_size", 14)
	close_btn.add_theme_color_override("font_color", Color(1.0, 0.86, 0.66))
	close_btn.add_theme_stylebox_override("normal", _button_style(Color(0.12, 0.045, 0.04, 0.92)))
	close_btn.add_theme_stylebox_override("hover", _hover_button_style(Color(0.25, 0.075, 0.055, 0.98)))
	close_btn.add_theme_stylebox_override("pressed", _button_style(Color(0.075, 0.026, 0.026, 1.0)))
	close_btn.pressed.connect(hide_diamond_store)
	header.add_child(close_btn)

	_diamond_store_wallet_label = _label("", 17)
	_diamond_store_wallet_label.add_theme_color_override("font_color", Color(0.76, 0.9, 1.0))
	content.add_child(_diamond_store_wallet_label)

	_diamond_store_status_label = _label("", 16)
	_diamond_store_status_label.add_theme_color_override("font_color", Color(0.94, 0.82, 0.66))
	_diamond_store_status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_diamond_store_status_label.custom_minimum_size = Vector2(0.0, 42.0)
	_diamond_store_status_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content.add_child(_diamond_store_status_label)

	var divider := ColorRect.new()
	divider.color = Color(0.95, 0.18, 0.045, 0.62)
	divider.custom_minimum_size = Vector2(0.0, 2.0)
	content.add_child(divider)

	_diamond_store_grid = GridContainer.new()
	_diamond_store_grid.columns = 6
	_diamond_store_grid.add_theme_constant_override("h_separation", 8)
	_diamond_store_grid.add_theme_constant_override("v_separation", 8)
	_diamond_store_grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_diamond_store_grid.size_flags_vertical = Control.SIZE_EXPAND_FILL
	content.add_child(_diamond_store_grid)

func show_diamond_store(title: String, items: Array[Dictionary], wallet_text: String, status_text: String, face_texture: Texture2D = null) -> void:
	if _diamond_store_panel == null:
		return
	_hide_config_panel()
	_hide_spell_slot_picker()
	_diamond_store_title_label.text = title
	_diamond_store_wallet_label.text = wallet_text
	_diamond_store_status_label.text = status_text
	if _diamond_store_face != null:
		if face_texture != null:
			_diamond_store_face.texture = face_texture
			_diamond_store_face.visible = true
		else:
			_diamond_store_face.visible = false
	for child in _diamond_store_grid.get_children():
		_diamond_store_grid.remove_child(child)
		child.queue_free()
	for item in items:
		_diamond_store_grid.add_child(_make_diamond_cell(item))
	_diamond_store_panel.visible = true
	_diamond_store_panel.move_to_front()
	if _spell_store_panel != null:
		_spell_store_panel.visible = false
	if _shop_panel != null:
		_shop_panel.visible = false

func hide_diamond_store() -> void:
	if _diamond_store_panel != null:
		_diamond_store_panel.visible = false

func _make_diamond_visual(diamond_id: String, gem_color: Color, visual_size: Vector2, muted: bool = false) -> Control:
	var frame := Control.new()
	frame.custom_minimum_size = visual_size
	frame.size = visual_size
	frame.mouse_filter = Control.MOUSE_FILTER_IGNORE
	frame.clip_contents = false

	var display_color := _diamond_display_color(diamond_id, gem_color)
	var diamond_tex := TextureRect.new()
	diamond_tex.texture = _diamond_texture_for_id(diamond_id)
	diamond_tex.set_anchors_preset(Control.PRESET_FULL_RECT)
	diamond_tex.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	diamond_tex.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	diamond_tex.modulate = display_color.darkened(0.55) if muted else display_color
	diamond_tex.mouse_filter = Control.MOUSE_FILTER_IGNORE
	frame.add_child(diamond_tex)

	var overlay := Control.new()
	overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	overlay.draw.connect(_draw_diamond_micro_vfx.bind(overlay, diamond_id, display_color, muted))
	frame.add_child(overlay)
	_diamond_vfx_overlays.append(overlay)
	return frame

func _diamond_texture_for_id(diamond_id: String) -> Texture2D:
	var clean_id := diamond_id.strip_edges().to_lower()
	var path := DIAMOND_FADED_TEXTURE_PATH
	if clean_id.begins_with("whispering_"):
		path = DIAMOND_WHISPERING_TEXTURE_PATH
	elif clean_id.begins_with("corrupted_"):
		path = DIAMOND_CORRUPTED_TEXTURE_PATH
	elif clean_id.begins_with("abyssal_"):
		path = DIAMOND_ABYSSAL_TEXTURE_PATH
	elif clean_id.begins_with("divine_"):
		path = DIAMOND_DIVINE_TEXTURE_PATH
	return _cached_diamond_tier_texture(path)

func _cached_diamond_tier_texture(path: String) -> Texture2D:
	if _diamond_tier_texture_cache.has(path):
		var cached := _diamond_tier_texture_cache[path] as Texture2D
		return cached if cached != null else DIAMOND_TEXTURE
	var texture := _texture_from_path(path)
	if texture == null:
		texture = DIAMOND_TEXTURE
	_diamond_tier_texture_cache[path] = texture
	return texture

func _update_diamond_micro_vfx() -> void:
	if _diamond_vfx_overlays.is_empty():
		return
	var alive_overlays: Array[Control] = []
	for overlay in _diamond_vfx_overlays:
		if is_instance_valid(overlay):
			overlay.queue_redraw()
			alive_overlays.append(overlay)
	_diamond_vfx_overlays = alive_overlays

func _draw_diamond_micro_vfx(overlay: Control, diamond_id: String, gem_color: Color, muted: bool) -> void:
	if overlay == null or muted:
		return
	var rect := Rect2(Vector2.ZERO, overlay.size)
	var center := overlay.size * 0.5
	var size := minf(rect.size.x, rect.size.y)
	if size <= 0.0:
		return
	var unit := size / 48.0
	var pulse := 0.5 + 0.5 * sin(_ui_time * 3.4)
	var slow := 0.5 + 0.5 * sin(_ui_time * 1.55)
	var sparkle_color := gem_color.lightened(0.38)

	overlay.draw_arc(center + Vector2(0.0, 5.0) * unit, 19.0 * unit + slow * 1.4 * unit, 0.02 * TAU, 0.98 * TAU, 48, Color(sparkle_color.r, sparkle_color.g, sparkle_color.b, 0.035 + pulse * 0.035), 1.0 * unit, true)
	for i in range(3):
		var drift := _ui_time * (0.55 + float(i) * 0.12) + float(i) * 2.17
		var mote := center + Vector2(cos(drift) * (15.5 + float(i) * 1.2), sin(drift * 1.21) * 8.5 + 7.0) * unit
		var alpha := (0.14 + 0.1 * sin(drift * 2.3)) * (0.45 + pulse * 0.55)
		overlay.draw_circle(mote, (0.75 + float(i % 2) * 0.28) * unit, Color(sparkle_color.r, sparkle_color.g, sparkle_color.b, alpha))

	var glint_phase := 0.5 + 0.5 * sin(_ui_time * 2.2 + float(diamond_id.hash() % 17))
	if glint_phase > 0.52:
		var glint_alpha := (glint_phase - 0.52) / 0.48
		_draw_diamond_glint(overlay, center + Vector2(8.5, -11.0) * unit, 4.2 * unit, Color(1.0, 1.0, 0.92, glint_alpha * 0.36))
		var sweep_y := center.y - 4.0 * unit + glint_alpha * 10.0 * unit
		overlay.draw_line(Vector2(center.x - 20.0 * unit, sweep_y), Vector2(center.x + 20.0 * unit, sweep_y - 5.0 * unit), Color(1.0, 1.0, 0.9, glint_alpha * 0.12), 1.0 * unit, true)

	match diamond_id:
		"faded_storm":
			var jitter := sin(_ui_time * 24.0) * 1.1 * unit
			var bolt := PackedVector2Array([
				center + Vector2(6.5, -15.0) * unit,
				center + Vector2(0.5, -5.5) * unit + Vector2(jitter, 0.0),
				center + Vector2(5.0, -2.5) * unit,
				center + Vector2(-1.5, 12.0) * unit - Vector2(jitter * 0.7, 0.0)
			])
			var fork := PackedVector2Array([
				center + Vector2(0.5, -5.5) * unit + Vector2(jitter, 0.0),
				center + Vector2(-7.0, 1.5) * unit,
				center + Vector2(-4.0, 7.5) * unit
			])
			overlay.draw_polyline(bolt, Color(0.18, 0.88, 1.0, 0.3 + pulse * 0.18), 4.0 * unit, true)
			overlay.draw_polyline(fork, Color(0.18, 0.88, 1.0, 0.2 + pulse * 0.14), 2.4 * unit, true)
			overlay.draw_polyline(bolt, Color(1.0, 0.96, 0.18, 0.64 + pulse * 0.26), 1.25 * unit, true)
			overlay.draw_polyline(fork, Color(1.0, 0.96, 0.18, 0.42 + pulse * 0.2), 0.9 * unit, true)
			for i in range(3):
				var spark := center + Vector2(14.0 - float(i) * 11.0, -10.0 + sin(_ui_time * 8.0 + float(i)) * 13.0) * unit
				_draw_diamond_glint(overlay, spark, (2.2 + pulse) * unit, Color(1.0, 0.93, 0.25, 0.34))
		"faded_frostbind":
			for i in range(6):
				var angle := _ui_time * 0.45 + float(i) * TAU / 6.0
				var point := center + Vector2(cos(angle) * 14.0, sin(angle * 0.92) * 8.0 + 3.0) * unit
				overlay.draw_circle(point, 0.8 * unit, Color(0.82, 0.97, 1.0, 0.28))
				overlay.draw_line(point + Vector2(-1.9, 0.0) * unit, point + Vector2(1.9, 0.0) * unit, Color(0.88, 0.98, 1.0, 0.22), 0.8 * unit, true)
				overlay.draw_line(point + Vector2(0.0, -1.9) * unit, point + Vector2(0.0, 1.9) * unit, Color(0.88, 0.98, 1.0, 0.18), 0.8 * unit, true)
				overlay.draw_line(point + Vector2(-1.4, -1.4) * unit, point + Vector2(1.4, 1.4) * unit, Color(0.88, 0.98, 1.0, 0.14), 0.7 * unit, true)
		"faded_flame_ring":
			overlay.draw_arc(center + Vector2(0.0, 5.0) * unit, 15.0 * unit + pulse * 1.4 * unit, 0.13 * TAU, 0.88 * TAU, 28, Color(1.0, 0.44, 0.06, 0.24 + pulse * 0.24), 2.0 * unit, true)
			overlay.draw_arc(center + Vector2(0.0, 5.0) * unit, 11.0 * unit + pulse * unit, 0.62 * TAU, 1.12 * TAU, 24, Color(1.0, 0.82, 0.22, 0.16 + pulse * 0.16), 1.15 * unit, true)
			for i in range(4):
				var ember_angle := _ui_time * 1.8 + float(i) * TAU / 4.0
				var ember := center + Vector2(cos(ember_angle) * 13.0, sin(ember_angle) * 5.5 + 7.0) * unit
				overlay.draw_circle(ember, (1.1 + pulse * 0.45) * unit, Color(1.0, 0.28, 0.04, 0.24 + pulse * 0.18))
		"faded_corruption":
			overlay.draw_arc(center, 18.0 * unit + slow * 1.8 * unit, _ui_time * 0.35, _ui_time * 0.35 + PI * 1.25, 34, Color(0.7, 0.12, 1.0, 0.2 + slow * 0.2), 1.7 * unit, true)
			overlay.draw_arc(center + Vector2(0.0, 1.5) * unit, 13.0 * unit + slow * 1.2 * unit, PI + _ui_time * 0.25, PI * 1.95 + _ui_time * 0.25, 22, Color(0.36, 0.0, 0.72, 0.18 + slow * 0.16), 2.4 * unit, true)
			overlay.draw_circle(center + Vector2(-8.0, 8.0) * unit, (1.2 + slow * 0.7) * unit, Color(0.86, 0.22, 1.0, 0.16 + slow * 0.12))
		"faded_rush":
			for i in range(3):
				var y := 12.0 + float(i) * 7.0 + sin(_ui_time * 4.5 + float(i)) * 1.2
				var start := Vector2(3.0, y) * unit
				var finish := Vector2(20.0 + pulse * 6.0 + float(i) * 2.0, y - 3.2) * unit
				overlay.draw_line(start, finish, Color(1.0, 0.66, 0.22, 0.22 + pulse * 0.2), 1.25 * unit, true)
				overlay.draw_line(start + Vector2(-4.0, 3.0) * unit, finish - Vector2(5.0, -1.0) * unit, Color(1.0, 0.34, 0.05, 0.12 + pulse * 0.14), 1.0 * unit, true)
		"faded_focus":
			overlay.draw_arc(center + Vector2(0.0, 1.0) * unit, 15.0 * unit, 0.0, TAU, 48, Color(0.42, 0.95, 1.0, 0.08 + pulse * 0.08), 1.0 * unit, true)
			for i in range(2):
				var y := center.y + (-5.0 + float(i) * 10.0 + sin(_ui_time * 2.0 + float(i)) * 0.7) * unit
				overlay.draw_line(Vector2(center.x - 15.0 * unit, y), Vector2(center.x + 15.0 * unit, y), Color(0.42, 0.95, 1.0, 0.2 + pulse * 0.14), 1.0 * unit, true)
			_draw_diamond_glint(overlay, center + Vector2(-7.0, -8.0) * unit, 3.0 * unit, Color(0.72, 1.0, 1.0, 0.2 + pulse * 0.16))
		"faded_vitality":
			for i in range(4):
				var lift := 14.0 - fposmod(_ui_time * (9.0 + float(i)) + float(i) * 5.0, 22.0)
				var x := -12.0 + float(i) * 8.0 + sin(_ui_time * 1.8 + float(i)) * 1.6
				var point := center + Vector2(x, lift + 7.0) * unit
				overlay.draw_line(point + Vector2(-1.9, 0.0) * unit, point + Vector2(1.9, 0.0) * unit, Color(0.24, 1.0, 0.58, 0.28), 1.05 * unit, true)
				overlay.draw_line(point + Vector2(0.0, -1.9) * unit, point + Vector2(0.0, 1.9) * unit, Color(0.24, 1.0, 0.58, 0.26), 1.05 * unit, true)
		"faded_fortune":
			for i in range(5):
				var phase := _ui_time * 1.6 + float(i) * 1.37
				var point := center + Vector2(cos(phase) * 15.0, sin(phase * 1.3) * 9.0 + 3.0) * unit
				overlay.draw_circle(point, 1.0 * unit, Color(1.0, 0.72, 0.12, 0.11 + pulse * 0.08))
				_draw_diamond_glint(overlay, point, (2.1 + sin(phase) * 0.7) * unit, Color(1.0, 0.86, 0.22, 0.2 + pulse * 0.19))
		"faded_echo":
			for i in range(2):
				var radius := (12.5 + float(i) * 4.5 + pulse * 1.4) * unit
				overlay.draw_arc(center + Vector2(-2.0 + float(i) * 4.0, 0.0) * unit, radius, -0.18 * TAU, 0.18 * TAU, 18, Color(1.0, 0.15, 0.74, 0.2 - float(i) * 0.04 + pulse * 0.1), 1.25 * unit, true)
				overlay.draw_arc(center + Vector2(-2.0 + float(i) * 4.0, 0.0) * unit, radius, 0.32 * TAU, 0.68 * TAU, 18, Color(1.0, 0.15, 0.74, 0.16 - float(i) * 0.03 + pulse * 0.08), 1.25 * unit, true)
		"faded_void":
			overlay.draw_arc(center + Vector2(1.0, 1.0) * unit, 17.0 * unit + slow * unit, 0.16 * TAU + _ui_time * 0.22, 0.82 * TAU + _ui_time * 0.22, 34, Color(0.52, 0.34, 1.0, 0.22 + slow * 0.15), 2.0 * unit, true)
			overlay.draw_arc(center + Vector2(-2.0, 2.0) * unit, 11.0 * unit + slow * 1.2 * unit, 0.58 * TAU - _ui_time * 0.18, 1.18 * TAU - _ui_time * 0.18, 28, Color(0.18, 0.62, 1.0, 0.16 + slow * 0.12), 1.5 * unit, true)
			overlay.draw_circle(center + Vector2(-7.0, 8.0) * unit, (2.0 + slow) * unit, Color(0.52, 0.34, 1.0, 0.08 + slow * 0.08))
			for i in range(3):
				var point := center + Vector2(cos(_ui_time * 0.7 + float(i) * 2.1) * 9.0, sin(_ui_time * 0.9 + float(i)) * 5.0) * unit
				overlay.draw_circle(point, 0.95 * unit, Color(0.72, 0.44, 1.0, 0.22 + slow * 0.12))
		"faded_fury":
			for i in range(4):
				var slash_center := center + Vector2(-11.0 + float(i) * 7.0, -5.0 + sin(_ui_time * 3.1 + float(i)) * 9.0) * unit
				overlay.draw_line(slash_center + Vector2(-2.6, 3.0) * unit, slash_center + Vector2(4.2, -3.3) * unit, Color(1.0, 0.08, 0.02, 0.22 + pulse * 0.22), 1.35 * unit, true)
		"faded_guardian":
			var shield_top := center + Vector2(0.0, -13.0) * unit
			var shield_left := center + Vector2(-13.5, -1.0) * unit
			var shield_right := center + Vector2(13.5, -1.0) * unit
			var shield_bottom := center + Vector2(0.0, 14.5) * unit
			overlay.draw_polyline(PackedVector2Array([shield_top, shield_right, shield_bottom, shield_left, shield_top]), Color(0.74, 0.96, 1.0, 0.16 + pulse * 0.13), 1.45 * unit, true)
			overlay.draw_line(center + Vector2(0.0, -9.0) * unit, center + Vector2(0.0, 10.0) * unit, Color(0.74, 0.96, 1.0, 0.09 + pulse * 0.1), 1.0 * unit, true)
			overlay.draw_arc(center, 15.5 * unit, 0.58 * TAU, 0.92 * TAU, 18, Color(0.8, 0.98, 1.0, 0.17 + pulse * 0.1), 1.3 * unit, true)
		_:
			overlay.draw_arc(center, size * 0.36, 0.05 * TAU, 0.48 * TAU, 20, Color(gem_color.r, gem_color.g, gem_color.b, 0.1 + pulse * 0.08), 1.0 * unit, true)

func _draw_diamond_glint(overlay: Control, position: Vector2, radius: float, color: Color) -> void:
	overlay.draw_line(position + Vector2(-radius, 0.0), position + Vector2(radius, 0.0), color, maxf(radius * 0.18, 0.7), true)
	overlay.draw_line(position + Vector2(0.0, -radius), position + Vector2(0.0, radius), color, maxf(radius * 0.18, 0.7), true)
	overlay.draw_line(position + Vector2(-radius * 0.55, -radius * 0.55), position + Vector2(radius * 0.55, radius * 0.55), Color(color.r, color.g, color.b, color.a * 0.42), maxf(radius * 0.12, 0.55), true)
	overlay.draw_line(position + Vector2(-radius * 0.55, radius * 0.55), position + Vector2(radius * 0.55, -radius * 0.55), Color(color.r, color.g, color.b, color.a * 0.42), maxf(radius * 0.12, 0.55), true)

func _diamond_display_color(diamond_id: String, gem_color: Color) -> Color:
	var display := gem_color
	match diamond_id:
		"faded_void":
			display = Color(0.28, 0.18, 0.82, gem_color.a)
		"faded_corruption":
			display = Color(0.46, 0.08, 0.9, gem_color.a)
		"faded_storm":
			display = Color(0.22, 0.66, 1.0, gem_color.a)
		_:
			var luminance := gem_color.r * 0.299 + gem_color.g * 0.587 + gem_color.b * 0.114
			if luminance < 0.24:
				display = gem_color.lerp(Color(0.5, 0.38, 1.0, gem_color.a), 0.58)
	display.a = gem_color.a
	return display

func _diamond_label_color(diamond_id: String, gem_color: Color, locked: bool) -> Color:
	if locked:
		return Color(0.55, 0.55, 0.55)
	var display := _diamond_display_color(diamond_id, gem_color)
	var luminance := display.r * 0.299 + display.g * 0.587 + display.b * 0.114
	if luminance < 0.4:
		display = display.lightened(0.32)
	display.a = 1.0
	return display

func _make_diamond_cell(item: Dictionary) -> Control:
	var btn := Button.new()
	btn.custom_minimum_size = DIAMOND_STORE_CELL_SIZE
	btn.focus_mode = Control.FOCUS_NONE
	btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	var item_name := String(item.get("name", "Diamond"))
	var description := String(item.get("description", ""))
	var price := String(item.get("price", ""))
	var tooltip := item_name
	if not description.is_empty():
		tooltip += "\n" + description
	tooltip += "\nPrice: " + price
	btn.tooltip_text = tooltip
	var item_color: Color = item.get("color", Color.WHITE)
	if not (item_color is Color):
		item_color = Color.WHITE
	var item_id := String(item.get("id", ""))
	var visual_color := _diamond_display_color(item_id, item_color)
	btn.add_theme_stylebox_override("normal", _button_style(Color(0.05, 0.042, 0.055, 0.96)))
	btn.add_theme_stylebox_override("hover", _hover_button_style(visual_color.darkened(0.5).lerp(Color(0.22, 0.1, 0.08), 0.42)))
	btn.add_theme_stylebox_override("pressed", _button_style(Color(0.04, 0.032, 0.038, 1.0)))
	var locked := item_id == "faded_locked"
	if not locked:
		btn.pressed.connect(_on_shop_item_pressed.bind(item_id))

	var vbox := VBoxContainer.new()
	vbox.set_anchors_preset(Control.PRESET_FULL_RECT)
	vbox.offset_left = 4.0
	vbox.offset_top = 4.0
	vbox.offset_right = -4.0
	vbox.offset_bottom = -4.0
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox.add_theme_constant_override("separation", 3)
	vbox.mouse_filter = Control.MOUSE_FILTER_IGNORE
	btn.add_child(vbox)

	var diamond_visual := _make_diamond_visual(item_id, item_color, DIAMOND_STORE_VISUAL_SIZE, locked)
	diamond_visual.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	vbox.add_child(diamond_visual)

	# Short label: strip "Faded Diamond of " prefix
	var short_name := item_name
	if item_name.begins_with("Faded Diamond of "):
		short_name = item_name.substr(17)
	var name_label := _label(short_name, 11)
	name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	name_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	name_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	name_label.custom_minimum_size = Vector2(80.0, DIAMOND_STORE_NAME_BLOCK_HEIGHT)
	name_label.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	name_label.clip_text = true
	name_label.add_theme_color_override("font_color", _diamond_label_color(item_id, item_color, locked))
	name_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	vbox.add_child(name_label)

	var price_label := _label(price, 10)
	price_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	price_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	price_label.custom_minimum_size = Vector2(80.0, DIAMOND_STORE_PRICE_BLOCK_HEIGHT)
	price_label.add_theme_color_override("font_color", Color(0.76, 0.9, 1.0))
	price_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	vbox.add_child(price_label)

	return btn

# ─── Spell Store ──────────────────────────────────────────────────────────────

func _make_spell_store_panel(root: Control) -> void:
	_spell_store_panel = PanelContainer.new()
	_spell_store_panel.visible = false
	_spell_store_panel.anchor_left = 0.5
	_spell_store_panel.anchor_top = 0.5
	_spell_store_panel.anchor_right = 0.5
	_spell_store_panel.anchor_bottom = 0.5
	_spell_store_panel.offset_left = -SPELL_STORE_PANEL_SIZE.x * 0.5
	_spell_store_panel.offset_top = -SPELL_STORE_PANEL_SIZE.y * 0.5
	_spell_store_panel.offset_right = SPELL_STORE_PANEL_SIZE.x * 0.5
	_spell_store_panel.offset_bottom = SPELL_STORE_PANEL_SIZE.y * 0.5
	_spell_store_panel.add_theme_stylebox_override("panel", _panel_style(Color(0.026, 0.018, 0.024, 0.97)))
	root.add_child(_spell_store_panel)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 18)
	margin.add_theme_constant_override("margin_top", 14)
	margin.add_theme_constant_override("margin_right", 18)
	margin.add_theme_constant_override("margin_bottom", 16)
	_spell_store_panel.add_child(margin)

	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", 10)
	margin.add_child(content)

	var header := HBoxContainer.new()
	header.add_theme_constant_override("separation", 8)
	content.add_child(header)

	_spell_store_title_label = _label("Spells & Rituals", 26)
	_spell_store_title_label.add_theme_color_override("font_color", Color(1.0, 0.72, 0.35))
	_spell_store_title_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header.add_child(_spell_store_title_label)

	_spell_store_face = TextureRect.new()
	_spell_store_face.custom_minimum_size = Vector2(56.0, 56.0)
	_spell_store_face.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	_spell_store_face.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	_spell_store_face.visible = false
	header.add_child(_spell_store_face)

	var close_btn := Button.new()
	close_btn.text = "X"
	close_btn.custom_minimum_size = Vector2(34.0, 30.0)
	close_btn.focus_mode = Control.FOCUS_NONE
	close_btn.add_theme_font_size_override("font_size", 14)
	close_btn.add_theme_color_override("font_color", Color(1.0, 0.86, 0.66))
	close_btn.add_theme_stylebox_override("normal", _button_style(Color(0.12, 0.045, 0.04, 0.92)))
	close_btn.add_theme_stylebox_override("hover", _hover_button_style(Color(0.25, 0.075, 0.055, 0.98)))
	close_btn.add_theme_stylebox_override("pressed", _button_style(Color(0.075, 0.026, 0.026, 1.0)))
	close_btn.pressed.connect(hide_spell_store)
	header.add_child(close_btn)

	_spell_store_wallet_label = _label("", 17)
	_spell_store_wallet_label.add_theme_color_override("font_color", Color(0.76, 0.9, 1.0))
	content.add_child(_spell_store_wallet_label)

	_spell_store_status_label = _label("", 16)
	_spell_store_status_label.add_theme_color_override("font_color", Color(0.94, 0.82, 0.66))
	_spell_store_status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_spell_store_status_label.custom_minimum_size = Vector2(0.0, 28.0)
	content.add_child(_spell_store_status_label)

	var divider := ColorRect.new()
	divider.color = Color(0.95, 0.18, 0.045, 0.62)
	divider.custom_minimum_size = Vector2(0.0, 2.0)
	content.add_child(divider)

	_spell_store_scroll = ScrollContainer.new()
	_spell_store_scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_spell_store_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_spell_store_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	_spell_store_scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
	content.add_child(_spell_store_scroll)

	_spell_store_content = VBoxContainer.new()
	_spell_store_content.add_theme_constant_override("separation", 8)
	_spell_store_content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_spell_store_content.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_spell_store_scroll.add_child(_spell_store_content)

func show_spell_store(title: String, items: Array[Dictionary], wallet_text: String, status_text: String, face_texture: Texture2D = null) -> void:
	if _spell_store_panel == null:
		return
	_hide_config_panel()
	_hide_spell_slot_picker()
	_spell_store_title_label.text = title
	_spell_store_wallet_label.text = wallet_text
	_spell_store_status_label.text = status_text
	if _spell_store_face != null:
		if face_texture != null:
			_spell_store_face.texture = face_texture
			_spell_store_face.visible = true
		else:
			_spell_store_face.visible = false

	for child in _spell_store_content.get_children():
		_spell_store_content.remove_child(child)
		child.queue_free()

	# Group items by category, preserving order: attack, buff, debuff, defense, healing
	const CATEGORY_ORDER := ["attack", "buff", "debuff", "defense", "healing"]
	const CATEGORY_LABELS := {
		"attack": "⚔  Attack",
		"buff": "💪  Buff",
		"debuff": "☠  Debuff",
		"defense": "🛡  Defense",
		"healing": "❤  Healing"
	}
	const CATEGORY_COLORS := {
		"attack": Color(1.0, 0.42, 0.28),
		"buff": Color(0.56, 0.88, 1.0),
		"debuff": Color(0.78, 0.36, 1.0),
		"defense": Color(0.36, 0.78, 1.0),
		"healing": Color(0.36, 1.0, 0.52)
	}
	var by_category := {}
	for item in items:
		var cat := String(item.get("category", "attack"))
		if not by_category.has(cat):
			by_category[cat] = []
		by_category[cat].append(item)

	for cat in CATEGORY_ORDER:
		if not by_category.has(cat) or by_category[cat].is_empty():
			continue
		var cat_color: Color = CATEGORY_COLORS.get(cat, Color(1.0, 0.72, 0.35))
		var section := VBoxContainer.new()
		section.add_theme_constant_override("separation", 4)
		_spell_store_content.add_child(section)

		var cat_label := _label(CATEGORY_LABELS.get(cat, cat.capitalize()), 16)
		cat_label.add_theme_color_override("font_color", cat_color)
		section.add_child(cat_label)

		var cat_divider := ColorRect.new()
		cat_divider.color = cat_color.darkened(0.4)
		cat_divider.color.a = 0.5
		cat_divider.custom_minimum_size = Vector2(0.0, 1.0)
		section.add_child(cat_divider)

		var grid := GridContainer.new()
		grid.columns = 7
		grid.add_theme_constant_override("h_separation", 5)
		grid.add_theme_constant_override("v_separation", 8)
		grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		section.add_child(grid)

		for spell_item in by_category[cat]:
			grid.add_child(_make_spell_cell(spell_item))

	if _spell_store_scroll != null:
		_spell_store_scroll.scroll_vertical = 0

	_spell_store_panel.visible = true
	_spell_store_panel.move_to_front()
	if _diamond_store_panel != null:
		_diamond_store_panel.visible = false
	if _shop_panel != null:
		_shop_panel.visible = false

func hide_spell_store() -> void:
	if _spell_store_panel != null:
		_spell_store_panel.visible = false

func _make_spell_cell(item: Dictionary) -> Control:
	var learned: bool = bool(item.get("learned", false))
	var btn := Button.new()
	btn.custom_minimum_size = SPELL_STORE_CELL_SIZE
	btn.focus_mode = Control.FOCUS_NONE
	btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	var spell_name := _clean_spell_display_name(String(item.get("name", "Spell")))
	var description := String(item.get("description", ""))
	var cost := int(item.get("gold_cost", 0))
	var spell_category := String(item.get("spell_category", _spell_theme_category_for_id(String(item.get("id", "")))))
	var tooltip := spell_name
	tooltip += "\nCategory: %s" % _spell_theme_category_display_name(spell_category)
	if not description.is_empty():
		tooltip += "\n" + description
	tooltip += "\nCost: %d gold" % cost
	if learned:
		tooltip += "\n✓ Learned"
	btn.tooltip_text = tooltip
	if learned:
		btn.add_theme_stylebox_override("normal", _spell_store_cell_style(Color(0.06, 0.08, 0.06, 0.96)))
		btn.add_theme_stylebox_override("hover", _hover_spell_store_cell_style(Color(0.1, 0.14, 0.1, 0.98)))
	else:
		btn.add_theme_stylebox_override("normal", _spell_store_cell_style(Color(0.055, 0.042, 0.065, 0.96)))
		btn.add_theme_stylebox_override("hover", _hover_spell_store_cell_style(Color(0.18, 0.08, 0.22, 0.98)))
	btn.add_theme_stylebox_override("pressed", _spell_store_cell_style(Color(0.04, 0.032, 0.038, 1.0)))
	if not learned:
		btn.pressed.connect(_on_shop_item_pressed.bind(String(item.get("id", ""))))

	var margin := MarginContainer.new()
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 6)
	margin.add_theme_constant_override("margin_top", 7)
	margin.add_theme_constant_override("margin_right", 6)
	margin.add_theme_constant_override("margin_bottom", 7)
	margin.mouse_filter = Control.MOUSE_FILTER_IGNORE
	btn.add_child(margin)

	var vbox := VBoxContainer.new()
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox.add_theme_constant_override("separation", 3)
	vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	vbox.size_flags_vertical = Control.SIZE_EXPAND_FILL
	vbox.mouse_filter = Control.MOUSE_FILTER_IGNORE
	margin.add_child(vbox)

	# Spell sigil image
	var img_path := String(item.get("image", ""))
	if not img_path.is_empty():
		var tex: Texture2D = load(img_path) as Texture2D
		if tex != null:
			var sigil_slot := CenterContainer.new()
			sigil_slot.custom_minimum_size = Vector2(0.0, SPELL_STORE_SIGIL_SLOT_HEIGHT)
			sigil_slot.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			sigil_slot.size_flags_vertical = Control.SIZE_SHRINK_CENTER
			sigil_slot.mouse_filter = Control.MOUSE_FILTER_IGNORE
			vbox.add_child(sigil_slot)

			var tex_rect := TextureRect.new()
			tex_rect.texture = tex
			tex_rect.custom_minimum_size = SPELL_STORE_SIGIL_ICON_SIZE
			tex_rect.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
			tex_rect.size_flags_vertical = Control.SIZE_SHRINK_CENTER
			tex_rect.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
			tex_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			tex_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
			if learned:
				tex_rect.modulate = Color(0.55, 0.88, 0.55, 0.85)
			sigil_slot.add_child(tex_rect)
		else:
			vbox.add_child(_make_spell_fallback_sigil(spell_name, learned))
	else:
		vbox.add_child(_make_spell_fallback_sigil(spell_name, learned))

	var name_label := _label(spell_name, 11)
	name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	name_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	name_label.autowrap_mode = TextServer.AUTOWRAP_OFF
	name_label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	name_label.custom_minimum_size = Vector2(0.0, SPELL_STORE_NAME_BLOCK_HEIGHT)
	name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	name_label.clip_text = true
	if learned:
		name_label.add_theme_color_override("font_color", Color(0.55, 0.88, 0.55))
	else:
		name_label.add_theme_color_override("font_color", Color(0.94, 0.82, 0.66))
	name_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	vbox.add_child(name_label)

	if learned:
		var learned_label := _label("✓", 10)
		learned_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		learned_label.custom_minimum_size = Vector2(0.0, SPELL_STORE_PRICE_BLOCK_HEIGHT)
		learned_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		learned_label.add_theme_color_override("font_color", Color(0.45, 0.85, 0.45))
		learned_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		vbox.add_child(learned_label)
	else:
		var cost_label := _label("%d gold" % cost, 10)
		cost_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		cost_label.custom_minimum_size = Vector2(0.0, SPELL_STORE_PRICE_BLOCK_HEIGHT)
		cost_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		cost_label.add_theme_color_override("font_color", Color(1.0, 0.78, 0.42))
		cost_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		vbox.add_child(cost_label)

	return btn

func _make_mission_panel(root: Control) -> void:
	_mission_panel = VBoxContainer.new()
	_mission_panel.visible = false
	_mission_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_mission_panel.anchor_left = 0.0
	_mission_panel.anchor_top = 0.0
	_mission_panel.anchor_right = 1.0
	_mission_panel.anchor_bottom = 0.0
	_mission_panel.offset_left = MISSION_TEXT_POSITION.x
	_mission_panel.offset_top = MISSION_TEXT_POSITION.y
	_mission_panel.offset_right = -MISSION_TEXT_POSITION.x
	_mission_panel.offset_bottom = MISSION_TEXT_POSITION.y + MISSION_PANEL_SIZE.y
	_mission_panel.add_theme_constant_override("separation", 5)
	root.add_child(_mission_panel)

	_mission_title_label = _label("", MISSION_TITLE_FONT_SIZE)
	_mission_title_label.add_theme_color_override("font_color", Color(1.0, 0.78, 0.46))
	_mission_title_label.add_theme_color_override("font_outline_color", Color(0.02, 0.01, 0.006, 0.96))
	_mission_title_label.add_theme_constant_override("outline_size", 2)
	_mission_title_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_mission_panel.add_child(_mission_title_label)

	_mission_list_label = _label("", MISSION_LIST_FONT_SIZE)
	_mission_list_label.add_theme_color_override("font_color", Color(0.94, 0.86, 0.7))
	_mission_list_label.add_theme_color_override("font_outline_color", Color(0.02, 0.01, 0.006, 0.96))
	_mission_list_label.add_theme_constant_override("outline_size", 2)
	_mission_list_label.autowrap_mode = TextServer.AUTOWRAP_OFF
	_mission_list_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_mission_panel.add_child(_mission_list_label)

func _position_demon_level_label(rise: float = 0.0) -> void:
	if _demon_level_label == null:
		return
	var label_left := DEMON_MENU_LEFT_OFFSET
	var label_top := DEMON_MENU_TOP_OFFSET - DEMON_LEVEL_LABEL_GAP - DEMON_LEVEL_LABEL_SIZE.y - rise
	_demon_level_label.offset_left = label_left
	_demon_level_label.offset_top = label_top
	_demon_level_label.offset_right = label_left + DEMON_LEVEL_LABEL_SIZE.x
	_demon_level_label.offset_bottom = label_top + DEMON_LEVEL_LABEL_SIZE.y

func _make_character_menu(root: Control) -> void:
	_demon_menu_button = Button.new()
	_demon_menu_button.text = ""
	_demon_menu_button.anchor_left = 0.0
	_demon_menu_button.anchor_top = 1.0
	_demon_menu_button.anchor_right = 0.0
	_demon_menu_button.anchor_bottom = 1.0
	_demon_menu_button.offset_left = DEMON_MENU_LEFT_OFFSET
	_demon_menu_button.offset_top = DEMON_MENU_TOP_OFFSET
	_demon_menu_button.offset_right = DEMON_MENU_LEFT_OFFSET + DEMON_MENU_BUTTON_SIZE.x
	_demon_menu_button.offset_bottom = DEMON_MENU_BOTTOM_OFFSET
	_demon_menu_button.focus_mode = Control.FOCUS_NONE
	_demon_menu_button.tooltip_text = "Character"
	_demon_menu_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	_demon_menu_button.pivot_offset = DEMON_MENU_BUTTON_SIZE * 0.5
	_demon_menu_button.z_as_relative = false
	_demon_menu_button.z_index = DEMON_MENU_Z_INDEX
	_demon_menu_button.add_theme_stylebox_override("normal", _icon_button_style(Color.TRANSPARENT, Color.TRANSPARENT))
	_demon_menu_button.add_theme_stylebox_override("hover", _icon_button_style(Color.TRANSPARENT, Color.TRANSPARENT))
	_demon_menu_button.add_theme_stylebox_override("pressed", _icon_button_style(Color.TRANSPARENT, Color.TRANSPARENT))
	_demon_menu_button.mouse_entered.connect(_on_demon_menu_button_mouse_entered)
	_demon_menu_button.mouse_exited.connect(_on_demon_menu_button_mouse_exited)
	_demon_menu_button.pressed.connect(_toggle_character_panel)
	root.add_child(_demon_menu_button)

	var demon_image: TextureRect = TextureRect.new()
	demon_image.texture = DEMON_MENU_TEXTURE
	demon_image.set_anchors_preset(Control.PRESET_FULL_RECT)
	demon_image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	demon_image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	demon_image.mouse_filter = Control.MOUSE_FILTER_IGNORE
	demon_image.material = _silhouette_outline_material(0.34)
	_demon_menu_button.add_child(demon_image)
	_demon_menu_image = demon_image

	_demon_level_label = _label("", 18)
	_demon_level_label.anchor_left = 0.0
	_demon_level_label.anchor_top = 1.0
	_demon_level_label.anchor_right = 0.0
	_demon_level_label.anchor_bottom = 1.0
	_position_demon_level_label()
	_demon_level_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_demon_level_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_demon_level_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_demon_level_label.add_theme_color_override("font_color", Color(1.0, 0.84, 0.48))
	_demon_level_label.add_theme_color_override("font_outline_color", Color(0.08, 0.02, 0.01, 0.95))
	_demon_level_label.add_theme_constant_override("outline_size", 2)
	_demon_level_label.z_as_relative = false
	_demon_level_label.z_index = DEMON_MENU_Z_INDEX + 1
	_demon_level_label.visible = false
	root.add_child(_demon_level_label)
	_refresh_demon_menu_visuals()

	_character_panel = PanelContainer.new()
	_character_panel.visible = false
	_character_panel.anchor_left = 0.0
	_character_panel.anchor_top = 1.0
	_character_panel.anchor_right = 0.0
	_character_panel.anchor_bottom = 1.0
	_character_panel.offset_left = DEMON_MENU_LEFT_OFFSET + DEMON_MENU_BUTTON_SIZE.x + DEMON_MENU_PANEL_GAP
	_character_panel.offset_top = -CHARACTER_PANEL_SIZE.y - 24.0
	_character_panel.offset_right = _character_panel.offset_left + CHARACTER_PANEL_SIZE.x
	_character_panel.offset_bottom = -24.0
	_character_panel.custom_minimum_size = CHARACTER_PANEL_SIZE
	_character_panel.clip_contents = true
	_character_panel.add_theme_stylebox_override("panel", _panel_style(Color(0.022, 0.012, 0.016, 0.98)))
	root.add_child(_character_panel)

	var fixed_body := Control.new()
	fixed_body.custom_minimum_size = CHARACTER_PANEL_BODY_SIZE
	fixed_body.clip_contents = true
	fixed_body.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	fixed_body.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_character_panel.add_child(fixed_body)

	var margin := MarginContainer.new()
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 18)
	margin.add_theme_constant_override("margin_top", 14)
	margin.add_theme_constant_override("margin_right", 18)
	margin.add_theme_constant_override("margin_bottom", 16)
	fixed_body.add_child(margin)

	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", 10)
	margin.add_child(content)

	var header := HBoxContainer.new()
	header.add_theme_constant_override("separation", 8)
	content.add_child(header)

	var title := _label("Soul Ledger", 26)
	title.add_theme_color_override("font_color", Color(1.0, 0.72, 0.35))
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header.add_child(title)

	var close_button := Button.new()
	close_button.text = "X"
	close_button.custom_minimum_size = Vector2(34.0, 30.0)
	close_button.focus_mode = Control.FOCUS_NONE
	close_button.add_theme_font_size_override("font_size", 14)
	close_button.add_theme_color_override("font_color", Color(1.0, 0.86, 0.66))
	close_button.add_theme_stylebox_override("normal", _button_style(Color(0.12, 0.045, 0.04, 0.92)))
	close_button.add_theme_stylebox_override("hover", _hover_button_style(Color(0.25, 0.075, 0.055, 0.98)))
	close_button.add_theme_stylebox_override("pressed", _button_style(Color(0.075, 0.026, 0.026, 1.0)))
	close_button.pressed.connect(_hide_character_panel)
	header.add_child(close_button)

	var ember_line: ColorRect = ColorRect.new()
	ember_line.color = Color(0.95, 0.17, 0.04, 0.7)
	ember_line.custom_minimum_size = Vector2(0.0, 2.0)
	content.add_child(ember_line)

	var tabs: HBoxContainer = HBoxContainer.new()
	tabs.add_theme_constant_override("separation", 6)
	content.add_child(tabs)
	_add_character_tab_button(tabs, "Stats", CHARACTER_PANEL_TAB_STATS)
	_add_character_tab_button(tabs, "Spells", CHARACTER_PANEL_TAB_SPELLS)
	_add_character_tab_button(tabs, "Inventory", CHARACTER_PANEL_TAB_INVENTORY)
	_add_character_tab_button(tabs, "Relics", CHARACTER_PANEL_TAB_RELICS)
	_add_character_tab_button(tabs, "Map", CHARACTER_PANEL_TAB_MAP)
	_add_character_tab_button(tabs, "Skill Tree", CHARACTER_PANEL_TAB_SKILL_TREE)

	_character_content_label = _label("", 18)
	_character_content_label.add_theme_color_override("font_color", Color(0.96, 0.88, 0.72))
	_character_content_label.add_theme_color_override("font_shadow_color", Color(0.0, 0.0, 0.0, 0.75))
	_character_content_label.add_theme_constant_override("shadow_offset_x", 1)
	_character_content_label.add_theme_constant_override("shadow_offset_y", 1)
	_character_content_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_character_content_label.size_flags_vertical = Control.SIZE_EXPAND_FILL
	content.add_child(_character_content_label)

	_spells_view = _make_spells_view()
	_spells_view.visible = false
	content.add_child(_spells_view)

	_inventory_view = _make_inventory_view()
	_inventory_view.visible = false
	content.add_child(_inventory_view)

	_relics_view = _make_relics_view()
	_relics_view.visible = false
	content.add_child(_relics_view)

	_map_view = _make_map_view()
	_map_view.visible = false
	content.add_child(_map_view)

	_skill_tree_view = SkillTreeView.new()
	_skill_tree_view.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_skill_tree_view.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_skill_tree_view.visible = false
	_skill_tree_view.point_spend_requested.connect(_on_skill_tree_point_spend_requested)
	content.add_child(_skill_tree_view)
	_sync_character_panel()

func _make_ritual_menu(root: Control) -> void:
	_config_menu_button = Button.new()
	_config_menu_button.text = ""
	_config_menu_button.anchor_left = 1.0
	_config_menu_button.anchor_top = 1.0
	_config_menu_button.anchor_right = 1.0
	_config_menu_button.anchor_bottom = 1.0
	_config_menu_button.offset_left = CONFIG_MENU_LEFT_OFFSET
	_config_menu_button.offset_top = CONFIG_MENU_TOP_OFFSET
	_config_menu_button.offset_right = CONFIG_MENU_RIGHT_OFFSET
	_config_menu_button.offset_bottom = CONFIG_MENU_BOTTOM_OFFSET
	_config_menu_button.focus_mode = Control.FOCUS_NONE
	_config_menu_button.tooltip_text = ""
	_config_menu_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	_config_menu_button.pivot_offset = CONFIG_MENU_BUTTON_SIZE * 0.5
	_config_menu_button.z_as_relative = false
	_config_menu_button.z_index = CONFIG_MENU_Z_INDEX
	_config_menu_button.add_theme_stylebox_override("normal", _icon_button_style(Color.TRANSPARENT, Color.TRANSPARENT))
	_config_menu_button.add_theme_stylebox_override("hover", _icon_button_style(Color.TRANSPARENT, Color.TRANSPARENT))
	_config_menu_button.add_theme_stylebox_override("pressed", _icon_button_style(Color.TRANSPARENT, Color.TRANSPARENT))
	_config_menu_button.mouse_entered.connect(_on_config_menu_button_mouse_entered)
	_config_menu_button.mouse_exited.connect(_on_config_menu_button_mouse_exited)
	_config_menu_button.pressed.connect(_toggle_config_panel)
	root.add_child(_config_menu_button)

	var config_image := TextureRect.new()
	config_image.texture = RITUAL_MENU_TEXTURE
	config_image.set_anchors_preset(Control.PRESET_FULL_RECT)
	config_image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	config_image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	config_image.mouse_filter = Control.MOUSE_FILTER_IGNORE
	config_image.material = _silhouette_outline_material(0.18)
	_config_menu_button.add_child(config_image)
	_config_menu_image = config_image

	_make_config_panel(root)
	_refresh_config_menu_visuals()

func _make_config_panel(root: Control) -> void:
	_config_panel = PanelContainer.new()
	_config_panel.visible = false
	_lock_config_panel_rect()
	_config_panel.custom_minimum_size = CONFIG_PANEL_SIZE
	_config_panel.add_theme_stylebox_override("panel", _config_panel_style())
	root.add_child(_config_panel)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 20)
	margin.add_theme_constant_override("margin_top", 16)
	margin.add_theme_constant_override("margin_right", 20)
	margin.add_theme_constant_override("margin_bottom", 18)
	_config_panel.add_child(margin)

	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", 10)
	margin.add_child(content)

	var header := HBoxContainer.new()
	header.add_theme_constant_override("separation", 10)
	content.add_child(header)

	var title := _label("Ritual Settings", 28)
	title.add_theme_color_override("font_color", Color(1.0, 0.72, 0.35))
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header.add_child(title)

	var close_button := Button.new()
	close_button.text = "X"
	close_button.custom_minimum_size = Vector2(34.0, 30.0)
	close_button.focus_mode = Control.FOCUS_NONE
	close_button.add_theme_font_size_override("font_size", 14)
	close_button.add_theme_color_override("font_color", Color(1.0, 0.86, 0.66))
	close_button.add_theme_stylebox_override("normal", _button_style(Color(0.12, 0.045, 0.04, 0.92)))
	close_button.add_theme_stylebox_override("hover", _hover_button_style(Color(0.25, 0.075, 0.055, 0.98)))
	close_button.add_theme_stylebox_override("pressed", _button_style(Color(0.075, 0.026, 0.026, 1.0)))
	close_button.pressed.connect(_hide_config_panel)
	header.add_child(close_button)

	var ember_line := ColorRect.new()
	ember_line.color = Color(0.95, 0.17, 0.04, 0.7)
	ember_line.custom_minimum_size = Vector2(0.0, 2.0)
	content.add_child(ember_line)

	var tabs := HBoxContainer.new()
	tabs.add_theme_constant_override("separation", 6)
	content.add_child(tabs)
	_add_config_tab_button(tabs, "Audio", CONFIG_PANEL_TAB_AUDIO)
	_add_config_tab_button(tabs, "Controls", CONFIG_PANEL_TAB_CONTROLS)
	_add_config_tab_button(tabs, "Graphics", CONFIG_PANEL_TAB_GRAPHICS)
	_add_config_tab_button(tabs, "Gameplay", CONFIG_PANEL_TAB_GAMEPLAY)

	_config_tab_content = VBoxContainer.new()
	_config_tab_content.add_theme_constant_override("separation", 10)
	_config_tab_content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_config_tab_content.size_flags_vertical = Control.SIZE_EXPAND_FILL
	content.add_child(_config_tab_content)
	_sync_config_panel()

func _add_config_tab_button(tabs: HBoxContainer, text: String, tab: String) -> void:
	var button := Button.new()
	button.text = text
	button.custom_minimum_size = Vector2(112.0, 34.0)
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button.focus_mode = Control.FOCUS_NONE
	button.add_theme_font_size_override("font_size", 16)
	button.add_theme_color_override("font_color", Color(1.0, 0.86, 0.66))
	button.pressed.connect(_set_config_panel_tab.bind(tab))
	tabs.add_child(button)
	_config_tab_buttons[tab] = button

func _toggle_config_panel() -> void:
	if _config_panel == null:
		return
	_set_config_panel_visible(not _config_panel.visible)

func _hide_config_panel() -> void:
	_set_config_panel_visible(false)

func _set_config_panel_visible(visible: bool) -> void:
	if _config_panel == null:
		return
	if visible:
		_hide_spell_slot_picker()
		if _character_panel != null and _character_panel.visible:
			_set_character_panel_visible(false)
		_lock_config_panel_rect()
		_sync_config_panel()
		_lock_config_panel_rect()
		_config_panel.move_to_front()
		_config_menu_button.move_to_front()
	_config_panel.visible = visible
	if _spell_cluster != null:
		_spell_cluster.visible = not visible
	_refresh_config_menu_visuals()

func _handle_config_panel_key(event: InputEvent) -> bool:
	if _config_panel == null or not _config_panel.visible:
		return false
	if not (event is InputEventKey):
		return false
	var key_event := event as InputEventKey
	if not key_event.pressed or key_event.echo:
		return false
	if key_event.keycode != KEY_ESCAPE and not key_event.is_action_pressed("ui_cancel"):
		return false
	_hide_config_panel()
	var viewport := get_viewport()
	if viewport != null:
		viewport.set_input_as_handled()
	return true

func _lock_config_panel_rect() -> void:
	if _config_panel == null:
		return
	_config_panel.anchor_left = 0.5
	_config_panel.anchor_top = 0.5
	_config_panel.anchor_right = 0.5
	_config_panel.anchor_bottom = 0.5
	_config_panel.offset_left = -CONFIG_PANEL_SIZE.x * 0.5
	_config_panel.offset_top = -CONFIG_PANEL_SIZE.y * 0.5
	_config_panel.offset_right = CONFIG_PANEL_SIZE.x * 0.5
	_config_panel.offset_bottom = CONFIG_PANEL_SIZE.y * 0.5
	_config_panel.size = CONFIG_PANEL_SIZE

func _set_config_panel_tab(tab: String) -> void:
	_config_panel_tab = tab
	_sync_config_panel()

func _sync_config_panel() -> void:
	if _config_tab_content == null:
		return
	for tab in _config_tab_buttons.keys():
		var button := _config_tab_buttons[tab] as Button
		if button == null:
			continue
		if tab == _config_panel_tab:
			button.add_theme_color_override("font_color", Color(1.0, 0.9, 0.66))
			button.add_theme_stylebox_override("normal", _button_style(Color(0.38, 0.04, 0.035, 0.96)))
			button.add_theme_stylebox_override("hover", _hover_button_style(Color(0.46, 0.065, 0.05, 0.98)))
			button.add_theme_stylebox_override("pressed", _button_style(Color(0.2, 0.032, 0.026, 1.0)))
		else:
			button.add_theme_color_override("font_color", Color(0.9, 0.74, 0.55))
			button.add_theme_stylebox_override("normal", _button_style(Color(0.06, 0.052, 0.058, 0.96)))
			button.add_theme_stylebox_override("hover", _hover_button_style(Color(0.16, 0.08, 0.07, 0.98)))
			button.add_theme_stylebox_override("pressed", _button_style(Color(0.04, 0.032, 0.038, 1.0)))
	for child in _config_tab_content.get_children():
		_config_tab_content.remove_child(child)
		child.queue_free()
	match _config_panel_tab:
		CONFIG_PANEL_TAB_CONTROLS:
			_make_config_controls_tab(_config_tab_content)
		CONFIG_PANEL_TAB_GRAPHICS:
			_make_config_graphics_tab(_config_tab_content)
		CONFIG_PANEL_TAB_GAMEPLAY:
			_make_config_gameplay_tab(_config_tab_content)
		_:
			_make_config_audio_tab(_config_tab_content)

func _make_config_audio_tab(parent: VBoxContainer) -> void:
	parent.add_child(_make_config_note_label("Tune the sounds that answer when the ritual stirs."))
	var silence := CheckBox.new()
	silence.text = "Silence the Whisper"
	silence.button_pressed = _config_silence_whisper
	silence.focus_mode = Control.FOCUS_NONE
	silence.add_theme_font_size_override("font_size", 18)
	silence.add_theme_color_override("font_color", Color(0.96, 0.86, 0.68))
	silence.toggled.connect(_on_config_silence_toggled)
	parent.add_child(silence)
	_add_config_slider(parent, "Ritual Chant Volume", _config_chant_volume, "chant")
	_add_config_slider(parent, "Echoes of the Abyss", _config_echo_volume, "echo")

func _make_config_controls_tab(parent: VBoxContainer) -> void:
	parent.add_child(_make_config_note_label("Bindings carved into the current prototype."))
	_add_config_readonly_row(parent, "Move", "WASD or left mouse")
	_add_config_readonly_row(parent, "Cast", "Space")
	_add_config_readonly_row(parent, "Camera", "Mouse wheel, Z to reset")
	_add_config_readonly_row(parent, "Advance Dialogue", "Enter or click")

func _make_config_graphics_tab(parent: VBoxContainer) -> void:
	parent.add_child(_make_config_note_label("Visual offerings for the shadowed glass."))
	_add_config_slider(parent, "Shadow Fidelity", 78.0, "visual")
	_add_config_slider(parent, "Abyss Glow", 64.0, "visual")
	var window_mode := OptionButton.new()
	window_mode.custom_minimum_size = Vector2(0.0, 38.0)
	window_mode.focus_mode = Control.FOCUS_NONE
	window_mode.add_item("Fullscreen")
	window_mode.add_item("Windowed")
	window_mode.add_item("Borderless")
	window_mode.selected = 0
	window_mode.add_theme_font_size_override("font_size", 16)
	window_mode.add_theme_color_override("font_color", Color(0.96, 0.86, 0.68))
	parent.add_child(window_mode)

func _make_config_gameplay_tab(parent: VBoxContainer) -> void:
	parent.add_child(_make_config_note_label("Small vows that shape the run."))
	_add_config_toggle(parent, "Whisper Hints", true)
	_add_config_toggle(parent, "Show Damage Numbers", true)
	_add_config_toggle(parent, "Pause on Ritual Settings", false)
	_add_config_readonly_row(parent, "Current Oath", "Feed the Whisper. Reach the exit.")

func _make_config_note_label(text: String) -> Label:
	var note := _label(text, 16)
	note.add_theme_color_override("font_color", Color(0.78, 0.7, 0.62))
	note.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	note.custom_minimum_size = Vector2(0.0, 32.0)
	return note

func _add_config_readonly_row(parent: VBoxContainer, label_text: String, value_text: String) -> void:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 12)
	row.custom_minimum_size = Vector2(0.0, 38.0)
	parent.add_child(row)

	var label := _label(label_text, 17)
	label.custom_minimum_size = Vector2(210.0, 0.0)
	label.add_theme_color_override("font_color", Color(1.0, 0.78, 0.46))
	row.add_child(label)

	var value := _label(value_text, 17)
	value.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	value.add_theme_color_override("font_color", Color(0.94, 0.86, 0.72))
	row.add_child(value)

func _add_config_toggle(parent: VBoxContainer, text: String, enabled: bool) -> void:
	var toggle := CheckBox.new()
	toggle.text = text
	toggle.button_pressed = enabled
	toggle.focus_mode = Control.FOCUS_NONE
	toggle.add_theme_font_size_override("font_size", 17)
	toggle.add_theme_color_override("font_color", Color(0.96, 0.86, 0.68))
	parent.add_child(toggle)

func _add_config_slider(parent: VBoxContainer, label_text: String, value: float, key: String) -> void:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 12)
	row.custom_minimum_size = Vector2(0.0, 42.0)
	parent.add_child(row)

	var label := _label(label_text, 17)
	label.custom_minimum_size = Vector2(230.0, 0.0)
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_color_override("font_color", Color(1.0, 0.78, 0.46))
	row.add_child(label)

	var slider := HSlider.new()
	slider.min_value = 0.0
	slider.max_value = 100.0
	slider.step = 1.0
	slider.value = value
	slider.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	slider.focus_mode = Control.FOCUS_NONE
	row.add_child(slider)

	var value_label := _label("%d%%" % int(round(value)), 16)
	value_label.custom_minimum_size = Vector2(52.0, 0.0)
	value_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	value_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	value_label.add_theme_color_override("font_color", Color(0.94, 0.86, 0.72))
	row.add_child(value_label)
	slider.value_changed.connect(_on_config_slider_value_changed.bind(key, value_label))

func _on_config_silence_toggled(enabled: bool) -> void:
	_config_silence_whisper = enabled
	set_whispers_enabled(not enabled)
	whisper_silence_changed.emit(enabled)

func _on_config_slider_value_changed(value: float, key: String, value_label: Label) -> void:
	match key:
		"chant":
			_config_chant_volume = value
		"echo":
			_config_echo_volume = value
	if value_label != null:
		value_label.text = "%d%%" % int(round(value))
	if key == "chant" or key == "echo":
		whisper_audio_mix_changed.emit(_config_chant_volume, _config_echo_volume)

func _on_config_menu_button_mouse_entered() -> void:
	_config_menu_hovered = true
	_refresh_config_menu_visuals()

func _on_config_menu_button_mouse_exited() -> void:
	_config_menu_hovered = false
	_refresh_config_menu_visuals()

func _refresh_config_menu_visuals() -> void:
	if _config_menu_button == null:
		return
	var active := _config_panel != null and _config_panel.visible
	var button_scale := Vector2.ONE
	var button_modulate := Color.WHITE
	var image_modulate := Color(0.92, 0.84, 0.72, 0.92)
	var outline_alpha := 0.18
	var outline_size := 2.0
	if _config_menu_hovered or active:
		button_scale = Vector2(1.05, 1.05)
		button_modulate = Color(1.0, 0.86, 0.72, 1.0)
		image_modulate = Color(1.0, 0.94, 0.84, 1.0)
		outline_alpha = 1.0
		outline_size = 4.0
	_config_menu_button.scale = button_scale
	_config_menu_button.modulate = button_modulate
	if _config_menu_image != null:
		_config_menu_image.modulate = image_modulate
		var material := _config_menu_image.material as ShaderMaterial
		if material != null:
			material.set_shader_parameter("outline_alpha", outline_alpha)
			material.set_shader_parameter("outline_size", outline_size)
	if _config_menu_label != null:
		_config_menu_label.add_theme_color_override("font_color", Color(1.0, 0.85, 0.58) if active else Color(0.9, 0.74, 0.55))

func _add_character_tab_button(tabs: HBoxContainer, text: String, tab: String) -> void:
	var button := Button.new()
	button.text = text
	button.custom_minimum_size = Vector2(120.0, 34.0)
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button.focus_mode = Control.FOCUS_NONE
	button.add_theme_font_size_override("font_size", 16)
	button.add_theme_color_override("font_color", Color(1.0, 0.86, 0.66))
	button.pressed.connect(Callable(self, "_set_character_panel_tab").bind(tab))
	tabs.add_child(button)
	_character_tab_buttons[tab] = button

func _toggle_character_panel() -> void:
	if _character_panel == null:
		return
	_set_character_panel_visible(not _character_panel.visible)
	if _character_panel.visible:
		_acknowledge_level_up_feedback()
		_sync_character_panel()
		_character_panel.move_to_front()
		_demon_menu_button.move_to_front()

func _hide_character_panel() -> void:
	_set_character_panel_visible(false)

func _set_character_panel_visible(visible: bool) -> void:
	if _character_panel == null:
		return
	if visible and _config_panel != null and _config_panel.visible:
		_set_config_panel_visible(false)
	_character_panel.visible = visible
	if _spell_cluster != null:
		_spell_cluster.visible = not visible
	if visible:
		if _spell_slot_hover_tooltip != null:
			_spell_slot_hover_tooltip.visible = false
		_hide_spell_slot_picker()
		_spell_slot_hovered_index = -1

func _set_character_panel_tab(tab: String) -> void:
	if not _is_character_tab_available(tab):
		return
	_character_panel_tab = tab
	if tab != CHARACTER_PANEL_TAB_SPELLS:
		_spells_hovered_name = ""
	_sync_character_panel()

func _sync_character_panel() -> void:
	if _character_content_label == null:
		return
	if not _is_character_tab_available(_character_panel_tab):
		_character_panel_tab = CHARACTER_PANEL_TAB_STATS
	for tab in _character_tab_buttons.keys():
		var button := _character_tab_buttons[tab] as Button
		if button == null:
			continue
		button.visible = _is_character_tab_available(tab)
		if tab == _character_panel_tab:
			button.add_theme_color_override("font_color", Color(1.0, 0.9, 0.66))
			button.add_theme_stylebox_override("normal", _button_style(Color(0.38, 0.04, 0.035, 0.96)))
			button.add_theme_stylebox_override("hover", _hover_button_style(Color(0.46, 0.065, 0.05, 0.98)))
			button.add_theme_stylebox_override("pressed", _button_style(Color(0.2, 0.032, 0.026, 1.0)))
		else:
			button.add_theme_color_override("font_color", Color(0.9, 0.74, 0.55))
			button.add_theme_stylebox_override("normal", _button_style(Color(0.06, 0.052, 0.058, 0.96)))
			button.add_theme_stylebox_override("hover", _hover_button_style(Color(0.16, 0.08, 0.07, 0.98)))
			button.add_theme_stylebox_override("pressed", _button_style(Color(0.04, 0.032, 0.038, 1.0)))
	if _spells_view != null:
		_spells_view.visible = _character_panel_tab == CHARACTER_PANEL_TAB_SPELLS
	if _skill_tree_view != null:
		_skill_tree_view.visible = _character_panel_tab == CHARACTER_PANEL_TAB_SKILL_TREE
	if _inventory_view != null:
		_inventory_view.visible = _character_panel_tab == CHARACTER_PANEL_TAB_INVENTORY
	if _relics_view != null:
		_relics_view.visible = _character_panel_tab == CHARACTER_PANEL_TAB_RELICS
	if _map_view != null:
		_map_view.visible = _character_panel_tab == CHARACTER_PANEL_TAB_MAP
	_character_content_label.visible = _character_panel_tab == CHARACTER_PANEL_TAB_STATS
	if _character_panel_tab == CHARACTER_PANEL_TAB_INVENTORY:
		_sync_inventory_view()
	elif _character_panel_tab == CHARACTER_PANEL_TAB_RELICS:
		_sync_relics_view()
	elif _character_panel_tab == CHARACTER_PANEL_TAB_MAP:
		_sync_map_view()
	elif _character_panel_tab == CHARACTER_PANEL_TAB_SPELLS:
		_sync_spells_view()
	elif _character_panel_tab == CHARACTER_PANEL_TAB_SKILL_TREE:
		_sync_skill_tree_view()
	elif _character_panel_tab == CHARACTER_PANEL_TAB_STATS:
		_character_content_label.text = _character_stats_text()

func _is_character_tab_available(tab: String) -> bool:
	if tab == CHARACTER_PANEL_TAB_MAP:
		return _has_teleport_device_in_stats()
	return true

func _sync_skill_tree_view() -> void:
	if _skill_tree_view == null:
		return
	var points: int = int(_latest_stats.get("skill_points", 0))
	var possession_points: int = int(_latest_stats.get("possession_points", 0))
	var unlocked_nodes: Array = _latest_stats.get("unlocked_skill_nodes", [])
	_skill_tree_view.set_skill_data(points, possession_points, unlocked_nodes)
	_skill_tree_view.set_corruption_ratio(_corruption_ratio)

func _make_spells_view() -> Control:
	var spells: VBoxContainer = VBoxContainer.new()
	spells.add_theme_constant_override("separation", 12)
	spells.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	spells.size_flags_vertical = Control.SIZE_EXPAND_FILL

	_spells_hover_label = _label("Hover over each sigil to reveal its name.", 15)
	_spells_hover_label.add_theme_color_override("font_color", Color(0.82, 0.73, 0.63))
	spells.add_child(_spells_hover_label)

	for category_variant in SPELL_SLOT_HOVER_CATEGORIES:
		var category := String(category_variant)
		var section: VBoxContainer = VBoxContainer.new()
		section.add_theme_constant_override("separation", 6)
		spells.add_child(section)

		var header := _label("%s Spells:" % String(SPELL_SLOT_HOVER_LABELS.get(category, category.capitalize())), 17)
		header.add_theme_color_override("font_color", Color(0.96, 0.88, 0.72))
		section.add_child(header)

		var row: HFlowContainer = HFlowContainer.new()
		row.add_theme_constant_override("h_separation", 8)
		row.add_theme_constant_override("v_separation", 8)
		section.add_child(row)
		_spell_category_rows[category] = row

	return spells

func _sync_spells_view() -> void:
	if _spells_hover_label != null:
		if _spells_hovered_name.is_empty():
			_spells_hover_label.text = "Hover over each sigil to reveal its name."
		else:
			_spells_hover_label.text = "Spell: %s" % _spells_hovered_name
	var next_signature := _spells_signature_for_current_stats()
	if next_signature == _spells_view_signature:
		return
	_spells_view_signature = next_signature
	for category_variant in SPELL_SLOT_HOVER_CATEGORIES:
		var category := String(category_variant)
		var row := _spell_category_rows.get(category) as HFlowContainer
		if row == null:
			continue
		for child in row.get_children():
			row.remove_child(child)
			child.queue_free()
		var entries := _spell_entries_for_category(category)
		if entries.is_empty():
			var empty_label := _label("None", 15)
			empty_label.add_theme_color_override("font_color", Color(0.56, 0.5, 0.47))
			row.add_child(empty_label)
			continue
		for entry in entries:
			row.add_child(_make_spell_chip(entry))

func _spells_signature_for_current_stats() -> String:
	var learned_spells: Array = _latest_stats.get("learned_spells", [])
	var tokens: Array[String] = []
	for spell_id_variant in learned_spells:
		tokens.append(String(spell_id_variant))
	tokens.sort()
	var active_slots: Dictionary = _latest_stats.get("active_spell_slots", {})
	var active_tokens: Array[String] = []
	for category_variant in active_slots.keys():
		active_tokens.append("%s:%s" % [String(category_variant), String(active_slots[category_variant])])
	active_tokens.sort()
	return "|".join(tokens) + "||" + "|".join(active_tokens)

func _spell_entries_for_category(category: String) -> Array[Dictionary]:
	var entries: Array[Dictionary] = []
	var added_ids: Array[String] = []
	if category == "attack":
		entries.append({
			"name": "Firestorm",
			"id": "fire_storm",
			"icon": FIRESTORM_TEXTURE,
			"category": category
		})
		added_ids.append("fire_storm")
	var learned_spells: Array = _latest_stats.get("learned_spells", [])
	for spell_id_variant in learned_spells:
		var spell_id := String(spell_id_variant)
		if _spell_category_for_id(spell_id) != category:
			continue
		if added_ids.has(spell_id):
			continue
		var display_name := _spell_display_name(spell_id)
		entries.append({
			"name": display_name,
			"id": spell_id,
			"icon": _spell_icon_for_id(spell_id),
			"text": _spell_chip_abbreviation(display_name),
			"category": category
		})
		added_ids.append(spell_id)
	return entries

func _make_spell_chip(entry: Dictionary) -> Control:
	var chip: Button = Button.new()
	chip.text = ""
	chip.custom_minimum_size = Vector2(54.0, 54.0)
	chip.focus_mode = Control.FOCUS_NONE
	chip.tooltip_text = _spell_tooltip_text(String(entry.get("name", "Spell")), String(entry.get("id", "")), String(entry.get("category", "")))
	chip.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	var chip_style := _spell_chip_style(String(entry.get("category", "attack")))
	chip.add_theme_stylebox_override("normal", chip_style)
	chip.add_theme_stylebox_override("hover", _hover_spell_chip_style(String(entry.get("category", "attack"))))
	chip.add_theme_stylebox_override("pressed", chip_style)
	chip.mouse_entered.connect(_on_spell_chip_mouse_entered.bind(String(entry.get("name", "Spell"))))
	chip.mouse_exited.connect(_on_spell_chip_mouse_exited)

	var center: CenterContainer = CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	center.mouse_filter = Control.MOUSE_FILTER_IGNORE
	chip.add_child(center)

	var icon := entry.get("icon", null) as Texture2D
	if icon != null:
		var icon_rect: TextureRect = TextureRect.new()
		icon_rect.texture = icon
		icon_rect.custom_minimum_size = Vector2(34.0, 34.0)
		icon_rect.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
		icon_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		icon_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
		center.add_child(icon_rect)
	else:
		var glyph := _label(String(entry.get("text", "?")), 16)
		glyph.add_theme_color_override("font_color", Color(1.0, 0.9, 0.78))
		glyph.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		glyph.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		glyph.mouse_filter = Control.MOUSE_FILTER_IGNORE
		center.add_child(glyph)

	return chip

func _spell_chip_style(category: String) -> StyleBoxFlat:
	var accent := _spell_category_color(category)
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.065, 0.038, 0.036, 0.96)
	style.border_color = accent
	style.set_border_width_all(2)
	style.set_corner_radius_all(8)
	style.content_margin_left = 8
	style.content_margin_right = 8
	style.content_margin_top = 8
	style.content_margin_bottom = 8
	return style

func _spell_category_color(category: String) -> Color:
	match category:
		"attack":
			return Color(0.95, 0.4, 0.18, 0.98)
		"defense":
			return Color(0.42, 0.7, 1.0, 0.98)
		"healing":
			return Color(0.54, 0.92, 0.64, 0.98)
		"buff":
			return Color(0.9, 0.72, 0.3, 0.98)
		"debuff":
			return Color(0.8, 0.42, 0.92, 0.98)
		_:
			return Color(0.74, 0.25, 0.12, 0.95)

func _spell_chip_abbreviation(display_name: String) -> String:
	var parts := display_name.split(" ", false)
	var abbreviation := ""
	for part in parts:
		if part.is_empty():
			continue
		abbreviation += part.substr(0, 1).to_upper()
	if abbreviation.length() >= 2:
		return abbreviation.substr(0, 3)
	if display_name.length() >= 2:
		return display_name.substr(0, 2).to_upper()
	return display_name.to_upper()

func _spell_icon_for_id(spell_id: String) -> Texture2D:
	if spell_id == "fire_storm":
		return FIRESTORM_TEXTURE
	var icon_path := String(SPELL_ICON_PATH_BY_ID.get(spell_id, ""))
	return _texture_from_path(icon_path)

func _on_spell_chip_mouse_entered(spell_name: String) -> void:
	_spells_hovered_name = spell_name
	if _spells_hover_label == null:
		return
	_spells_hover_label.text = "Spell: %s" % spell_name

func _on_spell_chip_mouse_exited() -> void:
	_spells_hovered_name = ""
	if _spells_hover_label == null:
		return
	_spells_hover_label.text = "Hover over each sigil to reveal its name."

func _make_inventory_view() -> Control:
	var inventory: HBoxContainer = HBoxContainer.new()
	inventory.add_theme_constant_override("separation", 8)
	inventory.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	inventory.size_flags_vertical = Control.SIZE_EXPAND_FILL

	# --- Left: Gloves with invisible socket hit-areas ---
	var equip_frame: Control = Control.new()
	equip_frame.custom_minimum_size = INVENTORY_GLOVE_FRAME_SIZE
	equip_frame.size = INVENTORY_GLOVE_FRAME_SIZE
	equip_frame.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	equip_frame.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	inventory.add_child(equip_frame)

	var equip_image: TextureRect = TextureRect.new()
	equip_image.texture = EQUIP_TEXTURE
	equip_image.set_anchors_preset(Control.PRESET_FULL_RECT)
	equip_image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	equip_image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	equip_image.mouse_filter = Control.MOUSE_FILTER_IGNORE
	equip_image.modulate = Color(1.0, 0.92, 0.82, 0.96)
	equip_frame.add_child(equip_image)

	_inventory_socket_nodes.clear()
	_inventory_socket_icons.clear()
	for socket_index in range(INVENTORY_SOCKET_COUNT):
		if socket_index >= INVENTORY_SOCKET_POSITIONS.size():
			continue
		var socket_position: Vector2 = INVENTORY_SOCKET_POSITIONS[socket_index]
		var socket: Panel = Panel.new()
		socket.custom_minimum_size = INVENTORY_SOCKET_HITBOX_SIZE
		socket.size = socket.custom_minimum_size
		socket.position = socket_position
		socket.clip_contents = true
		socket.mouse_filter = Control.MOUSE_FILTER_STOP
		socket.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		socket.z_index = 10
		socket.add_theme_stylebox_override("panel", _inventory_socket_hitbox_style(Color(0.0, 0.0, 0.0, 0.0)))
		socket.mouse_entered.connect(_on_inventory_socket_mouse_entered.bind(socket_index))
		socket.mouse_exited.connect(_on_inventory_socket_mouse_exited.bind(socket_index))
		socket.gui_input.connect(_on_inventory_socket_gui_input.bind(socket_index))
		equip_frame.add_child(socket)
		_inventory_socket_nodes.append(socket)

		var socket_icon := TextureRect.new()
		socket_icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		socket_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		socket_icon.texture = DIAMOND_UP_TEXTURE
		socket_icon.custom_minimum_size = INVENTORY_SOCKET_ICON_SIZE
		socket_icon.size = INVENTORY_SOCKET_ICON_SIZE
		socket_icon.position = socket_position + (INVENTORY_SOCKET_HITBOX_SIZE - INVENTORY_SOCKET_ICON_SIZE) * 0.5
		socket_icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
		socket_icon.z_index = 20
		socket_icon.visible = false
		equip_frame.add_child(socket_icon)
		_inventory_socket_icons.append(socket_icon)

	# --- Right: Info + Diamond Grid ---
	var details: VBoxContainer = VBoxContainer.new()
	details.add_theme_constant_override("separation", 10)
	details.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	details.size_flags_vertical = Control.SIZE_EXPAND_FILL
	inventory.add_child(details)

	_inventory_status_label = _label("", 14)
	_inventory_status_label.add_theme_color_override("font_color", Color(0.72, 0.64, 0.58))
	_inventory_status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_inventory_status_label.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	details.add_child(_inventory_status_label)

	var list_title := _label("Diamonds", 17)
	list_title.add_theme_color_override("font_color", Color(0.88, 0.83, 1.0))
	details.add_child(list_title)

	var diamond_scroll := ScrollContainer.new()
	diamond_scroll.custom_minimum_size = Vector2(0.0, INVENTORY_DIAMOND_SCROLL_HEIGHT)
	diamond_scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	diamond_scroll.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	diamond_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	diamond_scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
	details.add_child(diamond_scroll)

	var grid: GridContainer = GridContainer.new()
	grid.columns = INVENTORY_DIAMOND_GRID_COLUMNS
	grid.add_theme_constant_override("h_separation", INVENTORY_DIAMOND_GRID_H_SEPARATION)
	grid.add_theme_constant_override("v_separation", INVENTORY_DIAMOND_GRID_V_SEPARATION)
	grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	grid.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	diamond_scroll.add_child(grid)
	_inventory_diamond_grid = grid

	var bonus_title := _label("Accumulated Bonuses", 15)
	bonus_title.add_theme_color_override("font_color", Color(1.0, 0.78, 0.48))
	details.add_child(bonus_title)

	var bonus_panel := PanelContainer.new()
	bonus_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	bonus_panel.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	var bonus_style := StyleBoxFlat.new()
	bonus_style.bg_color = Color(0.05, 0.032, 0.04, 0.88)
	bonus_style.border_color = Color(0.72, 0.31, 0.16, 0.82)
	bonus_style.set_border_width_all(1)
	bonus_style.set_corner_radius_all(6)
	bonus_style.content_margin_left = 10
	bonus_style.content_margin_right = 10
	bonus_style.content_margin_top = 8
	bonus_style.content_margin_bottom = 8
	bonus_panel.add_theme_stylebox_override("panel", bonus_style)
	details.add_child(bonus_panel)

	_inventory_bonus_list = VBoxContainer.new()
	_inventory_bonus_list.add_theme_constant_override("separation", 4)
	_inventory_bonus_list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	bonus_panel.add_child(_inventory_bonus_list)

	_inventory_drag_preview = TextureRect.new()
	_inventory_drag_preview.visible = false
	_inventory_drag_preview.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_inventory_drag_preview.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_inventory_drag_preview.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	_inventory_drag_preview.texture = DIAMOND_TEXTURE
	_inventory_drag_preview.custom_minimum_size = INVENTORY_DRAG_ICON_SIZE
	_inventory_drag_preview.size = INVENTORY_DRAG_ICON_SIZE
	if _root_control != null:
		_root_control.add_child(_inventory_drag_preview)
	else:
		inventory.add_child(_inventory_drag_preview)
	_inventory_drag_preview.move_to_front()

	return inventory

func _sync_inventory_view() -> void:
	var learned_spells: Array = _latest_stats.get("learned_spells", [])
	_inventory_catalog_by_id.clear()
	var catalog: Array = _latest_stats.get("faded_catalog", [])
	for entry_variant in catalog:
		if entry_variant is Dictionary:
			var entry := entry_variant as Dictionary
			_inventory_catalog_by_id[String(entry.get("id", ""))] = entry
	var socket_values: Array = _latest_stats.get("faded_sockets", [])
	_inventory_socket_ids.clear()
	for socket_value in socket_values:
		_inventory_socket_ids.append(String(socket_value))
	while _inventory_socket_ids.size() < INVENTORY_SOCKET_COUNT:
		_inventory_socket_ids.append("")
	if _inventory_socket_ids.size() > INVENTORY_SOCKET_COUNT:
		_inventory_socket_ids.resize(INVENTORY_SOCKET_COUNT)
	_refresh_inventory_socket_display()
	_refresh_inventory_diamond_grid(_latest_stats.get("faded_owned", {}), catalog)
	_refresh_inventory_bonus_summary(_latest_stats.get("faded_bonus_summary", []))
	if _inventory_status_label != null:
		_inventory_status_label.text = "Drag a diamond onto a glove socket  |  Right-click socket to unsocket"

func _refresh_inventory_socket_display() -> void:
	for index in range(_inventory_socket_nodes.size()):
		if index >= _inventory_socket_icons.size():
			continue
		var socket: Panel = _inventory_socket_nodes[index]
		var icon: TextureRect = _inventory_socket_icons[index]
		if socket == null or icon == null:
			continue
		var diamond_id := ""
		if index < _inventory_socket_ids.size():
			diamond_id = _inventory_socket_ids[index]
		if diamond_id.is_empty():
			icon.visible = false
			_apply_inventory_socket_style(socket, Color(0.88, 0.44, 0.34, 1.0), false, index == _inventory_hovered_socket and not _inventory_dragging_diamond_id.is_empty(), 0.0)
			socket.tooltip_text = "Empty glove socket\nLeft-click drag to socket/swap, Right-click to unsocket."
			continue
		var entry: Dictionary = _inventory_catalog_by_id.get(diamond_id, {}) as Dictionary
		var name := String(entry.get("name", "Faded Diamond"))
		var bonus := String(entry.get("bonus", ""))
		var color: Color = entry.get("color", Color(0.9, 0.78, 0.58)) if entry.get("color") is Color else Color(0.9, 0.78, 0.58)
		var pulse := 0.5 + 0.5 * sin(_ui_time * 3.2 + float(index) * 0.9)
		icon.visible = true
		icon.texture = DIAMOND_UP_TEXTURE
		var socket_position: Vector2 = INVENTORY_SOCKET_POSITIONS[index] if index < INVENTORY_SOCKET_POSITIONS.size() else socket.position
		var diamond_offset: Vector2 = INVENTORY_SOCKET_DIAMOND_OFFSETS.get(diamond_id, Vector2.ZERO)
		icon.position = socket_position + (INVENTORY_SOCKET_HITBOX_SIZE - INVENTORY_SOCKET_ICON_SIZE) * 0.5 + diamond_offset
		icon.modulate = color.lightened(0.08 + pulse * 0.1)
		_apply_inventory_socket_style(socket, color, true, index == _inventory_hovered_socket and not _inventory_dragging_diamond_id.is_empty(), pulse)
		socket.tooltip_text = "%s\n%s\nLeft-click drag to socket/swap, Right-click to unsocket." % [name, bonus]

func _apply_inventory_socket_style(socket: Panel, _color: Color, filled: bool, _hovered_drop_target: bool, _pulse: float = 0.0) -> void:
	if socket == null:
		return
	var style := StyleBoxFlat.new()
	if filled:
		style.bg_color = Color(0.0, 0.0, 0.0, 0.0)
		style.border_color = Color(0.0, 0.0, 0.0, 0.0)
	else:
		style.bg_color = Color(0.0, 0.0, 0.0, 0.0)
		style.border_color = Color(0.0, 0.0, 0.0, 0.0)
	style.set_border_width_all(0)
	style.set_corner_radius_all(INVENTORY_SOCKET_CORNER_RADIUS)
	socket.add_theme_stylebox_override("panel", style)

func _inventory_socket_hitbox_style(fill: Color) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = fill
	style.border_color = Color(0.0, 0.0, 0.0, 0.0)
	style.set_border_width_all(0)
	style.set_corner_radius_all(INVENTORY_SOCKET_CORNER_RADIUS)
	return style

func _update_inventory_socket_glow() -> void:
	if _character_panel == null or not _character_panel.visible:
		return
	if _character_panel_tab != CHARACTER_PANEL_TAB_INVENTORY:
		return
	if _inventory_socket_nodes.is_empty():
		return
	_refresh_inventory_socket_display()

func _refresh_inventory_diamond_list(_owned_data: Variant, _catalog: Array) -> void:
	pass  # replaced by _refresh_inventory_diamond_grid

func _refresh_inventory_bonus_summary(summary_data: Variant) -> void:
	if _inventory_bonus_list == null:
		return
	for child in _inventory_bonus_list.get_children():
		_inventory_bonus_list.remove_child(child)
		child.queue_free()
	var summary: Array = summary_data if summary_data is Array else []
	if summary.is_empty():
		var empty_label := _label("No socketed diamond bonuses", 12)
		empty_label.add_theme_color_override("font_color", Color(0.56, 0.49, 0.48))
		empty_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		_inventory_bonus_list.add_child(empty_label)
		return
	for line_variant in summary:
		var line := String(line_variant)
		if line.is_empty():
			continue
		var label := _label(line, 12)
		label.add_theme_color_override("font_color", Color(0.92, 0.83, 0.68))
		label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		_inventory_bonus_list.add_child(label)

func _refresh_inventory_diamond_grid(owned_data: Variant, catalog: Array) -> void:
	if _inventory_diamond_grid == null:
		return
	for child in _inventory_diamond_grid.get_children():
		_inventory_diamond_grid.remove_child(child)
		child.queue_free()
	var owned := {}
	if owned_data is Dictionary:
		owned = owned_data as Dictionary
	var has_any := false
	for entry_variant in catalog:
		if not (entry_variant is Dictionary):
			continue
		var entry := entry_variant as Dictionary
		var diamond_id := String(entry.get("id", ""))
		if diamond_id.is_empty():
			continue
		var owned_count := int(owned.get(diamond_id, 0))
		if owned_count <= 0:
			continue
		has_any = true
		var socketed_count := 0
		for socket_id in _inventory_socket_ids:
			if socket_id == diamond_id:
				socketed_count += 1
		var available_count := maxi(0, owned_count - socketed_count)
		var gem_color: Color = entry.get("color", Color(0.9, 0.78, 0.58)) if entry.get("color") is Color else Color(0.9, 0.78, 0.58)

		# Cell container
		var cell := Panel.new()
		cell.custom_minimum_size = INVENTORY_DIAMOND_CELL_SIZE
		cell.clip_contents = true
		cell.mouse_filter = Control.MOUSE_FILTER_STOP
		cell.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		var cell_style := StyleBoxFlat.new()
		cell_style.bg_color = Color(0.065, 0.04, 0.048, 0.94)
		cell_style.border_color = Color(0.88, 0.46, 0.22, 0.92)
		cell_style.set_border_width_all(1)
		cell_style.set_corner_radius_all(6)
		cell.add_theme_stylebox_override("panel", cell_style)
		cell.tooltip_text = "%s\n%s\nOwned: %s  Available: %s" % [String(entry.get("name", "Diamond")), String(entry.get("bonus", "")), owned_count, available_count]
		cell.gui_input.connect(_on_inventory_diamond_gui_input.bind(diamond_id, available_count))

		var cell_content := VBoxContainer.new()
		cell_content.set_anchors_preset(Control.PRESET_FULL_RECT)
		cell_content.offset_top = 5.0
		cell_content.offset_bottom = -3.0
		cell_content.alignment = BoxContainer.ALIGNMENT_CENTER
		cell_content.add_theme_constant_override("separation", 3)
		cell_content.mouse_filter = Control.MOUSE_FILTER_IGNORE
		cell.add_child(cell_content)

		var diamond_visual := _make_diamond_visual(diamond_id, gem_color, INVENTORY_DIAMOND_VISUAL_SIZE, available_count <= 0)
		diamond_visual.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		cell_content.add_child(diamond_visual)

		var count_lbl := _label("x%s" % available_count, 10)
		count_lbl.custom_minimum_size = Vector2(INVENTORY_DIAMOND_CELL_SIZE.x, 14.0)
		count_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		count_lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		count_lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
		var badge_color := _diamond_label_color(diamond_id, gem_color, available_count <= 0)
		count_lbl.add_theme_color_override("font_color", badge_color)
		cell_content.add_child(count_lbl)

		_inventory_diamond_grid.add_child(cell)
	if not has_any:
		for index in range(INVENTORY_DIAMOND_EMPTY_SLOT_COUNT):
			_inventory_diamond_grid.add_child(_make_empty_inventory_diamond_slot())

func _make_empty_inventory_diamond_slot() -> Control:
	var slot := Panel.new()
	slot.custom_minimum_size = INVENTORY_DIAMOND_CELL_SIZE
	slot.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.045, 0.036, 0.042, 0.68)
	style.border_color = Color(0.28, 0.17, 0.13, 0.75)
	style.set_border_width_all(1)
	style.set_corner_radius_all(6)
	slot.add_theme_stylebox_override("panel", style)
	return slot

func _on_inventory_diamond_gui_input(event: InputEvent, diamond_id: String, available_count: int) -> void:
	if not (event is InputEventMouseButton):
		return
	var mouse_event := event as InputEventMouseButton
	if mouse_event.button_index != MOUSE_BUTTON_LEFT:
		return
	if mouse_event.pressed:
		if available_count <= 0:
			return
		_start_inventory_drag(diamond_id, -1)
	else:
		_finish_inventory_drag()

func _on_inventory_socket_gui_input(event: InputEvent, slot_index: int) -> void:
	if not (event is InputEventMouseButton):
		return
	var mouse_event: InputEventMouseButton = event as InputEventMouseButton
	if mouse_event.button_index == MOUSE_BUTTON_RIGHT and mouse_event.pressed:
		if slot_index >= 0 and slot_index < _inventory_socket_ids.size():
			if not _inventory_socket_ids[slot_index].is_empty():
				inventory_socket_clear_requested.emit(slot_index)
		return
	if mouse_event.button_index != MOUSE_BUTTON_LEFT:
		return
	if mouse_event.pressed:
		if slot_index >= 0 and slot_index < _inventory_socket_ids.size():
			var diamond_id: String = _inventory_socket_ids[slot_index]
			if not diamond_id.is_empty():
				_start_inventory_drag(diamond_id, slot_index)
	else:
		_finish_inventory_drag()

func _on_inventory_socket_mouse_entered(slot_index: int) -> void:
	_inventory_hovered_socket = slot_index
	_refresh_inventory_socket_display()

func _on_inventory_socket_mouse_exited(slot_index: int) -> void:
	if _inventory_hovered_socket == slot_index:
		_inventory_hovered_socket = -1
	_refresh_inventory_socket_display()

func _start_inventory_drag(diamond_id: String, source_slot_index: int) -> void:
	_inventory_dragging_diamond_id = diamond_id
	_inventory_dragging_source_slot = source_slot_index
	_refresh_inventory_socket_display()
	if _inventory_drag_preview == null:
		return
	var entry: Dictionary = _inventory_catalog_by_id.get(diamond_id, {}) as Dictionary
	var gem_color: Color = entry.get("color", Color(0.9, 0.78, 0.58)) if entry.get("color") is Color else Color(0.9, 0.78, 0.58)
	_inventory_drag_preview.texture = _diamond_texture_for_id(diamond_id)
	_inventory_drag_preview.modulate = gem_color.lightened(0.08)
	_inventory_drag_preview.visible = true
	_inventory_drag_preview.move_to_front()
	_update_inventory_drag_preview()

func _finish_inventory_drag() -> void:
	if _inventory_dragging_diamond_id.is_empty():
		return
	if _inventory_hovered_socket >= 0:
		inventory_socket_drop_requested.emit(_inventory_hovered_socket, _inventory_dragging_diamond_id, _inventory_dragging_source_slot)
	_inventory_dragging_diamond_id = ""
	_inventory_dragging_source_slot = -1
	_refresh_inventory_socket_display()
	if _inventory_drag_preview != null:
		_inventory_drag_preview.visible = false

func _update_inventory_drag_preview() -> void:
	if _inventory_drag_preview == null:
		return
	if _inventory_dragging_diamond_id.is_empty():
		_inventory_drag_preview.visible = false
		return
	if not _inventory_drag_preview.visible:
		return
	var mouse: Vector2 = get_viewport().get_mouse_position()
	_inventory_drag_preview.size = INVENTORY_DRAG_ICON_SIZE
	_inventory_drag_preview.global_position = mouse - (INVENTORY_DRAG_ICON_SIZE * 0.5)

func _make_map_view() -> Control:
	var map_root: HBoxContainer = HBoxContainer.new()
	map_root.alignment = BoxContainer.ALIGNMENT_CENTER
	map_root.add_theme_constant_override("separation", 14)
	map_root.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	map_root.size_flags_vertical = Control.SIZE_EXPAND_FILL

	var device_card := PanelContainer.new()
	device_card.custom_minimum_size = MAP_DEVICE_CARD_SIZE
	device_card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	device_card.size_flags_vertical = Control.SIZE_EXPAND_FILL
	device_card.size_flags_stretch_ratio = 0.72
	device_card.add_theme_stylebox_override("panel", _map_card_style())
	map_root.add_child(device_card)

	var content := VBoxContainer.new()
	content.alignment = BoxContainer.ALIGNMENT_CENTER
	content.add_theme_constant_override("separation", 10)
	device_card.add_child(content)

	var title := _label("Teleport Anchor", 21)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_color_override("font_color", Color(1.0, 0.8, 0.52))
	content.add_child(title)

	var device_stage := Control.new()
	device_stage.custom_minimum_size = MAP_DEVICE_STAGE_SIZE
	device_stage.size = MAP_DEVICE_STAGE_SIZE
	device_stage.clip_contents = false
	device_stage.mouse_filter = Control.MOUSE_FILTER_IGNORE
	device_stage.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	content.add_child(device_stage)

	var outer_ring := _make_teleport_device_layer(
		device_stage,
		_texture_from_path(TELEPORT_DEVICE_OUTER_RING_PATH),
		MAP_DEVICE_OUTER_SIZE,
		MAP_DEVICE_STAGE_SIZE * 0.5
	)
	outer_ring.z_index = 0
	_map_device_inner_vortex = _make_teleport_device_layer(
		device_stage,
		_texture_from_path(TELEPORT_DEVICE_INNER_VORTEX_PATH),
		MAP_DEVICE_VORTEX_SIZE,
		MAP_DEVICE_INNER_CENTER
	)
	_map_device_inner_vortex.z_index = 1
	_map_device_stone_ring = _make_teleport_device_layer(
		device_stage,
		_texture_from_path(TELEPORT_DEVICE_STONE_RING_PATH),
		MAP_DEVICE_STONE_RING_SIZE,
		MAP_DEVICE_INNER_CENTER
	)
	_map_device_stone_ring.z_index = 2
	_map_device_stone_ring.move_to_front()

	_map_status_label = _label("", 14)
	_map_status_label.custom_minimum_size = Vector2(280.0, 36.0)
	_map_status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_map_status_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_map_status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_map_status_label.add_theme_color_override("font_color", Color(0.82, 0.74, 0.64))
	content.add_child(_map_status_label)

	var teleport_button := Button.new()
	teleport_button.text = "Awaken Device"
	teleport_button.custom_minimum_size = Vector2(220.0, 38.0)
	teleport_button.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	teleport_button.focus_mode = Control.FOCUS_NONE
	teleport_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	teleport_button.add_theme_font_size_override("font_size", 15)
	teleport_button.add_theme_color_override("font_color", Color(1.0, 0.86, 0.66))
	teleport_button.add_theme_stylebox_override("normal", _button_style(Color(0.12, 0.045, 0.04, 0.92)))
	teleport_button.add_theme_stylebox_override("hover", _hover_button_style(Color(0.25, 0.075, 0.055, 0.98)))
	teleport_button.add_theme_stylebox_override("pressed", _button_style(Color(0.075, 0.026, 0.026, 1.0)))
	teleport_button.pressed.connect(_on_map_teleport_device_pressed)
	content.add_child(teleport_button)
	_map_teleport_device_button = teleport_button

	var world_card := PanelContainer.new()
	world_card.custom_minimum_size = WORLD_MAP_PANEL_SIZE
	world_card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	world_card.size_flags_vertical = Control.SIZE_EXPAND_FILL
	world_card.size_flags_stretch_ratio = 1.55
	world_card.add_theme_stylebox_override("panel", _map_card_style())
	map_root.add_child(world_card)

	var world_content := VBoxContainer.new()
	world_content.alignment = BoxContainer.ALIGNMENT_CENTER
	world_content.add_theme_constant_override("separation", 10)
	world_card.add_child(world_content)

	var world_title := _label("World Map", 21)
	world_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	world_title.add_theme_color_override("font_color", Color(1.0, 0.8, 0.52))
	world_content.add_child(world_title)

	var map_stage := Control.new()
	map_stage.custom_minimum_size = WORLD_MAP_VIEW_SIZE
	map_stage.size = WORLD_MAP_VIEW_SIZE
	map_stage.clip_contents = true
	map_stage.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	map_stage.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	world_content.add_child(map_stage)

	var world_map := TextureRect.new()
	world_map.texture = _texture_from_path(WORLD_MAP_FIRST_VELMORA_PATH)
	world_map.set_anchors_preset(Control.PRESET_FULL_RECT)
	world_map.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	world_map.stretch_mode = TextureRect.STRETCH_SCALE
	world_map.mouse_filter = Control.MOUSE_FILTER_IGNORE
	map_stage.add_child(world_map)
	_world_map_image = world_map

	_make_map_destination_button(
		map_stage,
		MAP_DESTINATION_BLACK_VAULT,
		"The Black Vault",
		Vector2(0.18, 0.73),
		Vector2(0.24, 0.22)
	)
	_make_map_destination_button(
		map_stage,
		MAP_DESTINATION_VELMORA,
		"Velmora, The Hollow City",
		Vector2(0.46, 0.51),
		Vector2(0.27, 0.21)
	)
	_make_map_destination_button(
		map_stage,
		MAP_DESTINATION_HOOFGROVE_WILDS,
		"Hoofgrove Wilds",
		Vector2(0.24, 0.47),
		Vector2(0.25, 0.24)
	)

	return map_root

func _make_map_destination_button(parent: Control, destination_id: String, tooltip: String, center_ratio: Vector2, size_ratio: Vector2) -> void:
	var button_size := WORLD_MAP_VIEW_SIZE * size_ratio
	var button_position := WORLD_MAP_VIEW_SIZE * center_ratio - button_size * 0.5

	var glow := Panel.new()
	glow.position = button_position
	glow.size = button_size
	glow.mouse_filter = Control.MOUSE_FILTER_IGNORE
	glow.add_theme_stylebox_override("panel", _map_destination_style(Color(1.0, 0.36, 0.08, 0.0), Color(1.0, 0.58, 0.18, 0.0)))
	glow.visible = false
	parent.add_child(glow)
	_map_destination_glows[destination_id] = glow

	var button := Button.new()
	button.text = ""
	button.tooltip_text = tooltip
	button.position = button_position
	button.size = button_size
	button.focus_mode = Control.FOCUS_NONE
	button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	button.add_theme_stylebox_override("normal", _icon_button_style(Color.TRANSPARENT, Color.TRANSPARENT))
	button.add_theme_stylebox_override("hover", _icon_button_style(Color(1.0, 0.36, 0.08, 0.16), Color(1.0, 0.58, 0.18, 0.8)))
	button.add_theme_stylebox_override("pressed", _icon_button_style(Color(0.35, 0.055, 0.03, 0.24), Color(1.0, 0.8, 0.36, 0.95)))
	button.pressed.connect(_on_map_destination_pressed.bind(destination_id))
	parent.add_child(button)
	_map_destination_buttons[destination_id] = button

func _make_teleport_device_layer(parent: Control, texture: Texture2D, size: Vector2, center: Vector2) -> TextureRect:
	var layer := TextureRect.new()
	layer.texture = texture
	layer.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	layer.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	layer.size = size
	layer.custom_minimum_size = size
	layer.position = center - size * 0.5
	layer.pivot_offset = size * 0.5
	layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(layer)
	return layer

func _sync_map_view() -> void:
	var has_teleport_device := _has_teleport_device_in_stats()
	var has_world_map := _has_unlocked_world_map()
	if not has_teleport_device:
		_map_selecting_destination = false
	if _map_status_label != null:
		if not has_teleport_device:
			_map_status_label.text = "No anchor bound."
		elif not has_world_map:
			_map_status_label.text = "No map revealed."
		elif _map_selecting_destination:
			_map_status_label.text = "Open anchors are calling."
		else:
			_map_status_label.text = "Wake the device to choose a destination."
	if _map_teleport_device_button != null:
		_map_teleport_device_button.visible = has_teleport_device and has_world_map
		_map_teleport_device_button.disabled = not has_teleport_device or not has_world_map
		_map_teleport_device_button.text = "Anchors Open" if _map_selecting_destination else "Awaken Device"
	if _world_map_image != null:
		var map_texture := _texture_from_path(_unlocked_world_map_path())
		_world_map_image.texture = map_texture
		_world_map_image.visible = map_texture != null
	for destination_id in _map_destination_buttons.keys():
		var button := _map_destination_buttons[destination_id] as Button
		var destination_unlocked := has_teleport_device and has_world_map and _is_map_destination_unlocked(String(destination_id))
		if button != null:
			button.disabled = not destination_unlocked
			button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND if destination_unlocked else Control.CURSOR_ARROW
		var glow := _map_destination_glows.get(destination_id) as Panel
		if glow != null:
			glow.visible = _map_selecting_destination and destination_unlocked

func _update_map_tab_animation(delta: float) -> void:
	if _map_view == null or not _map_view.visible:
		return
	if _map_device_inner_vortex != null:
		var speed_multiplier := 2.2 if _map_selecting_destination else 1.0
		_map_device_inner_vortex.rotation += MAP_DEVICE_VORTEX_ROTATION_SPEED * delta * speed_multiplier
		var pulse_amount := MAP_DEVICE_VORTEX_PULSE_AMOUNT * (1.35 if _map_selecting_destination else 1.0)
		var pulse_scale := 1.0 + sin(_ui_time * MAP_DEVICE_VORTEX_PULSE_SPEED) * pulse_amount
		_map_device_inner_vortex.scale = Vector2.ONE * pulse_scale
		_map_device_inner_vortex.modulate = Color(1.0, 0.92 + pulse_amount, 0.86 + pulse_amount, 0.96)
	if _map_device_stone_ring != null:
		var speed_multiplier := 2.2 if _map_selecting_destination else 1.0
		_map_device_stone_ring.rotation += MAP_DEVICE_STONE_RING_ROTATION_SPEED * delta * speed_multiplier
		var stone_pulse := 1.0 + sin(_ui_time * MAP_DEVICE_VORTEX_PULSE_SPEED + PI * 0.5) * 0.012
		_map_device_stone_ring.scale = Vector2.ONE * stone_pulse
	if _map_selecting_destination:
		var pulse := 0.45 + 0.38 * sin(_ui_time * 6.2)
		for destination_id in _map_destination_glows.keys():
			var glow := _map_destination_glows[destination_id] as Panel
			if glow != null:
				glow.add_theme_stylebox_override("panel", _map_destination_style(
					Color(1.0, 0.28, 0.06, 0.12 + pulse * 0.16),
					Color(1.0, 0.62, 0.2, 0.38 + pulse * 0.48)
				))

func _has_teleport_device_in_stats() -> bool:
	var relic_owned: Variant = _latest_stats.get("relic_owned", {})
	return relic_owned is Dictionary and int((relic_owned as Dictionary).get("teleport_device", 0)) > 0

func _has_unlocked_world_map() -> bool:
	return not _unlocked_world_map_path().is_empty()

func _is_map_destination_unlocked(destination_id: String) -> bool:
	match destination_id:
		MAP_DESTINATION_BLACK_VAULT, MAP_DESTINATION_VELMORA:
			return _has_unlocked_world_map()
		MAP_DESTINATION_HOOFGROVE_WILDS:
			return _has_unlocked_map_id(MAP_HOOFGROVE_UNLOCK_ID)
		_:
			return false

func _has_unlocked_map_id(map_id: String) -> bool:
	var target := map_id.strip_edges().get_file().to_lower()
	if target.is_empty():
		return false
	var unlocked_maps: Array = _latest_stats.get("unlocked_maps", [])
	for unlocked_variant in unlocked_maps:
		var unlocked_id := String(unlocked_variant).strip_edges().get_file().to_lower()
		if unlocked_id == target:
			return true
	return false

func _unlocked_world_map_path() -> String:
	var unlocked_maps: Array = _latest_stats.get("unlocked_maps", [])
	if unlocked_maps.is_empty():
		return ""
	var map_id := String(unlocked_maps[unlocked_maps.size() - 1]).strip_edges()
	if map_id.is_empty():
		return ""
	if map_id.begins_with("res://"):
		return map_id
	return "res://assets/images/objects/world-map/%s" % map_id

func _make_relics_view() -> Control:
	var relics: HBoxContainer = HBoxContainer.new()
	relics.add_theme_constant_override("separation", 24)
	relics.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	relics.size_flags_vertical = Control.SIZE_EXPAND_FILL

	var equip_frame: Control = Control.new()
	equip_frame.custom_minimum_size = INVENTORY_GLOVE_FRAME_SIZE
	equip_frame.size = INVENTORY_GLOVE_FRAME_SIZE
	equip_frame.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	equip_frame.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	relics.add_child(equip_frame)

	var equip_image: TextureRect = TextureRect.new()
	equip_image.texture = RELIC_EQUIP_TEXTURE
	equip_image.set_anchors_preset(Control.PRESET_FULL_RECT)
	equip_image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	equip_image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	equip_image.mouse_filter = Control.MOUSE_FILTER_IGNORE
	equip_image.modulate = Color(1.0, 0.92, 0.82, 0.96)
	equip_frame.add_child(equip_image)

	var details: VBoxContainer = VBoxContainer.new()
	details.add_theme_constant_override("separation", 10)
	details.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	details.size_flags_vertical = Control.SIZE_EXPAND_FILL
	relics.add_child(details)

	_relics_status_label = _label("", 14)
	_relics_status_label.add_theme_color_override("font_color", Color(0.72, 0.64, 0.58))
	_relics_status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_relics_status_label.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	details.add_child(_relics_status_label)

	var list_title := _label("Relics", 17)
	list_title.add_theme_color_override("font_color", Color(1.0, 0.82, 0.6))
	details.add_child(list_title)

	var grid: GridContainer = GridContainer.new()
	grid.columns = 5
	grid.add_theme_constant_override("h_separation", 8)
	grid.add_theme_constant_override("v_separation", 8)
	grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	grid.size_flags_vertical = Control.SIZE_EXPAND_FILL
	details.add_child(grid)
	_relics_grid = grid

	return relics

func _sync_relics_view() -> void:
	var relic_owned: Variant = _latest_stats.get("relic_owned", {})
	_refresh_relic_grid(relic_owned, _latest_stats.get("relic_catalog", []))

func _refresh_relic_grid(owned_data: Variant, catalog: Variant) -> void:
	if _relics_grid == null:
		return
	for child in _relics_grid.get_children():
		_relics_grid.remove_child(child)
		child.queue_free()
	var owned := {}
	if owned_data is Dictionary:
		owned = owned_data as Dictionary
	var entries: Array[Dictionary] = []
	if catalog is Array:
		for entry_variant in catalog:
			if not (entry_variant is Dictionary):
				continue
			var entry := (entry_variant as Dictionary).duplicate(true)
			var relic_id := String(entry.get("id", ""))
			if relic_id.is_empty():
				continue
			if relic_id == "teleport_device":
				continue
			var owned_count := int(entry.get("owned_count", owned.get(relic_id, 0)))
			if owned_count <= 0:
				continue
			entry["owned_count"] = owned_count
			entries.append(entry)
	if entries.is_empty():
		if _relics_status_label != null:
			_relics_status_label.text = "Relics carried: 0"
		for index in range(RELIC_GRID_EMPTY_SLOT_COUNT):
			_relics_grid.add_child(_make_empty_relic_slot())
		return
	if _relics_status_label != null:
		_relics_status_label.text = "Relics carried: %s" % entries.size()
	for entry in entries:
		_relics_grid.add_child(_make_relic_cell(entry))

func _make_empty_relic_slot() -> Control:
	var slot := Panel.new()
	slot.custom_minimum_size = RELIC_GRID_CELL_SIZE
	slot.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.045, 0.036, 0.042, 0.68)
	style.border_color = Color(0.28, 0.17, 0.13, 0.75)
	style.set_border_width_all(1)
	style.set_corner_radius_all(6)
	slot.add_theme_stylebox_override("panel", style)
	return slot

func _make_relic_cell(entry: Dictionary) -> Control:
	var cell := Panel.new()
	cell.custom_minimum_size = RELIC_GRID_CELL_SIZE
	cell.clip_contents = true
	cell.mouse_filter = Control.MOUSE_FILTER_STOP
	cell.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	var cell_style := StyleBoxFlat.new()
	cell_style.bg_color = Color(0.065, 0.04, 0.048, 0.94)
	cell_style.border_color = Color(0.88, 0.46, 0.22, 0.92)
	cell_style.set_border_width_all(1)
	cell_style.set_corner_radius_all(6)
	cell.add_theme_stylebox_override("panel", cell_style)

	var name := String(entry.get("name", "Relic"))
	var description := String(entry.get("description", entry.get("bonus", "")))
	var owned_count := int(entry.get("owned_count", 1))
	cell.tooltip_text = "%s\n%s\nOwned: %s" % [name, description, owned_count]

	var cell_content := VBoxContainer.new()
	cell_content.set_anchors_preset(Control.PRESET_FULL_RECT)
	cell_content.offset_top = 5.0
	cell_content.offset_bottom = -3.0
	cell_content.alignment = BoxContainer.ALIGNMENT_CENTER
	cell_content.add_theme_constant_override("separation", 3)
	cell_content.mouse_filter = Control.MOUSE_FILTER_IGNORE
	cell.add_child(cell_content)

	var texture := _texture_for_relic_entry(entry)
	if texture != null:
		var icon := TextureRect.new()
		icon.texture = texture
		icon.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
		icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		icon.custom_minimum_size = RELIC_GRID_ICON_SIZE
		icon.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
		cell_content.add_child(icon)
	else:
		var glyph := _label(_spell_chip_abbreviation(name), 15)
		glyph.add_theme_color_override("font_color", Color(1.0, 0.86, 0.66))
		glyph.custom_minimum_size = RELIC_GRID_ICON_SIZE
		glyph.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		glyph.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		glyph.mouse_filter = Control.MOUSE_FILTER_IGNORE
		cell_content.add_child(glyph)

	var count_lbl := _label("x%s" % owned_count, 10)
	count_lbl.custom_minimum_size = Vector2(RELIC_GRID_CELL_SIZE.x, 14.0)
	count_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	count_lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	count_lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
	count_lbl.add_theme_color_override("font_color", Color(1.0, 0.78, 0.48))
	cell_content.add_child(count_lbl)

	return cell

func _texture_for_relic_entry(entry: Dictionary) -> Texture2D:
	var texture := entry.get("texture", null) as Texture2D
	if texture != null:
		return texture
	var image_path := String(entry.get("image", entry.get("icon_path", "")))
	if image_path.is_empty():
		return null
	if not ResourceLoader.exists(image_path):
		return null
	return load(image_path) as Texture2D

func _character_stats_text() -> String:
	var life: int = int(_latest_stats.get("life", 100))
	var max_life: int = int(_latest_stats.get("max_life", 100))
	var level: int = int(_latest_stats.get("level", 1))
	var xp: int = int(_latest_stats.get("xp", 0))
	var xp_to_next: int = int(_latest_stats.get("xp_to_next", 100))
	var skill_points: int = int(_latest_stats.get("skill_points", 0))
	var possession_points: int = int(_latest_stats.get("possession_points", 0))
	var gold: int = int(_latest_stats.get("gold", 0))
	var shield: int = int(_latest_stats.get("shield", 0))
	var active_attack_spell: String = String(_latest_stats.get("active_attack_spell", "Firestorm"))
	var active_attack_damage_min: int = int(_latest_stats.get("active_attack_damage_min", 0))
	var active_attack_damage_max: int = int(_latest_stats.get("active_attack_damage_max", active_attack_damage_min))
	var active_attack_cooldown: float = float(_latest_stats.get("active_attack_cooldown_duration", 4.5))
	return "Life: %s / %s\nPossession: %s%%\nPossession Points: %s\nShield: %s\nLevel: %s\nXP: %s / %s\nSkill Points: %s\nGold: %s\n\nActive Attack Spell: %s\ndamage: %s - %s\ncooldown: %.1fs" % [
		life,
		max_life,
		int(round(_possession_ratio * 100.0)),
		possession_points,
		shield,
		level,
		xp,
		xp_to_next,
		skill_points,
		gold,
		active_attack_spell,
		active_attack_damage_min,
		active_attack_damage_max,
		active_attack_cooldown
	]

func _on_demon_menu_button_mouse_entered() -> void:
	_demon_menu_hovered = true
	_refresh_demon_menu_visuals()

func _on_demon_menu_button_mouse_exited() -> void:
	_demon_menu_hovered = false
	_refresh_demon_menu_visuals()

func _trigger_level_up_feedback(level_gain: int) -> void:
	_level_up_pending_ack = true
	_level_up_feedback_timer = LEVEL_UP_FEEDBACK_SECONDS
	if _demon_level_label != null:
		_demon_level_label.text = "RITUAL DEEPENED\nSkill Point Granted" if level_gain <= 1 else "RITUAL DEEPENED\nSkill Points Granted"
		_demon_level_label.visible = true
		_demon_level_label.modulate = Color(1.0, 0.82, 0.42, 1.0)
		_demon_level_label.scale = Vector2(1.2, 1.2)
		var label_tween := _demon_level_label.create_tween()
		label_tween.tween_property(_demon_level_label, "scale", Vector2.ONE, 0.22).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	_play_level_up_sound()
	_pulse_level_up_screen()
	_spawn_level_up_embers()
	_refresh_demon_menu_visuals()

func _update_level_up_feedback(delta: float) -> void:
	if not _level_up_pending_ack:
		if _demon_level_label != null and _demon_level_label.visible:
			_demon_level_label.visible = false
			_refresh_demon_menu_visuals()
		return
	_level_up_feedback_timer = maxf(_level_up_feedback_timer - delta, 0.0)
	if _level_up_feedback_timer <= 0.0:
		_acknowledge_level_up_feedback()
		return
	if _demon_level_label != null:
		var rise := sin(_ui_time * (LEVEL_UP_BLINK_SPEED * 0.9)) * 2.5
		_position_demon_level_label(rise)
		var fade := clampf(_level_up_feedback_timer / LEVEL_UP_LABEL_FADE_SECONDS, 0.0, 1.0)
		_demon_level_label.modulate = Color(1.0, 0.82, 0.42, fade)
		_demon_level_label.visible = true
	_refresh_demon_menu_visuals()

func _play_level_up_sound() -> void:
	if _level_up_player == null:
		return
	_level_up_player.stop()
	_level_up_player.play()

func _pulse_level_up_screen() -> void:
	if _level_up_pulse_overlay == null:
		return
	_level_up_pulse_overlay.color = Color(0.42, 0.0, 0.0, 0.28)
	var pulse_tween := _level_up_pulse_overlay.create_tween()
	pulse_tween.tween_property(_level_up_pulse_overlay, "color:a", 0.0, 0.42).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

func _spawn_level_up_embers() -> void:
	if _level_up_ember_layer == null:
		return
	var origin := Vector2(
		DEMON_MENU_LEFT_OFFSET + DEMON_MENU_BUTTON_SIZE.x * 0.5,
		DEMON_MENU_TOP_OFFSET + DEMON_MENU_BUTTON_SIZE.y * 0.15
	)
	for i in range(18):
		var ember := ColorRect.new()
		ember.mouse_filter = Control.MOUSE_FILTER_IGNORE
		var ember_size := _rng.randf_range(2.0, 5.0)
		ember.size = Vector2(ember_size, ember_size)
		ember.position = origin + Vector2(_rng.randf_range(-34.0, 34.0), _rng.randf_range(-8.0, 16.0))
		ember.color = Color(1.0, _rng.randf_range(0.32, 0.68), 0.08, _rng.randf_range(0.78, 1.0))
		_level_up_ember_layer.add_child(ember)
		var drift := Vector2(_rng.randf_range(-26.0, 26.0), _rng.randf_range(-86.0, -38.0))
		var ember_tween := ember.create_tween()
		ember_tween.tween_property(ember, "position", ember.position + drift, _rng.randf_range(0.75, 1.25)).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		ember_tween.parallel().tween_property(ember, "color:a", 0.0, _rng.randf_range(0.65, 1.05))
		ember_tween.parallel().tween_property(ember, "scale", Vector2.ONE * _rng.randf_range(0.35, 0.7), 0.9)
		ember_tween.tween_callback(Callable(ember, "queue_free"))

func _refresh_demon_menu_visuals() -> void:
	if _demon_menu_button == null:
		return
	var flash_active := _level_up_pending_ack
	var flash_on := flash_active and int(_ui_time * (LEVEL_UP_BLINK_SPEED * 2.0)) % 2 == 0
	var button_scale := Vector2.ONE
	var button_modulate := Color.WHITE
	var image_modulate := Color.WHITE
	var outline_alpha := 0.34
	if _demon_menu_hovered:
		button_scale = Vector2(1.08, 1.08)
		button_modulate = Color(1.0, 0.82, 0.72, 1.0)
		outline_alpha = 0.96
	if flash_active:
		var slow_blink_on := int(_ui_time * (LEVEL_UP_BLINK_SPEED * 2.0)) % 2 == 0
		button_scale *= 1.03 if flash_on else 0.98
		button_modulate = Color(1.0, 0.7 if slow_blink_on else 0.55, 0.56, 1.0)
		image_modulate = Color(1.0, 0.8 if slow_blink_on else 0.4, 0.72 if slow_blink_on else 0.5, 1.0 if slow_blink_on else 0.32)
		outline_alpha = maxf(outline_alpha, 0.78 if slow_blink_on else 0.48)
	elif _demon_menu_hovered:
		image_modulate = Color(1.0, 0.92, 0.88, 1.0)
	_demon_menu_button.scale = button_scale
	_demon_menu_button.modulate = button_modulate
	if _demon_menu_image != null:
		_demon_menu_image.modulate = image_modulate
	_set_demon_outline_alpha(outline_alpha)

func _acknowledge_level_up_feedback() -> void:
	if not _level_up_pending_ack:
		return
	_level_up_pending_ack = false
	_level_up_feedback_timer = 0.0
	if _demon_level_label != null:
		_demon_level_label.visible = false
		_position_demon_level_label()
	_refresh_demon_menu_visuals()

func _apply_corruption_stage() -> void:
	var next_stage := _corruption_stage_for(_corruption)
	if next_stage == _corruption_stage:
		return
	_corruption_stage = next_stage
	_passive_whisper_timer = _rng.randf_range(5.0, 9.0)
	if _corruption_stage == 4:
		_full_possession_timer = POSSESSION_FULL_FX_SECONDS
		_chromatic_flash_timer = maxf(_chromatic_flash_timer, 0.72)
	_show_stage_whisper()

func _corruption_stage_for(corruption: float) -> int:
	if corruption >= 100.0:
		return 4
	if corruption >= 75.0:
		return 3
	if corruption >= 50.0:
		return 2
	if corruption >= 25.0:
		return 1
	return 0

func _show_stage_whisper() -> void:
	if _whisper_label == null:
		return
	if _corruption_stage <= 0 and not _whispers_enabled:
		return
	var index: int = clampi(_corruption_stage, 0, CORRUPTION_STAGE_LINES.size() - 1)
	_show_voiced_whisper(CORRUPTION_STAGE_LINES[index])

func _update_static_corruption_layers() -> void:
	if _possession_fill_texture == null:
		return
	var power_color := Color(0.65, 0.85, 1.0, 0.95).lerp(Color(1.0, 0.5, 0.5, 0.98), _corruption_ratio)
	_possession_fill_texture.modulate = power_color
	if _vignette_overlay != null:
		var vignette_material := _vignette_overlay.material as ShaderMaterial
		if vignette_material != null:
			vignette_material.set_shader_parameter("strength", lerpf(0.0, 0.55, _corruption_ratio))
	if _screen_noise_overlay != null:
		var noise_material := _screen_noise_overlay.material as ShaderMaterial
		if noise_material != null:
			noise_material.set_shader_parameter("intensity", lerpf(0.0, 0.25, _corruption_ratio))

func _update_corruption_fx(delta: float) -> void:
	_ui_time += delta
	_chromatic_flash_timer = maxf(_chromatic_flash_timer - delta, 0.0)
	_vein_flash_timer = maxf(_vein_flash_timer - delta, 0.0)
	_full_possession_timer = maxf(_full_possession_timer - delta, 0.0)
	_possession_gain_timer = maxf(_possession_gain_timer - delta, 0.0)
	_minimap_blink_timer = maxf(_minimap_blink_timer - delta, 0.0)
	_skill_glitch_timer = maxf(_skill_glitch_timer - delta, 0.0)
	_update_bar_pulses()
	_update_overlay_materials()
	_update_flash_layers()
	_update_minimap_corruption(delta)
	_update_skill_glitch()
	_update_heartbeat_audio(delta)
	_update_passive_whispers(delta)

func _update_bar_pulses() -> void:
	if _possession_fill_texture == null:
		return
	var possession_wave := 0.5 + 0.5 * sin(_ui_time * (2.2 + _corruption_ratio * 4.8))
	if _corruption_stage >= 3 and _life_fill_texture != null:
		var life_wave := 0.5 + 0.5 * sin(_ui_time * 5.1 + PI)
		_life_fill_texture.modulate.a = 0.78 + life_wave * 0.22
		_possession_fill_texture.modulate.a = 0.78 + possession_wave * 0.2
	elif _life_fill_texture != null:
		_life_fill_texture.modulate.a = 1.0
		_possession_fill_texture.modulate.a = 1.0
	if _possession_cluster != null:
		_possession_cluster.scale = Vector2.ONE

func _update_overlay_materials() -> void:
	if _screen_noise_overlay != null:
		var noise_material := _screen_noise_overlay.material as ShaderMaterial
		if noise_material != null:
			noise_material.set_shader_parameter("noise_time", _ui_time * 30.0)
	if _vein_cracks_overlay != null:
		var vein_alpha := clampf((_corruption - 50.0) / 50.0, 0.0, 1.0)
		vein_alpha = maxf(vein_alpha * 0.42, _vein_flash_timer * 0.74)
		for child in _vein_cracks_overlay.get_children():
			var line := child as Line2D
			if line != null:
				var line_color := line.default_color
				line_color.a = vein_alpha * (0.64 + 0.36 * sin(_ui_time * 8.0 + float(line.get_index())))
				line.default_color = line_color
	if _heartbeat_pulse_overlay != null:
		var heartbeat_alpha := 0.0
		if _corruption > 45.0 or _hp_percent < 0.3:
			var beat := pow(maxf(sin(_ui_time * (5.8 + _corruption_ratio * 1.4)), 0.0), 12.0)
			var pressure := maxf(_corruption_ratio * 0.65, clampf((0.35 - _hp_percent) * 2.4, 0.0, 1.0))
			heartbeat_alpha = beat * pressure * 0.28
		_heartbeat_pulse_overlay.color = Color(0.82, 0.0, 0.04, heartbeat_alpha)

func _update_flash_layers() -> void:
	if _chromatic_flash_overlay == null or _distortion_overlay == null:
		return
	var flash_alpha := clampf(_chromatic_flash_timer * 1.9, 0.0, 0.34)
	if int(_ui_time * 36.0) % 2 == 0:
		_chromatic_flash_overlay.color = Color(0.0, 0.62, 1.0, flash_alpha)
	else:
		_chromatic_flash_overlay.color = Color(1.0, 0.0, 0.04, flash_alpha)
	var full_alpha := clampf(_full_possession_timer / POSSESSION_FULL_FX_SECONDS, 0.0, 1.0)
	var distortion_alpha := clampf((_corruption_ratio - 0.35) * 0.2, 0.0, 0.13)
	distortion_alpha = maxf(distortion_alpha, sin(_ui_time * 19.0) * full_alpha * 0.24)
	_distortion_overlay.color = Color(0.52, 0.0, 0.04, clampf(distortion_alpha, 0.0, 0.32))

func _update_minimap_corruption(delta: float) -> void:
	if _minimap_frame == null:
		return
	if _corruption_stage >= 3:
		_next_minimap_blink = maxf(_next_minimap_blink - delta, 0.0)
		if _next_minimap_blink <= 0.0:
			_minimap_blink_timer = maxf(_minimap_blink_timer, 0.22)
			_next_minimap_blink = _rng.randf_range(5.2, 11.0)
	if _minimap_blink_timer > 0.0:
		var blink_ratio := clampf(_minimap_blink_timer / 0.22, 0.0, 1.0)
		_minimap_frame.scale = Vector2(1.0 + blink_ratio * 0.025, 1.0 - blink_ratio * 0.86)
		_minimap_frame.modulate = Color(1.0, 0.08, 0.06, 0.9)
	else:
		_minimap_frame.scale = Vector2.ONE
		_minimap_frame.modulate = Color.WHITE

func _update_skill_glitch() -> void:
	if _skill_slot == null:
		return
	if _skill_glitch_timer > 0.0:
		var jitter := Vector2(_rng.randf_range(-3.5, 3.5), _rng.randf_range(-2.5, 2.5))
		_skill_slot.position = _skill_slot_base_position + jitter
		if _skill_icon != null:
			_skill_icon.modulate = Color(1.0, 0.32 + _rng.randf() * 0.68, 0.28 + _rng.randf() * 0.55, 1.0)
	else:
		_skill_slot.position = _skill_slot_base_position

func _update_heartbeat_audio(delta: float) -> void:
	if _heartbeat_player == null:
		return
	var should_heartbeat := _corruption > 45.0 or _hp_percent < 0.3
	if not should_heartbeat:
		_heartbeat_timer = 0.0
		return
	_heartbeat_timer = maxf(_heartbeat_timer - delta, 0.0)
	if _heartbeat_timer > 0.0:
		return
	var urgency := maxf(clampf((_corruption - 45.0) / 55.0, 0.0, 1.0), clampf((0.3 - _hp_percent) / 0.3, 0.0, 1.0))
	_heartbeat_player.volume_db = lerpf(-24.0, -11.0, urgency)
	_heartbeat_player.play()
	_heartbeat_timer = lerpf(1.16, 0.48, urgency)

func _update_passive_whispers(delta: float) -> void:
	if _corruption_stage < 3:
		return
	_passive_whisper_timer = maxf(_passive_whisper_timer - delta, 0.0)
	if _passive_whisper_timer > 0.0:
		return
	var index: int = clampi(_corruption_stage, 0, CORRUPTION_STAGE_LINES.size() - 1)
	_show_voiced_whisper(CORRUPTION_STAGE_LINES[index])
	_passive_whisper_timer = _rng.randf_range(8.0, 15.0) - _corruption_ratio * 4.0

func _label(text: String, size: int) -> Label:
	var label: Label = Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", size)
	label.add_theme_color_override("font_color", Color(0.92, 0.88, 0.78))
	return label

func _texture_from_path(path: String) -> Texture2D:
	if path.is_empty():
		return null
	if ResourceLoader.exists(path):
		return load(path) as Texture2D
	var image := Image.load_from_file(path)
	if image == null:
		return null
	return ImageTexture.create_from_image(image)

func _make_minimap_dot(color: Color, dot_size: float) -> Panel:
	var dot: Panel = Panel.new()
	dot.size = Vector2.ONE * dot_size
	dot.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var style := StyleBoxFlat.new()
	style.bg_color = color
	style.border_color = Color(0.0, 0.0, 0.0, 0.82)
	style.set_border_width_all(1)
	style.set_corner_radius_all(int(dot_size * 0.5))
	dot.add_theme_stylebox_override("panel", style)
	return dot

func _place_minimap_dot(dot: Control, world_position: Vector3, arena_half_size: float, center: Vector2, radius: float, dot_size: float) -> void:
	var arena_size: float = maxf(arena_half_size, 0.1)
	var normalized := Vector2(world_position.x, world_position.z) / arena_size
	if normalized.length() > 1.0:
		normalized = normalized.normalized()
	dot.position = center + normalized * radius - Vector2.ONE * (dot_size * 0.5)

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

func _set_life_ratio(ratio: float) -> void:
	ratio = clampf(ratio, 0.0, 1.0)
	if _life_fill_clip == null:
		return
	var fill_width := LIFE_FILL_SIZE.x * ratio
	_life_fill_clip.visible = ratio > 0.001
	_life_fill_clip.size = Vector2(fill_width, LIFE_FILL_SIZE.y)

func _set_exp_ratio(ratio: float) -> void:
	ratio = clampf(ratio, 0.0, 1.0)
	if _exp_fill_clip == null:
		return
	var fill_width := EXP_FILL_SIZE.x * ratio
	_exp_fill_clip.visible = ratio > 0.001
	_exp_fill_clip.size = Vector2(fill_width, EXP_FILL_SIZE.y)

func _make_spell_slot_hover_ui(parent: Control) -> void:
	var tooltip := PanelContainer.new()
	tooltip.name = "SpellSlotTooltip"
	tooltip.visible = false
	tooltip.mouse_filter = Control.MOUSE_FILTER_IGNORE
	tooltip.size = SPELL_SLOT_TOOLTIP_SIZE
	tooltip.add_theme_stylebox_override("panel", _spell_slot_tooltip_style())
	parent.add_child(tooltip)
	_spell_slot_hover_tooltip = tooltip

	var tooltip_label := _label("", SPELL_SLOT_HOVER_FONT_SIZE)
	tooltip_label.set_anchors_preset(Control.PRESET_FULL_RECT)
	tooltip_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	tooltip_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	tooltip_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	tooltip_label.add_theme_color_override("font_color", Color(1.0, 0.95, 0.84, 1.0))
	tooltip_label.add_theme_color_override("font_outline_color", Color(0.0, 0.0, 0.0, 0.95))
	tooltip_label.add_theme_constant_override("outline_size", 2)
	tooltip.add_child(tooltip_label)
	_spell_slot_hover_tooltip_label = tooltip_label

	for i in range(SPELL_SLOT_HOVER_CATEGORIES.size()):
		var hitbox := Control.new()
		hitbox.name = "SpellSlotHoverRegion%s" % i
		hitbox.mouse_filter = Control.MOUSE_FILTER_STOP
		hitbox.size = SPELL_SLOT_HOVER_REGION_SIZE
		hitbox.position = _spell_slot_source_to_local(SPELL_SLOT_HOVER_CENTER_SOURCES[i]) - hitbox.size * 0.5
		hitbox.mouse_entered.connect(_on_spell_slot_mouse_entered.bind(i))
		hitbox.mouse_exited.connect(_on_spell_slot_mouse_exited.bind(i))
		hitbox.gui_input.connect(_on_spell_slot_gui_input.bind(i))
		parent.add_child(hitbox)
		_spell_slot_hover_regions.append(hitbox)
	_make_spell_slot_picker(parent)

func _make_spell_slot_picker(parent: Control) -> void:
	var picker := PanelContainer.new()
	picker.name = "SpellSlotPicker"
	picker.visible = false
	picker.mouse_filter = Control.MOUSE_FILTER_STOP
	picker.size = SPELL_SLOT_PICKER_SIZE
	picker.add_theme_stylebox_override("panel", _spell_slot_picker_style("attack"))
	picker.gui_input.connect(_on_spell_slot_picker_gui_input)
	parent.add_child(picker)
	_spell_slot_picker_panel = picker

	var margin := MarginContainer.new()
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 10)
	margin.add_theme_constant_override("margin_top", 8)
	margin.add_theme_constant_override("margin_right", 10)
	margin.add_theme_constant_override("margin_bottom", 8)
	margin.mouse_filter = Control.MOUSE_FILTER_PASS
	picker.add_child(margin)

	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", 7)
	content.mouse_filter = Control.MOUSE_FILTER_PASS
	margin.add_child(content)

	_spell_slot_picker_title_label = _label("", 15)
	_spell_slot_picker_title_label.add_theme_color_override("font_color", Color(1.0, 0.92, 0.76))
	_spell_slot_picker_title_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	content.add_child(_spell_slot_picker_title_label)

	_spell_slot_picker_row = HFlowContainer.new()
	_spell_slot_picker_row.add_theme_constant_override("h_separation", 8)
	_spell_slot_picker_row.add_theme_constant_override("v_separation", 6)
	_spell_slot_picker_row.mouse_filter = Control.MOUSE_FILTER_PASS
	content.add_child(_spell_slot_picker_row)

func _spell_slot_tooltip_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.05, 0.03, 0.02, TOOLTIP_READABLE_ALPHA)
	style.border_color = Color(0.96, 0.58, 0.18, 1.0)
	style.set_border_width_all(2)
	style.set_corner_radius_all(6)
	style.content_margin_left = 10
	style.content_margin_right = 10
	style.content_margin_top = 8
	style.content_margin_bottom = 8
	return style

func _spell_slot_picker_style(category: String) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.045, 0.026, 0.03, 0.98)
	style.border_color = _spell_category_color(category)
	style.set_border_width_all(2)
	style.set_corner_radius_all(6)
	style.content_margin_left = 10
	style.content_margin_right = 10
	style.content_margin_top = 8
	style.content_margin_bottom = 8
	return style

func _on_spell_slot_mouse_entered(slot_index: int) -> void:
	_spell_slot_hovered_index = slot_index
	if _spell_cluster != null:
		_spell_cluster.move_to_front()
	_refresh_spell_slot_tooltip()
	if _spell_slot_hover_tooltip != null:
		_spell_slot_hover_tooltip.visible = true

func _on_spell_slot_mouse_exited(slot_index: int) -> void:
	if _spell_slot_hovered_index != slot_index:
		return
	_spell_slot_hovered_index = -1
	if _spell_slot_hover_tooltip != null:
		_spell_slot_hover_tooltip.visible = false

func _on_spell_slot_gui_input(event: InputEvent, slot_index: int) -> void:
	if not (event is InputEventMouseButton):
		return
	var mouse_event := event as InputEventMouseButton
	if mouse_event.button_index != MOUSE_BUTTON_LEFT or not mouse_event.pressed:
		return
	_toggle_spell_slot_picker(slot_index)
	var viewport := get_viewport()
	if viewport != null:
		viewport.set_input_as_handled()

func _on_spell_slot_picker_gui_input(event: InputEvent) -> void:
	if not (event is InputEventMouseButton):
		return
	var mouse_event := event as InputEventMouseButton
	if mouse_event.button_index != MOUSE_BUTTON_LEFT or not mouse_event.pressed:
		return
	var viewport := get_viewport()
	if viewport != null:
		viewport.set_input_as_handled()

func _close_spell_slot_picker_from_outside_click(event: InputEvent) -> void:
	if _spell_slot_picker_panel == null or not _spell_slot_picker_panel.visible:
		return
	if not (event is InputEventMouseButton):
		return
	var mouse_event := event as InputEventMouseButton
	if mouse_event.button_index != MOUSE_BUTTON_LEFT or not mouse_event.pressed:
		return
	var viewport := get_viewport()
	if viewport == null:
		_hide_spell_slot_picker()
		return
	var mouse_position := viewport.get_mouse_position()
	if _spell_slot_picker_panel.get_global_rect().has_point(mouse_position):
		return
	if _is_mouse_over_spell_slot_control(mouse_position):
		return
	_hide_spell_slot_picker()

func _handle_spell_slot_picker_global_click(event: InputEvent) -> bool:
	if _spell_slot_picker_panel == null or not _spell_slot_picker_panel.visible:
		return false
	if not (event is InputEventMouseButton):
		return false
	var mouse_event := event as InputEventMouseButton
	if mouse_event.button_index != MOUSE_BUTTON_LEFT or not mouse_event.pressed:
		return false
	var viewport := get_viewport()
	if viewport == null:
		_hide_spell_slot_picker()
		return true
	var mouse_position := viewport.get_mouse_position()
	if not _spell_slot_picker_panel.get_global_rect().has_point(mouse_position):
		_hide_spell_slot_picker()
	viewport.set_input_as_handled()
	return true

func _is_mouse_over_spell_slot_control(mouse_position: Vector2) -> bool:
	if _skill_icon != null and _skill_icon.get_global_rect().has_point(mouse_position):
		return true
	for region in _spell_slot_hover_regions:
		if region != null and region.get_global_rect().has_point(mouse_position):
			return true
	return false

func _toggle_spell_slot_picker(slot_index: int) -> void:
	if slot_index < 0 or slot_index >= SPELL_SLOT_HOVER_CATEGORIES.size():
		_hide_spell_slot_picker()
		return
	var category: String = SPELL_SLOT_HOVER_CATEGORIES[slot_index]
	if _spell_slot_picker_panel != null and _spell_slot_picker_panel.visible and _spell_slot_picker_category == category:
		_hide_spell_slot_picker()
		return
	_show_spell_slot_picker(slot_index, category)

func _show_spell_slot_picker(slot_index: int, category: String) -> void:
	if _spell_slot_picker_panel == null:
		return
	_spell_slot_picker_category = category
	_refresh_spell_slot_picker()
	var slot_center := _spell_slot_source_to_local(SPELL_SLOT_HOVER_CENTER_SOURCES[slot_index])
	var target_position := slot_center - Vector2(SPELL_SLOT_PICKER_SIZE.x * 0.5, SPELL_SLOT_PICKER_SIZE.y + 10.0)
	target_position.x = clampf(target_position.x, -24.0, SPELL_SLOT_SIZE.x - SPELL_SLOT_PICKER_SIZE.x + 24.0)
	target_position.y = clampf(target_position.y, -SPELL_SLOT_PICKER_SIZE.y - 18.0, SPELL_SLOT_SIZE.y - SPELL_SLOT_PICKER_SIZE.y)
	_spell_slot_picker_panel.position = target_position
	_spell_slot_picker_panel.visible = true
	_spell_slot_picker_panel.move_to_front()
	if _spell_slot_hover_tooltip != null:
		_spell_slot_hover_tooltip.visible = false

func _hide_spell_slot_picker() -> void:
	_spell_slot_picker_category = ""
	if _spell_slot_picker_panel != null:
		_spell_slot_picker_panel.visible = false

func _refresh_spell_slot_picker() -> void:
	if _spell_slot_picker_panel == null or _spell_slot_picker_title_label == null or _spell_slot_picker_row == null:
		return
	if _spell_slot_picker_category.is_empty():
		return
	var title := String(SPELL_SLOT_HOVER_LABELS.get(_spell_slot_picker_category, _spell_slot_picker_category.capitalize()))
	_spell_slot_picker_title_label.text = "%s spells" % title
	_spell_slot_picker_panel.add_theme_stylebox_override("panel", _spell_slot_picker_style(_spell_slot_picker_category))
	for child in _spell_slot_picker_row.get_children():
		_spell_slot_picker_row.remove_child(child)
		child.queue_free()
	var entries := _spell_entries_for_category(_spell_slot_picker_category)
	if entries.is_empty():
		var empty_label := _label("No learned spells", 14)
		empty_label.add_theme_color_override("font_color", Color(0.66, 0.58, 0.52))
		_spell_slot_picker_row.add_child(empty_label)
		return
	for entry in entries:
		_spell_slot_picker_row.add_child(_make_spell_slot_picker_button(entry))

func _make_spell_slot_picker_button(entry: Dictionary) -> Button:
	var category := String(entry.get("category", "attack"))
	var spell_id := String(entry.get("id", ""))
	var display_name := String(entry.get("name", "Spell"))
	var active := _active_spell_id_for_category(category) == spell_id
	var button := Button.new()
	button.text = ""
	button.custom_minimum_size = SPELL_SLOT_PICKER_ICON_SIZE
	button.focus_mode = Control.FOCUS_NONE
	button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	button.tooltip_text = _spell_tooltip_text(display_name, spell_id, category)
	button.add_theme_stylebox_override("normal", _spell_slot_picker_button_style(category, active))
	button.add_theme_stylebox_override("hover", _hover_spell_slot_picker_button_style(category, active))
	button.add_theme_stylebox_override("pressed", _spell_slot_picker_button_style(category, true))
	button.gui_input.connect(_on_spell_slot_picker_button_gui_input.bind(category, spell_id))

	var center := CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	center.mouse_filter = Control.MOUSE_FILTER_IGNORE
	button.add_child(center)

	var icon := entry.get("icon", null) as Texture2D
	if icon != null:
		var icon_rect := TextureRect.new()
		icon_rect.texture = icon
		icon_rect.custom_minimum_size = Vector2(34.0, 34.0)
		icon_rect.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
		icon_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		icon_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
		center.add_child(icon_rect)
	else:
		var glyph := _label(String(entry.get("text", "?")), 15)
		glyph.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		glyph.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		glyph.mouse_filter = Control.MOUSE_FILTER_IGNORE
		center.add_child(glyph)
	return button

func _spell_slot_picker_button_style(category: String, active: bool) -> StyleBoxFlat:
	var accent := _spell_category_color(category)
	var style := _icon_button_style(Color(0.06, 0.038, 0.04, 0.96), accent)
	style.set_border_width_all(3 if active else 1)
	return style

func _hover_spell_slot_picker_button_style(category: String, active: bool) -> StyleBoxFlat:
	var style := _spell_slot_picker_button_style(category, active)
	style.bg_color = _opaque_hover_color(style.bg_color.lightened(0.1))
	style.border_color = _opaque_hover_color(style.border_color)
	return style

func _on_spell_slot_picker_button_gui_input(event: InputEvent, category: String, spell_id: String) -> void:
	if not (event is InputEventMouseButton):
		return
	var mouse_event := event as InputEventMouseButton
	if mouse_event.button_index != MOUSE_BUTTON_LEFT or not mouse_event.pressed:
		return
	_set_local_active_spell_slot(category, spell_id)
	_hide_spell_slot_picker()
	spell_slot_spell_selected.emit(category, spell_id)
	var viewport := get_viewport()
	if viewport != null:
		viewport.set_input_as_handled()

func _set_local_active_spell_slot(category: String, spell_id: String) -> void:
	var active_slots: Dictionary = _latest_stats.get("active_spell_slots", {})
	active_slots[category] = spell_id
	_latest_stats["active_spell_slots"] = active_slots
	if category == "attack":
		_latest_stats["active_attack_spell_id"] = spell_id
		_latest_stats["active_attack_spell"] = _spell_display_name(spell_id)
	_refresh_active_spell_slot_icons()

func _refresh_spell_slot_tooltip() -> void:
	if _spell_slot_hover_tooltip == null or _spell_slot_hover_tooltip_label == null:
		return
	if _spell_slot_hovered_index < 0 or _spell_slot_hovered_index >= SPELL_SLOT_HOVER_CATEGORIES.size():
		_spell_slot_hover_tooltip.visible = false
		return
	var category: String = SPELL_SLOT_HOVER_CATEGORIES[_spell_slot_hovered_index]
	var title: String = String(SPELL_SLOT_HOVER_LABELS.get(category, category.capitalize()))
	var spell_name := _slot_spell_name_for_category(category)
	_spell_slot_hover_tooltip_label.text = "%s: %s" % [title, spell_name]
	var slot_center := _spell_slot_source_to_local(SPELL_SLOT_HOVER_CENTER_SOURCES[_spell_slot_hovered_index])
	var target_position := slot_center - _spell_slot_hover_tooltip.size * 0.5 + Vector2(0.0, -84.0)
	target_position.x = clampf(target_position.x, 0.0, SPELL_SLOT_SIZE.x - _spell_slot_hover_tooltip.size.x)
	target_position.y = clampf(target_position.y, -96.0, SPELL_SLOT_SIZE.y - _spell_slot_hover_tooltip.size.y)
	_spell_slot_hover_tooltip.position = target_position

func _slot_spell_name_for_category(category: String) -> String:
	var active_spell_id := _active_spell_id_for_category(category)
	if not active_spell_id.is_empty():
		return _spell_display_name(active_spell_id)
	var learned_spells: Array = _latest_stats.get("learned_spells", [])
	for spell_id_variant in learned_spells:
		var spell_id := String(spell_id_variant)
		if _spell_category_for_id(spell_id) == category:
			return _spell_display_name(spell_id)
	return "None"

func _active_spell_id_for_category(category: String) -> String:
	var active_slots: Dictionary = _latest_stats.get("active_spell_slots", {})
	var spell_id := String(active_slots.get(category, ""))
	if spell_id.is_empty() and category == "attack":
		spell_id = String(_latest_stats.get("active_attack_spell_id", "fire_storm"))
	return spell_id

func _refresh_active_spell_slot_icons() -> void:
	if _skill_icon == null:
		return
	var active_attack_spell_id := _active_spell_id_for_category("attack")
	var icon := _spell_icon_for_id(active_attack_spell_id)
	_skill_icon.texture = icon
	if _skill_fallback_label != null:
		_skill_fallback_label.text = "" if icon != null else _spell_chip_abbreviation(_spell_display_name(active_attack_spell_id))
	_skill_icon.tooltip_text = _spell_tooltip_text(_spell_display_name(active_attack_spell_id), active_attack_spell_id, "attack")

func _spell_category_for_id(spell_id: String) -> String:
	if SPELL_GROUP_CATEGORY_BY_ID.has(spell_id):
		return String(SPELL_GROUP_CATEGORY_BY_ID[spell_id])
	if spell_id in ["fire_storm", "wide_flame"]:
		return "attack"
	if spell_id in ["quickened_ritual", "ember_stride"]:
		return "buff"
	if spell_id.contains("defense") or spell_id.contains("shield") or spell_id.contains("guard"):
		return "defense"
	if spell_id.contains("heal") or spell_id.contains("recovery") or spell_id.contains("life"):
		return "healing"
	if spell_id.contains("debuff") or spell_id.contains("curse") or spell_id.contains("slow") or spell_id.contains("weaken"):
		return "debuff"
	if spell_id.contains("buff"):
		return "buff"
	return "attack"

func _spell_display_name(spell_id: String) -> String:
	if SPELL_ID_TO_DISPLAY_NAME.has(spell_id):
		return String(SPELL_ID_TO_DISPLAY_NAME[spell_id])
	return _mission_title_case(spell_id.replace("_", " "))

func _spell_tooltip_text(spell_name: String, spell_id: String, _category: String = "") -> String:
	var clean_name := _clean_spell_display_name(spell_name)
	var spell_category := _spell_theme_category_from_name(spell_name)
	if spell_category.is_empty():
		spell_category = _spell_theme_category_for_id(spell_id)
	if spell_category.is_empty():
		return clean_name
	return "%s\nCategory: %s" % [clean_name, _spell_theme_category_display_name(spell_category)]

func _spell_category_display_name(category: String) -> String:
	var clean_category := category.strip_edges().to_lower()
	if clean_category.is_empty():
		return "Unknown"
	return String(SPELL_SLOT_HOVER_LABELS.get(clean_category, clean_category.capitalize()))

func _spell_theme_category_for_id(spell_id: String) -> String:
	if SPELL_THEME_CATEGORY_BY_ID.has(spell_id):
		return String(SPELL_THEME_CATEGORY_BY_ID[spell_id])
	if spell_id.contains("fire") or spell_id.contains("flame") or spell_id.contains("ember") or spell_id.contains("eclipse"):
		return "Flame"
	if spell_id.contains("ice") or spell_id.contains("frost") or spell_id.contains("zero") or spell_id.contains("titanium") or spell_id.contains("laziness"):
		return "Ice"
	if spell_id.contains("electric") or spell_id.contains("storm") or spell_id.contains("lightning") or spell_id.contains("mark"):
		return "Electricity"
	if not spell_id.is_empty():
		return "Beyond"
	return ""

func _spell_theme_category_display_name(category: String) -> String:
	var clean_category := category.strip_edges().to_lower()
	match clean_category:
		"flame":
			return "Flame"
		"ice":
			return "Ice"
		"electricity":
			return "Electricity"
		"beyond":
			return "Beyond"
	return category.strip_edges().capitalize()

func _spell_theme_category_from_name(raw_name: String) -> String:
	var category_marker_index := raw_name.findn(" - category:")
	if category_marker_index < 0:
		return ""
	return raw_name.substr(category_marker_index + " - category:".length()).strip_edges()

func _clean_spell_display_name(raw_name: String) -> String:
	var spell_name := raw_name.strip_edges()
	var category_marker_index := spell_name.findn(" - category:")
	if category_marker_index >= 0:
		return spell_name.substr(0, category_marker_index).strip_edges()
	return spell_name

func _set_possession_ratio(ratio: float) -> void:
	ratio = clampf(ratio, 0.0, 1.0)
	if _possession_fill_clip == null or _possession_fill_texture == null:
		return
	var fill_width: float = POSSESSION_FILL_SIZE.x * ratio
	var clip_x := POSSESSION_FILL_POSITION.x + POSSESSION_FILL_SIZE.x - fill_width
	_possession_fill_clip.visible = ratio > 0.001
	_possession_fill_clip.position = Vector2(clip_x, POSSESSION_FILL_POSITION.y)
	_possession_fill_clip.size = Vector2(fill_width, POSSESSION_FILL_SIZE.y)
	_possession_fill_texture.position = Vector2(fill_width - POSSESSION_FILL_SIZE.x, 0.0)

func _refresh_bar_tooltips() -> void:
	if _life_hover_region != null:
		_life_hover_region.tooltip_text = "Life: %s%%" % int(round(_hp_percent * 100.0))
	if _possession_hover_region != null:
		_possession_hover_region.tooltip_text = "Possession: %s%%" % int(round(_possession_ratio * 100.0))

func _make_hover_region() -> Button:
	var hover_region := Button.new()
	hover_region.text = ""
	hover_region.focus_mode = Control.FOCUS_NONE
	hover_region.mouse_default_cursor_shape = Control.CURSOR_ARROW
	hover_region.add_theme_stylebox_override("normal", _icon_button_style(Color.TRANSPARENT, Color.TRANSPARENT))
	hover_region.add_theme_stylebox_override("hover", _icon_button_style(Color.TRANSPARENT, Color.TRANSPARENT))
	hover_region.add_theme_stylebox_override("pressed", _icon_button_style(Color.TRANSPARENT, Color.TRANSPARENT))
	return hover_region

func _spell_slot_source_to_local(source_position: Vector2) -> Vector2:
	return Vector2(
		source_position.x / SPELL_SLOT_SOURCE_SIZE.x * SPELL_SLOT_SIZE.x,
		source_position.y / SPELL_SLOT_SOURCE_SIZE.y * SPELL_SLOT_SIZE.y
	)

func _silhouette_outline_material(alpha: float) -> ShaderMaterial:
	var material := _shader_material("""
shader_type canvas_item;
uniform vec4 outline_color : source_color = vec4(1.0, 0.22, 0.08, 1.0);
uniform float outline_size = 2.0;
uniform float outline_alpha = 0.34;
void fragment() {
	vec4 base = texture(TEXTURE, UV);
	vec2 step_size = TEXTURE_PIXEL_SIZE * outline_size;
	float nearby_alpha = 0.0;
	nearby_alpha = max(nearby_alpha, texture(TEXTURE, UV + vec2(step_size.x, 0.0)).a);
	nearby_alpha = max(nearby_alpha, texture(TEXTURE, UV + vec2(-step_size.x, 0.0)).a);
	nearby_alpha = max(nearby_alpha, texture(TEXTURE, UV + vec2(0.0, step_size.y)).a);
	nearby_alpha = max(nearby_alpha, texture(TEXTURE, UV + vec2(0.0, -step_size.y)).a);
	nearby_alpha = max(nearby_alpha, texture(TEXTURE, UV + step_size).a);
	nearby_alpha = max(nearby_alpha, texture(TEXTURE, UV - step_size).a);
	nearby_alpha = max(nearby_alpha, texture(TEXTURE, UV + vec2(step_size.x, -step_size.y)).a);
	nearby_alpha = max(nearby_alpha, texture(TEXTURE, UV + vec2(-step_size.x, step_size.y)).a);
	float outline = max(nearby_alpha - base.a, 0.0) * outline_alpha;
	COLOR = mix(vec4(outline_color.rgb, outline), base, base.a);
}
""")
	material.set_shader_parameter("outline_alpha", alpha)
	return material

func _set_demon_outline_alpha(alpha: float) -> void:
	if _demon_menu_image == null:
		return
	var material := _demon_menu_image.material as ShaderMaterial
	if material != null:
		material.set_shader_parameter("outline_alpha", alpha)

func _panel_style(color: Color) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = color
	style.border_color = Color(0.42, 0.16, 0.13, 0.9)
	style.set_border_width_all(1)
	style.set_corner_radius_all(6)
	style.content_margin_left = 14
	style.content_margin_right = 14
	style.content_margin_top = 12
	style.content_margin_bottom = 12
	return style

func _map_card_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.045, 0.028, 0.036, 0.96)
	style.border_color = Color(0.72, 0.22, 0.78, 0.82)
	style.set_border_width_all(1)
	style.set_corner_radius_all(6)
	style.content_margin_left = 18
	style.content_margin_right = 18
	style.content_margin_top = 14
	style.content_margin_bottom = 16
	return style

func _map_destination_style(fill_color: Color, border_color: Color) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = fill_color
	style.border_color = border_color
	style.set_border_width_all(2)
	style.set_corner_radius_all(6)
	return style

func _scroll_panel_style() -> StyleBoxTexture:
	var style := StyleBoxTexture.new()
	style.texture = SCROLL_OPEN_TEXTURE
	style.draw_center = true
	style.axis_stretch_horizontal = StyleBoxTexture.AXIS_STRETCH_MODE_STRETCH
	style.axis_stretch_vertical = StyleBoxTexture.AXIS_STRETCH_MODE_STRETCH
	style.texture_margin_left = 160
	style.texture_margin_top = 190
	style.texture_margin_right = 160
	style.texture_margin_bottom = 220
	style.content_margin_left = 140
	style.content_margin_top = 110
	style.content_margin_right = 140
	style.content_margin_bottom = 90
	return style

func _config_panel_style() -> StyleBoxTexture:
	var style := StyleBoxTexture.new()
	style.texture = CONFIG_MENU_TEXTURE
	style.draw_center = true
	style.axis_stretch_horizontal = StyleBoxTexture.AXIS_STRETCH_MODE_STRETCH
	style.axis_stretch_vertical = StyleBoxTexture.AXIS_STRETCH_MODE_STRETCH
	style.texture_margin_left = 150
	style.texture_margin_top = 105
	style.texture_margin_right = 150
	style.texture_margin_bottom = 92
	style.content_margin_left = 136
	style.content_margin_top = 82
	style.content_margin_right = 136
	style.content_margin_bottom = 74
	return style

func _button_style(color: Color) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = color
	style.border_color = Color(0.74, 0.25, 0.12, 0.95)
	style.set_border_width_all(1)
	style.set_corner_radius_all(5)
	style.content_margin_left = 18
	style.content_margin_right = 18
	style.content_margin_top = 8
	style.content_margin_bottom = 8
	return style

func _hud_tooltip_theme() -> Theme:
	var theme := Theme.new()
	theme.set_stylebox("panel", "TooltipPanel", _tooltip_panel_style())
	theme.set_color("font_color", "TooltipLabel", Color(1.0, 0.93, 0.78, 1.0))
	theme.set_color("font_shadow_color", "TooltipLabel", Color(0.0, 0.0, 0.0, 0.9))
	theme.set_constant("shadow_offset_x", "TooltipLabel", 1)
	theme.set_constant("shadow_offset_y", "TooltipLabel", 1)
	theme.set_constant("outline_size", "TooltipLabel", 1)
	theme.set_color("font_outline_color", "TooltipLabel", Color(0.0, 0.0, 0.0, 0.92))
	return theme

func _tooltip_panel_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.035, 0.022, 0.024, TOOLTIP_READABLE_ALPHA)
	style.border_color = Color(0.86, 0.32, 0.12, 0.98)
	style.set_border_width_all(1)
	style.set_corner_radius_all(5)
	style.content_margin_left = 10
	style.content_margin_right = 10
	style.content_margin_top = 8
	style.content_margin_bottom = 8
	return style

func _opaque_hover_color(color: Color) -> Color:
	var hover_color := color
	hover_color.a = HOVER_READABLE_ALPHA
	return hover_color

func _hover_button_style(color: Color) -> StyleBoxFlat:
	var style := _button_style(_opaque_hover_color(color))
	style.border_color = _opaque_hover_color(style.border_color)
	return style

func _spell_store_cell_style(color: Color) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = color
	style.border_color = Color(0.74, 0.25, 0.12, 0.95)
	style.set_border_width_all(1)
	style.set_corner_radius_all(5)
	style.content_margin_left = 4
	style.content_margin_right = 4
	style.content_margin_top = 4
	style.content_margin_bottom = 4
	return style

func _hover_spell_store_cell_style(color: Color) -> StyleBoxFlat:
	var style := _spell_store_cell_style(_opaque_hover_color(color))
	style.border_color = _opaque_hover_color(style.border_color)
	return style

func _hover_spell_chip_style(category: String) -> StyleBoxFlat:
	var style := _spell_chip_style(category)
	style.bg_color = _opaque_hover_color(style.bg_color)
	style.border_color = _opaque_hover_color(style.border_color)
	return style

func _make_spell_fallback_sigil(spell_name: String, learned: bool) -> Control:
	var badge := PanelContainer.new()
	badge.custom_minimum_size = SPELL_STORE_SIGIL_ICON_SIZE
	badge.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	badge.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.11, 0.08, 0.12, 0.95)
	style.border_color = Color(0.74, 0.25, 0.12, 0.9)
	style.set_border_width_all(1)
	style.set_corner_radius_all(int(SPELL_STORE_SIGIL_ICON_SIZE.x * 0.5))
	badge.add_theme_stylebox_override("panel", style)

	var letters := ""
	for token in spell_name.split(" ", false):
		if token.is_empty():
			continue
		letters += token.substr(0, 1).to_upper()
		if letters.length() >= 2:
			break
	if letters.is_empty():
		letters = "??"

	var text := _label(letters, 13)
	text.set_anchors_preset(Control.PRESET_FULL_RECT)
	text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	text.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	text.mouse_filter = Control.MOUSE_FILTER_IGNORE
	text.add_theme_color_override("font_color", Color(0.55, 0.88, 0.55) if learned else Color(0.94, 0.82, 0.66))
	badge.add_child(text)
	return badge

func _icon_button_style(color: Color, border_color: Color) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = color
	style.border_color = border_color
	style.set_border_width_all(1)
	style.set_corner_radius_all(6)
	style.content_margin_left = 0
	style.content_margin_right = 0
	style.content_margin_top = 0
	style.content_margin_bottom = 0
	return style

func _whisper_button(text: String, color: Color) -> Button:
	var button := Button.new()
	button.text = text
	button.custom_minimum_size = Vector2(128.0, 38.0)
	button.focus_mode = Control.FOCUS_NONE
	button.add_theme_font_size_override("font_size", 18)
	button.add_theme_color_override("font_color", Color(1.0, 0.86, 0.66))
	button.add_theme_stylebox_override("normal", _button_style(color))
	button.add_theme_stylebox_override("hover", _hover_button_style(color.lightened(0.14)))
	button.add_theme_stylebox_override("pressed", _button_style(color.darkened(0.18)))
	return button

func _on_resurrect_button_pressed() -> void:
	resurrect_requested.emit()

func _on_offer_accept_pressed() -> void:
	flash_offer_acceptance()
	offer_accepted.emit()

func _on_offer_reject_pressed() -> void:
	offer_rejected.emit()

func _on_shop_item_pressed(item_id: String) -> void:
	if item_id.is_empty():
		return
	shop_purchase_requested.emit(item_id)

func _on_teleport_device_pressed() -> void:
	teleport_device_requested.emit()

func _on_map_teleport_device_pressed() -> void:
	if not _has_teleport_device_in_stats() or not _has_unlocked_world_map():
		return
	_map_selecting_destination = true
	_sync_map_view()

func _on_map_destination_pressed(destination_id: String) -> void:
	if not _has_teleport_device_in_stats() or not _has_unlocked_world_map():
		return
	if not _map_selecting_destination:
		if _map_status_label != null:
			_map_status_label.text = "Wake the device first."
		return
	_map_selecting_destination = false
	_sync_map_view()
	teleport_destination_requested.emit(destination_id)

func _on_skill_tree_point_spend_requested(node_key: String) -> void:
	if node_key.is_empty():
		return
	skill_tree_point_requested.emit(node_key)

func _bar_style(color: Color) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = color
	style.set_corner_radius_all(4)
	return style
