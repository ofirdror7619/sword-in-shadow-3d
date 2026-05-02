extends CharacterBody3D
class_name SISEnemy

const LightningVortexScript := preload("res://scripts/LightningVortex.gd")
const ProgressionConfigScript := preload("res://scripts/ProgressionConfig.gd")
const ANGEL_BODY_TEXTURE: Texture2D = preload("res://assets/images/enemies/angel/angel-body.png")
const ANGEL_LEFT_WING_TEXTURE: Texture2D = preload("res://assets/images/enemies/angel/angel-left-wing.png")
const ANGEL_RIGHT_WING_TEXTURE: Texture2D = preload("res://assets/images/enemies/angel/angel-right-wing.png")
const ANGEL_BODY_BACK_PATH := "res://assets/images/enemies/angel/angel-back.png"
const KNIGHT_MODEL_PATH := "res://assets/images/enemies/knight/knight.glb"
const CLERIC_MODEL_PATH := "res://assets/images/enemies/cleric/cleric.glb"
const CENTAUR_MODEL_PATH := "res://assets/images/enemies/centaur/centaur.glb"
const HUMAN_WARRIOR_MODEL_PATH := "res://assets/images/enemies/human-warrior/human-warrior.glb"
const GIANT_MODEL_PATH := "res://assets/images/enemies/giant/giant.glb"
const STATUS_FX_SCENE: PackedScene = preload("res://assets/images/statusFX/effects/status/vfx_status_shatter.tscn")

signal killed(enemy: Node3D)

const ENEMY_KIND_ANGEL := &"angel"
const ENEMY_KIND_KNIGHT := &"knight"
const ENEMY_KIND_CLERIC := &"cleric"
const ENEMY_KIND_SKELETON := &"skeleton"
const ENEMY_KIND_CENTAUR := &"centaur"
const ENEMY_KIND_HUMAN_WARRIOR := &"human_warrior"
const ENEMY_KIND_GIANT := &"giant"
const GRAVITY := 30.0
const ATTACK_RANGE := 1.35
const ATTACK_INTERVAL := 0.9
const CLERIC_ATTACK_INTERVAL := 1.65
const CLERIC_SIGHT_RANGE := 16.0
const CENTAUR_ATTACK_INTERVAL := 1.85
const CENTAUR_SIGHT_RANGE := 17.0
const CENTAUR_IDEAL_RANGE := 8.5
const CENTAUR_VORTEX_SPEED := 8.6
const CLERIC_VISUAL_HEIGHT := 2.45
const CLERIC_PROXY_BASE_HEIGHT := 1.78
const CLERIC_LIFE_BAR_HEIGHT := 2.82
const CENTAUR_VISUAL_HEIGHT := 2.25
const CENTAUR_PROXY_BASE_HEIGHT := 1.86
const CENTAUR_LIFE_BAR_HEIGHT := 2.62
const NOTICE_RANGE := 13.5
const LOSE_INTEREST_RANGE := 18.0
const FACING_FRONT := 0
const FACING_BACK := 1
const FACING_LEFT := 2
const FACING_RIGHT := 3
const ANGEL_HOVER_HEIGHT := 0.46
const ANGEL_HOVER_BOB := 0.07
const KNIGHT_VISUAL_HEIGHT := 2.05
const KNIGHT_PROXY_BASE_HEIGHT := 1.72
const KNIGHT_LIFE_BAR_HEIGHT := 2.42
const HUMAN_WARRIOR_VISUAL_HEIGHT := 2.05
const HUMAN_WARRIOR_PROXY_BASE_HEIGHT := 1.72
const HUMAN_WARRIOR_LIFE_BAR_HEIGHT := 2.42
const GIANT_VISUAL_HEIGHT := 4.85
const GIANT_PROXY_BASE_HEIGHT := 3.55
const GIANT_LIFE_BAR_HEIGHT := 5.25
const ANGEL_STATUS_FX_COLOR := Color(0.72, 0.9, 1.0, 1.0)
const ANGEL_STATUS_FX_EMISSION := 5.8
const ANGEL_STATUS_FX_SCALE := 0.62
const ANGEL_STATUS_FX_VERTICAL := 0.18
const ANGEL_STATUS_FX_ORBIT := 0.25

var enemy_kind: StringName = ENEMY_KIND_ANGEL
var player: Node3D
var max_life := 45
var life := 45
var speed := 3.1
var damage := 10
var xp_reward := 28
var gold_reward := 8
var enemy_level := 1
var elite_enemy := false
var attack_timer := 0.0
var alive := true
var _wing_time: float = 0.0
var _skeleton_time: float = 0.0
var _knight_time: float = 0.0
var _cleric_time: float = 0.0
var _player_noticed := false
var _status_fx: Node3D
var _status_fx_base_scale := Vector3.ONE
var _status_fx_time: float = 0.0
var _lightning_bolts: Array[Dictionary] = []

var _visual_root: Node3D
var _life_bar: MeshInstance3D
var _angel_body_sprite: Sprite3D
var _angel_body_back_texture: Texture2D
var _left_wing_pivot: Node3D
var _right_wing_pivot: Node3D
var _left_wing_sprite: Sprite3D
var _right_wing_sprite: Sprite3D
var _left_arm_pivot: Node3D
var _right_arm_pivot: Node3D
var _left_leg_pivot: Node3D
var _right_leg_pivot: Node3D
var _visual_facing := -1
var _left_wing_base_rotation := Vector3.ZERO
var _right_wing_base_rotation := Vector3.ZERO

func _ready() -> void:
	_load_optional_textures()
	_make_collision()
	_make_visuals()

func configure(target_player: Node3D, enemy_level: int, elite: bool = false, kind: StringName = ENEMY_KIND_ANGEL) -> void:
	player = target_player
	self.enemy_level = enemy_level
	elite_enemy = elite
	enemy_kind = kind
	max_life = 38 + enemy_level * 10
	life = max_life
	damage = 8 + enemy_level * 2
	speed = 2.8 + minf(float(enemy_level) * 0.12, 1.2)
	xp_reward = ProgressionConfigScript.enemy_xp(enemy_level)
	gold_reward = 6 + enemy_level * 3
	if enemy_kind == ENEMY_KIND_SKELETON:
		max_life = int(float(max_life) * 0.82)
		life = max_life
		damage = maxi(damage - 2, 1)
		speed += 0.55
	elif enemy_kind == ENEMY_KIND_CLERIC:
		max_life = int(float(max_life) * 1.28)
		life = max_life
		damage += 7
		speed = 0.0
		gold_reward += 8
	elif enemy_kind == ENEMY_KIND_CENTAUR:
		max_life = int(float(max_life) * 1.18)
		life = max_life
		damage += 5
		speed += 0.35
		gold_reward += 6
	elif enemy_kind == ENEMY_KIND_HUMAN_WARRIOR:
		max_life = int(float(max_life) * 1.12)
		life = max_life
		damage += 4
		speed += 0.18
		gold_reward += 5
	elif enemy_kind == ENEMY_KIND_GIANT:
		max_life = int(float(max_life) * 5.4)
		life = max_life
		damage += 22
		speed = 1.75
		xp_reward = ProgressionConfigScript.enemy_xp(enemy_level, ProgressionConfigScript.ENEMY_XP_BOSS)
		gold_reward += 80
		scale = Vector3.ONE * 1.28
	if elite:
		max_life *= 2
		life = max_life
		damage += 8
		xp_reward = ProgressionConfigScript.enemy_xp(enemy_level, ProgressionConfigScript.ENEMY_XP_ELITE)
		gold_reward *= 3
		scale = Vector3.ONE * 1.25
		if enemy_kind == ENEMY_KIND_CENTAUR:
			max_life = int(float(max_life) * 1.35)
			life = max_life
			damage += 8
			scale = Vector3.ONE * 1.62
	_make_random_status_fx(elite)

