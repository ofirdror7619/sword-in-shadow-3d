extends Area3D
class_name SISDroppedLoot

signal picked_up(loot: Dictionary)

const LootTableScript := preload("res://scripts/LootTable.gd")
const PICKUP_GRACE_SECONDS := 0.45
const DIAMOND_FADED_TEXTURE_PATH := "res://assets/images/objects/diamond-faded.png"
const DIAMOND_WHISPERING_TEXTURE_PATH := "res://assets/images/objects/diamond-whispering.png"
const DIAMOND_CORRUPTED_TEXTURE_PATH := "res://assets/images/objects/diamond-corrupted.png"
const DIAMOND_ABYSSAL_TEXTURE_PATH := "res://assets/images/objects/diamond-abyssal.png"
const DIAMOND_DIVINE_TEXTURE_PATH := "res://assets/images/objects/diamond-divine.png"
const SPELLBOOK_TEXTURE_PATH := "res://assets/images/objects/spellbook.png"
const FALLBACK_DIAMOND_TEXTURE: Texture2D = preload("res://assets/images/objects/diamond.png")

var loot: Dictionary = {}
var _base_y := 0.0
var _pickup_grace := PICKUP_GRACE_SECONDS
var _visual_root: Node3D
var _sprite: Sprite3D
var _light: OmniLight3D

func configure(drop_data: Dictionary) -> void:
	loot = drop_data.duplicate(true)

func _ready() -> void:
	_base_y = position.y
	body_entered.connect(_on_body_entered)
	_make_collision()
	_make_visuals()

func _process(delta: float) -> void:
	_pickup_grace = maxf(_pickup_grace - delta, 0.0)
	var phase := float(abs(hash(String(loot.get("id", loot.get("display_name", ""))))) % 1000) * 0.01
	position.y = _base_y + sin(Time.get_ticks_msec() * 0.006 + phase) * 0.08
	if _visual_root != null:
		_visual_root.rotation.y += delta * 1.6
		_visual_root.position.y = sin(Time.get_ticks_msec() * 0.009 + phase) * 0.035
	if _light != null:
		_light.light_energy = _rarity_light_energy() + sin(Time.get_ticks_msec() * 0.008 + phase) * 0.12
	if _pickup_grace <= 0.0:
		_check_overlapping_pickup()

func _on_body_entered(body: Node3D) -> void:
	if _pickup_grace > 0.0:
		return
	_try_pickup(body)

func _check_overlapping_pickup() -> void:
	for body in get_overlapping_bodies():
		if _try_pickup(body as Node3D):
			return

func _try_pickup(body: Node3D) -> bool:
	if body == null:
		return false
	if body.name == "Player":
		picked_up.emit(loot.duplicate(true))
		queue_free()
		return true
	return false

func _make_collision() -> void:
	var collider := CollisionShape3D.new()
	var shape := SphereShape3D.new()
	shape.radius = 0.82
	collider.shape = shape
	add_child(collider)

func _make_visuals() -> void:
	_visual_root = Node3D.new()
	add_child(_visual_root)

	_sprite = Sprite3D.new()
	_sprite.texture = _loot_texture()
	_sprite.pixel_size = _sprite_pixel_size()
	_sprite.shaded = false
	_sprite.double_sided = true
	_sprite.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	_sprite.texture_filter = BaseMaterial3D.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS
	_sprite.alpha_cut = SpriteBase3D.ALPHA_CUT_DISCARD
	_sprite.modulate = _loot_color()
	_visual_root.add_child(_sprite)

	_light = OmniLight3D.new()
	_light.light_color = _loot_color().lightened(0.22)
	_light.light_energy = _rarity_light_energy()
	_light.omni_range = _rarity_light_range()
	_light.position.y = 0.18
	add_child(_light)

func _loot_texture() -> Texture2D:
	var loot_type := String(loot.get("type", ""))
	if loot_type == LootTableScript.TYPE_SPELL:
		var spellbook_texture := _load_texture_from_path(SPELLBOOK_TEXTURE_PATH)
		if spellbook_texture != null:
			return spellbook_texture
	var image_path := String(loot.get("image", ""))
	var image_texture := _load_texture_from_path(image_path)
	if image_texture != null:
		return image_texture
	if loot_type == LootTableScript.TYPE_DIAMOND:
		var texture_path := _diamond_texture_path(String(loot.get("tier", LootTableScript.TIER_FADED)))
		var diamond_texture := _load_texture_from_path(texture_path)
		if diamond_texture != null:
			return diamond_texture
	return FALLBACK_DIAMOND_TEXTURE

func _load_texture_from_path(path: String) -> Texture2D:
	if path.is_empty():
		return null
	if ResourceLoader.exists(path):
		var texture := load(path) as Texture2D
		if texture != null:
			return texture
	var image := Image.load_from_file(path)
	if image == null:
		return null
	return ImageTexture.create_from_image(image)

func _diamond_texture_path(tier: String) -> String:
	match tier:
		LootTableScript.TIER_WHISPERING:
			return DIAMOND_WHISPERING_TEXTURE_PATH
		LootTableScript.TIER_CORRUPTED:
			return DIAMOND_CORRUPTED_TEXTURE_PATH
		LootTableScript.TIER_ABYSSAL:
			return DIAMOND_ABYSSAL_TEXTURE_PATH
		LootTableScript.TIER_DIVINE:
			return DIAMOND_DIVINE_TEXTURE_PATH
		_:
			return DIAMOND_FADED_TEXTURE_PATH

func _loot_color() -> Color:
	var color_variant: Variant = loot.get("color", _rarity_color())
	if color_variant is Color:
		return color_variant as Color
	return _rarity_color()

func _rarity_color() -> Color:
	match String(loot.get("rarity", "")):
		LootTableScript.TIER_WHISPERING:
			return Color(0.45, 0.95, 1.0, 1.0)
		LootTableScript.TIER_CORRUPTED:
			return Color(0.72, 0.18, 1.0, 1.0)
		LootTableScript.TIER_ABYSSAL:
			return Color(0.35, 0.18, 1.0, 1.0)
		LootTableScript.TIER_DIVINE:
			return Color(1.0, 0.92, 0.55, 1.0)
		"rare":
			return Color(1.0, 0.62, 0.22, 1.0)
		"spell":
			return Color(0.58, 0.82, 1.0, 1.0)
		_:
			return Color(0.86, 0.76, 0.68, 1.0)

func _rarity_light_energy() -> float:
	match String(loot.get("rarity", "")):
		LootTableScript.TIER_DIVINE:
			return 1.75
		LootTableScript.TIER_ABYSSAL:
			return 1.32
		LootTableScript.TIER_CORRUPTED, "spell", "rare":
			return 1.05
		_:
			return 0.68

func _rarity_light_range() -> float:
	match String(loot.get("rarity", "")):
		LootTableScript.TIER_DIVINE:
			return 4.6
		LootTableScript.TIER_ABYSSAL:
			return 3.8
		_:
			return 2.8

func _sprite_pixel_size() -> float:
	match String(loot.get("type", "")):
		LootTableScript.TYPE_SPELL:
			return 0.0032
		LootTableScript.TYPE_RELIC:
			return 0.0028
		_:
			return 0.0036
