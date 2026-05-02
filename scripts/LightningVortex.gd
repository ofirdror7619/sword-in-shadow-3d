extends Area3D
class_name SISLightningVortex

signal enemy_hit(enemy: Node3D, damage: int)

const ATTACK_SOUND: AudioStream = preload("res://assets/audio/sounds/electricity-vortex-attack.mp3")
const LIFETIME := 1.65
const STRIKE_RADIUS := 1.35
const STRIKE_HEIGHT := 3.0
const VORTEX_HEIGHT := 2.85
const STRIKE_INTERVAL := 0.36
const STRIKE_DAMAGE_MULTIPLIER := 0.22
const BRANCH_LIFETIME := 0.2
const GROUND_GLOW_RADIUS := 1.55

var damage := 12
var hostile_to_player := true
var _life := LIFETIME
var _strike_timer := 0.18
var _enemies: Array[Node3D] = []
var _visual_root: Node3D
var _ground_root: Node3D
var _rings: Array[MeshInstance3D] = []
var _ground_rings: Array[MeshInstance3D] = []
var _storm_shards: Array[MeshInstance3D] = []
var _branches: Array[Dictionary] = []
var _light: OmniLight3D
var _ground_light: OmniLight3D

func _ready() -> void:
	_make_collision()
	_make_visuals()
	_play_attack_sound()

func configure(
	target_position: Vector3,
	_direction: Vector3 = Vector3.ZERO,
	_speed: float = 0.0,
	damage_amount: int = 12,
	should_hit_player: bool = true,
	enemies: Array[Node3D] = []
) -> void:
	position = target_position
	damage = max(1, damage_amount)
	hostile_to_player = should_hit_player
	_enemies = enemies

func _physics_process(delta: float) -> void:
	_life -= delta
	if _life <= 0.0:
		queue_free()
		return

	_strike_timer -= delta
	if _strike_timer <= 0.0:
		_strike_timer = STRIKE_INTERVAL
		_strike()

	_animate_visuals(delta)
	_animate_branches(delta)

func _make_collision() -> void:
	var collision: CollisionShape3D = CollisionShape3D.new()
	var shape: CylinderShape3D = CylinderShape3D.new()
	shape.radius = STRIKE_RADIUS
	shape.height = STRIKE_HEIGHT
	collision.shape = shape
	collision.position.y = STRIKE_HEIGHT * 0.5
	add_child(collision)

func _make_visuals() -> void:
	_ground_root = Node3D.new()
	_ground_root.name = "ElectricityVortexGroundGlow"
	_ground_root.position.y = 0.025
	add_child(_ground_root)

	var warning_disc := MeshInstance3D.new()
	warning_disc.name = "WarningDisc"
	var warning_mesh := CylinderMesh.new()
	warning_mesh.top_radius = GROUND_GLOW_RADIUS
	warning_mesh.bottom_radius = GROUND_GLOW_RADIUS
	warning_mesh.height = 0.012
	warning_mesh.radial_segments = 48
	warning_disc.mesh = warning_mesh
	warning_disc.scale = Vector3(1.0, 1.0, 0.78)
	warning_disc.material_override = _vortex_material(Color(0.12, 0.72, 1.0, 0.12), Color(0.08, 0.62, 1.0), 0.9)
	warning_disc.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	_ground_root.add_child(warning_disc)

	for i in range(3):
		var ground_ring := MeshInstance3D.new()
		ground_ring.name = "GroundArc"
		var ground_mesh := TorusMesh.new()
		ground_mesh.inner_radius = 0.72 + float(i) * 0.22
		ground_mesh.outer_radius = 0.75 + float(i) * 0.22
		ground_mesh.ring_segments = 54
		ground_mesh.rings = 6
		ground_ring.mesh = ground_mesh
		ground_ring.rotation_degrees = Vector3(0.0, float(i) * 31.0, 0.0)
		ground_ring.material_override = _vortex_material(Color(0.38, 0.9, 1.0, 0.26), Color(0.2, 0.72, 1.0), 2.4)
		ground_ring.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
		_ground_root.add_child(ground_ring)
		_ground_rings.append(ground_ring)

	_visual_root = Node3D.new()
	_visual_root.position.y = VORTEX_HEIGHT
	add_child(_visual_root)

	var core := MeshInstance3D.new()
	var core_mesh := SphereMesh.new()
	core_mesh.radius = 0.12
	core_mesh.height = 0.18
	core.mesh = core_mesh
	core.material_override = _vortex_material(Color(0.58, 0.95, 1.0, 0.82), Color(0.35, 0.88, 1.0), 4.2)
	core.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	_visual_root.add_child(core)

	for i in range(4):
		var ring := MeshInstance3D.new()
		var mesh := TorusMesh.new()
		mesh.inner_radius = 0.38 + float(i) * 0.14
		mesh.outer_radius = 0.42 + float(i) * 0.14
		mesh.ring_segments = 64
		mesh.rings = 8
		ring.mesh = mesh
		ring.position.y = -float(i) * 0.065
		ring.rotation_degrees = Vector3(-18.0 + float(i) * 11.0, float(i) * 27.0, float(i) * 41.0)
		ring.material_override = _vortex_material(Color(0.52, 0.9, 1.0, 0.34), Color(0.32, 0.76, 1.0), 4.4)
		ring.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
		_visual_root.add_child(ring)
		_rings.append(ring)

	for i in range(10):
		var shard := MeshInstance3D.new()
		shard.name = "ElectricShard"
		var shard_mesh := BoxMesh.new()
		shard_mesh.size = Vector3(randf_range(0.18, 0.46), 0.024, 0.024)
		shard.mesh = shard_mesh
		var angle := float(i) / 10.0 * TAU
		var radius := 0.32 + float(i % 4) * 0.16
		shard.position = Vector3(cos(angle) * radius, randf_range(-0.34, 0.22), sin(angle) * radius)
		shard.rotation_degrees = Vector3(randf_range(-18.0, 18.0), rad_to_deg(angle), randf_range(-35.0, 35.0))
		shard.material_override = _vortex_material(Color(0.76, 0.98, 1.0, 0.6), Color(0.42, 0.9, 1.0), 3.2)
		shard.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
		_visual_root.add_child(shard)
		_storm_shards.append(shard)

	_light = OmniLight3D.new()
	_light.light_color = Color(0.45, 0.85, 1.0)
	_light.light_energy = 2.7
	_light.omni_range = 5.8
	_light.position.y = VORTEX_HEIGHT * 0.72
	add_child(_light)

	_ground_light = OmniLight3D.new()
	_ground_light.light_color = Color(0.18, 0.72, 1.0)
	_ground_light.light_energy = 0.8
	_ground_light.omni_range = 3.2
	_ground_light.position.y = 0.22
	add_child(_ground_light)

