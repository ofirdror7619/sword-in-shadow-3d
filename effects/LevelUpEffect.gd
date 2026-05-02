extends Node3D
class_name LevelUpEffect

@export var duration := 1.4
@export var pulse_radius := 3.2

var light: OmniLight3D
var ring: MeshInstance3D
var particles: GPUParticles3D

func _ready() -> void:
	_create_light()
	_create_ring()
	_create_particles()
	_play()

func _create_light() -> void:
	light = OmniLight3D.new()
	light.light_color = Color(1.0, 0.32, 0.08)
	light.light_energy = 0.0
	light.omni_range = 6.0
	light.position = Vector3(0.0, 0.8, 0.0)
	add_child(light)

func _create_ring() -> void:
	ring = MeshInstance3D.new()
	ring.name = "LevelUpRitualRing"
	var mesh := TorusMesh.new()
	mesh.inner_radius = 0.6
	mesh.outer_radius = 0.625
	mesh.ring_segments = 64
	mesh.rings = 12
	ring.mesh = mesh
	ring.rotation_degrees.x = 90.0
	ring.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF

	var mat := StandardMaterial3D.new()
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mat.blend_mode = BaseMaterial3D.BLEND_MODE_ADD
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mat.albedo_color = Color(1.0, 0.25, 0.05, 0.75)
	mat.emission_enabled = true
	mat.emission = Color(1.0, 0.22, 0.04)
	mat.emission_energy_multiplier = 2.5
	ring.material_override = mat

	ring.scale = Vector3.ONE * 0.2
	add_child(ring)

func _create_particles() -> void:
	particles = GPUParticles3D.new()
	particles.name = "LevelUpEmbers"
	particles.amount = 90
	particles.lifetime = 1.1
	particles.one_shot = true
	particles.explosiveness = 0.75
	particles.fixed_fps = 60
	particles.position = Vector3.ZERO
	particles.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF

	var process := ParticleProcessMaterial.new()
	process.direction = Vector3.UP
	process.spread = 35.0
	process.gravity = Vector3(0.0, 1.8, 0.0)
	process.initial_velocity_min = 0.8
	process.initial_velocity_max = 2.8
	process.scale_min = 0.035
	process.scale_max = 0.11
	process.color = Color(1.0, 0.28, 0.04, 1.0)
	particles.process_material = process

	var quad := QuadMesh.new()
	quad.size = Vector2(0.12, 0.12)
	var mat := StandardMaterial3D.new()
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mat.blend_mode = BaseMaterial3D.BLEND_MODE_ADD
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mat.albedo_color = Color(1.0, 0.36, 0.06, 0.86)
	mat.emission_enabled = true
	mat.emission = Color(1.0, 0.22, 0.04)
	mat.emission_energy_multiplier = 2.2
	quad.material = mat
	particles.draw_pass_1 = quad

	add_child(particles)

func _play() -> void:
	particles.emitting = true

	var tween := create_tween()
	tween.set_parallel(true)

	tween.tween_property(light, "light_energy", 4.5, 0.12)
	tween.tween_property(light, "light_energy", 0.0, duration).set_delay(0.12)

	tween.tween_property(ring, "scale", Vector3.ONE * pulse_radius, 0.45) \
		.set_trans(Tween.TRANS_QUAD) \
		.set_ease(Tween.EASE_OUT)

	tween.tween_property(ring.material_override, "albedo_color:a", 0.0, 0.75) \
		.set_delay(0.25)

	tween.tween_callback(queue_free).set_delay(duration)
