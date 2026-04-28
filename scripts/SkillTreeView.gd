extends Control
class_name SkillTreeView

const TITLE_FONT: FontFile = preload("res://assets/fonts/PICKYSIDE.otf")
const PALETTE_TEXT := Color(0.96, 0.86, 0.68)
const PALETTE_TEXT_DIM := Color(0.72, 0.61, 0.48)
const PALETTE_PANEL := Color(0.09, 0.035, 0.03, 0.96)
const PALETTE_PANEL_DARK := Color(0.025, 0.012, 0.014, 0.98)
const PALETTE_LINE := Color(0.42, 0.16, 0.13, 0.82)
const PALETTE_EMBER := Color(0.95, 0.17, 0.04, 1.0)
const PALETTE_GOLD := Color(1.0, 0.72, 0.35, 1.0)
const CONTENT_SIZE := Vector2(360.0, 260.0)

const START_NODE := {
	"key": "start",
	"label": "Start",
	"position": Vector2(180.0, 82.0),
	"radius": 31.0,
	"state": "unlocked"
}
const CHOICE_NODES := [
	{
		"key": "damage",
		"label": "Damage",
		"position": Vector2(66.0, 195.0),
		"radius": 27.0,
		"state": "available"
	},
	{
		"key": "radius",
		"label": "Radius",
		"position": Vector2(180.0, 195.0),
		"radius": 27.0,
		"state": "available"
	},
	{
		"key": "cooldown",
		"label": "Cooldown",
		"position": Vector2(294.0, 195.0),
		"radius": 27.0,
		"state": "available"
	}
]

var pulse := 0.0

func _ready() -> void:
	custom_minimum_size = CONTENT_SIZE
	mouse_filter = Control.MOUSE_FILTER_IGNORE

func _process(delta: float) -> void:
	pulse += delta
	queue_redraw()

func _draw() -> void:
	var origin := Vector2(maxf((size.x - CONTENT_SIZE.x) * 0.5, 0.0), 0.0)
	draw_string(TITLE_FONT, origin + Vector2(0.0, 28.0), "Skill Tree", HORIZONTAL_ALIGNMENT_LEFT, -1.0, 30, PALETTE_GOLD)

	for node in CHOICE_NODES:
		_draw_connection(START_NODE, node, origin)

	_draw_node(START_NODE, origin)
	for node in CHOICE_NODES:
		_draw_node(node, origin)

func _draw_connection(from_node: Dictionary, to_node: Dictionary, origin: Vector2) -> void:
	var from_position: Vector2 = origin + from_node["position"]
	var to_position: Vector2 = origin + to_node["position"]
	var direction := (to_position - from_position).normalized()
	var start := from_position + direction * float(from_node["radius"])
	var end := to_position - direction * float(to_node["radius"])
	draw_line(start + Vector2(0.0, 2.0), end + Vector2(0.0, 2.0), Color(0.0, 0.0, 0.0, 0.45), 7.0, true)
	draw_line(start, end, PALETTE_LINE, 4.0, true)
	draw_line(start, end, Color(PALETTE_GOLD.r, PALETTE_GOLD.g, PALETTE_GOLD.b, 0.22), 1.5, true)

func _draw_node(node: Dictionary, origin: Vector2) -> void:
	var center: Vector2 = origin + node["position"]
	var radius: float = float(node["radius"])
	var is_start := String(node["state"]) == "unlocked"
	var ring_pulse := 0.5 + 0.5 * sin(pulse * 2.7)
	var glow_alpha := (0.2 + ring_pulse * 0.18) if is_start else 0.04
	var edge_color := PALETTE_GOLD if is_start else Color(0.44, 0.28, 0.19, 0.95)
	var sigil_color := Color(PALETTE_EMBER.r, PALETTE_EMBER.g, PALETTE_EMBER.b, 0.96) if is_start else Color(0.55, 0.3, 0.18, 0.62)

	_draw_pentagon(center + Vector2(0.0, 4.0), radius + 9.0, Color(0.0, 0.0, 0.0, 0.34), Color.TRANSPARENT, 0.0)
	_draw_pentagon(center, radius + 11.0, Color(PALETTE_EMBER.r, PALETTE_EMBER.g, PALETTE_EMBER.b, glow_alpha), Color.TRANSPARENT, 0.0)
	_draw_pentagon(center, radius + 5.0, PALETTE_PANEL_DARK, edge_color, 2.0)
	_draw_pentagon(center, radius - 2.0, PALETTE_PANEL, Color(0.21, 0.08, 0.065, 1.0), 1.0)
	_draw_pentagram(center, radius - 8.0, sigil_color, 2.2 if is_start else 1.7)

	var label := String(node["label"])
	var label_color := PALETTE_TEXT if is_start else PALETTE_TEXT_DIM
	_draw_centered_string(label, center + Vector2(0.0, radius + 26.0), 18, label_color)

	var status := "Unlocked" if is_start else "Pick"
	_draw_centered_string(status, center + Vector2(0.0, 6.0), 13, Color(1.0, 0.86, 0.66, 0.95) if is_start else Color(0.86, 0.68, 0.47, 0.74))

func _draw_pentagon(center: Vector2, radius: float, fill_color: Color, border_color: Color, border_width: float) -> void:
	var points := _pentagon_points(center, radius)
	draw_colored_polygon(points, fill_color)
	if border_width > 0.0:
		for i in range(points.size()):
			draw_line(points[i], points[(i + 1) % points.size()], border_color, border_width, true)

func _draw_pentagram(center: Vector2, radius: float, color: Color, width: float) -> void:
	var points := _pentagon_points(center, radius)
	var order := [0, 2, 4, 1, 3, 0]
	for i in range(order.size() - 1):
		draw_line(points[order[i]], points[order[i + 1]], color, width, true)

func _pentagon_points(center: Vector2, radius: float) -> PackedVector2Array:
	var points := PackedVector2Array()
	for i in range(5):
		var angle := -PI * 0.5 + TAU * float(i) / 5.0
		points.append(center + Vector2(cos(angle), sin(angle)) * radius)
	return points

func _draw_centered_string(text: String, baseline_center: Vector2, size: int, color: Color) -> void:
	var text_size := TITLE_FONT.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1.0, size)
	draw_string(TITLE_FONT, baseline_center + Vector2(-text_size.x * 0.5, 0.0), text, HORIZONTAL_ALIGNMENT_LEFT, -1.0, size, color)