func _strike() -> void:
	var root := Node3D.new()
	root.name = "ElectricityVortexStrike"
	add_child(root)

	var material := _vortex_material(Color(0.64, 0.95, 1.0, 0.95), Color(0.42, 0.82, 1.0), 5.8)
	var core_material := _vortex_material(Color(0.92, 1.0, 1.0, 0.96), Color(0.72, 0.96, 1.0), 7.2)
	var top_center := global_position + Vector3(0.0, VORTEX_HEIGHT, 0.0)
	var target := global_position + Vector3(randf_range(-0.22, 0.22), 0.15, randf_range(-0.22, 0.22))
	_add_jagged_branch(root, top_center, target, 0.058, core_material, 7, 0.12)

	for i in range(8):
		var angle := randf() * TAU
		var top_offset := Vector3(cos(angle), 0.0, sin(angle)) * randf_range(0.24, 0.92)
		var ground_offset := Vector3(randf_range(-STRIKE_RADIUS, STRIKE_RADIUS), 0.0, randf_range(-STRIKE_RADIUS, STRIKE_RADIUS))
		if ground_offset.length() > STRIKE_RADIUS:
			ground_offset = ground_offset.normalized() * STRIKE_RADIUS
		var start := top_center + top_offset + Vector3(0.0, randf_range(-0.12, 0.12), 0.0)
		var end := global_position + ground_offset + Vector3(0.0, randf_range(0.08, 0.5), 0.0)
		_add_jagged_branch(root, start, end, 0.02, material, 5, 0.22)
		if i % 2 == 0:
			var fork_end := end + Vector3(randf_range(-0.55, 0.55), randf_range(0.18, 0.56), randf_range(-0.55, 0.55))
			_add_jagged_branch(root, start.lerp(end, randf_range(0.45, 0.7)), fork_end, 0.012, material, 3, 0.12)

	var flash := OmniLight3D.new()
	flash.name = "ElectricityVortexFlash"
	flash.light_color = Color(0.55, 0.88, 1.0)
	flash.light_energy = 5.0
	flash.omni_range = 4.8
	flash.global_position = top_center
	root.add_child(flash)

	_branches.append({
		"node": root,
		"material": material,
		"core_material": core_material,
		"light": flash,
		"life": BRANCH_LIFETIME,
		"max_life": BRANCH_LIFETIME
	})
	_damage_targets()

func _add_jagged_branch(parent: Node3D, start: Vector3, end: Vector3, radius: float, material: Material, segments: int = 4, jitter_amount: float = 0.18) -> void:
	var previous := start
	for i in range(1, segments + 1):
		var progress := float(i) / float(segments)
		var point := start.lerp(end, progress)
		var jitter := jitter_amount * (1.0 - progress * 0.35)
		point += Vector3(randf_range(-jitter, jitter), randf_range(-0.1, 0.1), randf_range(-jitter, jitter))
		_add_branch_segment(parent, previous, point, radius, material)
		previous = point

