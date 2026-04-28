extends Area3D
class_name SISScroll

const SCROLL_TEXTURE: Texture2D = preload("res://assets/images/objects/scroll.png")
const SPRITE_PIXEL_SIZE := 0.00125

signal read_requested(scroll: Node3D)

var scroll_level := 1
var _base_y := 0.0
var _visual_root: Node3D

func _ready() -> void:
	_base_y = position.y
	body_entered.connect(_on_body_entered)
	_make_collision()
	_make_visuals()

func _process(delta: float) -> void:
	rotation.y += delta * 0.72
	position.y = _base_y + sin(Time.get_ticks_msec() * 0.004 + float(scroll_level)) * 0.06

func _on_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		read_requested.emit(self)
		queue_free()

func _make_collision() -> void:
	var collider := CollisionShape3D.new()
	var shape := SphereShape3D.new()
	shape.radius = 0.62
	collider.shape = shape
	collider.position.y = 0.32
	add_child(collider)

func _make_visuals() -> void:
	_visual_root = Node3D.new()
	add_child(_visual_root)

	var sprite := Sprite3D.new()
	sprite.texture = SCROLL_TEXTURE
	sprite.position = Vector3(0.0, 0.42, 0.0)
	sprite.pixel_size = SPRITE_PIXEL_SIZE
	sprite.shaded = true
	sprite.double_sided = true
	sprite.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	sprite.texture_filter = BaseMaterial3D.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS
	sprite.alpha_cut = SpriteBase3D.ALPHA_CUT_DISCARD
	_visual_root.add_child(sprite)

	var light := OmniLight3D.new()
	light.light_color = Color(1.0, 0.72, 0.22)
	light.light_energy = 0.45
	light.omni_range = 2.2
	light.position = Vector3(0.0, 0.38, 0.0)
	_visual_root.add_child(light)