func _physics_process(delta: float) -> void:
	if not alive or player == null:
		return
	attack_timer = maxf(attack_timer - delta, 0.0)
	var offset := player.global_position - global_position
	offset.y = 0.0
	var distance := offset.length()
	if not _player_noticed and distance <= NOTICE_RANGE:
		_player_noticed = true
	elif _player_noticed and distance > LOSE_INTEREST_RANGE:
		_player_noticed = false

	if enemy_kind == ENEMY_KIND_CLERIC:
		_physics_process_cleric(delta, offset, distance)
		return
	if enemy_kind == ENEMY_KIND_CENTAUR:
		_physics_process_centaur(delta, offset, distance)
		return

	if not _player_noticed:
		velocity.x = move_toward(velocity.x, 0.0, speed)
		velocity.z = move_toward(velocity.z, 0.0, speed)
	elif distance > ATTACK_RANGE:
		var direction := offset.normalized()
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		if enemy_kind == ENEMY_KIND_SKELETON or enemy_kind == ENEMY_KIND_KNIGHT or enemy_kind == ENEMY_KIND_HUMAN_WARRIOR or enemy_kind == ENEMY_KIND_GIANT:
			_visual_root.rotation.y = atan2(velocity.x, velocity.z)
	else:
		velocity.x = move_toward(velocity.x, 0.0, speed)
		velocity.z = move_toward(velocity.z, 0.0, speed)
		if attack_timer <= 0.0 and player.has_method("take_damage"):
			player.take_damage(damage)
			attack_timer = ATTACK_INTERVAL

	if not is_on_floor():
		velocity.y -= GRAVITY * delta
	else:
		velocity.y = -0.1
	move_and_slide()
	if enemy_kind == ENEMY_KIND_ANGEL:
		if Vector2(velocity.x, velocity.z).length() > 0.1:
			_update_angel_visual_facing(Vector2(velocity.x, velocity.z).normalized())
		_face_angel_visuals_to_camera()
		_animate_angel_hover()
	elif enemy_kind == ENEMY_KIND_KNIGHT or enemy_kind == ENEMY_KIND_HUMAN_WARRIOR or enemy_kind == ENEMY_KIND_GIANT:
		_animate_knight(delta)
	_animate_wings(delta)
	_animate_skeleton(delta)
	_animate_status_fx(delta)
	_animate_lightning_bolts(delta)

func _physics_process_centaur(delta: float, offset: Vector3, distance: float) -> void:
	if not is_on_floor():
		velocity.y -= GRAVITY * delta
	else:
		velocity.y = -0.1

	if offset.length_squared() > 0.001 and _visual_root != null:
		_visual_root.rotation.y = atan2(offset.x, offset.z)

	var can_see := distance <= CENTAUR_SIGHT_RANGE and _has_clear_sight_to_player()
	if can_see:
		_player_noticed = true

	if not _player_noticed:
		velocity.x = move_toward(velocity.x, 0.0, speed)
		velocity.z = move_toward(velocity.z, 0.0, speed)
	else:
		var direction := offset.normalized()
		var movement := Vector3.ZERO
		if distance > CENTAUR_IDEAL_RANGE + 1.8:
			movement = direction
		elif distance < CENTAUR_IDEAL_RANGE - 1.5:
			movement = -direction
		velocity.x = movement.x * speed
		velocity.z = movement.z * speed
		if can_see and attack_timer <= 0.0:
			_shoot_lightning_vortex(direction)
			attack_timer = CENTAUR_ATTACK_INTERVAL

	move_and_slide()
	_animate_centaur(delta)
	_animate_status_fx(delta)
	_animate_lightning_bolts(delta)

func _physics_process_cleric(delta: float, offset: Vector3, distance: float) -> void:
	velocity.x = 0.0
	velocity.z = 0.0
	if not is_on_floor():
		velocity.y -= GRAVITY * delta
	else:
		velocity.y = -0.1
	move_and_slide()

	if offset.length_squared() > 0.001 and _visual_root != null:
		_visual_root.rotation.y = atan2(offset.x, offset.z)

	var can_attack := distance <= CLERIC_SIGHT_RANGE and _has_clear_sight_to_player()
	if can_attack:
		_player_noticed = true
		if attack_timer <= 0.0 and player.has_method("take_damage"):
			player.take_damage(damage)
			_make_lightning_bolt(_lightning_start_position(), player.global_position + Vector3(0.0, 0.85, 0.0))
			attack_timer = CLERIC_ATTACK_INTERVAL

	_animate_cleric(delta, can_attack)
	_animate_status_fx(delta)
	_animate_lightning_bolts(delta)

func take_damage(amount: int) -> void:
	if not alive:
		return
	_player_noticed = true
	life = maxi(life - amount, 0)
	_update_life_bar()
	if life <= 0:
		alive = false
		killed.emit(self)
		_clear_lightning_bolts()
		queue_free()

func _update_life_bar() -> void:
	if _life_bar == null:
		return
	var ratio: float = clampf(float(life) / float(max_life), 0.0, 1.0)
	_life_bar.scale.x = maxf(ratio, 0.02)
	_life_bar.position.x = -0.45 * (1.0 - ratio)

