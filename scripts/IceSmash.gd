extends Node3D
class_name SISIceSmash

signal enemy_hit(enemy: Node3D, damage: int)
signal impact_landed(impact_position: Vector3, impact_radius: float)

const BUILD_TIME := 1.25
const DROP_TIME := 0.34
const CLEANUP_DELAY := 1.45
const WIND_HEIGHT := 7.4
const WIND_RING_COUNT := 5
const WIND_STREAM_COUNT := 9
const WIND_STREAM_SEGMENTS := 5
const WIND_STREAK_COUNT := 22
const SNOW_BIT_COUNT := 52
const IMPACT_SHARD_COUNT := 70
const FROST_CRACK_COUNT := 18
const FROST_PLATE_COUNT := 22
const FROST_EDGE_CHUNK_COUNT := 18
const ORBITING_SHARD_COUNT := 20
const IMPACT_SPIKE_COUNT := 22
const CHUNK_ART_TEXTURE: Texture2D = preload("res://assets/images/spell-art/icesmash-2.png")
const CHUNK_ART_PIXEL_SIZE := 0.0031
const CHUNK_ART_LOCAL_Y := 1.22

var radius := 6.6
var damage := 102

var _rng := RandomNumberGenerator.new()
var _enemies: Array[Node3D] = []
var _elapsed := 0.0
var _impacted := false
var _ground_root: Node3D
var _wind_root: Node3D
var _chunk_root: Node3D
var _ground_frost_patches: Array[Dictionary] = []
var _wind_rings: Array[MeshInstance3D] = []
var _wind_streams: Array[Dictionary] = []
var _wind_streaks: Array[Dictionary] = []
var _snow_bits: Array[Dictionary] = []
var _frost_cracks: Array[Dictionary] = []
var _chunk_orbiters: Array[Dictionary] = []
var _chunk_sprite: Sprite3D
var _chunk_glow_sprite: Sprite3D
var _chunk_light: OmniLight3D

func configure(target_position: Vector3, enemies: Array[Node3D], skill_level: int) -> void:
	position = target_position
	_enemies = enemies
	damage = 84 + skill_level * 18

func _ready() -> void:
	_rng.randomize()
	_make_visuals()
	_start_sequence()

func _process(delta: float) -> void:
	_elapsed += delta
	_animate_ground(delta)
	_animate_wind(delta)
	_animate_chunk(delta)

func _start_sequence() -> void:
	_chunk_root.position.y = WIND_HEIGHT
	_chunk_root.scale = Vector3.ONE * 0.08

	var chunk_final_scale := _chunk_visual_scale()
	var tween := create_tween()
	tween.tween_property(_chunk_root, "scale", chunk_final_scale, BUILD_TIME).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(_chunk_light, "light_energy", 4.2, BUILD_TIME * 0.82)
	tween.tween_property(_chunk_root, "position:y", 1.15, DROP_TIME).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)
	tween.parallel().tween_property(_chunk_root, "scale", chunk_final_scale * 1.06, DROP_TIME)
	tween.tween_callback(Callable(self, "_impact"))
	tween.tween_interval(CLEANUP_DELAY)
	tween.tween_callback(Callable(self, "queue_free"))

func _make_visuals() -> void:
	_make_ground_warning()
	_make_wind()
	_make_chunk()

