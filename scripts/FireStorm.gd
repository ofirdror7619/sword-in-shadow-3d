extends Node3D
class_name SISFireStorm

signal enemy_hit(enemy: Node3D, damage: int)

const FIRESTORM_ART_SIZE := 256

var radius := 5.0
var duration := 3.25
var strikes := 16
var impact_radius := 1.85
var damage := 32

var _rng: RandomNumberGenerator = RandomNumberGenerator.new()
var _elapsed := 0.0
var _strike_timer := 0.0
var _strikes_done := 0
var _enemies: Array[Node3D] = []
var _ground_marker: Node3D
var _fall_texture: Texture2D
var _explosion_texture: Texture2D

func configure(target_position: Vector3, enemies: Array[Node3D], skill_level: int) -> void:
	global_position = target_position
	_enemies = enemies
	damage = 22 + skill_level * 5
	strikes = 14 + skill_level * 2

func _ready() -> void:
	_rng.randomize()
	_fall_texture = _make_falling_fire_texture(FIRESTORM_ART_SIZE)
	_explosion_texture = _make_flame_burst_texture(FIRESTORM_ART_SIZE)
	_make_marker()

func _process(delta: float) -> void:
	_elapsed += delta
	_strike_timer -= delta
	_ground_marker.rotation.y += delta * 1.8
	if _strike_timer <= 0.0 and _strikes_done < strikes:
		_strike_timer = duration / float(strikes)
		_strikes_done += 1
		_spawn_strike()
	if _elapsed >= duration + 0.7:
		queue_free()

func _spawn_strike() -> void:
	var offset := Vector3(_rng.randf_range(-radius, radius), 0.0, _rng.randf_range(-radius, radius))
	if offset.length() > radius:
		offset = offset.normalized() * _rng.randf_range(0.0, radius)
	var impact := global_position + offset

	var start_position: Vector3 = impact + Vector3(_rng.randf_range(-1.6, 1.6), 8.0, _rng.randf_range(-1.6, 1.6))
	var end_position: Vector3 = impact + Vector3(0.0, 1.1, 0.0)
	var fireball: Node3D = _make_fireball()
	fireball.global_position = start_position
	fireball.scale = Vector3.ONE * _rng.randf_range(0.85, 1.15)
	add_child(fireball)

	var tween := create_tween()
	tween.tween_property(fireball, "global_position", end_position, 0.38).set_trans(Tween.TRANS_QUAD)
	tween.parallel().tween_property(fireball, "scale", Vector3.ONE * 1.45, 0.38)
	tween.tween_callback(func() -> void:
		_apply_impact(impact)
		_make_flash(impact)
		_make_impact_smoke(impact)
		_make_ash_splash(impact)
		_make_scorch_splatter(impact)
		fireball.queue_free()
	)

func _apply_impact(impact: Vector3) -> void:
	for enemy in _enemies:
		if is_instance_valid(enemy) and enemy.global_position.distance_to(impact) <= impact_radius:
			enemy_hit.emit(enemy, damage)

func _make_marker() -> void:
	_ground_marker = Node3D.new()
	add_child(_ground_marker)

func _make_flash(impact: Vector3) -> void:
	var flash: MeshInstance3D = MeshInstance3D.new()
	var mesh: SphereMesh = SphereMesh.new()
	mesh.radius = 0.75
	mesh.height = 1.25
	flash.mesh = mesh
	flash.global_position = impact + Vector3(0.0, 0.75, 0.0)
	flash.material_override = _fire_material(Color(1.0, 0.56, 0.05), Color(1.0, 0.95, 0.22), 5.0)
	get_tree().current_scene.add_child(flash)

	var light: OmniLight3D = OmniLight3D.new()
	light.light_color = Color(1.0, 0.48, 0.08)
	light.light_energy = 4.2
	light.omni_range = 6.0
	light.position = Vector3(0.0, 0.25, 0.0)
	flash.add_child(light)

	var tween := flash.create_tween()
	tween.tween_property(flash, "scale", Vector3.ONE * 2.8, 0.22)
	tween.parallel().tween_property(light, "light_energy", 0.0, 0.26)
	tween.tween_callback(Callable(flash, "queue_free"))

	_make_explosion_art(impact)
	_make_glowing_impact_ring(impact)

