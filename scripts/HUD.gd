extends CanvasLayer
class_name SISHUD

signal resurrect_requested
signal offer_accepted
signal offer_rejected
signal shop_purchase_requested(item_id: String)
signal shop_closed
signal skill_tree_point_requested(node_key: String)

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
const EQUIP_TEXTURE: Texture2D = preload("res://assets/images/hud/equip/equip.png")
const SCROLL_OPEN_TEXTURE: Texture2D = preload("res://assets/images/objects/scroll-open.png")
const WHISPER_FONT: FontFile = preload("res://assets/fonts/Simbiot.ttf")
const MISSION_FONT: FontFile = preload("res://assets/fonts/PICKYSIDE.otf")
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
const SPELL_ID_TO_DISPLAY_NAME := {
	"searing_fire": "Searing Fire",
	"wide_flame": "Widened Flame",
	"quickened_ritual": "Quickened Ritual",
	"ember_stride": "Ember Stride"
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
const MISSION_FONT_SIZE := 30
const MINIMAP_SIZE := Vector2(210.0, 140.0)
const MINIMAP_DOT_SIZE := 6.0
const MINIMAP_PLAYER_DOT_SIZE := 8.0
const MINIMAP_HOLE_SHADE_ALPHA := 0.56
const WHISPER_PANEL_SIZE := Vector2(430.0, 205.0)
const DIRECTIVE_PANEL_SIZE := Vector2(360.0, 92.0)
const SHOP_PANEL_SIZE := Vector2(520.0, 410.0)
const DEMON_MENU_BUTTON_SIZE := Vector2(92.0, 92.0)
const CHARACTER_PANEL_SIZE := Vector2(560.0, 470.0)
const CHARACTER_PANEL_TAB_STATS := "stats"
const CHARACTER_PANEL_TAB_SPELLS := "spells"
const CHARACTER_PANEL_TAB_INVENTORY := "inventory"
const CHARACTER_PANEL_TAB_SKILL_TREE := "skill_tree"
const LEVEL_UP_BLINK_SPEED := 0.35
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
var _skill_cooldown_label: Label
var _objective_label: Label
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
var _directive_panel: PanelContainer
var _directive_text_label: Label
var _directive_progress_label: Label
var _directive_time_fill: ColorRect
var _demon_menu_button: Button
var _demon_menu_image: TextureRect
var _demon_level_label: Label
var _character_panel: PanelContainer
var _character_content_label: Label
var _spells_view: Control
var _spells_hover_label: Label
var _inventory_view: Control
var _inventory_gold_label: Label
var _inventory_status_label: Label
var _skill_tree_view: SkillTreeView
var _character_tab_buttons := {}
var _spell_category_rows := {}
var _spells_view_signature := "__uninitialized__"
var _spells_hovered_name := ""
var _distortion_overlay: ColorRect
var _vignette_overlay: ColorRect
var _chromatic_flash_overlay: ColorRect
var _vein_cracks_overlay: Control
var _heartbeat_pulse_overlay: ColorRect
var _screen_noise_overlay: ColorRect
var _heartbeat_player: AudioStreamPlayer
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
var _minimap_blink_timer := 0.0
var _next_minimap_blink := 7.0
var _skill_glitch_timer := 0.0
var _heartbeat_timer := 0.0
var _skill_slot_base_position := Vector2.ZERO
var _latest_stats := {}
var _character_panel_tab := CHARACTER_PANEL_TAB_STATS
var _demon_menu_hovered := false
var _level_up_pending_ack := false
var _last_displayed_level := -1
var _possession_ratio := 0.0
var _rng := RandomNumberGenerator.new()
var _spell_slot_hover_regions: Array[Control] = []
var _spell_slot_hover_tooltip: PanelContainer
var _spell_slot_hover_tooltip_label: Label
var _spell_slot_hovered_index := -1

func _ready() -> void:
	_rng.randomize()
	_make_ui()

func _process(delta: float) -> void:
	_update_corruption_fx(delta)
	_update_level_up_feedback(delta)

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
	if _spell_slot_hovered_index >= 0:
		_refresh_spell_slot_tooltip()

func set_objective(text: String) -> void:
	_objective_label.text = _mission_title_case(text)

func set_possession_ratio(ratio: float) -> void:
	_possession_ratio = clampf(ratio, 0.0, 1.0)
	_set_possession_ratio(_possession_ratio)
	_refresh_bar_tooltips()
	if _character_panel != null and _character_panel.visible and _character_panel_tab == CHARACTER_PANEL_TAB_STATS:
		_sync_character_panel()

func set_corruption_ui(corruption: float, hp_percent: float = -1.0) -> void:
	_corruption = clampf(corruption, 0.0, 100.0)
	_corruption_ratio = _corruption / 100.0
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

func show_shop(title: String, items: Array[Dictionary], status_text: String, wallet_text: String) -> void:
	if _shop_panel == null:
		return
	_shop_title_label.text = title
	_shop_wallet_label.text = wallet_text
	_shop_status_label.text = status_text
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
	shop_closed.emit()

func is_mouse_over_character_panel() -> bool:
	if _character_panel == null or not _character_panel.visible:
		return false
	var viewport := get_viewport()
	if viewport == null:
		return false
	return _character_panel.get_global_rect().has_point(viewport.get_mouse_position())

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
	var root := Control.new()
	root.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(root)
	_root_control = root
	_make_corruption_fx_layers(root)

	var hud_cluster := Control.new()
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

	var life_plate := Control.new()
	life_plate.position = LIFE_BAR_POSITION
	life_plate.size = LIFE_BAR_SIZE
	hud_cluster.add_child(life_plate)

	var life_image := TextureRect.new()
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

	var spell_cluster := Control.new()
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

	var exp_bar_texture := AtlasTexture.new()
	exp_bar_texture.atlas = EXP_BAR_TEXTURE
	exp_bar_texture.region = EXP_BAR_SOURCE_RECT

	var exp_fill_texture := AtlasTexture.new()
	exp_fill_texture.atlas = EXP_FILL_TEXTURE
	exp_fill_texture.region = EXP_FILL_SOURCE_RECT

	var exp_cluster := Control.new()
	exp_cluster.anchor_left = 0.5
	exp_cluster.anchor_top = 1.0
	exp_cluster.anchor_right = 0.5
	exp_cluster.anchor_bottom = 1.0
	exp_cluster.offset_left = -EXP_BAR_SIZE.x * 0.5
	exp_cluster.offset_top = -SPELL_SLOT_BOTTOM_MARGIN - SPELL_SLOT_SIZE.y - EXP_BAR_SLOT_GAP - EXP_BAR_SIZE.y
	exp_cluster.offset_right = EXP_BAR_SIZE.x * 0.5
	exp_cluster.offset_bottom = -SPELL_SLOT_BOTTOM_MARGIN - SPELL_SLOT_SIZE.y - EXP_BAR_SLOT_GAP
	root.add_child(exp_cluster)

	var exp_bar := TextureRect.new()
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

	var exp_fill := TextureRect.new()
	exp_fill.texture = exp_fill_texture
	exp_fill.position = Vector2.ZERO
	exp_fill.size = EXP_FILL_SIZE
	exp_fill.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	exp_fill.stretch_mode = TextureRect.STRETCH_SCALE
	_exp_fill_clip.add_child(exp_fill)

	var spell_slots := TextureRect.new()
	spell_slots.texture = SPELL_SLOT_TEXTURE
	spell_slots.set_anchors_preset(Control.PRESET_FULL_RECT)
	spell_slots.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	spell_slots.stretch_mode = TextureRect.STRETCH_SCALE
	spell_cluster.add_child(spell_slots)
	_make_spell_slot_hover_ui(spell_cluster)

	var skill_slot := Control.new()
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
	_skill_icon.mouse_entered.connect(_on_spell_slot_mouse_entered.bind(0))
	_skill_icon.mouse_exited.connect(_on_spell_slot_mouse_exited.bind(0))
	skill_slot.add_child(_skill_icon)

	_skill_cooldown_label = _label("", SKILL_COOLDOWN_FONT_SIZE)
	_skill_cooldown_label.set_anchors_preset(Control.PRESET_FULL_RECT)
	_skill_cooldown_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	_skill_cooldown_label.vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM
	_skill_cooldown_label.add_theme_color_override("font_color", Color(1.0, 0.84, 0.62))
	skill_slot.add_child(_skill_cooldown_label)

	_objective_label = _label(_mission_title_case("Slay everyone in the castle."), MISSION_FONT_SIZE)
	_objective_label.add_theme_font_override("font", MISSION_FONT)
	_objective_label.add_theme_color_override("font_color", Color(1.0, 0.91, 0.68))
	_objective_label.add_theme_color_override("font_outline_color", Color(0.02, 0.01, 0.006, 0.96))
	_objective_label.add_theme_constant_override("outline_size", 4)
	_objective_label.add_theme_color_override("font_shadow_color", Color(0.0, 0.0, 0.0, 0.86))
	_objective_label.add_theme_constant_override("shadow_offset_x", 2)
	_objective_label.add_theme_constant_override("shadow_offset_y", 2)
	_objective_label.anchor_left = 0.02
	_objective_label.anchor_top = 0.025
	_objective_label.anchor_right = 0.58
	_objective_label.anchor_bottom = 0.18
	_objective_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	_objective_label.vertical_alignment = VERTICAL_ALIGNMENT_TOP
	_objective_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	root.add_child(_objective_label)

	_make_character_menu(root)

	var minimap_cluster := Control.new()
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

	var minimap_hole_shade := ColorRect.new()
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

	var minimap_frame := TextureRect.new()
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

	var possession_cluster := Control.new()
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

	var possession_image := TextureRect.new()
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

	var death_content := VBoxContainer.new()
	death_content.add_theme_constant_override("separation", 14)
	_death_panel.add_child(death_content)

	var death_label := _label("The Whisper keeps what remains.", 24)
	death_label.custom_minimum_size = Vector2(0.0, 78.0)
	death_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	death_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	death_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	death_content.add_child(death_label)

	var resurrect_button := Button.new()
	resurrect_button.text = "Resurrect"
	resurrect_button.custom_minimum_size = Vector2(190.0, 42.0)
	resurrect_button.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	resurrect_button.focus_mode = Control.FOCUS_NONE
	resurrect_button.add_theme_font_size_override("font_size", 20)
	resurrect_button.add_theme_color_override("font_color", Color(1.0, 0.86, 0.66))
	resurrect_button.add_theme_stylebox_override("normal", _button_style(Color(0.27, 0.055, 0.04, 0.95)))
	resurrect_button.add_theme_stylebox_override("hover", _button_style(Color(0.42, 0.09, 0.055, 0.98)))
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

	var scroll_content := VBoxContainer.new()
	scroll_content.add_theme_constant_override("separation", 10)
	_scroll_panel.add_child(scroll_content)

	_scroll_title_label = _label("", 28)
	_scroll_title_label.add_theme_font_override("font", MISSION_FONT)
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

	var close_scroll_button := Button.new()
	close_scroll_button.text = "Close"
	close_scroll_button.custom_minimum_size = Vector2(150.0, 40.0)
	close_scroll_button.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	close_scroll_button.focus_mode = Control.FOCUS_NONE
	close_scroll_button.add_theme_font_size_override("font_size", 18)
	close_scroll_button.add_theme_color_override("font_color", Color(0.2, 0.06, 0.025))
	close_scroll_button.add_theme_stylebox_override("normal", _button_style(Color(0.78, 0.48, 0.22, 0.72)))
	close_scroll_button.add_theme_stylebox_override("hover", _button_style(Color(0.92, 0.6, 0.28, 0.82)))
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
	_character_panel.move_to_front()

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

func _make_vein_crack_lines() -> void:
	var crack_sets := [
		[Vector2(0.0, 92.0), Vector2(86.0, 116.0), Vector2(126.0, 174.0), Vector2(216.0, 196.0)],
		[Vector2(1280.0, 76.0), Vector2(1190.0, 108.0), Vector2(1162.0, 168.0), Vector2(1086.0, 196.0)],
		[Vector2(44.0, 720.0), Vector2(94.0, 650.0), Vector2(144.0, 614.0), Vector2(182.0, 548.0)],
		[Vector2(1280.0, 628.0), Vector2(1218.0, 590.0), Vector2(1196.0, 536.0), Vector2(1126.0, 508.0)],
		[Vector2(640.0, 0.0), Vector2(616.0, 48.0), Vector2(650.0, 102.0), Vector2(626.0, 146.0)]
	]
	for points in crack_sets:
		var line := Line2D.new()
		line.points = PackedVector2Array(points)
		line.width = 2.0
		line.default_color = Color(0.78, 0.0, 0.035, 0.0)
		line.joint_mode = Line2D.LINE_JOINT_SHARP
		_vein_cracks_overlay.add_child(line)
		for i in range(1, points.size() - 1):
			var branch := Line2D.new()
			var start: Vector2 = points[i]
			var direction := Vector2(-18.0 + float(i) * 31.0, -52.0 + float(i) * 14.0)
			branch.points = PackedVector2Array([start, start + direction])
			branch.width = 1.2
			branch.default_color = Color(0.95, 0.05, 0.02, 0.0)
			branch.joint_mode = Line2D.LINE_JOINT_SHARP
			_vein_cracks_overlay.add_child(branch)

func _shader_material(shader_code: String) -> ShaderMaterial:
	var shader := Shader.new()
	shader.code = shader_code
	var material := ShaderMaterial.new()
	material.shader = shader
	return material

func _make_heartbeat_stream() -> AudioStreamWAV:
	var stream := AudioStreamWAV.new()
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

	var buttons := HBoxContainer.new()
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

	var time_back := ColorRect.new()
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
	content.add_theme_constant_override("separation", 10)
	margin.add_child(content)

	var header := HBoxContainer.new()
	header.add_theme_constant_override("separation", 8)
	content.add_child(header)

	_shop_title_label = _label("Vendor", 26)
	_shop_title_label.add_theme_font_override("font", MISSION_FONT)
	_shop_title_label.add_theme_color_override("font_color", Color(1.0, 0.72, 0.35))
	_shop_title_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header.add_child(_shop_title_label)

	var close_button := Button.new()
	close_button.text = "X"
	close_button.custom_minimum_size = Vector2(34.0, 30.0)
	close_button.focus_mode = Control.FOCUS_NONE
	close_button.add_theme_font_size_override("font_size", 14)
	close_button.add_theme_color_override("font_color", Color(1.0, 0.86, 0.66))
	close_button.add_theme_stylebox_override("normal", _button_style(Color(0.12, 0.045, 0.04, 0.92)))
	close_button.add_theme_stylebox_override("hover", _button_style(Color(0.25, 0.075, 0.055, 0.98)))
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

	var divider := ColorRect.new()
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
	button.add_theme_color_override("font_color", Color(1.0, 0.86, 0.66))
	button.add_theme_stylebox_override("normal", _button_style(Color(0.055, 0.052, 0.058, 0.96)))
	button.add_theme_stylebox_override("hover", _button_style(Color(0.16, 0.08, 0.07, 0.98)))
	button.add_theme_stylebox_override("pressed", _button_style(Color(0.04, 0.032, 0.038, 1.0)))
	button.pressed.connect(_on_shop_item_pressed.bind(String(item.get("id", ""))))
	return button

func _make_character_menu(root: Control) -> void:
	_demon_menu_button = Button.new()
	_demon_menu_button.text = ""
	_demon_menu_button.anchor_left = 0.02
	_demon_menu_button.anchor_top = 0.08
	_demon_menu_button.anchor_right = 0.02
	_demon_menu_button.anchor_bottom = 0.08
	_demon_menu_button.offset_left = 0.0
	_demon_menu_button.offset_top = 8.0
	_demon_menu_button.offset_right = DEMON_MENU_BUTTON_SIZE.x
	_demon_menu_button.offset_bottom = DEMON_MENU_BUTTON_SIZE.y + 8.0
	_demon_menu_button.focus_mode = Control.FOCUS_NONE
	_demon_menu_button.tooltip_text = "Character"
	_demon_menu_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	_demon_menu_button.pivot_offset = DEMON_MENU_BUTTON_SIZE * 0.5
	_demon_menu_button.add_theme_stylebox_override("normal", _icon_button_style(Color.TRANSPARENT, Color.TRANSPARENT))
	_demon_menu_button.add_theme_stylebox_override("hover", _icon_button_style(Color.TRANSPARENT, Color.TRANSPARENT))
	_demon_menu_button.add_theme_stylebox_override("pressed", _icon_button_style(Color.TRANSPARENT, Color.TRANSPARENT))
	_demon_menu_button.mouse_entered.connect(_on_demon_menu_button_mouse_entered)
	_demon_menu_button.mouse_exited.connect(_on_demon_menu_button_mouse_exited)
	_demon_menu_button.pressed.connect(_toggle_character_panel)
	root.add_child(_demon_menu_button)

	var demon_image := TextureRect.new()
	demon_image.texture = DEMON_MENU_TEXTURE
	demon_image.set_anchors_preset(Control.PRESET_FULL_RECT)
	demon_image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	demon_image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	demon_image.mouse_filter = Control.MOUSE_FILTER_IGNORE
	demon_image.material = _silhouette_outline_material(0.34)
	_demon_menu_button.add_child(demon_image)
	_demon_menu_image = demon_image

	_demon_level_label = _label("", 18)
	_demon_level_label.anchor_left = 0.02
	_demon_level_label.anchor_top = 0.08
	_demon_level_label.anchor_right = 0.02
	_demon_level_label.anchor_bottom = 0.08
	_demon_level_label.offset_left = -16.0
	_demon_level_label.offset_top = DEMON_MENU_BUTTON_SIZE.y + 16.0
	_demon_level_label.offset_right = DEMON_MENU_BUTTON_SIZE.x + 36.0
	_demon_level_label.offset_bottom = DEMON_MENU_BUTTON_SIZE.y + 44.0
	_demon_level_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_demon_level_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_demon_level_label.add_theme_font_override("font", MISSION_FONT)
	_demon_level_label.add_theme_color_override("font_color", Color(1.0, 0.84, 0.48))
	_demon_level_label.add_theme_color_override("font_outline_color", Color(0.08, 0.02, 0.01, 0.95))
	_demon_level_label.add_theme_constant_override("outline_size", 2)
	_demon_level_label.visible = false
	root.add_child(_demon_level_label)
	_refresh_demon_menu_visuals()

	_character_panel = PanelContainer.new()
	_character_panel.visible = false
	_character_panel.anchor_left = 0.02
	_character_panel.anchor_top = 0.08
	_character_panel.anchor_right = 0.02
	_character_panel.anchor_bottom = 0.08
	_character_panel.offset_left = DEMON_MENU_BUTTON_SIZE.x + 12.0
	_character_panel.offset_top = 10.0
	_character_panel.offset_right = DEMON_MENU_BUTTON_SIZE.x + 12.0 + CHARACTER_PANEL_SIZE.x
	_character_panel.offset_bottom = 10.0 + CHARACTER_PANEL_SIZE.y
	_character_panel.add_theme_stylebox_override("panel", _panel_style(Color(0.022, 0.012, 0.016, 0.98)))
	root.add_child(_character_panel)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 18)
	margin.add_theme_constant_override("margin_top", 14)
	margin.add_theme_constant_override("margin_right", 18)
	margin.add_theme_constant_override("margin_bottom", 16)
	_character_panel.add_child(margin)

	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", 10)
	margin.add_child(content)

	var header := HBoxContainer.new()
	header.add_theme_constant_override("separation", 8)
	content.add_child(header)

	var title := _label("Soul Ledger", 26)
	title.add_theme_font_override("font", MISSION_FONT)
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
	close_button.add_theme_stylebox_override("hover", _button_style(Color(0.25, 0.075, 0.055, 0.98)))
	close_button.add_theme_stylebox_override("pressed", _button_style(Color(0.075, 0.026, 0.026, 1.0)))
	close_button.pressed.connect(_hide_character_panel)
	header.add_child(close_button)

	var ember_line := ColorRect.new()
	ember_line.color = Color(0.95, 0.17, 0.04, 0.7)
	ember_line.custom_minimum_size = Vector2(0.0, 2.0)
	content.add_child(ember_line)

	var tabs := HBoxContainer.new()
	tabs.add_theme_constant_override("separation", 6)
	content.add_child(tabs)
	_add_character_tab_button(tabs, "Stats", CHARACTER_PANEL_TAB_STATS)
	_add_character_tab_button(tabs, "Spells", CHARACTER_PANEL_TAB_SPELLS)
	_add_character_tab_button(tabs, "Inventory", CHARACTER_PANEL_TAB_INVENTORY)
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

	_skill_tree_view = SkillTreeView.new()
	_skill_tree_view.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_skill_tree_view.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_skill_tree_view.visible = false
	_skill_tree_view.point_spend_requested.connect(_on_skill_tree_point_spend_requested)
	content.add_child(_skill_tree_view)
	_sync_character_panel()

