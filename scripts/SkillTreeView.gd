extends Control
class_name SkillTreeView

signal point_spend_requested(node_key: String)

const PALETTE_TEXT := Color(0.96, 0.86, 0.68)
const PALETTE_TEXT_DIM := Color(0.7, 0.62, 0.52)
const PALETTE_PANEL := Color(0.055, 0.022, 0.026, 0.97)
const PALETTE_PANEL_DARK := Color(0.018, 0.009, 0.012, 0.98)
const PALETTE_GOLD := Color(1.0, 0.72, 0.35, 1.0)
const MIN_ZOOM := 0.72
const MAX_ZOOM := 1.8
const BASE_BRANCH_RADIUS := 176.0
const CORE_RADIUS := 40.0
const TOOLTIP_SIZE := Vector2(292.0, 188.0)

const BRANCH_COLORS := {
	"core": Color(0.86, 0.1, 0.16, 1.0),
	"offense": Color(1.0, 0.33, 0.12, 1.0),
	"defense": Color(0.62, 0.66, 0.72, 1.0),
	"buff": Color(0.66, 0.26, 0.84, 1.0),
	"heal": Color(0.34, 0.86, 0.46, 1.0),
	"debuff": Color(0.46, 0.74, 0.26, 1.0),
	"synergy": Color(0.95, 0.62, 0.16, 1.0)
}

const RITUAL_NODES := [
	{
		"id": "core",
		"label": "Dark Core",
		"type": "core",
		"branch": "core",
		"position": Vector2.ZERO,
		"radius": CORE_RADIUS,
		"requires": [],
		"gameplay_key": "",
		"description": "The ritual heart. Its pulse answers corruption.",
		"stats": ["Center of your sigil web", "Visual corruption reacts over time"]
	},
	{
		"id": "cleave_edge",
		"label": "Cleave Edge",
		"type": "attack",
		"branch": "offense",
		"position": Vector2(-78.0, -46.0),
		"radius": 18.0,
		"requires": ["core"],
		"gameplay_key": "",
		"description": "An intermediate shadow technique.",
		"stats": ["Tier-2 offense node", "Leads to Abyssal Blade"]
	},
	{
		"id": "damage",
		"label": "Abyssal Blade",
		"type": "attack",
		"branch": "offense",
		"position": Vector2(-156.0, -92.0),
		"radius": 24.0,
		"requires": ["core"],
		"gameplay_key": "damage",
		"description": "Slash enemies with shadow force.",
		"stats": ["Damage multiplier +15%", "Scales with base spell damage"]
	},
	{
		"id": "warding_glyph",
		"label": "Warding Glyph",
		"type": "defense",
		"branch": "defense",
		"position": Vector2(78.0, -48.0),
		"radius": 18.0,
		"requires": ["core"],
		"gameplay_key": "",
		"description": "An intermediate warding sigil.",
		"stats": ["Tier-2 defense node", "Leads to Veil Ward"]
	},
	{
		"id": "radius",
		"label": "Veil Ward",
		"type": "defense",
		"branch": "defense",
		"position": Vector2(158.0, -96.0),
		"radius": 24.0,
		"requires": ["core"],
		"gameplay_key": "radius",
		"description": "Expand your protection circle and spell reach.",
		"stats": ["Firestorm radius bonus +0.9", "Improves zone control"]
	},
	{
		"id": "spell_rhythm",
		"label": "Spell Rhythm",
		"type": "buff",
		"branch": "buff",
		"position": Vector2(0.0, 84.0),
		"radius": 18.0,
		"requires": ["core"],
		"gameplay_key": "",
		"description": "Synchronize your spell cadence.",
		"stats": ["Tier-2 cooldown node", "Leads to Quickened Ritual"]
	},
	{
		"id": "cooldown",
		"label": "Quickened Ritual",
		"type": "buff",
		"branch": "buff",
		"position": Vector2(0.0, 168.0),
		"radius": 24.0,
		"requires": ["core"],
		"gameplay_key": "cooldown",
		"description": "Tighten casting rhythm through blood-time bends.",
		"stats": ["Cooldown reduction -0.4s", "Stacks with spell upgrades"]
	},
	{
		"id": "soul_echo",
		"label": "Soul Echo",
		"type": "debuff",
		"branch": "debuff",
		"position": Vector2(-85.0, 50.0),
		"radius": 18.0,
		"requires": ["core"],
		"gameplay_key": "",
		"description": "Resonate with departed souls.",
		"stats": ["Tier-2 debuff node", "Prepares deeper curses"]
	},
	{
		"id": "soul_rot",
		"label": "Soul Rot",
		"type": "debuff",
		"branch": "debuff",
		"position": Vector2(-172.0, 80.0),
		"radius": 20.0,
		"requires": ["core"],
		"gameplay_key": "",
		"description": "A dormant debuff branch waiting to awaken.",
		"stats": ["Preview node", "Planned for future builds"]
	},
	{
		"id": "lifeweave",
		"label": "Lifeweave",
		"type": "healing",
		"branch": "heal",
		"position": Vector2(85.0, 50.0),
		"radius": 18.0,
		"requires": ["core"],
		"gameplay_key": "",
		"description": "Weave vital threads of protection.",
		"stats": ["Tier-2 healing node", "Channels life force"]
	},
	{
		"id": "blood_mend",
		"label": "Blood Mend",
		"type": "healing",
		"branch": "heal",
		"position": Vector2(170.0, 82.0),
		"radius": 20.0,
		"requires": ["core"],
		"gameplay_key": "",
		"description": "A dormant healing branch awaiting future rites.",
		"stats": ["Preview node", "Planned for future builds"]
	},
	{
		"id": "stormblood_pact",
		"label": "Stormblood Pact",
		"type": "synergy",
		"branch": "synergy",
		"position": Vector2(0.0, -176.0),
		"radius": 26.0,
		"requires": ["damage", "radius"],
		"gameplay_key": "",
		"description": "Fire and ward rites converge into a dual sigil.",
		"stats": ["Synergy node", "Unlocks when both paths converge"]
	}
]