func _make_explosion_art(impact: Vector3) -> void:
	if _explosion_texture == null:
		return
	var sprite := Sprite3D.new()
	sprite.name = "FireStormExplosionArt"
	sprite.texture = _explosion_texture
	sprite.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	sprite.shaded = false
	sprite.double_sided = true
	sprite.texture_filter = BaseMaterial3D.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS
	sprite.alpha_cut = SpriteBase3D.ALPHA_CUT_DISABLED
	sprite.pixel_size = 0.0095
	sprite.modulate = Color(1.0, 1.0, 1.0, 0.96)
	sprite.global_position = impact + Vector3(0.0, 1.05, 0.0)
	sprite.rotation_degrees.z = _rng.randf_range(0.0, 360.0)
	sprite.scale = Vector3(_rng.randf_range(0.82, 1.02), _rng.randf_range(0.68, 0.86), 1.0)
	sprite.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	get_tree().current_scene.add_child(sprite)

	var tween := sprite.create_tween()
	tween.tween_property(sprite, "scale", Vector3(_rng.randf_range(1.38, 1.7), _rng.randf_range(1.05, 1.32), 1.0), 0.18).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(sprite, "modulate:a", 0.0, 0.34).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tween.tween_callback(Callable(sprite, "queue_free"))

func _make_glowing_impact_ring(impact: Vector3) -> void:
	var ring := MeshInstance3D.new()
	ring.name = "FireStormGoldenImpactRing"
	var mesh := TorusMesh.new()
	mesh.inner_radius = 0.22
	mesh.outer_radius = 0.3
	mesh.ring_segments = 72
	mesh.rings = 6
	ring.mesh = mesh
	ring.global_position = impact + Vector3(0.0, 0.12, 0.0)
	ring.rotation_degrees.x = 90.0
	var material := _fire_material(Color(1.0, 0.66, 0.08, 0.72), Color(1.0, 0.92, 0.18), 4.7)
	ring.material_override = material
	ring.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	get_tree().current_scene.add_child(ring)

	var tween := ring.create_tween()
	tween.tween_property(ring, "scale", Vector3.ONE * _rng.randf_range(4.0, 5.2), 0.24).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(material, "albedo_color:a", 0.0, 0.34)
	tween.tween_callback(Callable(ring, "queue_free"))

func _make_impact_smoke(impact: Vector3) -> void:
	var root: Node3D = Node3D.new()
	get_tree().current_scene.add_child(root)
	root.global_position = impact

	for i in range(12):
		var puff: MeshInstance3D = MeshInstance3D.new()
		var mesh: SphereMesh = SphereMesh.new()
		mesh.radius = _rng.randf_range(0.36, 0.74)
		mesh.height = mesh.radius * 1.45
		puff.mesh = mesh
		puff.position = Vector3(_rng.randf_range(-0.55, 0.55), 0.18, _rng.randf_range(-0.55, 0.55))
		puff.scale = Vector3.ONE * _rng.randf_range(0.9, 1.45)
		var material := _smoke_material(Color(0.055, 0.045, 0.04, _rng.randf_range(0.62, 0.82)))
		puff.material_override = material
		root.add_child(puff)

		var drift := Vector3(_rng.randf_range(-0.85, 0.85), _rng.randf_range(1.0, 1.9), _rng.randf_range(-0.85, 0.85))
		var tween := puff.create_tween()
		tween.tween_property(puff, "position", puff.position + drift, _rng.randf_range(1.0, 1.45)).set_trans(Tween.TRANS_SINE)
		tween.parallel().tween_property(puff, "scale", puff.scale * _rng.randf_range(2.4, 3.5), 1.25)
		tween.parallel().tween_property(material, "albedo_color:a", 0.0, 1.25)
		tween.tween_callback(Callable(puff, "queue_free"))

	var cleanup := root.create_tween()
	cleanup.tween_interval(1.7)
	cleanup.tween_callback(Callable(root, "queue_free"))