func _make_ground_warning() -> void:
	_ground_root = Node3D.new()
	_ground_root.name = "IceSmashGroundWarning"
	_ground_root.position.y = 0.035
	add_child(_ground_root)

	for i in range(FROST_PLATE_COUNT):
		var plate := MeshInstance3D.new()
		plate.name = "IceSmashFrozenGroundPlate"
		var mesh := CylinderMesh.new()
		mesh.top_radius = 1.0
		mesh.bottom_radius = 1.0
		mesh.height = _rng.randf_range(0.012, 0.024)
		mesh.radial_segments = _rng.randi_range(5, 8)
		plate.mesh = mesh
		var distance_ratio := pow(_rng.randf_range(0.02, 1.0), 0.55)
		var angle := _rng.randf_range(0.0, TAU)
		var local_position := Vector3(cos(angle), 0.0, sin(angle)) * radius * distance_ratio * _rng.randf_range(0.25, 0.94)
		plate.position = local_position + Vector3(0.0, _rng.randf_range(0.01, 0.035), 0.0)
		var plate_size := radius * _rng.randf_range(0.13, 0.32) * (1.05 - distance_ratio * 0.3)
		plate.scale = Vector3(plate_size * _rng.randf_range(1.0, 1.95), 1.0, plate_size * _rng.randf_range(0.32, 0.88))
		plate.rotation_degrees.y = _rng.randf_range(0.0, 360.0)
		plate.material_override = _frost_material(Color(0.62, 0.94, 1.0, _rng.randf_range(0.1, 0.22)), Color(0.2, 0.72, 1.0), _rng.randf_range(0.75, 1.4), true)
		plate.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
		_ground_root.add_child(plate)
		_ground_frost_patches.append({
			"node": plate,
			"base_scale": plate.scale,
			"phase": _rng.randf_range(0.0, TAU),
			"pulse": _rng.randf_range(0.025, 0.08)
		})

	for i in range(FROST_EDGE_CHUNK_COUNT):
		var angle := float(i) / float(FROST_EDGE_CHUNK_COUNT) * TAU + _rng.randf_range(-0.18, 0.18)
		var distance := radius * _rng.randf_range(0.68, 1.02)
		var chip := _make_ground_frost_chip(Vector3(cos(angle) * distance, 0.0, sin(angle) * distance), angle)
		_ground_root.add_child(chip)
		_ground_frost_patches.append({
			"node": chip,
			"base_scale": chip.scale,
			"phase": _rng.randf_range(0.0, TAU),
			"pulse": _rng.randf_range(0.035, 0.09)
		})

	for i in range(FROST_CRACK_COUNT):
		var angle := float(i) / float(FROST_CRACK_COUNT) * TAU + _rng.randf_range(-0.12, 0.12)
		var length := _rng.randf_range(radius * 0.32, radius * 1.04)
		var start := Vector3(cos(angle), 0.0, sin(angle)) * _rng.randf_range(0.3, 0.85)
		var end := Vector3(cos(angle + _rng.randf_range(-0.18, 0.18)), 0.0, sin(angle + _rng.randf_range(-0.18, 0.18))) * length
		var crack_material := _frost_material(Color(0.58, 0.94, 1.0, 0.0), Color(0.28, 0.78, 1.0), 1.6, true)
		var crack := _make_segment(start + Vector3(0.0, 0.045, 0.0), end + Vector3(0.0, 0.045, 0.0), _rng.randf_range(0.018, 0.035), crack_material, 5)
		crack.name = "IceSmashFrostCrack"
		add_child(crack)
		_frost_cracks.append({
			"node": crack,
			"material": crack_material,
			"alpha": _rng.randf_range(0.42, 0.78),
			"delay": _rng.randf_range(0.0, 0.45)
		})