const RITUAL_CONNECTIONS := [
	["core", "cleave_edge"],
	["cleave_edge", "damage"],
	["core", "warding_glyph"],
	["warding_glyph", "radius"],
	["core", "spell_rhythm"],
	["spell_rhythm", "cooldown"],
	["core", "soul_echo"],
	["soul_echo", "soul_rot"],
	["core", "lifeweave"],
	["lifeweave", "blood_mend"],
	["damage", "stormblood_pact"],
	["radius", "stormblood_pact"]
]

var pulse := 0.0
var _available_points := 0
var _unlocked_nodes := {
	"core": true,
	"damage": false,
	"radius": false,
	"cooldown": false
}
var _corruption_ratio := 0.0
var _selected_node_id := "core"
var _hovered_node_id := ""
var _zoom := 0.9
var _pan_offset := Vector2.ZERO
var _dragging := false
var _drag_started_on_node := false
var _drag_start_mouse := Vector2.ZERO
var _drag_start_pan := Vector2.ZERO
var _pressed_node_id := ""
var _mouse_position := Vector2.ZERO

func _ready() -> void:
	custom_minimum_size = Vector2(0.0, 360.0)
	mouse_filter = Control.MOUSE_FILTER_STOP
	_mouse_position = get_local_mouse_position()

func _process(delta: float) -> void:
	pulse += delta
	_mouse_position = get_local_mouse_position()
	_hovered_node_id = _node_at_screen_position(_mouse_position)
	queue_redraw()

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_event := event as InputEventMouseButton
		if mouse_event == null:
			return
		if mouse_event.button_index == MOUSE_BUTTON_WHEEL_UP and mouse_event.pressed:
			_adjust_zoom(1.08, mouse_event.position)
			return
		if mouse_event.button_index == MOUSE_BUTTON_WHEEL_DOWN and mouse_event.pressed:
			_adjust_zoom(1.0 / 1.08, mouse_event.position)
			return
		if mouse_event.button_index == MOUSE_BUTTON_LEFT:
			if mouse_event.pressed:
				_handle_left_press(mouse_event.position)
			else:
				_handle_left_release(mouse_event.position)
			return
	if event is InputEventMouseMotion:
		var motion_event := event as InputEventMouseMotion
		if motion_event == null:
			return
		_mouse_position = motion_event.position
		_hovered_node_id = _node_at_screen_position(motion_event.position)
		if _dragging:
			_pan_offset = _drag_start_pan + (motion_event.position - _drag_start_mouse)
		queue_redraw()

