extends Area3D
class_name SISDroppedGold

signal picked_up(amount: int)

const COIN_MODEL_PATH := "res://assets/images/objects/coin.glb"
const COIN_DIAMETER := 0.56
const COIN_THICKNESS := 0.08
const PICKUP_GRACE_SECONDS := 0.45

var amount := 1
var _base_y := 0.0
var _pickup_grace := PICKUP_GRACE_SECONDS
var _visual_root: Node3D

func _ready() -> void:
	_base_y = position.y
	body_entered.connect(_on_body_entered)
	_make_collision()
	_make_visuals()

func _process(delta: float) -> void:
	_pickup_grace = maxf(_pickup_grace - delta, 0.0)
	position.y = _base_y + sin(Time.get_ticks_msec() * 0.006 + amount) * 0.08
	_face_visuals_to_camera()
	if _visual_root != null:
		_visual_root.position.y = sin(Time.get_ticks_msec() * 0.009 + amount) * 0.035
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
		picked_up.emit(amount)
		queue_free()
		return true
	return false

func _make_collision() -> void:
	var collider := CollisionShape3D.new()
	var shape := SphereShape3D.new()
	shape.radius = 0.8
	collider.shape = shape
	add_child(collider)

func _make_visuals() -> void:
	_visual_root = Node3D.new()
	add_child(_visual_root)

	var coin := _load_coin_model()
	if coin == null:
		_make_fallback_coin()
		return
	_scale_coin_to_current_size(coin)
	_brighten_coin_materials(coin)
	_visual_root.add_child(coin)
	_face_visuals_to_camera()

func _load_coin_model() -> Node3D:
	var coin_scene := ResourceLoader.load(COIN_MODEL_PATH) as PackedScene
	if coin_scene != null:
		return coin_scene.instantiate() as Node3D

	var gltf := GLTFDocument.new()
	var state := GLTFState.new()
	var error := gltf.append_from_file(COIN_MODEL_PATH, state)
	if error != OK:
		push_warning("Could not load coin model: %s" % COIN_MODEL_PATH)
		return null
	return gltf.generate_scene(state)

func _make_fallback_coin() -> void:
	var coin := MeshInstance3D.new()
	var mesh := CylinderMesh.new()
	mesh.top_radius = COIN_DIAMETER * 0.5
	mesh.bottom_radius = COIN_DIAMETER * 0.5
	mesh.height = COIN_THICKNESS
	coin.mesh = mesh
	coin.rotation.x = PI / 2.0
	coin.material_override = _coin_material()
	_visual_root.add_child(coin)

func _face_visuals_to_camera() -> void:
	if _visual_root == null:
		return
	var camera := get_viewport().get_camera_3d()
	if camera == null:
		return
	var offset := camera.global_position - global_position
	offset.y = 0.0
	if offset.length_squared() <= 0.001:
		return
	_visual_root.rotation.y = atan2(offset.x, offset.z)

func _brighten_coin_materials(coin: Node3D) -> void:
	for child in coin.find_children("*", "MeshInstance3D", true, false):
		var mesh_instance := child as MeshInstance3D
		if mesh_instance == null or mesh_instance.mesh == null:
			continue
		mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
		for surface_index in range(mesh_instance.mesh.get_surface_count()):
			var source_material := mesh_instance.get_surface_override_material(surface_index)
			if source_material == null:
				source_material = mesh_instance.mesh.surface_get_material(surface_index)
			var material := source_material as StandardMaterial3D
			if material == null:
				continue
			var visible_material := material.duplicate() as StandardMaterial3D
			visible_material.cull_mode = BaseMaterial3D.CULL_DISABLED
			visible_material.albedo_color = visible_material.albedo_color.lightened(0.16)
			visible_material.emission_enabled = true
			visible_material.emission = Color(1.0, 0.48, 0.08, 1.0)
			visible_material.emission_energy_multiplier = maxf(visible_material.emission_energy_multiplier, 0.28)
			mesh_instance.set_surface_override_material(surface_index, visible_material)

func _coin_material() -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	material.albedo_color = Color(1.0, 0.72, 0.18, 1.0)
	material.cull_mode = BaseMaterial3D.CULL_DISABLED
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.metallic = 0.55
	material.roughness = 0.2
	material.emission_enabled = true
	material.emission = Color(1.0, 0.58, 0.12, 1.0)
	material.emission_energy_multiplier = 0.85
	return material

func _scale_coin_to_current_size(coin: Node3D) -> void:
	var bounds := _node_bounds(coin)
	var width: float = bounds.size.x
	var height: float = bounds.size.y
	var thickness: float = bounds.size.z
	if width <= 0.0 or height <= 0.0 or thickness <= 0.0:
		return
	coin.scale = Vector3(
		COIN_DIAMETER / width,
		COIN_DIAMETER / height,
		COIN_THICKNESS / thickness
	)

func _node_bounds(node: Node3D) -> AABB:
	var data := [AABB(), false]
	_collect_node_bounds(node, Transform3D.IDENTITY, data)
	return data[0]

func _collect_node_bounds(node: Node3D, parent_transform: Transform3D, data: Array) -> void:
	var node_transform := parent_transform * node.transform
	var mesh_instance := node as MeshInstance3D
	if mesh_instance != null and mesh_instance.mesh != null:
		var mesh_bounds := _transformed_aabb(mesh_instance.get_aabb(), node_transform)
		if bool(data[1]):
			data[0] = (data[0] as AABB).merge(mesh_bounds)
		else:
			data[0] = mesh_bounds
			data[1] = true
	for child in node.get_children():
		var child_node := child as Node3D
		if child_node != null:
			_collect_node_bounds(child_node, node_transform, data)

func _transformed_aabb(source_bounds: AABB, transform: Transform3D) -> AABB:
	var result_bounds := AABB()
	var has_bounds := false
	for x in [source_bounds.position.x, source_bounds.position.x + source_bounds.size.x]:
		for y in [source_bounds.position.y, source_bounds.position.y + source_bounds.size.y]:
			for z in [source_bounds.position.z, source_bounds.position.z + source_bounds.size.z]:
				var point := transform * Vector3(x, y, z)
				var point_bounds := AABB(point, Vector3.ZERO)
				if has_bounds:
					result_bounds = result_bounds.merge(point_bounds)
				else:
					result_bounds = point_bounds
					has_bounds = true
	return result_bounds