func _make_wind() -> void:
	_wind_root = Node3D.new()
	_wind_root.name = "IceSmashGatheringWind"
	_wind_root.position.y = WIND_HEIGHT
	add_child(_wind_root)

	for i in range(WIND_RING_COUNT):
		var ring := MeshInstance3D.new()
		var mesh := TorusMesh.new()
		mesh.inner_radius = radius * (0.16 + float(i) * 0.064)
		mesh.outer_radius = mesh.inner_radius + 0.026
		mesh.ring_segments = 96
		mesh.rings = 5
		ring.mesh = mesh
		ring.position.y = -float(i) * 0.28
		ring.scale = Vector3(1.0, 1.0, 0.48 + float(i) * 0.075)
		ring.rotation_degrees = Vector3(_rng.randf_range(-7.0, 7.0), _rng.randf_range(0.0, 360.0), _rng.randf_range(-9.0, 9.0))
		ring.material_override = _frost_material(Color(0.72, 0.98, 1.0, 0.12), Color(0.34, 0.86, 1.0), 1.9, true)
		ring.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
		_wind_root.add_child(ring)
		_wind_rings.append(ring)

	for i in range(WIND_STREAM_COUNT):
		var angle := float(i) / float(WIND_STREAM_COUNT) * TAU + _rng.randf_range(-0.18, 0.18)
		var material := _frost_material(Color(0.78, 0.98, 1.0, _rng.randf_range(0.1, 0.18)), Color(0.46, 0.9, 1.0), 1.35, true)
		var stream := _make_spiral_stream(
			angle,
			radius * _rng.randf_range(0.24, 0.42),
			_rng.randf_range(0.15, 0.55),
			_rng.randf_range(1.7, 2.7),
			_rng.randf_range(0.58, 0.92) * (-1.0 if i % 2 == 0 else 1.0),
			_rng.randf_range(0.026, 0.044),
			material
		)
		_wind_root.add_child(stream)
		_wind_streams.append({
			"node": stream,
			"speed": _rng.randf_range(22.0, 46.0) * (-1.0 if i % 2 == 0 else 1.0),
			"phase": _rng.randf_range(0.0, TAU)
		})

	for i in range(WIND_STREAK_COUNT):
		var streak := MeshInstance3D.new()
		var mesh := BoxMesh.new()
		mesh.size = Vector3(_rng.randf_range(0.026, 0.052), _rng.randf_range(0.025, 0.048), _rng.randf_range(0.34, 0.82))
		streak.mesh = mesh
		streak.material_override = _frost_material(Color(0.7, 0.96, 1.0, _rng.randf_range(0.15, 0.3)), Color(0.36, 0.8, 1.0), 1.45, true)
		streak.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
		_wind_root.add_child(streak)
		_wind_streaks.append({
			"node": streak,
			"angle": _rng.randf_range(0.0, TAU),
			"distance": _rng.randf_range(radius * 0.18, radius * 0.39),
			"height": _rng.randf_range(-1.22, 0.52),
			"speed": _rng.randf_range(1.6, 3.1) * (-1.0 if i % 2 == 0 else 1.0),
			"phase": _rng.randf_range(0.0, TAU),
			"tilt": _rng.randf_range(-24.0, -8.0)
		})

	for i in range(SNOW_BIT_COUNT):
		var bit := MeshInstance3D.new()
		var mesh := SphereMesh.new()
		mesh.radius = _rng.randf_range(0.018, 0.046)
		mesh.height = mesh.radius * 1.45
		mesh.radial_segments = 8
		mesh.rings = 4
		bit.mesh = mesh
		bit.material_override = _ice_material(Color(0.84, 0.98, 1.0, 0.6), Color(0.46, 0.84, 1.0), 1.15, true)
		bit.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
		_wind_root.add_child(bit)
		_snow_bits.append({
			"node": bit,
			"angle": _rng.randf_range(0.0, TAU),
			"distance": _rng.randf_range(radius * 0.05, radius * 0.42),
			"height": _rng.randf_range(-1.6, 0.9),
			"speed": _rng.randf_range(0.8, 2.2),
			"phase": _rng.randf_range(0.0, TAU)
		})

func _make_spiral_stream(base_angle: float, distance: float, top_height: float, height_span: float, twist: float, width: float, material: Material) -> Node3D:
	var stream := Node3D.new()
	stream.name = "IceSmashSpiralFrostStream"
	for i in range(WIND_STREAM_SEGMENTS):
		var t0 := float(i) / float(WIND_STREAM_SEGMENTS)
		var t1 := float(i + 1) / float(WIND_STREAM_SEGMENTS)
		var angle0 := base_angle + twist * t0
		var angle1 := base_angle + twist * (t1 + 0.12)
		var distance0 := distance * (1.08 - t0 * 0.28)
		var distance1 := distance * (1.08 - t1 * 0.28)
		var start := Vector3(cos(angle0) * distance0, top_height - height_span * t0, sin(angle0) * distance0)
		var end := Vector3(cos(angle1) * distance1, top_height - height_span * t1, sin(angle1) * distance1)
		var segment := _make_segment(start, end, width * (1.0 - t0 * 0.35), material, 6)
		segment.name = "IceSmashSpiralFrostSegment"
		stream.add_child(segment)
	return stream