func set_skill_data(points: int, unlocked_nodes: Array) -> void:
	_available_points = maxi(points, 0)
	_unlocked_nodes["core"] = true
	_unlocked_nodes["damage"] = false
	_unlocked_nodes["radius"] = false
	_unlocked_nodes["cooldown"] = false
	for key_variant in unlocked_nodes:
		var key := String(key_variant)
		if _unlocked_nodes.has(key):
			_unlocked_nodes[key] = true
	if _selected_node_id.is_empty() or not _node_by_id(_selected_node_id).is_empty():
		pass
	else:
		_selected_node_id = "core"
	queue_redraw()

func set_corruption_ratio(ratio: float) -> void:
	_corruption_ratio = clampf(ratio, 0.0, 1.0)
	queue_redraw()

func _draw() -> void:
	var tree_rect := _tree_rect()
	_draw_background(tree_rect)
	_draw_tree(tree_rect)
	if not _hovered_node_id.is_empty():
		var hovered := _node_by_id(_hovered_node_id)
		if not hovered.is_empty():
			_draw_hover_panel(tree_rect, hovered, _mouse_position)

func _draw_background(tree_rect: Rect2) -> void:
	draw_rect(tree_rect, PALETTE_PANEL_DARK, true)
	var center := tree_rect.get_center() + _pan_offset
	var corruption_tint := Color(0.08, 0.01, 0.02, 0.16 + _corruption_ratio * 0.25)
	draw_circle(center, BASE_BRANCH_RADIUS * _zoom * 1.18, corruption_tint)
	var ring_color := Color(0.42, 0.08, 0.1, 0.32)
	draw_arc(center, BASE_BRANCH_RADIUS * _zoom, 0.0, TAU, 128, ring_color, 2.0, true)
	draw_arc(center, BASE_BRANCH_RADIUS * _zoom * 0.74, pulse * 0.18, TAU + pulse * 0.18, 128, Color(0.35, 0.08, 0.24, 0.36), 1.6, true)
	_draw_left_string("Ritual Circle", Vector2(tree_rect.position.x + 12.0, tree_rect.position.y + 28.0), 17, Color(0.96, 0.78, 0.56, 0.95))
	_draw_left_string("Skill Points: %s" % _available_points, Vector2(tree_rect.position.x + 12.0, tree_rect.position.y + 50.0), 14, Color(0.9, 0.74, 0.58, 0.9))

func _draw_tree(tree_rect: Rect2) -> void:
	for pair in RITUAL_CONNECTIONS:
		if pair.size() < 2:
			continue
		var from_node := _node_by_id(pair[0])
		var to_node := _node_by_id(pair[1])
		if from_node.is_empty() or to_node.is_empty():
			continue
		_draw_connection(from_node, to_node, tree_rect)

	for node in RITUAL_NODES:
		_draw_node(node, tree_rect)

func _draw_connection(from_node: Dictionary, to_node: Dictionary, tree_rect: Rect2) -> void:
	var start := _world_to_screen(Vector2(from_node["position"]), tree_rect)
	var end := _world_to_screen(Vector2(to_node["position"]), tree_rect)
	var branch_color := _branch_color(String(to_node.get("branch", "core")) )
	var all_ready := _prerequisites_met(String(to_node["id"]))
	var intensity := 0.16
	if all_ready:
		intensity = 0.36 + 0.2 * (0.5 + 0.5 * sin(pulse * 2.2))
	if _is_node_unlocked(String(to_node["id"])):
		intensity = 0.78 + 0.16 * (0.5 + 0.5 * sin(pulse * 3.1))
	var width := 2.2 * _zoom
	var direction := (end - start)
	var normal := Vector2(-direction.y, direction.x).normalized()
	var bend := 18.0 * _zoom
	var midpoint := start.lerp(end, 0.5) + normal * bend
	var points := PackedVector2Array()
	for i in range(17):
		var t := float(i) / 16.0
		var p := _quadratic_bezier(start, midpoint, end, t)
		points.append(p)
	draw_polyline(points, Color(0.0, 0.0, 0.0, 0.36), width + 3.2, true)
	draw_polyline(points, Color(branch_color.r, branch_color.g, branch_color.b, intensity), width, true)