func _make_random_status_fx(elite: bool) -> void:
	if _status_fx != null:
		return
	if _visual_root == null:
		return
	if enemy_kind != ENEMY_KIND_ANGEL:
		return

	_status_fx = STATUS_FX_SCENE.instantiate() as Node3D
	if _status_fx == null:
		return
	_status_fx.name = "RandomStatusFX"
	_status_fx.position = _status_fx_position()
	var base_scale := ANGEL_STATUS_FX_SCALE
	if enemy_kind == ENEMY_KIND_KNIGHT:
		base_scale *= 0.92
	if elite:
		base_scale *= 1.18
	_status_fx_base_scale = Vector3.ONE * base_scale
	_status_fx.scale = _status_fx_base_scale
	_visual_root.add_child(_status_fx)

	_status_fx.set("primary_color", ANGEL_STATUS_FX_COLOR)
	_status_fx.set("secondary_color", ANGEL_STATUS_FX_COLOR)
	_status_fx.set("tertiary_color", ANGEL_STATUS_FX_COLOR)
	_status_fx.set("emission", ANGEL_STATUS_FX_EMISSION)
	_status_fx.set("hue_variation", 0.0)
	_status_fx.set("waviness", randf_range(0.05, 0.28))
	_status_fx.set("noise_scale", Vector2(randf_range(0.82, 1.6), randf_range(0.42, 0.95)))
	_status_fx.set("noise_scroll", Vector2(randf_range(-0.08, 0.08), randf_range(-0.18, 0.16)))
	_status_fx.set("particles_amount", randi_range(18, 40))
	_status_fx.set("lifetime", randf_range(1.25, 2.45))
	_status_fx.set("emission_shape", Vector3(randf_range(0.42, 0.72), randf_range(0.75, 1.2), randf_range(0.42, 0.72)))
	_status_fx.set("particles_orbit", ANGEL_STATUS_FX_ORBIT)
	_status_fx.set("particles_radial", randf_range(-0.38, 0.24))
	_status_fx.set("particles_vertical", ANGEL_STATUS_FX_VERTICAL)
	if _status_fx.has_method("play_open"):
		_status_fx.call("play_open")

func _status_fx_position() -> Vector3:
	if enemy_kind == ENEMY_KIND_KNIGHT:
		return Vector3(0.0, 1.18, 0.0)
	if enemy_kind == ENEMY_KIND_CLERIC:
		return Vector3(0.0, 1.0, 0.0)
	return Vector3(0.0, 0.78, 0.0)

func _has_clear_sight_to_player() -> bool:
	if player == null:
		return false
	var space_state := get_world_3d().direct_space_state
	var query := PhysicsRayQueryParameters3D.create(_lightning_start_position(), player.global_position + Vector3(0.0, 0.85, 0.0))
	query.exclude = [get_rid()]
	var hit := space_state.intersect_ray(query)
	return hit.is_empty() or hit.get("collider") == player

func _lightning_start_position() -> Vector3:
	return global_position + Vector3(0.0, 1.72, 0.0)

func _shoot_lightning_vortex(direction: Vector3) -> void:
	var parent := get_parent() as Node3D
	if parent == null or player == null:
		return
	var vortex: SISLightningVortex = LightningVortexScript.new() as SISLightningVortex
	var target := player.global_position
	target.y = global_position.y
	vortex.configure(target, direction, CENTAUR_VORTEX_SPEED, damage)
	parent.add_child(vortex)
	_make_lightning_bolt(global_position + Vector3(0.0, 1.6, 0.0), target + Vector3(0.0, 2.85, 0.0))

func _make_collision() -> void:
	var collider: CollisionShape3D = CollisionShape3D.new()
	var capsule: CapsuleShape3D = CapsuleShape3D.new()
	capsule.radius = 0.42
	capsule.height = 1.15
	collider.shape = capsule
	collider.position.y = 0.65
	add_child(collider)

func _load_optional_textures() -> void:
	if ResourceLoader.exists(ANGEL_BODY_BACK_PATH):
		_angel_body_back_texture = load(ANGEL_BODY_BACK_PATH) as Texture2D

func _face_angel_visuals_to_camera() -> void:
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

func _make_visuals() -> void:
	_visual_root = Node3D.new()
	add_child(_visual_root)

	if enemy_kind == ENEMY_KIND_SKELETON:
		_make_skeleton_visuals()
		return
	if enemy_kind == ENEMY_KIND_KNIGHT:
		_make_knight_visuals()
		return
	if enemy_kind == ENEMY_KIND_CLERIC:
		_make_cleric_visuals()
		return
	if enemy_kind == ENEMY_KIND_CENTAUR:
		_make_centaur_visuals()
		return
	if enemy_kind == ENEMY_KIND_HUMAN_WARRIOR:
		_make_human_warrior_visuals()
		return
	if enemy_kind == ENEMY_KIND_GIANT:
		_make_giant_visuals()
		return

	_visual_root.position.y = ANGEL_HOVER_HEIGHT
	add_child(_make_angel_shadow())
	_make_angel_wings()

	_angel_body_sprite = _make_character_sprite(ANGEL_BODY_TEXTURE, 0.0073)
	_angel_body_sprite.name = "AngelBody"
	_angel_body_sprite.position = Vector3(0.0, 0.95, 0.0)
	_angel_body_sprite.modulate = Color(1.03, 1.0, 0.92, 1.0)
	_visual_root.add_child(_angel_body_sprite)
	_apply_angel_visual_facing(FACING_FRONT)
	_face_angel_visuals_to_camera()

	_life_bar = MeshInstance3D.new()
	var bar_mesh: BoxMesh = BoxMesh.new()
	bar_mesh.size = Vector3(0.9, 0.08, 0.06)
	_life_bar.mesh = bar_mesh
	_life_bar.position = Vector3(0.0, 1.8 + ANGEL_HOVER_HEIGHT, 0.0)
	_life_bar.material_override = _material(Color(0.88, 0.08, 0.08))
	add_child(_life_bar)

func _make_knight_visuals() -> void:
	_visual_root.name = "KnightVisualRoot"
	add_child(_make_knight_shadow())

	var model_loaded := false
	if ResourceLoader.exists(KNIGHT_MODEL_PATH):
		var scene := load(KNIGHT_MODEL_PATH) as PackedScene
		if scene != null:
			var model := scene.instantiate() as Node3D
			if model != null:
				model.name = "KnightModel"
				_visual_root.add_child(model)
				_fit_visual_node(model, KNIGHT_VISUAL_HEIGHT)
				_play_first_model_animation(model)
				model_loaded = true

	if not model_loaded:
		_make_knight_proxy_visuals()
		_visual_root.scale = Vector3.ONE * (KNIGHT_VISUAL_HEIGHT / KNIGHT_PROXY_BASE_HEIGHT)

	_life_bar = MeshInstance3D.new()
	var bar_mesh: BoxMesh = BoxMesh.new()
	bar_mesh.size = Vector3(0.9, 0.08, 0.06)
	_life_bar.mesh = bar_mesh
	_life_bar.position = Vector3(0.0, KNIGHT_LIFE_BAR_HEIGHT, 0.0)
	_life_bar.material_override = _material(Color(0.88, 0.08, 0.08))
	add_child(_life_bar)