func _make_ground_frost_chip(local_position: Vector3, angle: float) -> MeshInstance3D:
	var chip := MeshInstance3D.new()
	chip.name = "IceSmashFrozenGroundEdge"
	var mesh := BoxMesh.new()
	mesh.size = Vector3(_rng.randf_range(0.32, 0.78), _rng.randf_range(0.018, 0.042), _rng.randf_range(0.7, 1.65))
	chip.mesh = mesh
	chip.position = local_position + Vector3(0.0, _rng.randf_range(0.03, 0.075), 0.0)
	chip.rotation_degrees = Vector3(_rng.randf_range(-4.0, 4.0), rad_to_deg(angle) + _rng.randf_range(-38.0, 38.0), _rng.randf_range(-5.0, 5.0))
	chip.scale = Vector3.ONE * _rng.randf_range(0.75, 1.45)
	chip.material_override = _ice_material(Color(0.72, 0.96, 1.0, _rng.randf_range(0.24, 0.46)), Color(0.34, 0.82, 1.0), 1.3, true)
	chip.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	return chip

func _make_chunk() -> void:
	_chunk_root = Node3D.new()
	_chunk_root.name = "IceSmashJaggedBlock"
	add_child(_chunk_root)

	_chunk_glow_sprite = _make_chunk_sprite("IceSmashMainSpriteGlow", Color(0.35, 0.82, 1.0, 0.24), 1.13)
	_chunk_root.add_child(_chunk_glow_sprite)

	_chunk_sprite = _make_chunk_sprite("IceSmashMainSprite", Color(0.84, 0.96, 1.0, 0.96), 1.0)
	_chunk_root.add_child(_chunk_sprite)

	for i in range(ORBITING_SHARD_COUNT):
		var orbiter := MeshInstance3D.new()
		var mesh := BoxMesh.new()
		mesh.size = Vector3(_rng.randf_range(0.08, 0.18), _rng.randf_range(0.08, 0.16), _rng.randf_range(0.34, 0.74))
		orbiter.mesh = mesh
		orbiter.material_override = _ice_material(Color(0.88, 1.0, 1.0, 0.64), Color(0.55, 0.92, 1.0), 2.4, true)
		orbiter.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
		_chunk_root.add_child(orbiter)
		_chunk_orbiters.append({
			"node": orbiter,
			"angle": _rng.randf_range(0.0, TAU),
			"distance": _rng.randf_range(1.7, 2.65),
			"height": _rng.randf_range(-0.85, 0.9),
			"speed": _rng.randf_range(1.3, 3.0) * (-1.0 if i % 2 == 0 else 1.0)
		})

	_chunk_light = OmniLight3D.new()
	_chunk_light.name = "IceSmashColdLight"
	_chunk_light.light_color = Color(0.42, 0.84, 1.0)
	_chunk_light.light_energy = 0.15
	_chunk_light.omni_range = 9.5
	_chunk_root.add_child(_chunk_light)

func _make_chunk_sprite(sprite_name: String, tint: Color, sprite_scale: float) -> Sprite3D:
	var sprite := Sprite3D.new()
	sprite.name = sprite_name
	sprite.texture = CHUNK_ART_TEXTURE
	sprite.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	sprite.pixel_size = CHUNK_ART_PIXEL_SIZE
	sprite.shaded = false
	sprite.double_sided = true
	sprite.texture_filter = BaseMaterial3D.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS
	sprite.alpha_cut = SpriteBase3D.ALPHA_CUT_DISABLED
	sprite.modulate = tint
	sprite.position = Vector3(0.0, CHUNK_ART_LOCAL_Y, 0.0)
	sprite.scale = Vector3.ONE * sprite_scale
	sprite.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	return sprite

func _make_ice_spike(length: float, width: float, direction: Vector3) -> MeshInstance3D:
	var spike := MeshInstance3D.new()
	var mesh := CylinderMesh.new()
	mesh.top_radius = 0.015
	mesh.bottom_radius = width
	mesh.height = length
	mesh.radial_segments = 5
	spike.mesh = mesh
	spike.position = direction * (1.08 + length * 0.42)
	_orient_y_to_direction(spike, direction)
	spike.rotation_degrees.y += _rng.randf_range(-28.0, 28.0)
	spike.material_override = _ice_material(Color(0.7, 0.94, 1.0, 0.82), Color(0.28, 0.76, 1.0), 1.4, true)
	spike.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_ON
	return spike

func _impact() -> void:
	if _impacted:
		return
	_impacted = true
	_apply_impact_damage()
	impact_landed.emit(global_position, radius)
	_make_impact_flash()
	_make_shockwave()
	_make_impact_spikes()
	_make_aftershock_cracks()
	_make_ice_burst()
	_make_frost_cloud()
	_chunk_root.visible = false