func _add_character_tab_button(tabs: HBoxContainer, text: String, tab: String) -> void:
	var button := Button.new()
	button.text = text
	button.custom_minimum_size = Vector2(120.0, 34.0)
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button.focus_mode = Control.FOCUS_NONE
	button.add_theme_font_override("font", MISSION_FONT)
	button.add_theme_font_size_override("font_size", 16)
	button.add_theme_color_override("font_color", Color(1.0, 0.86, 0.66))
	button.pressed.connect(Callable(self, "_set_character_panel_tab").bind(tab))
	tabs.add_child(button)
	_character_tab_buttons[tab] = button

func _toggle_character_panel() -> void:
	if _character_panel == null:
		return
	_character_panel.visible = not _character_panel.visible
	if _character_panel.visible:
		_acknowledge_level_up_feedback()
		_sync_character_panel()
		_character_panel.move_to_front()
		_demon_menu_button.move_to_front()

func _hide_character_panel() -> void:
	if _character_panel != null:
		_character_panel.visible = false

func _set_character_panel_tab(tab: String) -> void:
	_character_panel_tab = tab
	if tab != CHARACTER_PANEL_TAB_SPELLS:
		_spells_hovered_name = ""
	_sync_character_panel()

func _sync_character_panel() -> void:
	if _character_content_label == null:
		return
	for tab in _character_tab_buttons.keys():
		var button := _character_tab_buttons[tab] as Button
		if button == null:
			continue
		if tab == _character_panel_tab:
			button.add_theme_color_override("font_color", Color(1.0, 0.9, 0.66))
			button.add_theme_stylebox_override("normal", _button_style(Color(0.38, 0.04, 0.035, 0.96)))
			button.add_theme_stylebox_override("hover", _button_style(Color(0.46, 0.065, 0.05, 0.98)))
			button.add_theme_stylebox_override("pressed", _button_style(Color(0.2, 0.032, 0.026, 1.0)))
		else:
			button.add_theme_color_override("font_color", Color(0.9, 0.74, 0.55))
			button.add_theme_stylebox_override("normal", _button_style(Color(0.06, 0.052, 0.058, 0.96)))
			button.add_theme_stylebox_override("hover", _button_style(Color(0.16, 0.08, 0.07, 0.98)))
			button.add_theme_stylebox_override("pressed", _button_style(Color(0.04, 0.032, 0.038, 1.0)))
	if _spells_view != null:
		_spells_view.visible = _character_panel_tab == CHARACTER_PANEL_TAB_SPELLS
	if _skill_tree_view != null:
		_skill_tree_view.visible = _character_panel_tab == CHARACTER_PANEL_TAB_SKILL_TREE
	if _inventory_view != null:
		_inventory_view.visible = _character_panel_tab == CHARACTER_PANEL_TAB_INVENTORY
	_character_content_label.visible = _character_panel_tab == CHARACTER_PANEL_TAB_STATS
	if _character_panel_tab == CHARACTER_PANEL_TAB_INVENTORY:
		_sync_inventory_view()
	elif _character_panel_tab == CHARACTER_PANEL_TAB_SPELLS:
		_sync_spells_view()
	elif _character_panel_tab == CHARACTER_PANEL_TAB_SKILL_TREE:
		_sync_skill_tree_view()
	elif _character_panel_tab == CHARACTER_PANEL_TAB_STATS:
		_character_content_label.text = _character_stats_text()