func _make_cleric_visuals() -> void:
	_visual_root.name = "ClericVisualRoot"
	add_child(_make_cleric_shadow())

	var model_loaded := false
	if ResourceLoader.exists(CLERIC_MODEL_PATH):
		var scene := load(CLERIC_MODEL_PATH) as PackedScene
		if scene != null:
			var model := scene.instantiate() as Node3D
			if model != null:
				model.name = "ClericModel"
				_visual_root.add_child(model)
				_fit_visual_node(model, CLERIC_VISUAL_HEIGHT)
				_play_first_model_animation(model)
				model_loaded = true

	if not model_loaded:
		_make_cleric_proxy_visuals()
		_visual_root.scale = Vector3.ONE * (CLERIC_VISUAL_HEIGHT / CLERIC_PROXY_BASE_HEIGHT)

	_life_bar = MeshInstance3D.new()
	var bar_mesh: BoxMesh = BoxMesh.new()
	bar_mesh.size = Vector3(0.9, 0.08, 0.06)
	_life_bar.mesh = bar_mesh
	_life_bar.position = Vector3(0.0, CLERIC_LIFE_BAR_HEIGHT, 0.0)
	_life_bar.material_override = _material(Color(0.88, 0.08, 0.08))
	add_child(_life_bar)

func _make_centaur_visuals() -> void:
	_visual_root.name = "CentaurVisualRoot"
	add_child(_make_centaur_shadow())

	var model_loaded := false
	if ResourceLoader.exists(CENTAUR_MODEL_PATH):
		var scene := load(CENTAUR_MODEL_PATH) as PackedScene
		if scene != null:
			var model := scene.instantiate() as Node3D
			if model != null:
				model.name = "CentaurModel"
				_visual_root.add_child(model)
				_fit_visual_node(model, CENTAUR_VISUAL_HEIGHT)
				_play_first_model_animation(model)
				model_loaded = true

	if not model_loaded:
		_make_centaur_proxy_visuals()
		_visual_root.scale = Vector3.ONE * (CENTAUR_VISUAL_HEIGHT / CENTAUR_PROXY_BASE_HEIGHT)

	_life_bar = MeshInstance3D.new()
	var bar_mesh: BoxMesh = BoxMesh.new()
	bar_mesh.size = Vector3(0.95, 0.08, 0.06)
	_life_bar.mesh = bar_mesh
	_life_bar.position = Vector3(0.0, CENTAUR_LIFE_BAR_HEIGHT, 0.0)
	_life_bar.material_override = _material(Color(0.88, 0.08, 0.08))
	add_child(_life_bar)

func _make_human_warrior_visuals() -> void:
	_visual_root.name = "HumanWarriorVisualRoot"
	add_child(_make_knight_shadow())

	var model_loaded := false
	if ResourceLoader.exists(HUMAN_WARRIOR_MODEL_PATH):
		var scene := load(HUMAN_WARRIOR_MODEL_PATH) as PackedScene
		if scene != null:
			var model := scene.instantiate() as Node3D
			if model != null:
				model.name = "HumanWarriorModel"
				_visual_root.add_child(model)
				_fit_visual_node(model, HUMAN_WARRIOR_VISUAL_HEIGHT)
				_play_first_model_animation(model)
				model_loaded = true

	if not model_loaded:
		_make_knight_proxy_visuals()
		_visual_root.scale = Vector3.ONE * (HUMAN_WARRIOR_VISUAL_HEIGHT / HUMAN_WARRIOR_PROXY_BASE_HEIGHT)

	_life_bar = MeshInstance3D.new()
	var bar_mesh: BoxMesh = BoxMesh.new()
	bar_mesh.size = Vector3(0.9, 0.08, 0.06)
	_life_bar.mesh = bar_mesh
	_life_bar.position = Vector3(0.0, HUMAN_WARRIOR_LIFE_BAR_HEIGHT, 0.0)
	_life_bar.material_override = _material(Color(0.88, 0.08, 0.08))
	add_child(_life_bar)

func _make_giant_visuals() -> void:
	_visual_root.name = "GiantVisualRoot"
	add_child(_make_giant_shadow())

	var model_loaded := false
	if ResourceLoader.exists(GIANT_MODEL_PATH):
		var scene := load(GIANT_MODEL_PATH) as PackedScene
		if scene != null:
			var model := scene.instantiate() as Node3D
			if model != null:
				model.name = "GiantModel"
				_visual_root.add_child(model)
				_fit_visual_node(model, GIANT_VISUAL_HEIGHT)
				_play_first_model_animation(model)
				model_loaded = true

	if not model_loaded:
		_make_giant_proxy_visuals()
		_visual_root.scale = Vector3.ONE * (GIANT_VISUAL_HEIGHT / GIANT_PROXY_BASE_HEIGHT)

	_life_bar = MeshInstance3D.new()
	var bar_mesh: BoxMesh = BoxMesh.new()
	bar_mesh.size = Vector3(1.4, 0.1, 0.08)
	_life_bar.mesh = bar_mesh
	_life_bar.position = Vector3(0.0, GIANT_LIFE_BAR_HEIGHT, 0.0)
	_life_bar.material_override = _material(Color(0.88, 0.08, 0.08))
	add_child(_life_bar)

func _make_centaur_shadow() -> MeshInstance3D:
	var shadow: MeshInstance3D = MeshInstance3D.new()
	shadow.name = "CentaurModelShadow"
	var mesh: CylinderMesh = CylinderMesh.new()
	mesh.top_radius = 0.78
	mesh.bottom_radius = 0.78
	mesh.height = 0.01
	mesh.radial_segments = 32
	shadow.mesh = mesh
	shadow.position = Vector3(0.0, 0.016, 0.0)
	shadow.scale = Vector3(1.45, 1.0, 0.72)
	shadow.material_override = _transparent_material(Color(0.0, 0.0, 0.0, 0.34))
	shadow.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	return shadow

func _make_centaur_proxy_visuals() -> void:
	var hide := _material(Color(0.32, 0.18, 0.1), Color.BLACK, 0.0)
	var skin := _material(Color(0.62, 0.46, 0.32), Color.BLACK, 0.0)
	var cloth := _material(Color(0.18, 0.28, 0.14), Color(0.04, 0.12, 0.04), 0.05)
	_visual_root.add_child(_make_bone_box(Vector3(0.88, 0.38, 0.32), Vector3(0.0, 0.72, 0.0), hide))
	_visual_root.add_child(_make_bone_box(Vector3(0.34, 0.72, 0.24), Vector3(0.0, 1.24, 0.0), cloth))
	_visual_root.add_child(_make_bone_box(Vector3(0.28, 0.28, 0.24), Vector3(0.0, 1.76, 0.0), skin))
	for x in [-0.32, -0.12, 0.12, 0.32]:
		_visual_root.add_child(_make_bone_box(Vector3(0.1, 0.62, 0.1), Vector3(x, 0.3, 0.0), hide))