func _apply_impact_damage() -> void:
	for enemy in _enemies:
		if not is_instance_valid(enemy):
			continue
		if enemy.global_position.distance_to(global_position) <= radius:
			enemy_hit.emit(enemy, damage)

func _make_impact_flash() -> void:
	var light := OmniLight3D.new()
	light.name = "IceSmashImpactLight"
	light.light_color = Color(0.58, 0.9, 1.0)
	light.light_energy = 8.0
	light.omni_range = radius * 1.7
	_add_fx_node(light, global_position + Vector3(0.0, 1.2, 0.0))

	var tween := light.create_tween()
	tween.tween_property(light, "light_energy", 0.0, 0.55)
	tween.tween_callback(Callable(light, "queue_free"))

func _make_shockwave() -> void:
	var shock := MeshInstance3D.new()
	var mesh := CylinderMesh.new()
	mesh.top_radius = 1.0
	mesh.bottom_radius = 1.0
	mesh.height = 0.035
	mesh.radial_segments = 96
	shock.mesh = mesh
	var material := _frost_material(Color(0.7, 0.96, 1.0, 0.42), Color(0.35, 0.84, 1.0), 3.0, true)
	shock.material_override = material
	shock.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	_add_fx_node(shock, global_position + Vector3(0.0, 0.055, 0.0))

	var tween := shock.create_tween()
	tween.tween_property(shock, "scale", Vector3(radius, 1.0, radius), 0.34).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(material, "albedo_color:a", 0.0, 0.46)
	tween.tween_callback(Callable(shock, "queue_free"))

	var ring := MeshInstance3D.new()
	var ring_mesh := TorusMesh.new()
	ring_mesh.inner_radius = 0.74
	ring_mesh.outer_radius = 0.8
	ring_mesh.ring_segments = 96
	ring_mesh.rings = 8
	ring.mesh = ring_mesh
	var ring_material := _frost_material(Color(0.95, 1.0, 1.0, 0.66), Color(0.62, 0.94, 1.0), 4.5, true)
	ring.material_override = ring_material
	ring.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	_add_fx_node(ring, global_position + Vector3(0.0, 0.09, 0.0))
	var ring_tween := ring.create_tween()
	ring_tween.tween_property(ring, "scale", Vector3(radius * 1.08, 1.0, radius * 1.08), 0.28).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	ring_tween.parallel().tween_property(ring_material, "albedo_color:a", 0.0, 0.38)
	ring_tween.tween_callback(Callable(ring, "queue_free"))

func _make_impact_spikes() -> void:
	var root := Node3D.new()
	root.name = "IceSmashGroundSpikes"
	_add_fx_node(root, global_position)

	for i in range(IMPACT_SPIKE_COUNT):
		var angle := float(i) / float(IMPACT_SPIKE_COUNT) * TAU + _rng.randf_range(-0.11, 0.11)
		var distance := _rng.randf_range(radius * 0.18, radius * 0.74)
		var direction := Vector3(cos(angle), _rng.randf_range(0.55, 0.9), sin(angle)).normalized()
		var spike := _make_ice_spike(_rng.randf_range(0.45, 1.35), _rng.randf_range(0.08, 0.24), direction)
		spike.position = Vector3(cos(angle) * distance, 0.08, sin(angle) * distance)
		spike.scale = Vector3(0.08, 0.08, 0.08)
		root.add_child(spike)

		var final_scale := Vector3.ONE * _rng.randf_range(0.78, 1.35)
		var tween := spike.create_tween()
		tween.tween_property(spike, "scale", final_scale, 0.16).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		tween.tween_interval(_rng.randf_range(0.45, 0.82))
		tween.tween_property(spike, "scale", Vector3.ZERO, 0.22)
		tween.tween_callback(Callable(spike, "queue_free"))

	var cleanup := root.create_tween()
	cleanup.tween_interval(1.25)
	cleanup.tween_callback(Callable(root, "queue_free"))