func _make_ash_splash(impact: Vector3) -> void:
	var root: Node3D = Node3D.new()
	get_tree().current_scene.add_child(root)
	root.global_position = impact

	for i in range(28):
		var ash: MeshInstance3D = MeshInstance3D.new()
		var mesh: BoxMesh = BoxMesh.new()
		var chip_size := _rng.randf_range(0.07, 0.16)
		mesh.size = Vector3(chip_size, chip_size * 0.55, chip_size)
		ash.mesh = mesh
		ash.position = Vector3(0.0, 0.09, 0.0)
		var hot := _rng.randf() < 0.42
		if hot:
			ash.material_override = _ember_material(Color(1.0, 0.09, 0.02), Color(1.0, 0.18, 0.02), 2.4)
		else:
			ash.material_override = _smoke_material(Color(0.0, 0.0, 0.0, 1.0))
		root.add_child(ash)

		var direction := Vector3(_rng.randf_range(-1.0, 1.0), 0.0, _rng.randf_range(-1.0, 1.0)).normalized()
		var distance := _rng.randf_range(0.65, 2.1)
		var midpoint := direction * distance * 0.55 + Vector3(0.0, _rng.randf_range(0.18, 0.42), 0.0)
		var endpoint := direction * distance + Vector3(0.0, 0.045, 0.0)
		ash.rotation_degrees = Vector3(_rng.randf_range(0.0, 360.0), _rng.randf_range(0.0, 360.0), _rng.randf_range(0.0, 360.0))

		var tween := ash.create_tween()
		tween.tween_property(ash, "position", midpoint, 0.12).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		tween.tween_property(ash, "position", endpoint, 0.28).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
		tween.tween_interval(0.25)
		tween.tween_property(ash, "scale", Vector3.ZERO, 0.28)
		tween.tween_callback(Callable(ash, "queue_free"))

	var cleanup := root.create_tween()
	cleanup.tween_interval(1.0)
	cleanup.tween_callback(Callable(root, "queue_free"))

func _make_scorch_splatter(impact: Vector3) -> void:
	var root: Node3D = Node3D.new()
	root.name = "FireStormPermanentScorch"
	get_tree().current_scene.add_child(root)
	root.global_position = impact

	for i in range(10):
		var mark: MeshInstance3D = MeshInstance3D.new()
		var mesh: CylinderMesh = CylinderMesh.new()
		mesh.top_radius = _rng.randf_range(0.08, 0.18)
		mesh.bottom_radius = mesh.top_radius
		mesh.height = 0.018
		mark.mesh = mesh
		var angle := _rng.randf_range(0.0, TAU)
		var distance := _rng.randf_range(0.15, 1.45)
		mark.position = Vector3(cos(angle) * distance, 0.025, sin(angle) * distance)
		mark.scale = Vector3(_rng.randf_range(1.0, 2.4), 1.0, _rng.randf_range(0.5, 1.2))
		mark.rotation_degrees.y = _rng.randf_range(0.0, 360.0)
		if _rng.randf() < 0.32:
			mark.material_override = _ember_material(Color(0.75, 0.02, 0.01, 0.86), Color(1.0, 0.07, 0.02), 0.8)
		else:
			mark.material_override = _smoke_material(Color(0.0, 0.0, 0.0, 0.88))
		mark.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
		root.add_child(mark)