func _make_cleric_shadow() -> MeshInstance3D:
	var shadow: MeshInstance3D = MeshInstance3D.new()
	shadow.name = "ClericModelShadow"
	var mesh: CylinderMesh = CylinderMesh.new()
	mesh.top_radius = 0.48
	mesh.bottom_radius = 0.48
	mesh.height = 0.01
	mesh.radial_segments = 32
	shadow.mesh = mesh
	shadow.position = Vector3(0.0, 0.016, 0.0)
	shadow.scale = Vector3(1.1, 1.0, 0.74)
	shadow.material_override = _transparent_material(Color(0.0, 0.0, 0.0, 0.3))
	shadow.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	return shadow

func _make_cleric_proxy_visuals() -> void:
	var robe := _material(Color(0.2, 0.22, 0.34), Color(0.03, 0.05, 0.12), 0.08)
	var trim := _material(Color(0.82, 0.75, 0.46), Color(0.34, 0.27, 0.08), 0.25)
	var skin := _material(Color(0.7, 0.56, 0.42), Color.BLACK, 0.0)
	_visual_root.add_child(_make_bone_box(Vector3(0.48, 0.9, 0.28), Vector3(0.0, 0.92, 0.0), robe))
	_visual_root.add_child(_make_bone_box(Vector3(0.58, 0.08, 0.04), Vector3(0.0, 1.32, 0.15), trim))
	_visual_root.add_child(_make_bone_box(Vector3(0.3, 0.28, 0.24), Vector3(0.0, 1.55, 0.0), skin))
	_visual_root.add_child(_make_bone_box(Vector3(0.08, 0.9, 0.08), Vector3(0.36, 1.0, 0.0), trim))

func _make_knight_shadow() -> MeshInstance3D:
	var shadow: MeshInstance3D = MeshInstance3D.new()
	shadow.name = "KnightModelShadow"
	var mesh: CylinderMesh = CylinderMesh.new()
	mesh.top_radius = 0.48
	mesh.bottom_radius = 0.48
	mesh.height = 0.01
	mesh.radial_segments = 32
	shadow.mesh = mesh
	shadow.position = Vector3(0.0, 0.016, 0.0)
	shadow.scale = Vector3(1.0, 1.0, 0.68)
	shadow.material_override = _transparent_material(Color(0.0, 0.0, 0.0, 0.28))
	shadow.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	return shadow

func _make_knight_proxy_visuals() -> void:
	var armor := _material(Color(0.45, 0.47, 0.5), Color(0.06, 0.07, 0.08), 0.08)
	var dark := _material(Color(0.05, 0.045, 0.04), Color.BLACK, 0.0)
	var red := _material(Color(0.36, 0.035, 0.035), Color.BLACK, 0.0)
	_visual_root.add_child(_make_bone_box(Vector3(0.48, 0.72, 0.24), Vector3(0.0, 1.02, 0.0), armor))
	_visual_root.add_child(_make_bone_box(Vector3(0.32, 0.32, 0.28), Vector3(0.0, 1.55, 0.0), armor))
	_visual_root.add_child(_make_bone_box(Vector3(0.52, 0.12, 0.05), Vector3(0.0, 1.55, 0.16), dark))
	_visual_root.add_child(_make_bone_box(Vector3(0.36, 0.18, 0.08), Vector3(0.0, 1.18, 0.15), red))
	_visual_root.add_child(_make_bone_box(Vector3(0.1, 0.76, 0.1), Vector3(-0.2, 0.48, 0.0), armor))
	_visual_root.add_child(_make_bone_box(Vector3(0.1, 0.76, 0.1), Vector3(0.2, 0.48, 0.0), armor))

func _make_giant_shadow() -> MeshInstance3D:
	var shadow: MeshInstance3D = MeshInstance3D.new()
	shadow.name = "GiantModelShadow"
	var mesh: CylinderMesh = CylinderMesh.new()
	mesh.top_radius = 1.05
	mesh.bottom_radius = 1.05
	mesh.height = 0.01
	mesh.radial_segments = 40
	shadow.mesh = mesh
	shadow.position = Vector3(0.0, 0.016, 0.0)
	shadow.scale = Vector3(1.18, 1.0, 0.78)
	shadow.material_override = _transparent_material(Color(0.0, 0.0, 0.0, 0.38))
	shadow.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	return shadow

func _make_giant_proxy_visuals() -> void:
	var skin := _material(Color(0.54, 0.42, 0.32), Color(0.12, 0.06, 0.025), 0.04)
	var hide := _material(Color(0.22, 0.13, 0.08), Color(0.05, 0.02, 0.01), 0.03)
	var iron := _material(Color(0.32, 0.32, 0.34), Color(0.08, 0.07, 0.06), 0.16)
	_visual_root.add_child(_make_bone_box(Vector3(0.95, 1.45, 0.48), Vector3(0.0, 1.72, 0.0), skin))
	_visual_root.add_child(_make_bone_box(Vector3(1.08, 0.24, 0.12), Vector3(0.0, 2.15, 0.32), hide))
	_visual_root.add_child(_make_bone_box(Vector3(0.62, 0.52, 0.48), Vector3(0.0, 2.78, 0.0), skin))
	_visual_root.add_child(_make_bone_box(Vector3(0.24, 1.2, 0.22), Vector3(-0.58, 1.55, 0.0), skin))
	_visual_root.add_child(_make_bone_box(Vector3(0.24, 1.2, 0.22), Vector3(0.58, 1.55, 0.0), skin))
	_visual_root.add_child(_make_bone_box(Vector3(0.28, 1.35, 0.24), Vector3(-0.28, 0.58, 0.0), iron))
	_visual_root.add_child(_make_bone_box(Vector3(0.28, 1.35, 0.24), Vector3(0.28, 0.58, 0.0), iron))

func _fit_visual_node(model: Node3D, target_height: float) -> void:
	model.force_update_transform()
	var bounds := AABB()
	var has_bounds := false
	if model is VisualInstance3D:
		bounds = (model as VisualInstance3D).get_aabb()
		has_bounds = true
	for visual_node in model.find_children("*", "VisualInstance3D", true, false):
		var visual := visual_node as VisualInstance3D
		if visual == null:
			continue
		var relative_transform := model.global_transform.affine_inverse() * visual.global_transform
		var visual_bounds: AABB = _transformed_aabb(visual.get_aabb(), relative_transform)
		if has_bounds:
			bounds = bounds.merge(visual_bounds)
		else:
			bounds = visual_bounds
			has_bounds = true
	if not has_bounds or bounds.size.y <= 0.001:
		model.scale = Vector3.ONE
		model.position = Vector3.ZERO
		return
	var fit_scale := target_height / bounds.size.y
	var center := bounds.get_center()
	model.scale = Vector3.ONE * fit_scale
	model.position = Vector3(-center.x * fit_scale, -bounds.position.y * fit_scale, -center.z * fit_scale)