func _make_aftershock_cracks() -> void:
	var root := Node3D.new()
	root.name = "IceSmashAftershockCracks"
	_add_fx_node(root, global_position)

	for i in range(16):
		var angle := _rng.randf_range(0.0, TAU)
		var length := _rng.randf_range(radius * 0.34, radius * 0.98)
		var start := Vector3(cos(angle), 0.0, sin(angle)) * _rng.randf_range(0.35, 1.25)
		var end := Vector3(cos(angle + _rng.randf_range(-0.2, 0.2)), 0.0, sin(angle + _rng.randf_range(-0.2, 0.2))) * length
		var material := _frost_material(Color(0.9, 1.0, 1.0, 0.68), Color(0.5, 0.9, 1.0), 3.0, true)
		var crack := _make_segment(start + Vector3(0.0, 0.055, 0.0), end + Vector3(0.0, 0.055, 0.0), _rng.randf_range(0.014, 0.032), material, 5)
		root.add_child(crack)

		var tween := crack.create_tween()
		tween.tween_interval(_rng.randf_range(0.18, 0.5))
		tween.tween_property(material, "albedo_color:a", 0.0, 0.55)
		tween.tween_callback(Callable(crack, "queue_free"))

	var cleanup := root.create_tween()
	cleanup.tween_interval(1.15)
	cleanup.tween_callback(Callable(root, "queue_free"))

func _make_ice_burst() -> void:
	var root := Node3D.new()
	root.name = "IceSmashBurst"
	_add_fx_node(root, global_position + Vector3(0.0, 0.2, 0.0))

	for i in range(IMPACT_SHARD_COUNT):
		var shard := MeshInstance3D.new()
		var mesh := BoxMesh.new()
		mesh.size = Vector3(_rng.randf_range(0.08, 0.24), _rng.randf_range(0.08, 0.2), _rng.randf_range(0.32, 0.95))
		shard.mesh = mesh
		shard.material_override = _ice_material(Color(0.76, 0.95, 1.0, 0.86), Color(0.3, 0.78, 1.0), 1.4, true)
		shard.rotation_degrees = Vector3(_rng.randf_range(0.0, 360.0), _rng.randf_range(0.0, 360.0), _rng.randf_range(0.0, 360.0))
		root.add_child(shard)

		var angle := _rng.randf_range(0.0, TAU)
		var direction := Vector3(cos(angle), _rng.randf_range(0.12, 0.58), sin(angle)).normalized()
		var distance := _rng.randf_range(radius * 0.22, radius * 0.92)
		var midpoint := direction * distance * 0.45 + Vector3(0.0, _rng.randf_range(0.45, 1.4), 0.0)
		var endpoint := Vector3(direction.x * distance, 0.05, direction.z * distance)

		var tween := shard.create_tween()
		tween.tween_property(shard, "position", midpoint, 0.14).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		tween.tween_property(shard, "position", endpoint, 0.34).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
		tween.parallel().tween_property(shard, "rotation_degrees", shard.rotation_degrees + Vector3(_rng.randf_range(120.0, 340.0), _rng.randf_range(120.0, 360.0), _rng.randf_range(120.0, 360.0)), 0.48)
		tween.tween_interval(0.25)
		tween.tween_property(shard, "scale", Vector3.ZERO, 0.26)
		tween.tween_callback(Callable(shard, "queue_free"))

	var cleanup := root.create_tween()
	cleanup.tween_interval(1.3)
	cleanup.tween_callback(Callable(root, "queue_free"))

func _make_frost_cloud() -> void:
	var root := Node3D.new()
	root.name = "IceSmashFrostCloud"
	_add_fx_node(root, global_position)

	for i in range(18):
		var puff := MeshInstance3D.new()
		var mesh := SphereMesh.new()
		mesh.radius = _rng.randf_range(0.32, 0.72)
		mesh.height = mesh.radius * 1.35
		mesh.radial_segments = 10
		mesh.rings = 5
		puff.mesh = mesh
		puff.position = Vector3(_rng.randf_range(-0.6, 0.6), 0.25, _rng.randf_range(-0.6, 0.6))
		var material := _frost_material(Color(0.78, 0.96, 1.0, _rng.randf_range(0.22, 0.42)), Color(0.34, 0.74, 1.0), 0.55, false)
		puff.material_override = material
		puff.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
		root.add_child(puff)

		var drift := Vector3(_rng.randf_range(-1.2, 1.2), _rng.randf_range(0.8, 1.8), _rng.randf_range(-1.2, 1.2))
		var tween := puff.create_tween()
		tween.tween_property(puff, "position", puff.position + drift, _rng.randf_range(0.9, 1.35)).set_trans(Tween.TRANS_SINE)
		tween.parallel().tween_property(puff, "scale", puff.scale * _rng.randf_range(2.4, 3.8), 1.1)
		tween.parallel().tween_property(material, "albedo_color:a", 0.0, 1.05)
		tween.tween_callback(Callable(puff, "queue_free"))

	var cleanup := root.create_tween()
	cleanup.tween_interval(1.55)
	cleanup.tween_callback(Callable(root, "queue_free"))