func _draw_node(node: Dictionary, tree_rect: Rect2) -> void:
	var node_id := String(node["id"])
	var world := Vector2(node["position"])
	var center := _world_to_screen(world, tree_rect)
	var base_radius := float(node["radius"]) * _zoom
	var state := _node_state(node)
	var branch_color := _branch_color(String(node.get("branch", "core")))
	var selected := node_id == _selected_node_id
	var hovered := node_id == _hovered_node_id
	var pulse_wave := 0.5 + 0.5 * sin(pulse * 3.0)
	var radius := base_radius * (1.06 if hovered else 1.0)
	if selected:
		radius *= 1.04

	var glow_alpha := 0.04
	match state:
		"unlocked":
			glow_alpha = 0.42 + pulse_wave * 0.26
		"available":
			glow_alpha = 0.26 + pulse_wave * 0.2
		"sealed":
			glow_alpha = 0.08 + pulse_wave * 0.06
		_:
			glow_alpha = 0.03

	var fill := PALETTE_PANEL
	var edge := Color(0.32, 0.15, 0.14, 0.9)
	var sigil := Color(0.45, 0.28, 0.24, 0.6)
	if state == "unlocked":
		edge = Color(PALETTE_GOLD.r, PALETTE_GOLD.g, PALETTE_GOLD.b, 0.98)
		sigil = Color(branch_color.r, branch_color.g, branch_color.b, 0.95)
	elif state == "available":
		edge = Color(branch_color.r, branch_color.g, branch_color.b, 0.95)
		sigil = Color(branch_color.r, branch_color.g, branch_color.b, 0.82)
	elif state == "sealed":
		edge = Color(0.42, 0.22, 0.18, 0.84)
		sigil = Color(branch_color.r, branch_color.g, branch_color.b, 0.36)

	if _corruption_ratio > 0.0 and node_id == "core":
		var corrupt_mix := clampf(_corruption_ratio * 1.1, 0.0, 1.0)
		edge = edge.lerp(Color(0.18, 0.04, 0.06, 1.0), corrupt_mix)
		sigil = sigil.lerp(Color(0.5, 0.0, 0.12, 1.0), corrupt_mix)

	_draw_circle_shape(center + Vector2(0.0, 4.0), radius + 10.0, Color(0.0, 0.0, 0.0, 0.3), Color.TRANSPARENT, 0.0)
	_draw_circle_shape(center, radius + 9.0, Color(branch_color.r, branch_color.g, branch_color.b, glow_alpha), Color.TRANSPARENT, 0.0)

	var node_type := String(node.get("type", "attack"))
	if node_type == "synergy":
		_draw_hexagon(center, radius + 4.0, PALETTE_PANEL_DARK, edge, 2.0)
		_draw_hexagon(center, radius - 2.0, fill, Color(0.2, 0.07, 0.08, 1.0), 1.0)
		_draw_sigil_glyph(center, radius - 7.0, sigil, branch_color, node_type)
	else:
		_draw_circle_shape(center, radius + 4.0, PALETTE_PANEL_DARK, edge, 2.0)
		_draw_circle_shape(center, radius - 2.0, fill, Color(0.2, 0.07, 0.08, 1.0), 1.0)
		_draw_sigil_glyph(center, radius - 7.0, sigil, branch_color, node_type)

	if selected:
		draw_arc(center, radius + 12.0, pulse * 0.6, TAU + pulse * 0.6, 52, Color(PALETTE_GOLD.r, PALETTE_GOLD.g, PALETTE_GOLD.b, 0.88), 2.0, true)

	var label_color := PALETTE_TEXT if state != "locked" else PALETTE_TEXT_DIM
	var label_alpha := _label_alpha_for_zoom()
	if label_alpha > 0.01:
		var label_color_with_alpha := Color(label_color.r, label_color.g, label_color.b, label_color.a * label_alpha)
		_draw_centered_string(String(node["label"]), center + Vector2(0.0, radius + 18.0), 13, label_color_with_alpha)