func _sync_skill_tree_view() -> void:
	if _skill_tree_view == null:
		return
	var points: int = int(_latest_stats.get("skill_points", 0))
	var unlocked_nodes: Array = _latest_stats.get("unlocked_skill_nodes", [])
	_skill_tree_view.set_skill_data(points, unlocked_nodes)
	_skill_tree_view.set_corruption_ratio(_corruption_ratio)

func _make_spells_view() -> Control:
	var spells := VBoxContainer.new()
	spells.add_theme_constant_override("separation", 12)
	spells.size_flags_vertical = Control.SIZE_EXPAND_FILL

	_spells_hover_label = _label("Hover over each sigil to reveal its name.", 15)
	_spells_hover_label.add_theme_color_override("font_color", Color(0.82, 0.73, 0.63))
	spells.add_child(_spells_hover_label)

	for category_variant in SPELL_SLOT_HOVER_CATEGORIES:
		var category := String(category_variant)
		var section := VBoxContainer.new()
		section.add_theme_constant_override("separation", 6)
		spells.add_child(section)

		var header := _label("%s Spells:" % String(SPELL_SLOT_HOVER_LABELS.get(category, category.capitalize())), 17)
		header.add_theme_color_override("font_color", Color(0.96, 0.88, 0.72))
		section.add_child(header)

		var row := HFlowContainer.new()
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
	return "|".join(tokens)