func _transformed_aabb(source: AABB, transform: Transform3D) -> AABB:
	var first_point := transform * source.position
	var result := AABB(first_point, Vector3.ZERO)
	for corner in [
		Vector3(source.position.x + source.size.x, source.position.y, source.position.z),
		Vector3(source.position.x, source.position.y + source.size.y, source.position.z),
		Vector3(source.position.x, source.position.y, source.position.z + source.size.z),
		Vector3(source.position.x + source.size.x, source.position.y + source.size.y, source.position.z),
		Vector3(source.position.x + source.size.x, source.position.y, source.position.z + source.size.z),
		Vector3(source.position.x, source.position.y + source.size.y, source.position.z + source.size.z),
		source.position + source.size
	]:
		result = result.expand(transform * corner)
	return result

func _play_first_model_animation(model: Node3D) -> void:
	for player_node in model.find_children("*", "AnimationPlayer", true, false):
		var animation_player := player_node as AnimationPlayer
		if animation_player == null:
			continue
		var animations := animation_player.get_animation_list()
		if animations.is_empty():
			continue
		var animation_name: StringName = animations[0]
		for candidate in animations:
			var lowered := String(candidate).to_lower()
			if lowered.contains("idle") or lowered.contains("walk") or lowered.contains("run"):
				animation_name = candidate
				break
		animation_player.play(animation_name)

func _make_angel_shadow() -> MeshInstance3D:
	var shadow: MeshInstance3D = MeshInstance3D.new()
	shadow.name = "AngelAirShadow"
	var mesh: CylinderMesh = CylinderMesh.new()
	mesh.top_radius = 0.55
	mesh.bottom_radius = 0.55
	mesh.height = 0.01
	mesh.radial_segments = 36
	shadow.mesh = mesh
	shadow.position = Vector3(0.0, 0.016, 0.03)
	shadow.scale = Vector3(1.25, 1.0, 0.55)
	shadow.material_override = _transparent_material(Color(0.0, 0.0, 0.0, 0.24))
	shadow.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	return shadow

func _make_skeleton_visuals() -> void:
	var bone_material := _material(Color(0.84, 0.78, 0.65), Color(0.12, 0.1, 0.07), 0.0)
	var dark_material := _material(Color(0.04, 0.035, 0.03), Color.BLACK, 0.0)

	_visual_root.add_child(_make_bone_box(Vector3(0.42, 0.12, 0.13), Vector3(0.0, 0.82, 0.0), bone_material))
	_visual_root.add_child(_make_bone_box(Vector3(0.12, 0.56, 0.12), Vector3(0.0, 1.1, 0.0), bone_material))
	_visual_root.add_child(_make_bone_box(Vector3(0.58, 0.1, 0.12), Vector3(0.0, 1.32, 0.0), bone_material))

	var skull: MeshInstance3D = MeshInstance3D.new()
	var skull_mesh: SphereMesh = SphereMesh.new()
	skull_mesh.radius = 0.23
	skull_mesh.height = 0.34
	skull.mesh = skull_mesh
	skull.position = Vector3(0.0, 1.62, 0.0)
	skull.material_override = bone_material
	_visual_root.add_child(skull)

	_visual_root.add_child(_make_bone_box(Vector3(0.07, 0.05, 0.04), Vector3(-0.08, 1.64, 0.2), dark_material))
	_visual_root.add_child(_make_bone_box(Vector3(0.07, 0.05, 0.04), Vector3(0.08, 1.64, 0.2), dark_material))

	_left_arm_pivot = _make_limb_pivot(Vector3(-0.34, 1.27, 0.0), Vector3(0.11, 0.56, 0.11), -0.28, bone_material)
	_right_arm_pivot = _make_limb_pivot(Vector3(0.34, 1.27, 0.0), Vector3(0.11, 0.56, 0.11), -0.28, bone_material)
	_left_leg_pivot = _make_limb_pivot(Vector3(-0.16, 0.78, 0.0), Vector3(0.12, 0.62, 0.12), -0.31, bone_material)
	_right_leg_pivot = _make_limb_pivot(Vector3(0.16, 0.78, 0.0), Vector3(0.12, 0.62, 0.12), -0.31, bone_material)
	_visual_root.add_child(_left_arm_pivot)
	_visual_root.add_child(_right_arm_pivot)
	_visual_root.add_child(_left_leg_pivot)
	_visual_root.add_child(_right_leg_pivot)

	_life_bar = MeshInstance3D.new()
	var bar_mesh: BoxMesh = BoxMesh.new()
	bar_mesh.size = Vector3(0.9, 0.08, 0.06)
	_life_bar.mesh = bar_mesh
	_life_bar.position = Vector3(0.0, 1.95, 0.0)
	_life_bar.material_override = _material(Color(0.88, 0.08, 0.08))
	add_child(_life_bar)

func _make_angel_wings() -> void:
	_left_wing_pivot = _make_angel_wing_pivot(-1, ANGEL_LEFT_WING_TEXTURE)
	_right_wing_pivot = _make_angel_wing_pivot(1, ANGEL_RIGHT_WING_TEXTURE)
	_visual_root.add_child(_left_wing_pivot)
	_visual_root.add_child(_right_wing_pivot)

func _make_angel_wing_pivot(side: int, texture: Texture2D) -> Node3D:
	var pivot: Node3D = Node3D.new()
	pivot.position = Vector3(float(side) * 0.26, 0.98, -0.12)
	pivot.rotation_degrees = Vector3(-4.0, float(side) * 18.0, float(side) * 10.0)

	var wing: Sprite3D = _make_character_sprite(texture, 0.0075)
	wing.name = "AngelWing"
	wing.position = Vector3(float(side) * 0.48, -0.06, -0.03)
	wing.modulate = Color(1.05, 1.02, 0.9, 1.0)
	pivot.add_child(wing)
	pivot.add_child(_make_angel_wing_socket(side))
	if side < 0:
		_left_wing_sprite = wing
	else:
		_right_wing_sprite = wing

	return pivot

func _make_angel_wing_socket(side: int) -> MeshInstance3D:
	var socket: MeshInstance3D = MeshInstance3D.new()
	socket.name = "AngelWingSocket"
	var mesh: SphereMesh = SphereMesh.new()
	mesh.radius = 0.1
	mesh.height = 0.15
	mesh.radial_segments = 12
	mesh.rings = 6
	socket.mesh = mesh
	socket.position = Vector3(float(side) * 0.02, -0.01, 0.02)
	socket.rotation_degrees = Vector3(0.0, 0.0, float(side) * 10.0)
	socket.scale = Vector3(1.15, 0.68, 0.52)
	socket.material_override = _material(
		Color(0.98, 0.82, 0.42, 1.0),
		Color(1.0, 0.72, 0.28, 1.0),
		0.16
	)
	socket.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	return socket