func _draw_hover_panel(tree_rect: Rect2, node: Dictionary, mouse_position: Vector2) -> void:
	var tooltip_position := mouse_position + Vector2(22.0, 16.0)
	var max_x := tree_rect.end.x - TOOLTIP_SIZE.x - 8.0
	var max_y := tree_rect.end.y - TOOLTIP_SIZE.y - 8.0
	tooltip_position.x = clampf(tooltip_position.x, tree_rect.position.x + 8.0, max_x)
	tooltip_position.y = clampf(tooltip_position.y, tree_rect.position.y + 8.0, max_y)
	var panel_rect := Rect2(tooltip_position, TOOLTIP_SIZE)
	draw_rect(panel_rect, Color(PALETTE_PANEL.r, PALETTE_PANEL.g, PALETTE_PANEL.b, 1.0), true)
	draw_rect(panel_rect, Color(0.2, 0.08, 0.08, 1.0), false, 2.0)

	var state := _node_state(node)
	var y := panel_rect.position.y + 22.0
	var x := panel_rect.position.x + 20.0
	var width := panel_rect.size.x - 40.0

	_draw_left_string("Ritual Node", Vector2(x, y), 16, Color(1.0, 0.78, 0.48, 0.96))
	y += 22.0
	_draw_left_string(String(node.get("label", "Dark Core")), Vector2(x, y), 19, Color(0.98, 0.9, 0.74, 0.96))
	y += 24.0

	var status_text := "Locked"
	var status_color := Color(0.72, 0.58, 0.44, 0.86)
	if state == "unlocked":
		status_text = "Unlocked"
		status_color = Color(0.98, 0.85, 0.62, 0.96)
	elif state == "available":
		status_text = "Available"
		status_color = Color(0.92, 0.72, 0.44, 0.96)
	elif state == "sealed":
		status_text = "Dormant"
		status_color = Color(0.65, 0.5, 0.72, 0.9)
	_draw_left_string(status_text, Vector2(x, y), 14, status_color)
	y += 22.0

	var description := String(node.get("description", ""))
	for line in _wrap_text(description, width, 13):
		_draw_left_string(line, Vector2(x, y), 13, Color(0.9, 0.8, 0.7, 0.88))
		y += 16.0

	y += 6.0
	var stats: Array = node.get("stats", [])
	for stat_variant in stats:
		_draw_left_string("• %s" % String(stat_variant), Vector2(x, y), 12, Color(0.84, 0.74, 0.64, 0.85))
		y += 15.0

	y += 8.0
	var hint := "Click sigil to unlock"
	var hint_color := Color(0.86, 0.72, 0.56, 0.8)
	if _is_node_unlocked(String(node.get("id", ""))):
		hint = "Already unlocked"
		hint_color = Color(0.95, 0.84, 0.66, 0.84)
	elif not _is_unlockable_node(node):
		hint = "Locked by prerequisites"
		hint_color = Color(0.72, 0.58, 0.44, 0.82)
	elif _available_points <= 0:
		hint = "Need skill points"
		hint_color = Color(0.74, 0.6, 0.48, 0.82)
	_draw_left_string(hint, Vector2(x, y), 12, hint_color)

func _handle_left_press(position: Vector2) -> void:
	var node_id := _node_at_screen_position(position)
	if not node_id.is_empty():
		_selected_node_id = node_id
		_pressed_node_id = node_id
		_dragging = false
		_drag_started_on_node = true
		_drag_start_mouse = position
		queue_redraw()
		return
	if _tree_rect().has_point(position):
		_pressed_node_id = ""
		_dragging = true
		_drag_started_on_node = false
		_drag_start_mouse = position
		_drag_start_pan = _pan_offset