func _spell_entries_for_category(category: String) -> Array[Dictionary]:
	var entries: Array[Dictionary] = []
	if category == "attack":
		entries.append({
			"name": "Firestorm",
			"tooltip": "Firestorm",
			"icon": FIRESTORM_TEXTURE,
			"category": category
		})
	var learned_spells: Array = _latest_stats.get("learned_spells", [])
	for spell_id_variant in learned_spells:
		var spell_id := String(spell_id_variant)
		if _spell_category_for_id(spell_id) != category:
			continue
		var display_name := _spell_display_name(spell_id)
		entries.append({
			"name": display_name,
			"tooltip": display_name,
			"text": _spell_chip_abbreviation(display_name),
			"category": category
		})
	return entries

func _make_spell_chip(entry: Dictionary) -> Control:
	var chip := Button.new()
	chip.text = ""
	chip.custom_minimum_size = Vector2(54.0, 54.0)
	chip.focus_mode = Control.FOCUS_NONE
	chip.tooltip_text = String(entry.get("tooltip", entry.get("name", "Spell")))
	chip.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	var chip_style := _spell_chip_style(String(entry.get("category", "attack")))
	chip.add_theme_stylebox_override("normal", chip_style)
	chip.add_theme_stylebox_override("hover", chip_style)
	chip.add_theme_stylebox_override("pressed", chip_style)
	chip.mouse_entered.connect(_on_spell_chip_mouse_entered.bind(String(entry.get("name", "Spell"))))
	chip.mouse_exited.connect(_on_spell_chip_mouse_exited)

	var center := CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	center.mouse_filter = Control.MOUSE_FILTER_IGNORE
	chip.add_child(center)

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
		var glyph := _label(String(entry.get("text", "?")), 16)
		glyph.add_theme_font_override("font", MISSION_FONT)
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
	var inventory := HBoxContainer.new()
	inventory.add_theme_constant_override("separation", 18)
	inventory.size_flags_vertical = Control.SIZE_EXPAND_FILL

	var equip_frame := Control.new()
	equip_frame.custom_minimum_size = Vector2(280.0, 340.0)
	equip_frame.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	equip_frame.size_flags_vertical = Control.SIZE_EXPAND_FILL
	inventory.add_child(equip_frame)

	var equip_image := TextureRect.new()
	equip_image.texture = EQUIP_TEXTURE
	equip_image.set_anchors_preset(Control.PRESET_FULL_RECT)
	equip_image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	equip_image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	equip_image.mouse_filter = Control.MOUSE_FILTER_IGNORE
	equip_image.modulate = Color(1.0, 0.92, 0.82, 0.96)
	equip_frame.add_child(equip_image)

	var details := VBoxContainer.new()
	details.add_theme_constant_override("separation", 6)
	details.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	details.size_flags_vertical = Control.SIZE_EXPAND_FILL
	inventory.add_child(details)

	_inventory_gold_label = _label("", 18)
	_inventory_gold_label.add_theme_color_override("font_color", Color(1.0, 0.88, 0.58))
	details.add_child(_inventory_gold_label)

	_inventory_status_label = _label("", 16)
	_inventory_status_label.add_theme_color_override("font_color", Color(0.92, 0.82, 0.68))
	_inventory_status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_inventory_status_label.size_flags_vertical = Control.SIZE_EXPAND_FILL
	details.add_child(_inventory_status_label)

	return inventory