func _make_character_sprite(texture: Texture2D, pixel_size: float) -> Sprite3D:
	var sprite: Sprite3D = Sprite3D.new()
	sprite.texture = texture
	sprite.pixel_size = pixel_size
	sprite.shaded = true
	sprite.double_sided = true
	sprite.billboard = BaseMaterial3D.BILLBOARD_DISABLED
	sprite.texture_filter = BaseMaterial3D.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS
	sprite.alpha_cut = SpriteBase3D.ALPHA_CUT_DISCARD
	return sprite

func _update_angel_visual_facing(direction: Vector2) -> void:
	var next_facing := FACING_FRONT
	if absf(direction.x) > absf(direction.y) * 1.15:
		if direction.x < 0.0:
			next_facing = FACING_LEFT
		else:
			next_facing = FACING_RIGHT
	elif direction.y < 0.0:
		next_facing = FACING_BACK
	_apply_angel_visual_facing(next_facing)

func _apply_angel_visual_facing(next_facing: int) -> void:
	if next_facing == _visual_facing and _angel_body_sprite != null:
		return
	_visual_facing = next_facing
	if _angel_body_sprite == null or _left_wing_pivot == null or _right_wing_pivot == null:
		return

	_angel_body_sprite.flip_h = false
	_angel_body_sprite.texture = ANGEL_BODY_TEXTURE
	_angel_body_sprite.scale = Vector3.ONE
	_angel_body_sprite.position = Vector3(0.0, 0.95, 0.0)
	_angel_body_sprite.rotation_degrees.x = -6.0
	_angel_body_sprite.modulate = Color(1.03, 1.0, 0.92, 1.0)
	_left_wing_sprite.texture = ANGEL_LEFT_WING_TEXTURE
	_right_wing_sprite.texture = ANGEL_RIGHT_WING_TEXTURE
	_left_wing_sprite.scale = Vector3.ONE
	_right_wing_sprite.scale = Vector3.ONE
	_left_wing_sprite.modulate = Color(1.05, 1.02, 0.9, 1.0)
	_right_wing_sprite.modulate = Color(1.05, 1.02, 0.9, 1.0)
	_left_wing_sprite.position = Vector3(-0.48, -0.06, -0.03)
	_right_wing_sprite.position = Vector3(0.48, -0.06, -0.03)
	_left_wing_pivot.position = Vector3(-0.26, 0.98, -0.12)
	_right_wing_pivot.position = Vector3(0.26, 0.98, -0.12)
	_left_wing_base_rotation = Vector3(-6.0, -18.0, -10.0)
	_right_wing_base_rotation = Vector3(-6.0, 18.0, 10.0)

	match next_facing:
		FACING_BACK:
			if _angel_body_back_texture != null:
				_angel_body_sprite.texture = _angel_body_back_texture
			_angel_body_sprite.position = Vector3(0.0, 0.95, -0.02)
			_angel_body_sprite.scale = Vector3(0.92, 1.0, 1.0)
			if _angel_body_back_texture == null:
				_angel_body_sprite.modulate = Color(0.76, 0.72, 0.58, 1.0)
			_left_wing_pivot.position = Vector3(-0.31, 0.98, 0.02)
			_right_wing_pivot.position = Vector3(0.31, 0.98, 0.02)
			_left_wing_sprite.position = Vector3(-0.55, -0.02, 0.02)
			_right_wing_sprite.position = Vector3(0.55, -0.02, 0.02)
			_left_wing_base_rotation = Vector3(-3.0, -10.0, -4.0)
			_right_wing_base_rotation = Vector3(-3.0, 10.0, 4.0)
		FACING_LEFT:
			_angel_body_sprite.flip_h = true
			_angel_body_sprite.scale = Vector3(0.9, 1.0, 1.0)
			_left_wing_pivot.position = Vector3(-0.23, 0.98, -0.04)
			_right_wing_pivot.position = Vector3(0.08, 0.93, -0.22)
			_left_wing_sprite.position = Vector3(-0.38, -0.04, 0.02)
			_right_wing_sprite.position = Vector3(0.26, -0.04, -0.05)
			_right_wing_sprite.scale = Vector3(0.76, 0.88, 1.0)
			_right_wing_sprite.modulate = Color(0.75, 0.72, 0.62, 1.0)
			_left_wing_base_rotation = Vector3(-6.0, -23.0, -9.0)
			_right_wing_base_rotation = Vector3(-10.0, 8.0, 3.0)
		FACING_RIGHT:
			_angel_body_sprite.scale = Vector3(0.9, 1.0, 1.0)
			_left_wing_pivot.position = Vector3(-0.08, 0.93, -0.22)
			_right_wing_pivot.position = Vector3(0.23, 0.98, -0.04)
			_left_wing_sprite.position = Vector3(-0.26, -0.04, -0.05)
			_right_wing_sprite.position = Vector3(0.38, -0.04, 0.02)
			_left_wing_sprite.scale = Vector3(0.76, 0.88, 1.0)
			_left_wing_sprite.modulate = Color(0.75, 0.72, 0.62, 1.0)
			_left_wing_base_rotation = Vector3(-10.0, -8.0, -3.0)
			_right_wing_base_rotation = Vector3(-6.0, 23.0, 9.0)

func _make_limb_pivot(pivot_position: Vector3, bone_size: Vector3, bone_offset_y: float, material: Material) -> Node3D:
	var pivot: Node3D = Node3D.new()
	pivot.position = pivot_position
	pivot.add_child(_make_bone_box(bone_size, Vector3(0.0, bone_offset_y, 0.0), material))
	return pivot

func _make_bone_box(size: Vector3, position: Vector3, material: Material) -> MeshInstance3D:
	var bone: MeshInstance3D = MeshInstance3D.new()
	var mesh: BoxMesh = BoxMesh.new()
	mesh.size = size
	bone.mesh = mesh
	bone.position = position
	bone.material_override = material
	return bone

func _animate_wings(delta: float) -> void:
	if _left_wing_pivot == null or _right_wing_pivot == null:
		return
	var movement_speed: float = Vector2(velocity.x, velocity.z).length()
	var movement_ratio: float = clampf(movement_speed / maxf(speed, 0.1), 0.0, 1.0)
	_wing_time += delta * (3.4 + movement_ratio * 8.5)
	var flap: float = sin(_wing_time) * (8.0 + movement_ratio * 24.0)
	var lift: float = sin(_wing_time + PI * 0.5) * (2.0 + movement_ratio * 7.0)
	_left_wing_pivot.rotation_degrees = _left_wing_base_rotation + Vector3(-lift, -flap, -movement_ratio * 2.5)
	_right_wing_pivot.rotation_degrees = _right_wing_base_rotation + Vector3(-lift, flap, movement_ratio * 2.5)