func _handle_left_release(position: Vector2) -> void:
	if _drag_started_on_node:
		var moved_on_node := position.distance_to(_drag_start_mouse)
		if moved_on_node < 7.0 and not _pressed_node_id.is_empty():
			var released_node_id := _node_at_screen_position(position)
			if released_node_id == _pressed_node_id:
				var node := _node_by_id(_pressed_node_id)
				if _can_unlock(node):
					point_spend_requested.emit(String(node.get("gameplay_key", "")))
	if _dragging and not _drag_started_on_node:
		var moved := position.distance_to(_drag_start_mouse)
		if moved < 7.0:
			var node_id := _node_at_screen_position(position)
			if not node_id.is_empty():
				_selected_node_id = node_id
	_pressed_node_id = ""
	_dragging = false
	_drag_started_on_node = false
	queue_redraw()

func _adjust_zoom(multiplier: float, mouse_position: Vector2) -> void:
	var next_zoom := clampf(_zoom * multiplier, MIN_ZOOM, MAX_ZOOM)
	if is_equal_approx(next_zoom, _zoom):
		return
	var tree_rect := _tree_rect()
	var pivot := tree_rect.get_center() + _pan_offset
	var before := (mouse_position - pivot) / _zoom
	_zoom = next_zoom
	var after_pivot := mouse_position - before * _zoom
	_pan_offset += after_pivot - pivot
	queue_redraw()

func _tree_rect() -> Rect2:
	return Rect2(Vector2(8.0, 8.0), Vector2(maxf(size.x - 16.0, 260.0), maxf(size.y - 16.0, 250.0)))

func _world_to_screen(world: Vector2, tree_rect: Rect2) -> Vector2:
	return tree_rect.get_center() + _pan_offset + world * _zoom

func _screen_to_world(screen: Vector2, tree_rect: Rect2) -> Vector2:
	return (screen - (tree_rect.get_center() + _pan_offset)) / _zoom

func _node_at_screen_position(screen_position: Vector2) -> String:
	var tree_rect := _tree_rect()
	if not tree_rect.has_point(screen_position):
		return ""
	var world := _screen_to_world(screen_position, tree_rect)
	for node in RITUAL_NODES:
		var node_world := Vector2(node["position"])
		var radius := float(node["radius"]) + 8.0
		if world.distance_to(node_world) <= radius:
			return String(node["id"])
	return ""

func _selected_node() -> Dictionary:
	var selected := _node_by_id(_selected_node_id)
	if selected.is_empty():
		return _node_by_id("core")
	return selected

func _node_by_id(node_id: String) -> Dictionary:
	for node in RITUAL_NODES:
		if String(node["id"]) == node_id:
			return node
	return {}

func _branch_color(branch: String) -> Color:
	if BRANCH_COLORS.has(branch):
		return BRANCH_COLORS[branch]
	return Color(0.74, 0.24, 0.16, 1.0)

func _node_state(node: Dictionary) -> String:
	var node_id := String(node.get("id", ""))
	if _is_node_unlocked(node_id):
		return "unlocked"
	if not _is_unlockable_node(node):
		if _is_preview_node(node):
			return "sealed"
		return "locked"
	if _available_points > 0:
		return "available"
	return "locked"

func _is_preview_node(node: Dictionary) -> bool:
	return String(node.get("gameplay_key", "")).is_empty() and String(node.get("id", "")) != "core"

func _is_unlockable_node(node: Dictionary) -> bool:
	var node_id := String(node.get("id", ""))
	if node_id == "core":
		return false
	var gameplay_key := String(node.get("gameplay_key", ""))
	if gameplay_key.is_empty():
		return false
	if _is_node_unlocked(node_id):
		return false
	return _prerequisites_met(node_id)

func _can_unlock(node: Dictionary) -> bool:
	return _is_unlockable_node(node) and _available_points > 0

func _prerequisites_met(node_id: String) -> bool:
	var node := _node_by_id(node_id)
	if node.is_empty():
		return false
	var requirements: Array = node.get("requires", [])
	for req in requirements:
		if not _is_node_unlocked(String(req)):
			return false
	return true

func _is_node_unlocked(node_key: String) -> bool:
	if _unlocked_nodes.has(node_key):
		return bool(_unlocked_nodes[node_key])
	return false

func _draw_circle_shape(center: Vector2, radius: float, fill_color: Color, border_color: Color, border_width: float) -> void:
	draw_circle(center, radius, fill_color)
	if border_width > 0.0:
		draw_arc(center, radius, 0.0, TAU, 42, border_color, border_width, true)