func _make_fireball() -> Node3D:
	var root: Node3D = Node3D.new()

	var fall_art: Sprite3D = null
	if _fall_texture != null:
		fall_art = Sprite3D.new()
		fall_art.name = "FireStormFallingArt"
		fall_art.texture = _fall_texture
		fall_art.billboard = BaseMaterial3D.BILLBOARD_ENABLED
		fall_art.shaded = false
		fall_art.double_sided = true
		fall_art.texture_filter = BaseMaterial3D.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS
		fall_art.alpha_cut = SpriteBase3D.ALPHA_CUT_DISABLED
		fall_art.pixel_size = 0.0074
		fall_art.modulate = Color(1.0, 1.0, 1.0, 0.94)
		fall_art.rotation_degrees.z = _rng.randf_range(-10.0, 10.0)
		fall_art.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
		root.add_child(fall_art)

	var core: MeshInstance3D = MeshInstance3D.new()
	var core_mesh: SphereMesh = SphereMesh.new()
	core_mesh.radius = 0.42
	core_mesh.height = 0.84
	core.mesh = core_mesh
	core.material_override = _fire_material(Color(1.0, 0.78, 0.08), Color(1.0, 0.92, 0.16), 4.8)
	root.add_child(core)

	var outer: MeshInstance3D = MeshInstance3D.new()
	var outer_mesh: SphereMesh = SphereMesh.new()
	outer_mesh.radius = 0.7
	outer_mesh.height = 1.1
	outer.mesh = outer_mesh
	outer.material_override = _fire_material(Color(1.0, 0.16, 0.02, 0.45), Color(1.0, 0.25, 0.02), 2.4)
	root.add_child(outer)

	for i in range(3):
		var smoke: MeshInstance3D = MeshInstance3D.new()
		var smoke_mesh: SphereMesh = SphereMesh.new()
		smoke_mesh.radius = _rng.randf_range(0.34, 0.52)
		smoke_mesh.height = smoke_mesh.radius * 1.6
		smoke.mesh = smoke_mesh
		smoke.position = Vector3(_rng.randf_range(-0.22, 0.22), _rng.randf_range(-0.1, 0.18), _rng.randf_range(-0.22, 0.22))
		smoke.material_override = _smoke_material(Color(0.018, 0.012, 0.01, 0.38))
		root.add_child(smoke)

	var light: OmniLight3D = OmniLight3D.new()
	light.light_color = Color(1.0, 0.46, 0.08)
	light.light_energy = 3.2
	light.omni_range = 4.5
	root.add_child(light)

	var tween: Tween = root.create_tween()
	tween.set_loops()
	tween.tween_property(outer, "scale", Vector3.ONE * 1.16, 0.08)
	if fall_art != null:
		tween.parallel().tween_property(fall_art, "scale", Vector3.ONE * 1.08, 0.08)
	tween.parallel().tween_property(light, "light_energy", 4.0, 0.08)
	tween.tween_property(outer, "scale", Vector3.ONE * 0.94, 0.08)
	if fall_art != null:
		tween.parallel().tween_property(fall_art, "scale", Vector3.ONE * 0.98, 0.08)
	tween.parallel().tween_property(light, "light_energy", 2.4, 0.08)
	return root

func _make_flame_burst_texture(size: int) -> Texture2D:
	var image := Image.create(size, size, false, Image.FORMAT_RGBA8)
	var center := Vector2(size * 0.5, size * 0.52)
	var max_radius := size * 0.48
	var crack_angles := PackedFloat32Array([
		0.1,
		0.78,
		1.35,
		2.15,
		2.92,
		3.74,
		4.48,
		5.4
	])

	for y in range(size):
		for x in range(size):
			var p := (Vector2(x, y) - center) / max_radius
			p.x *= 1.08
			p.y *= 0.92
			var radius := p.length()
			var angle := atan2(p.y, p.x)
			var jag := sin(angle * 7.0 + 0.35) * 0.085 + sin(angle * 13.0 - 1.2) * 0.045 + sin(angle * 23.0 + 2.4) * 0.025
			var edge := 0.68 + jag + _angular_noise(angle) * 0.11
			var flame_mask := clampf((edge - radius) / 0.12, 0.0, 1.0)
			if radius > edge:
				image.set_pixel(x, y, Color(0, 0, 0, 0))
				continue

			var core := clampf(1.0 - radius / 0.38, 0.0, 1.0)
			var heat := clampf(1.0 - radius / maxf(edge, 0.001), 0.0, 1.0)
			var outer_color := Color(0.72, 0.03, 0.0, 1.0)
			var mid_color := Color(1.0, 0.32, 0.02, 1.0)
			var core_color := Color(1.0, 0.93, 0.22, 1.0)
			var color := outer_color.lerp(mid_color, pow(heat, 0.7)).lerp(core_color, pow(core, 0.75))

			var crack_strength := 0.0
			for crack_angle in crack_angles:
				var angular_distance: float = abs(wrapf(angle - crack_angle, -PI, PI))
				var width := 0.012 + radius * 0.014
				var ray := clampf(1.0 - angular_distance / width, 0.0, 1.0)
				var radial_gate := clampf((radius - 0.12) / 0.22, 0.0, 1.0) * clampf((edge - radius) / 0.18, 0.0, 1.0)
				crack_strength = maxf(crack_strength, ray * radial_gate)
			color = color.lerp(Color(1.0, 0.98, 0.48, 1.0), crack_strength * 0.85)

			var alpha := clampf((flame_mask * 0.92 + core * 0.26 + crack_strength * 0.28), 0.0, 1.0)
			image.set_pixel(x, y, Color(color.r, color.g, color.b, alpha))
	return ImageTexture.create_from_image(image)