func _add_branch_segment(parent: Node3D, start: Vector3, end: Vector3, radius: float, material: Material) -> void:
	var direction := end - start
	var length := direction.length()
	if length <= 0.01:
		return
	direction /= length

	var segment := MeshInstance3D.new()
	var mesh := CylinderMesh.new()
	mesh.top_radius = radius
	mesh.bottom_radius = radius
	mesh.height = length
	mesh.radial_segments = 8
	segment.mesh = mesh
	segment.material_override = material
	segment.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	parent.add_child(segment)

	var axis := Vector3.UP.cross(direction)
	var basis := Basis.IDENTITY
	if axis.length_squared() > 0.0001:
		basis = Basis(axis.normalized(), Vector3.UP.angle_to(direction))
	elif direction.dot(Vector3.UP) < 0.0:
		basis = Basis(Vector3.RIGHT, PI)
	segment.global_transform = Transform3D(basis, start.lerp(end, 0.5))

func _damage_targets() -> void:
	var strike_damage: int = max(1, int(round(float(damage) * STRIKE_DAMAGE_MULTIPLIER)))
	if not hostile_to_player:
		for enemy in _enemies:
			if is_instance_valid(enemy) and enemy.global_position.distance_to(global_position) <= STRIKE_RADIUS:
				enemy_hit.emit(enemy, strike_damage)
		return
	for body in get_overlapping_bodies():
		var target := body as Node3D
		if target == null or target.name != "Player":
			continue
		if target.has_method("take_damage"):
			target.take_damage(strike_damage)

func _animate_visuals(delta: float) -> void:
	var elapsed := LIFETIME - _life
	var build_ratio := clampf(elapsed / 0.32, 0.0, 1.0)
	if _ground_root != null:
		_ground_root.rotation_degrees.y -= delta * 120.0
		_ground_root.scale = Vector3.ONE * (0.82 + build_ratio * 0.18)
	for i in range(_ground_rings.size()):
		var ground_ring := _ground_rings[i]
		if ground_ring != null:
			ground_ring.rotation_degrees.y += delta * (95.0 + float(i) * 32.0)
	if _visual_root != null:
		_visual_root.rotation_degrees.y += delta * (430.0 + build_ratio * 120.0)
		_visual_root.scale = Vector3.ONE * (0.72 + build_ratio * 0.28)
	for i in range(_rings.size()):
		var ring := _rings[i]
		if ring != null:
			ring.rotation_degrees.y += delta * (190.0 + float(i) * 70.0)
			ring.rotation_degrees.z -= delta * (85.0 + float(i) * 28.0)
	for i in range(_storm_shards.size()):
		var shard := _storm_shards[i]
		if shard != null:
			shard.rotation_degrees.y += delta * (360.0 + float(i) * 18.0)
			shard.rotation_degrees.z += delta * (180.0 + float(i) * 13.0)
			shard.position.y += sin(Time.get_ticks_msec() * 0.006 + float(i)) * 0.002
	if _light != null:
		var pulse := 0.75 + 0.25 * sin(Time.get_ticks_msec() * 0.026)
		_light.light_energy = (1.5 + pulse * 2.1) * maxf(build_ratio, 0.35)
	if _ground_light != null:
		var ground_pulse := 0.62 + 0.38 * sin(Time.get_ticks_msec() * 0.02)
		_ground_light.light_energy = (0.55 + ground_pulse * 0.75) * maxf(build_ratio, 0.4)

func _animate_branches(delta: float) -> void:
	for i in range(_branches.size() - 1, -1, -1):
		var branch := _branches[i]
		var life := float(branch["life"]) - delta
		var max_life := float(branch["max_life"])
		var ratio := clampf(life / max_life, 0.0, 1.0)
		var material := branch["material"] as StandardMaterial3D
		if material != null:
			material.albedo_color.a = ratio * 0.95
			material.emission_energy_multiplier = 5.8 * ratio
		var core_material := branch["core_material"] as StandardMaterial3D
		if core_material != null:
			core_material.albedo_color.a = ratio * 0.96
			core_material.emission_energy_multiplier = 7.2 * ratio
		var light := branch["light"] as OmniLight3D
		if light != null:
			light.light_energy = 5.0 * ratio
		branch["life"] = life
		if life <= 0.0:
			var node := branch["node"] as Node
			if node != null:
				node.queue_free()
			_branches.remove_at(i)

func _vortex_material(albedo: Color, emission: Color, emission_energy: float) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	material.albedo_color = albedo
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	material.blend_mode = BaseMaterial3D.BLEND_MODE_ADD
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.emission_enabled = true
	material.emission = emission
	material.emission_energy_multiplier = emission_energy
	return material

func _play_attack_sound() -> void:
	if DisplayServer.get_name() == "headless":
		return
	var sound_parent := get_parent() as Node3D
	if sound_parent == null:
		sound_parent = self
	var sound := AudioStreamPlayer.new()
	sound.name = "ElectricityVortexAttackSound"
	sound.stream = ATTACK_SOUND
	sound.volume_db = 3.0
	sound.finished.connect(sound.queue_free)
	sound_parent.add_child(sound)
	sound.play()