func _draw_hexagon(center: Vector2, radius: float, fill_color: Color, border_color: Color, border_width: float) -> void:
	var points := PackedVector2Array()
	for i in range(6):
		var angle := -PI * 0.5 + TAU * float(i) / 6.0
		points.append(center + Vector2(cos(angle), sin(angle)) * radius)
	draw_colored_polygon(points, fill_color)
	if border_width > 0.0:
		for i in range(points.size()):
			draw_line(points[i], points[(i + 1) % points.size()], border_color, border_width, true)

func _draw_sigil_glyph(center: Vector2, radius: float, color: Color, branch_color: Color, node_type: String) -> void:
	var spin := pulse * 0.85
	var ring_a := maxf(radius * 0.84, 4.0)
	var ring_b := maxf(radius * 0.56, 3.0)
	draw_arc(center, ring_a, spin, PI + spin, 26, Color(color.r, color.g, color.b, 0.88), 1.8, true)
	draw_arc(center, ring_a, PI + spin + 0.38, TAU + spin + 0.38, 26, Color(branch_color.r, branch_color.g, branch_color.b, 0.72), 1.4, true)
	draw_arc(center, ring_b, -spin * 1.4, PI - spin * 1.4, 24, Color(color.r, color.g, color.b, 0.78), 1.2, true)

	var diamond := PackedVector2Array([
		center + Vector2(0.0, -radius * 0.54),
		center + Vector2(radius * 0.54, 0.0),
		center + Vector2(0.0, radius * 0.54),
		center + Vector2(-radius * 0.54, 0.0)
	])
	for i in range(diamond.size()):
		draw_line(diamond[i], diamond[(i + 1) % diamond.size()], Color(color.r, color.g, color.b, 0.9), 1.5, true)
	draw_line(diamond[0], diamond[2], Color(color.r, color.g, color.b, 0.42), 1.0, true)
	draw_line(diamond[1], diamond[3], Color(color.r, color.g, color.b, 0.42), 1.0, true)

	if node_type == "synergy":
		draw_arc(center, radius * 0.34, spin * 2.2, TAU + spin * 2.2, 20, Color(1.0, 0.74, 0.36, 0.9), 1.2, true)
	else:
		draw_circle(center, maxf(radius * 0.14, 2.0), Color(color.r, color.g, color.b, 0.75))

func _label_alpha_for_zoom() -> float:
	if _zoom >= 0.95:
		return 1.0
	if _zoom <= 0.72:
		return 0.0
	var fade_range := 0.95 - 0.72
	var fade_in := (_zoom - 0.72) / fade_range
	return clampf(fade_in, 0.0, 1.0)

func _quadratic_bezier(a: Vector2, b: Vector2, c: Vector2, t: float) -> Vector2:
	var u := 1.0 - t
	return u * u * a + 2.0 * u * t * b + t * t * c

func _wrap_text(text: String, max_width: float, font_size: int) -> Array[String]:
	var words := text.split(" ", false)
	var lines: Array[String] = []
	var current := ""
	var font := _ui_font()
	for word_variant in words:
		var word := String(word_variant)
		var next := word
		if not current.is_empty():
			next = "%s %s" % [current, word]
		var width := font.get_string_size(next, HORIZONTAL_ALIGNMENT_LEFT, -1.0, font_size).x
		if width <= max_width or current.is_empty():
			current = next
		else:
			lines.append(current)
			current = word
	if not current.is_empty():
		lines.append(current)
	if lines.is_empty():
		lines.append("")
	return lines

func _draw_centered_string(text: String, baseline_center: Vector2, size: int, color: Color) -> void:
	var font := _ui_font()
	var text_size := font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1.0, size)
	draw_string(font, baseline_center + Vector2(-text_size.x * 0.5, 0.0), text, HORIZONTAL_ALIGNMENT_LEFT, -1.0, size, color)

func _draw_left_string(text: String, baseline_left: Vector2, size: int, color: Color) -> void:
	draw_string(_ui_font(), baseline_left, text, HORIZONTAL_ALIGNMENT_LEFT, -1.0, size, color)

func _ui_font() -> Font:
	return get_theme_font("font", "Label")