func _make_falling_fire_texture(size: int) -> Texture2D:
	var image := Image.create(size, size, false, Image.FORMAT_RGBA8)
	var center := Vector2(size * 0.55, size * 0.56)
	var inv_radius := 1.0 / float(size)
	var angle := deg_to_rad(-43.0)
	var axis := Vector2(cos(angle), sin(angle))
	var side := Vector2(-axis.y, axis.x)

	for y in range(size):
		for x in range(size):
			var p := Vector2(x, y) - center
			var along := p.dot(axis) * inv_radius
			var across := p.dot(side) * inv_radius
			var head := Vector2(along - 0.18, across)
			var head_radius := head.length() / 0.2
			var tail_ratio := clampf((-along + 0.28) / 0.62, 0.0, 1.0)
			var tail_width := 0.035 + tail_ratio * 0.12
			var tail_noise := sin((along - across) * 68.0) * 0.018 + sin((along + across) * 115.0) * 0.012
			var tail := clampf(1.0 - abs(across + tail_noise) / tail_width, 0.0, 1.0) * clampf((0.33 - along) / 0.58, 0.0, 1.0)
			tail *= clampf((along + 0.5) / 0.26, 0.0, 1.0)
			var flame := maxf(clampf(1.0 - head_radius, 0.0, 1.0), pow(tail, 1.35))
			if flame <= 0.01:
				image.set_pixel(x, y, Color(0, 0, 0, 0))
				continue

			var inner := clampf(1.0 - (abs(across) / maxf(tail_width * 0.46, 0.001)) - maxf(along, -0.08) * 0.9, 0.0, 1.0)
			inner = maxf(inner, clampf(1.0 - head_radius / 0.55, 0.0, 1.0))
			var color := Color(0.78, 0.02, 0.0, 1.0).lerp(Color(1.0, 0.28, 0.0, 1.0), flame)
			color = color.lerp(Color(1.0, 0.88, 0.18, 1.0), pow(inner, 0.8))
			var alpha := clampf(flame * 0.96, 0.0, 1.0)
			image.set_pixel(x, y, Color(color.r, color.g, color.b, alpha))
	return ImageTexture.create_from_image(image)

func _angular_noise(angle: float) -> float:
	return sin(angle * 3.0 + 0.7) * 0.45 + sin(angle * 9.0 - 1.1) * 0.35 + sin(angle * 17.0 + 2.6) * 0.2

func _fire_material(albedo: Color, emission: Color, emission_energy: float) -> StandardMaterial3D:
	var material: StandardMaterial3D = StandardMaterial3D.new()
	material.albedo_color = albedo
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	material.blend_mode = BaseMaterial3D.BLEND_MODE_ADD
	material.emission_enabled = true
	material.emission = emission
	material.emission_energy_multiplier = emission_energy
	return material

func _smoke_material(albedo: Color) -> StandardMaterial3D:
	var material: StandardMaterial3D = StandardMaterial3D.new()
	material.albedo_color = albedo
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	material.blend_mode = BaseMaterial3D.BLEND_MODE_MIX
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.roughness = 1.0
	return material

func _ember_material(albedo: Color, emission: Color, emission_energy: float) -> StandardMaterial3D:
	var material: StandardMaterial3D = StandardMaterial3D.new()
	material.albedo_color = albedo
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	material.blend_mode = BaseMaterial3D.BLEND_MODE_ADD
	material.emission_enabled = true
	material.emission = emission
	material.emission_energy_multiplier = emission_energy
	return material

func _material(albedo: Color, emission: Color, emission_energy: float) -> StandardMaterial3D:
	var material: StandardMaterial3D = StandardMaterial3D.new()
	material.albedo_color = albedo
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	material.emission_enabled = true
	material.emission = emission
	material.emission_energy_multiplier = emission_energy
	return material