func _animate_ground(delta: float) -> void:
	if _ground_root == null:
		return
	_ground_root.rotation_degrees.y += delta * 6.0
	for patch_data in _ground_frost_patches:
		var patch := patch_data["node"] as MeshInstance3D
		if patch == null:
			continue
		var base_scale: Vector3 = patch_data["base_scale"]
		var pulse := 1.0 + sin(_elapsed * 5.4 + float(patch_data["phase"])) * float(patch_data["pulse"])
		patch.scale = base_scale * pulse
	var build_ratio := clampf(_elapsed / BUILD_TIME, 0.0, 1.0)
	for crack_data in _frost_cracks:
		var crack := crack_data["node"] as MeshInstance3D
		var material := crack_data["material"] as StandardMaterial3D
		if crack == null or material == null:
			continue
		var delay := float(crack_data["delay"])
		var crack_ratio := clampf((_elapsed - delay) / 0.42, 0.0, 1.0)
		crack.scale = Vector3.ONE * (0.15 + crack_ratio * 0.85)
		material.albedo_color.a = float(crack_data["alpha"]) * crack_ratio * (0.65 + build_ratio * 0.35)
		material.emission_energy_multiplier = 1.3 + crack_ratio * 2.6

func _animate_wind(delta: float) -> void:
	if _wind_root == null:
		return
	_wind_root.rotation_degrees.y -= delta * 80.0
	for i in range(_wind_rings.size()):
		var ring := _wind_rings[i]
		if ring != null:
			ring.rotation_degrees.y += delta * (95.0 + float(i) * 28.0)
			ring.rotation_degrees.z += delta * (8.0 + float(i) * 5.0)
	for data in _wind_streams:
		var stream := data["node"] as Node3D
		if stream == null:
			continue
		stream.rotation_degrees.y += delta * float(data["speed"])
		var stream_pulse := 0.9 + sin(_elapsed * 4.4 + float(data["phase"])) * 0.075
		stream.scale = Vector3.ONE * stream_pulse
	for data in _wind_streaks:
		var streak := data["node"] as MeshInstance3D
		if streak == null:
			continue
		var angle := float(data["angle"]) + delta * float(data["speed"])
		data["angle"] = angle
		var distance := float(data["distance"])
		var bob := sin(_elapsed * 7.0 + float(data["phase"])) * 0.16
		streak.position = Vector3(cos(angle) * distance, float(data["height"]) + bob, sin(angle) * distance)
		streak.rotation_degrees = Vector3(float(data["tilt"]), -rad_to_deg(angle) + 90.0, 0.0)
		streak.scale = Vector3.ONE * (0.82 + sin(_elapsed * 6.0 + float(data["phase"])) * 0.12)
	for data in _snow_bits:
		var bit := data["node"] as MeshInstance3D
		if bit == null:
			continue
		var angle := float(data["angle"]) + delta * float(data["speed"])
		data["angle"] = angle
		var distance := float(data["distance"]) * (1.0 - clampf(_elapsed / BUILD_TIME, 0.0, 1.0) * 0.35)
		var sink := -fmod(_elapsed * 0.55 + float(data["phase"]), 1.8)
		bit.position = Vector3(cos(angle) * distance, float(data["height"]) + sink, sin(angle) * distance)

