extends Area3D
class_name SISChest

const CHEST_TEXTURE: Texture2D = preload("res://assets/images/objects/new-treasure-chest.png")
const OPEN_CHEST_TEXTURE: Texture2D = preload("res://assets/images/objects/new-treasure-chest-open.png")

signal opened(chest: Node3D)

var opened_already := false
var player: Node3D
var _visual_root: Node3D
var _front_sprite: Sprite3D

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	_make_collision()
	_make_visuals()

func configure(target_player: Node3D) -> void:
	player = target_player

func _process(_delta: float) -> void:
	if opened_already or player == null:
		return
	if global_position.distance_to(player.global_position) < 2.1 and Input.is_key_pressed(KEY_E):
		_open()

func _on_body_entered(body: Node3D) -> void:
	if opened_already:
		return
	if body.name == "Player":
		_open()

func _open() -> void:
	opened_already = true
	opened.emit(self)
	if _front_sprite != null:
		_front_sprite.texture = OPEN_CHEST_TEXTURE
		_front_sprite.modulate = Color(1.18, 1.02, 0.75, 1.0)

func _make_collision() -> void:
	var collider := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = Vector3(1.6, 1.1, 1.2)
	collider.shape = shape
	collider.position.y = 0.55
	add_child(collider)

func _make_visuals() -> void:
	_visual_root = Node3D.new()
	add_child(_visual_root)

	_front_sprite = _make_chest_sprite()
	_front_sprite.position = Vector3(0.0, 0.82, 0.0)
	_visual_root.add_child(_front_sprite)

func _make_chest_sprite() -> Sprite3D:
	var sprite: Sprite3D = Sprite3D.new()
	sprite.texture = CHEST_TEXTURE
	sprite.pixel_size = 0.0023
	sprite.shaded = true
	sprite.double_sided = true
	sprite.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	sprite.texture_filter = BaseMaterial3D.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS
	sprite.alpha_cut = SpriteBase3D.ALPHA_CUT_DISCARD
	return sprite

func _material(albedo: Color, emission: Color, emission_energy: float) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	material.albedo_color = albedo
	if emission_energy > 0.0:
		material.emission_enabled = true
		material.emission = emission
		material.emission_energy_multiplier = emission_energy
	return material
