extends Node3D
class_name SISFireStorm

signal enemy_hit(enemy: Node3D, damage: int)

var radius := 5.0
var duration := 2.9
var strikes := 18
var damage := 32

var _rng := RandomNumberGenerator.new()
var _elapsed := 0.0
var _strike_timer := 0.0
var _strikes_done := 0
var _enemies: Array[Node3D] = []
var _ground_marker: Node3D

func configure(target_position: Vector3, enemies: Array[Node3D], skill_level: int) -> void:
	global_position = target_position
	_enemies = enemies
	damage = 28 + skill_level * 7
	strikes = 16 + skill_level * 2

func _ready() -> void:
	_rng.randomize()
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
		if is_instance_valid(enemy) and enemy.global_position.distance_to(impact) <= 1.75:
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
	get_tree().current_scene.add_child(flash)

	var tween := flash.create_tween()
	tween.tween_property(flash, "scale", Vector3.ONE * 2.8, 0.22)
	tween.parallel().tween_property(light, "light_energy", 0.0, 0.26)
	tween.tween_callback(Callable(flash, "queue_free"))

func _make_impact_smoke(impact: Vector3) -> void:
	var root := Node3D.new()
	get_tree().current_scene.add_child(root)
	root.global_position = impact

	for i in range(12):
		var puff := MeshInstance3D.new()
		var mesh := SphereMesh.new()
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
	var root := Node3D.new()
	get_tree().current_scene.add_child(root)
	root.global_position = impact

	for i in range(28):
		var ash := MeshInstance3D.new()
		var mesh := BoxMesh.new()
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
	var root := Node3D.new()
	get_tree().current_scene.add_child(root)
	root.global_position = impact

	for i in range(10):
		var mark := MeshInstance3D.new()
		var mesh := CylinderMesh.new()
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
		root.add_child(mark)

		var tween := mark.create_tween()
		tween.tween_interval(_rng.randf_range(0.35, 0.7))
		tween.tween_property(mark, "scale", mark.scale * 0.35, 0.45)
		tween.tween_callback(Callable(mark, "queue_free"))

	var cleanup := root.create_tween()
	cleanup.tween_interval(1.25)
	cleanup.tween_callback(Callable(root, "queue_free"))

func _make_fireball() -> Node3D:
	var root: Node3D = Node3D.new()
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
	tween.parallel().tween_property(light, "light_energy", 4.0, 0.08)
	tween.tween_property(outer, "scale", Vector3.ONE * 0.94, 0.08)
	tween.parallel().tween_property(light, "light_energy", 2.4, 0.08)
	return root

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
	var material := StandardMaterial3D.new()
	material.albedo_color = albedo
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	material.emission_enabled = true
	material.emission = emission
	material.emission_energy_multiplier = emission_energy
	return material