func _animate_chunk(delta: float) -> void:
	if _chunk_root == null or _impacted:
		return
	_chunk_root.rotation_degrees.y += delta * (52.0 + clampf(_elapsed / BUILD_TIME, 0.0, 1.0) * 58.0)
	_chunk_root.rotation_degrees.x = sin(_elapsed * 3.2) * 4.5
	_chunk_root.rotation_degrees.z = cos(_elapsed * 2.7) * 3.8
	if _chunk_light != null:
		_chunk_light.light_energy += sin(_elapsed * 16.0) * 0.035
	if _chunk_sprite != null:
		var sprite_color := _chunk_sprite.modulate
		sprite_color.a = 0.91 + sin(_elapsed * 10.0) * 0.045
		_chunk_sprite.modulate = sprite_color
	if _chunk_glow_sprite != null:
		var glow_color := _chunk_glow_sprite.modulate
		glow_color.a = 0.18 + sin(_elapsed * 8.5) * 0.055
		_chunk_glow_sprite.modulate = glow_color
		_chunk_glow_sprite.scale = Vector3.ONE * (1.11 + sin(_elapsed * 6.2) * 0.035)
	for data in _chunk_orbiters:
		var orbiter := data["node"] as MeshInstance3D
		if orbiter == null:
			continue
		var angle := float(data["angle"]) + delta * float(data["speed"])
		data["angle"] = angle
		var distance := float(data["distance"])
		orbiter.position = Vector3(cos(angle) * distance, float(data["height"]) + sin(_elapsed * 4.0 + angle) * 0.18, sin(angle) * distance)
		orbiter.rotation_degrees += Vector3(delta * 180.0, delta * 260.0, delta * 210.0)

func _make_segment(start: Vector3, end: Vector3, width: float, material: Material, sides: int = 8) -> MeshInstance3D:
	var direction := end - start
	var length := direction.length()
	var segment := MeshInstance3D.new()
	var mesh := CylinderMesh.new()
	mesh.top_radius = width
	mesh.bottom_radius = width
	mesh.height = maxf(length, 0.01)
	mesh.radial_segments = sides
	segment.mesh = mesh
	segment.material_override = material
	segment.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	if length <= 0.01:
		segment.position = start
		return segment
	direction /= length
	var axis := Vector3.UP.cross(direction)
	var basis := Basis.IDENTITY
	if axis.length_squared() > 0.0001:
		basis = Basis(axis.normalized(), Vector3.UP.angle_to(direction))
	elif direction.dot(Vector3.UP) < 0.0:
		basis = Basis(Vector3.RIGHT, PI)
	segment.transform = Transform3D(basis, start.lerp(end, 0.5))
	return segment

func _chunk_visual_scale() -> Vector3:
	var scale_factor := maxf(radius / 2.35, 1.0)
	return Vector3(scale_factor * 1.18, scale_factor * 0.82, scale_factor * 1.08)

func _orient_y_to_direction(node: Node3D, direction: Vector3) -> void:
	var dir := direction.normalized()
	var axis := Vector3.UP.cross(dir)
	var basis := Basis.IDENTITY
	if axis.length_squared() > 0.0001:
		basis = Basis(axis.normalized(), Vector3.UP.angle_to(dir))
	elif dir.dot(Vector3.UP) < 0.0:
		basis = Basis(Vector3.RIGHT, PI)
	node.transform.basis = basis

func _add_fx_node(node: Node3D, target_position: Vector3) -> void:
	var parent := get_tree().current_scene
	if parent == null:
		parent = get_parent()
	if parent == null:
		parent = self
	parent.add_child(node)
	node.global_position = target_position

func _ice_material(albedo: Color, emission: Color, emission_energy: float, translucent: bool) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	material.albedo_color = albedo
	if translucent or albedo.a < 1.0:
		material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		material.blend_mode = BaseMaterial3D.BLEND_MODE_MIX
	material.roughness = 0.18
	material.metallic = 0.0
	material.emission_enabled = true
	material.emission = emission
	material.emission_energy_multiplier = emission_energy
	return material

func _frost_material(albedo: Color, emission: Color, emission_energy: float, additive: bool) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	material.albedo_color = albedo
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	material.blend_mode = BaseMaterial3D.BLEND_MODE_ADD if additive else BaseMaterial3D.BLEND_MODE_MIX
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.cull_mode = BaseMaterial3D.CULL_DISABLED
	material.emission_enabled = true
	material.emission = emission
	material.emission_energy_multiplier = emission_energy
	return material