func _sync_inventory_view() -> void:
	var gold: int = int(_latest_stats.get("gold", 0))
	var diamonds: int = int(_latest_stats.get("diamonds", 0))
	var learned_spells: Array = _latest_stats.get("learned_spells", [])
	if _inventory_gold_label != null:
		_inventory_gold_label.text = "Gold: %s    Diamonds: %s" % [gold, diamonds]
	if _inventory_status_label != null:
		_inventory_status_label.text = "Rings: empty sockets\nRelics: none equipped\nScrolls: opened from castle drops\nSpells purchased: %s\nOfferings: granted by The Whisper" % learned_spells.size()

func _character_stats_text() -> String:
	var life: int = int(_latest_stats.get("life", 100))
	var max_life: int = int(_latest_stats.get("max_life", 100))
	var level: int = int(_latest_stats.get("level", 1))
	var xp: int = int(_latest_stats.get("xp", 0))
	var xp_to_next: int = int(_latest_stats.get("xp_to_next", 100))
	var shield: int = int(_latest_stats.get("shield", 0))
	var active_attack_spell := String(_latest_stats.get("active_attack_spell", "Firestorm"))
	var active_attack_damage_min: int = int(_latest_stats.get("active_attack_damage_min", 0))
	var active_attack_damage_max: int = int(_latest_stats.get("active_attack_damage_max", active_attack_damage_min))
	var active_attack_cooldown: float = float(_latest_stats.get("active_attack_cooldown_duration", 4.5))
	return "Life: %s / %s\nPossession: %s%%\nShield: %s\nLevel: %s\nXP: %s / %s\n\nActive Attack Spell: %s\ndamage: %s - %s\ncooldown: %.1fs" % [
		life,
		max_life,
		int(round(_possession_ratio * 100.0)),
		shield,
		level,
		xp,
		xp_to_next,
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
	if _demon_level_label != null:
		_demon_level_label.text = "+1 Level"
		_demon_level_label.visible = true
	_refresh_demon_menu_visuals()

func _update_level_up_feedback(delta: float) -> void:
	if not _level_up_pending_ack:
		if _demon_level_label != null and _demon_level_label.visible:
			_demon_level_label.visible = false
			_refresh_demon_menu_visuals()
		return
	if _demon_level_label != null:
		var rise := sin(_ui_time * (LEVEL_UP_BLINK_SPEED * 0.9)) * 2.5
		_demon_level_label.offset_top = DEMON_MENU_BUTTON_SIZE.y + 16.0 - rise
		_demon_level_label.offset_bottom = DEMON_MENU_BUTTON_SIZE.y + 44.0 - rise
		var blink_on := int(_ui_time * (LEVEL_UP_BLINK_SPEED * 2.0)) % 2 == 0
		_demon_level_label.modulate = Color(1.0, 0.84, 0.48, 1.0 if blink_on else 0.45)
		_demon_level_label.visible = true
	_refresh_demon_menu_visuals()

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
	if _demon_level_label != null:
		_demon_level_label.visible = false
		_demon_level_label.offset_top = DEMON_MENU_BUTTON_SIZE.y + 16.0
		_demon_level_label.offset_bottom = DEMON_MENU_BUTTON_SIZE.y + 44.0
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
	_show_whisper(CORRUPTION_STAGE_LINES[index])

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
		var scale_wave := 1.0 + sin(_ui_time * 2.0) * (0.002 + _corruption_ratio * 0.006)
		_possession_cluster.scale = Vector2.ONE * scale_wave

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
	_show_whisper(CORRUPTION_STAGE_LINES[index])
	_passive_whisper_timer = _rng.randf_range(8.0, 15.0) - _corruption_ratio * 4.0

func _label(text: String, size: int) -> Label:
	var label := Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", size)
	label.add_theme_color_override("font_color", Color(0.92, 0.88, 0.78))
	return label

func _make_minimap_dot(color: Color, dot_size: float) -> Panel:
	var dot := Panel.new()
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
		parent.add_child(hitbox)
		_spell_slot_hover_regions.append(hitbox)

func _spell_slot_tooltip_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.05, 0.03, 0.02, 0.94)
	style.border_color = Color(0.96, 0.58, 0.18, 0.94)
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
	if category == "attack":
		return "Firestorm"
	var learned_spells: Array = _latest_stats.get("learned_spells", [])
	for spell_id_variant in learned_spells:
		var spell_id := String(spell_id_variant)
		if _spell_category_for_id(spell_id) == category:
			return _spell_display_name(spell_id)
	return "None"

func _spell_category_for_id(spell_id: String) -> String:
	if spell_id in ["searing_fire", "wide_flame"]:
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
		_possession_hover_region.tooltip_text = "Possesion: %s%%" % int(round(_possession_ratio * 100.0))

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
	button.add_theme_stylebox_override("hover", _button_style(color.lightened(0.14)))
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

func _on_skill_tree_point_spend_requested(node_key: String) -> void:
	if node_key.is_empty():
		return
	skill_tree_point_requested.emit(node_key)

func _bar_style(color: Color) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = color
	style.set_corner_radius_all(4)
	return style