func _animate_angel_hover() -> void:
	if _visual_root == null:
		return
	var movement_ratio: float = clampf(Vector2(velocity.x, velocity.z).length() / maxf(speed, 0.1), 0.0, 1.0)
	var bob_speed: float = 0.007 + movement_ratio * 0.003
	_visual_root.position.y = ANGEL_HOVER_HEIGHT + sin(Time.get_ticks_msec() * bob_speed + global_position.x * 0.17) * ANGEL_HOVER_BOB

func _animate_skeleton(delta: float) -> void:
	if _left_arm_pivot == null or _right_arm_pivot == null or _left_leg_pivot == null or _right_leg_pivot == null:
		return
	var movement_speed: float = Vector2(velocity.x, velocity.z).length()
	var movement_ratio: float = clampf(movement_speed / maxf(speed, 0.1), 0.0, 1.0)
	_skeleton_time += delta * (4.0 + movement_ratio * 7.0)
	var swing: float = sin(_skeleton_time) * 28.0 * movement_ratio
	_left_arm_pivot.rotation_degrees.x = swing
	_right_arm_pivot.rotation_degrees.x = -swing
	_left_leg_pivot.rotation_degrees.x = -swing
	_right_leg_pivot.rotation_degrees.x = swing

func _animate_knight(delta: float) -> void:
	if _visual_root == null:
		return
	var movement_speed: float = Vector2(velocity.x, velocity.z).length()
	var movement_ratio: float = clampf(movement_speed / maxf(speed, 0.1), 0.0, 1.0)
	_knight_time += delta * (3.0 + movement_ratio * 7.0)
	_visual_root.position.y = sin(_knight_time * 2.0) * 0.025 * movement_ratio
	_visual_root.rotation_degrees.z = sin(_knight_time) * 1.8 * movement_ratio

func _animate_cleric(delta: float, casting: bool) -> void:
	if _visual_root == null:
		return
	_cleric_time += delta * (2.0 if casting else 1.0)
	var cast_lean := 0.0
	if casting:
		cast_lean = sin(_cleric_time * 8.0) * 2.4
	_visual_root.position.y = sin(_cleric_time * 2.2) * 0.018
	_visual_root.rotation_degrees.x = cast_lean

func _animate_centaur(delta: float) -> void:
	if _visual_root == null:
		return
	var movement_ratio := clampf(Vector2(velocity.x, velocity.z).length() / maxf(speed, 0.1), 0.0, 1.0)
	_knight_time += delta * (2.2 + movement_ratio * 8.0)
	_visual_root.position.y = sin(_knight_time * 2.0) * 0.035 * movement_ratio
	_visual_root.rotation_degrees.z = sin(_knight_time) * 2.0 * movement_ratio

func _animate_status_fx(delta: float) -> void:
	if _status_fx == null:
		return
	_status_fx_time += delta
	var pulse := 1.0 + sin(_status_fx_time * 2.4 + global_position.x * 0.13) * 0.08
	_status_fx.scale = _status_fx_base_scale * pulse
	_status_fx.rotation_degrees.y += delta * 28.0

func _make_lightning_bolt(start: Vector3, end: Vector3) -> void:
	var parent := get_parent() as Node3D
	if parent == null:
		return
	var bolt_root: Node3D = Node3D.new()
	bolt_root.name = "ClericLightningBolt"
	parent.add_child(bolt_root)

	var material := _lightning_material(Color(0.55, 0.9, 1.0, 0.92), Color(0.35, 0.72, 1.0), 4.2)
	_add_lightning_segment(bolt_root, start, end, 0.045, material)
	for i in range(5):
		var progress := randf_range(0.16, 0.9)
		var branch_start := start.lerp(end, progress)
		branch_start += Vector3(randf_range(-0.16, 0.16), randf_range(-0.12, 0.2), randf_range(-0.16, 0.16))
		var branch_end := branch_start + Vector3(randf_range(-0.55, 0.55), randf_range(-0.28, 0.32), randf_range(-0.55, 0.55))
		_add_lightning_segment(bolt_root, branch_start, branch_end, 0.018, material)

	var flash: OmniLight3D = OmniLight3D.new()
	flash.name = "LightningFlash"
	flash.light_color = Color(0.55, 0.84, 1.0)
	flash.light_energy = 4.2
	flash.omni_range = 5.2
	flash.position = start
	bolt_root.add_child(flash)

	_lightning_bolts.append({
		"node": bolt_root,
		"material": material,
		"light": flash,
		"life": 0.18,
		"max_life": 0.18
	})

func _add_lightning_segment(parent: Node3D, start: Vector3, end: Vector3, radius: float, material: Material) -> void:
	var direction := end - start
	var length := direction.length()
	if length <= 0.01:
		return
	direction /= length
	var segment: MeshInstance3D = MeshInstance3D.new()
	var mesh: CylinderMesh = CylinderMesh.new()
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

func _animate_lightning_bolts(delta: float) -> void:
	for i in range(_lightning_bolts.size() - 1, -1, -1):
		var bolt := _lightning_bolts[i]
		var life: float = float(bolt["life"]) - delta
		var max_life: float = float(bolt["max_life"])
		var ratio: float = clampf(life / max_life, 0.0, 1.0)
		var material := bolt["material"] as StandardMaterial3D
		if material != null:
			material.albedo_color.a = ratio * 0.92
			material.emission_energy_multiplier = 4.2 * ratio
		var light := bolt["light"] as OmniLight3D
		if light != null:
			light.light_energy = 4.2 * ratio
		bolt["life"] = life
		if life <= 0.0:
			var node := bolt["node"] as Node
			if node != null:
				node.queue_free()
			_lightning_bolts.remove_at(i)

func _clear_lightning_bolts() -> void:
	for bolt in _lightning_bolts:
		var node := bolt["node"] as Node
		if node != null:
			node.queue_free()
	_lightning_bolts.clear()

func _lightning_material(albedo: Color, emission: Color, emission_energy: float) -> StandardMaterial3D:
	var material: StandardMaterial3D = StandardMaterial3D.new()
	material.albedo_color = albedo
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	material.blend_mode = BaseMaterial3D.BLEND_MODE_ADD
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.emission_enabled = true
	material.emission = emission
	material.emission_energy_multiplier = emission_energy
	return material

func _material(albedo: Color, emission: Color = Color.BLACK, emission_energy: float = 0.0) -> StandardMaterial3D:
	var material: StandardMaterial3D = StandardMaterial3D.new()
	material.albedo_color = albedo
	if emission_energy > 0.0:
		material.emission_enabled = true
		material.emission = emission
		material.emission_energy_multiplier = emission_energy
	return material

func _transparent_material(albedo: Color) -> StandardMaterial3D:
	var material: StandardMaterial3D = StandardMaterial3D.new()
	material.albedo_color = albedo
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	return material
