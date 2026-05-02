extends CharacterBody3D
class_name SISPlayer

const DEMON_BODY_TEXTURE: Texture2D = preload("res://assets/images/demon/demon-body.png")
const DEMON_LEFT_WING_TEXTURE: Texture2D = preload("res://assets/images/demon/demon-left-wing.png")
const DEMON_RIGHT_WING_TEXTURE: Texture2D = preload("res://assets/images/demon/demon-right-wing.png")
const DEMON_FLAME_TEXTURE: Texture2D = preload("res://assets/images/effects/firestorm-flame.png")
const DEMON_BODY_BACK_PATH := "res://assets/images/demon/demon-back.png"
const ProgressionConfigScript := preload("res://scripts/ProgressionConfig.gd")
const FLAME_DISC_TEXTURE_SIZE := 72

signal stats_changed(stats: Dictionary)
signal died
signal attack_spell_requested(target_position: Vector3)
signal damaged(amount: int)

const MOVE_SPEED := 7.0
const ACCELERATION := 18.0
const GRAVITY := 30.0
const HEAL_INTERVAL := 1.0
const HEAL_AMOUNT := 2
const FACING_FRONT := 0
const FACING_BACK := 1
const FACING_LEFT := 2
const FACING_RIGHT := 3
const DEMON_HOVER_HEIGHT := 0.42
const DEMON_HOVER_BOB := 0.08
const IDLE_WING_FLAP := 10.0
const IDLE_WING_LIFT := 3.4
const IDLE_WING_FOLD := 3.2
const POSSESSION_FLASH_DURATION := 2.6
const SKILL_TREE_NODE_KEYS := [
	"damage", "radius", "cooldown",
	"inf_1", "inf_2", "inf_3", "inf_major", "inf_fire_1", "inf_ice_1", "inf_lightning_1",
	"mys_1", "mys_2", "mys_3", "mys_major", "mys_aoe_1", "mys_cd_1", "mys_chain_1",
	"soul_1", "soul_2", "soul_3", "soul_major", "soul_lifesteal_1", "soul_shield_1", "soul_regen_1",
	"cur_1", "cur_2", "cur_3", "cur_major", "cur_dot_1", "cur_buff_1", "cur_control_1",
	"bridge_inf_cur", "bridge_mys_soul",
	"whisper_1", "whisper_2", "whisper_3", "whisper_4"
]
const SPELL_GROUP_CATEGORY_BY_ID := {
	"fire_storm": "attack",
	"absolute_zero": "attack",
	"abyssal_blade": "attack",
	"call_from_beyond": "attack",
	"electricity_vortex": "attack",
	"icesmash": "attack",
	"soul_drain": "attack",
	"demonic_frenzy": "buff",
	"killing_radius": "buff",
	"power_of_underworld": "buff",
	"void_infusion": "buff",
	"curse_of_laziness": "debuff",
	"mark_of_weakness": "debuff",
	"slowly_we_rot": "debuff",
	"armor_of_undead": "defense",
	"eclipse_shield": "defense",
	"titanium": "defense",
	"reincarnation": "healing",
	"soul_harvest": "healing"
}
const SPELL_ID_TO_DISPLAY_NAME := {
	"fire_storm": "Firestorm",
	"absolute_zero": "Absolute Zero",
	"abyssal_blade": "Abyssal Blade",
	"call_from_beyond": "Call From The Beyond",
	"electricity_vortex": "Electricity Vortex",
	"icesmash": "Ice Smash",
	"soul_drain": "Soul Drain",
	"demonic_frenzy": "Demonic Frenzy",
	"killing_radius": "Killing Radius",
	"power_of_underworld": "Power of the Underworld",
	"void_infusion": "Void Infusion",
	"curse_of_laziness": "Curse of Laziness",
	"mark_of_weakness": "Mark of Weakness",
	"slowly_we_rot": "Slowly We Rot",
	"armor_of_undead": "Armor of the Undead",
	"eclipse_shield": "Eclipse Shield",
	"titanium": "Titanium",
	"reincarnation": "Reincarnation",
	"soul_harvest": "Soul Harvest"
}
const DEATH_XP_LOSS_RATIO := 0.10

var max_life := 120
var life := 120
var level := 1
var xp := 0
var xp_to_next := 100
var skill_points := 0
var gold := 0
var diamonds := 0
var firestorm_cooldown := 0.0
var shield := 0
var alive := true
var move_target: Vector3
var has_move_target := false
var learned_spells: Array[String] = ["fire_storm"]
var unlocked_skill_nodes: Array[String] = []
var active_spell_slots := {"attack": "fire_storm"}
var _ignore_mouse_until_released := false
var _attacks_enabled := true
var _mouse_block_check: Callable

var _heal_timer := 0.0
var _damage_multiplier := 1.0
var _damage_multiplier_timer := 0.0
var _move_speed_multiplier := 1.0
var _move_speed_timer := 0.0
var _lifesteal_ratio := 0.0
var _lifesteal_timer := 0.0
var _hunger_unbound := false
var _hunger_stacks := 0
var _hunger_timer := 0.0
var _control_lapse_timer := 0.0
var _control_lapse_direction := Vector3.ZERO
var _wing_time: float = 0.0
var _visual_root: Node3D
var _camera: Camera3D
var _body_sprite: Sprite3D
var _body_back_texture: Texture2D
var _left_wing_pivot: Node3D
var _right_wing_pivot: Node3D
var _left_wing_sprite: Sprite3D
var _right_wing_sprite: Sprite3D
var _visual_facing := -1
var _left_wing_base_rotation := Vector3.ZERO
var _right_wing_base_rotation := Vector3.ZERO
var _left_wing_base_position := Vector3.ZERO
var _right_wing_base_position := Vector3.ZERO
var _left_wing_base_scale := Vector3.ONE
var _right_wing_base_scale := Vector3.ONE
var _flame_sprites: Array[Dictionary] = []
var _flame_particles: Array[GPUParticles3D] = []
var _flame_glow_sprites: Array[Dictionary] = []
var _flame_light: OmniLight3D
var _flame_time: float = 0.0
var _possession_flash_timer := 0.0
var _socket_damage_multiplier := 1.0
var _socket_move_speed_multiplier := 1.0
var _socket_cooldown_reduction := 0.0
var _socket_gold_multiplier := 1.0
var _socket_attack_damage_multiplier := 1.0
var _socket_attack_radius_bonus := 0.0
var _socket_healing_rate_multiplier := 1.0
var _socket_loot_luck_bonus := 0.0
var _socket_attack_effect_multiplier := 1.0
var _socket_beyond_effect_multiplier := 1.0
var _socket_defense_effect_multiplier := 1.0
var _socket_flame_effect_multiplier := 1.0
var _socket_ice_effect_multiplier := 1.0
var _socket_electricity_effect_multiplier := 1.0
var _socket_summon_slots_bonus := 0
var _max_life_penalty := 0

func _ready() -> void:
	name = "Player"
	_sync_progression_stats(false)
	move_target = global_position
	_load_optional_textures()
	_make_collision()
	_make_visuals()
	stats_changed.emit(get_stats())

func setup_camera(camera: Camera3D) -> void:
	_camera = camera
	_face_visuals_to_camera()

func _physics_process(delta: float) -> void:
	if not alive:
		return
	_update_cooldowns(delta)
	_handle_input()
	_apply_movement(delta)
	_handle_regen(delta)
	stats_changed.emit(get_stats())

func get_stats() -> Dictionary:
	return {
		"life": life,
		"max_life": max_life,
		"level": level,
		"xp": xp,
		"xp_to_next": xp_to_next,
		"skill_points": skill_points,
		"gold": gold,
		"diamonds": diamonds,
		"learned_spells": learned_spells.duplicate(),
		"active_spell_slots": active_spell_slots.duplicate(true),
		"unlocked_skill_nodes": unlocked_skill_nodes.duplicate(),
		"firestorm_cooldown": firestorm_cooldown,
		"shield": shield,
		"damage_multiplier": _damage_multiplier,
		"active_attack_spell_id": get_active_attack_spell_id(),
		"active_attack_spell": get_active_attack_spell_name(),
		"active_attack_damage_min": get_active_attack_spell_damage(),
		"active_attack_damage_max": get_active_attack_spell_damage(),
		"active_attack_cooldown_duration": get_active_attack_spell_cooldown_duration(),
		"socket_damage_multiplier": _socket_damage_multiplier,
		"socket_move_speed_multiplier": _socket_move_speed_multiplier,
		"socket_cooldown_reduction": _socket_cooldown_reduction,
		"socket_gold_multiplier": _socket_gold_multiplier,
		"socket_attack_damage_multiplier": _socket_attack_damage_multiplier,
		"socket_attack_radius_bonus": _socket_attack_radius_bonus,
		"socket_healing_rate_multiplier": _socket_healing_rate_multiplier,
		"socket_loot_luck_bonus": _socket_loot_luck_bonus,
		"socket_attack_effect_multiplier": _socket_attack_effect_multiplier,
		"socket_beyond_effect_multiplier": _socket_beyond_effect_multiplier,
		"socket_defense_effect_multiplier": _socket_defense_effect_multiplier,
		"socket_flame_effect_multiplier": _socket_flame_effect_multiplier,
		"socket_ice_effect_multiplier": _socket_ice_effect_multiplier,
		"socket_electricity_effect_multiplier": _socket_electricity_effect_multiplier,
		"socket_summon_slots_bonus": _socket_summon_slots_bonus
	}

func take_damage(amount: int) -> void:
	if not alive:
		return
	var remaining_damage := maxi(1, int(round(float(amount) * get_skill_damage_taken_multiplier())))
	if shield > 0:
		var absorbed := mini(shield, remaining_damage)
		shield -= absorbed
		remaining_damage -= absorbed
	if remaining_damage > 0:
		life = maxi(life - remaining_damage, 0)
	damaged.emit(amount)
	stats_changed.emit(get_stats())
	if life <= 0:
		alive = false
		_apply_death_xp_loss()
		died.emit()

func resurrect_at(spawn_position: Vector3) -> void:
	global_position = spawn_position
	move_target = spawn_position
	has_move_target = false
	velocity = Vector3.ZERO
	_ignore_mouse_until_released = false
	_heal_timer = 0.0
	alive = true
	life = max_life
	shield = 0
	_control_lapse_timer = 0.0
	_apply_visual_facing(FACING_FRONT)
	stats_changed.emit(get_stats())

func teleport_to(target_position: Vector3) -> void:
	global_position = target_position
	move_target = target_position
	has_move_target = false
	velocity = Vector3.ZERO
	_ignore_mouse_until_released = Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	_apply_visual_facing(FACING_FRONT)
	stats_changed.emit(get_stats())

func gain_xp(amount: int) -> bool:
	if level >= ProgressionConfigScript.MAX_PLAYER_LEVEL:
		xp = 0
		xp_to_next = 0
		stats_changed.emit(get_stats())
		return false
	xp += amount
	var leveled := false
	while xp_to_next > 0 and xp >= xp_to_next and level < ProgressionConfigScript.MAX_PLAYER_LEVEL:
		xp -= xp_to_next
		level += 1
		skill_points += 1
		_sync_progression_stats(true)
		leveled = true
	if level >= ProgressionConfigScript.MAX_PLAYER_LEVEL:
		xp = 0
		xp_to_next = 0
	stats_changed.emit(get_stats())
	return leveled

func _apply_death_xp_loss() -> void:
	if xp <= 0:
		return
	var xp_loss := mini(xp, maxi(1, int(ceil(float(xp) * DEATH_XP_LOSS_RATIO))))
	xp -= xp_loss
	stats_changed.emit(get_stats())

func add_gold(amount: int) -> void:
	gold += amount
	stats_changed.emit(get_stats())

func spend_gold(amount: int) -> bool:
	if gold < amount:
		return false
	gold -= amount
	stats_changed.emit(get_stats())
	return true

func add_diamonds(amount: int) -> void:
	diamonds += amount
	stats_changed.emit(get_stats())

func spend_diamonds(amount: int) -> bool:
	if diamonds < amount:
		return false
	diamonds -= amount
	stats_changed.emit(get_stats())
	return true

func learn_spell(spell_id: String) -> bool:
	if learned_spells.has(spell_id):
		return false
	learned_spells.append(spell_id)
	var category := _spell_category_for_id(spell_id)
	if category != "attack" and not active_spell_slots.has(category):
		active_spell_slots[category] = spell_id
	stats_changed.emit(get_stats())
	return true

func has_spell(spell_id: String) -> bool:
	return learned_spells.has(spell_id)

func set_active_spell(category: String, spell_id: String) -> bool:
	var clean_category := category.strip_edges().to_lower()
	var clean_spell_id := spell_id.strip_edges()
	if clean_category.is_empty() or clean_spell_id.is_empty():
		return false
	if _spell_category_for_id(clean_spell_id) != clean_category:
		return false
	if clean_spell_id != "fire_storm" and not learned_spells.has(clean_spell_id):
		return false
	if String(active_spell_slots.get(clean_category, "")) == clean_spell_id:
		return false
	active_spell_slots[clean_category] = clean_spell_id
	stats_changed.emit(get_stats())
	return true

func get_active_attack_spell_id() -> String:
	return String(active_spell_slots.get("attack", "fire_storm"))

func unlock_skill_node(node_key: String) -> bool:
	if node_key not in SKILL_TREE_NODE_KEYS:
		return false
	if unlocked_skill_nodes.has(node_key):
		return false
	if skill_points <= 0:
		return false
	skill_points -= 1
	unlocked_skill_nodes.append(node_key)
	stats_changed.emit(get_stats())
	return true

func heal_full() -> void:
	life = max_life
	stats_changed.emit(get_stats())

func heal(amount: int) -> void:
	var scaled_amount := maxi(1, int(round(float(amount) * get_skill_healing_received_multiplier())))
	life = mini(life + scaled_amount, max_life)
	stats_changed.emit(get_stats())

func reduce_max_life(amount: int) -> void:
	_max_life_penalty += maxi(amount, 0)
	max_life = _progression_max_life()
	life = mini(life, max_life)
	stats_changed.emit(get_stats())

func reduce_max_life_percent(percent: float) -> void:
	reduce_max_life(maxi(1, int(round(float(max_life) * percent))))

func add_shield(amount: int) -> void:
	shield = maxi(shield, int(round(float(amount) * _socket_defense_effect_multiplier)))
	stats_changed.emit(get_stats())

func apply_timed_damage_multiplier(multiplier: float, duration: float) -> void:
	_damage_multiplier = multiplier
	_damage_multiplier_timer = maxf(_damage_multiplier_timer, duration)
	stats_changed.emit(get_stats())

func apply_timed_slow(multiplier: float, duration: float) -> void:
	_move_speed_multiplier = minf(_move_speed_multiplier, multiplier)
	_move_speed_timer = maxf(_move_speed_timer, duration)
	stats_changed.emit(get_stats())

func apply_lifesteal(ratio: float, duration: float) -> void:
	_lifesteal_ratio = ratio
	_lifesteal_timer = maxf(_lifesteal_timer, duration)

func set_faded_diamond_bonuses(bonuses: Dictionary) -> void:
	_socket_damage_multiplier = 1.0 + maxf(0.0, float(bonuses.get("damage_bonus", 0.0)))
	_socket_move_speed_multiplier = 1.0 + maxf(0.0, float(bonuses.get("move_speed_bonus", 0.0)))
	_socket_cooldown_reduction = maxf(0.0, float(bonuses.get("cooldown_reduction", 0.0)))
	_socket_gold_multiplier = 1.0 + maxf(0.0, float(bonuses.get("gold_gain_bonus", 0.0)))
	_socket_attack_damage_multiplier = 1.0 + maxf(0.0, float(bonuses.get("attack_damage_bonus", 0.0)))
	_socket_attack_radius_bonus = maxf(0.0, float(bonuses.get("attack_radius_bonus", 0.0)))
	_socket_healing_rate_multiplier = 1.0 + maxf(0.0, float(bonuses.get("healing_rate_bonus", 0.0)))
	_socket_loot_luck_bonus = maxf(0.0, float(bonuses.get("loot_luck_bonus", 0.0)))
	_socket_attack_effect_multiplier = 1.0 + maxf(0.0, float(bonuses.get("attack_effect_bonus", 0.0)))
	_socket_beyond_effect_multiplier = 1.0 + maxf(0.0, float(bonuses.get("beyond_effect_bonus", 0.0)))
	_socket_defense_effect_multiplier = 1.0 + maxf(0.0, float(bonuses.get("defense_effect_bonus", 0.0)))
	_socket_flame_effect_multiplier = 1.0 + maxf(0.0, float(bonuses.get("flame_effect_bonus", 0.0)))
	_socket_ice_effect_multiplier = 1.0 + maxf(0.0, float(bonuses.get("ice_effect_bonus", 0.0)))
	_socket_electricity_effect_multiplier = 1.0 + maxf(0.0, float(bonuses.get("electricity_effect_bonus", 0.0)))
	_socket_summon_slots_bonus = maxi(0, int(bonuses.get("summon_slots_bonus", 0)))
	stats_changed.emit(get_stats())

func get_gold_gain_multiplier() -> float:
	return _socket_gold_multiplier

func get_socket_loot_luck_bonus() -> float:
	return _socket_loot_luck_bonus

func enable_hunger_unbound() -> void:
	_hunger_unbound = true
	_hunger_timer = 0.0
	_hunger_stacks = 0

func notify_kill() -> void:
	if _lifesteal_timer > 0.0 and _lifesteal_ratio > 0.0:
		heal(maxi(1, int(round(float(max_life) * 0.08 * _lifesteal_ratio))))
	var skill_heal_ratio := get_skill_heal_on_kill_ratio()
	if skill_heal_ratio > 0.0:
		heal(maxi(1, int(round(float(max_life) * skill_heal_ratio))))
	if unlocked_skill_nodes.has("soul_shield_1"):
		add_shield(maxi(2, int(round(float(max_life) * 0.025))))
	if _hunger_unbound:
		_hunger_stacks = mini(_hunger_stacks + 1, 6)
		_hunger_timer = 5.0
		_damage_multiplier = maxf(_damage_multiplier, 1.0 + float(_hunger_stacks) * 0.08)
		_damage_multiplier_timer = maxf(_damage_multiplier_timer, 5.2)

func apply_control_lapse(duration: float) -> void:
	_control_lapse_timer = maxf(_control_lapse_timer, duration)
	var angle := randf() * TAU
	_control_lapse_direction = Vector3(cos(angle), 0.0, sin(angle)).normalized()

func flash_possession_red() -> void:
	_possession_flash_timer = POSSESSION_FLASH_DURATION
	_apply_possession_flash_tint(1.0)

func get_damage_multiplier() -> float:
	return _damage_multiplier

func get_socket_damage_multiplier() -> float:
	return _socket_damage_multiplier

func get_socket_attack_damage_multiplier() -> float:
	return _socket_attack_damage_multiplier

func get_socket_attack_radius_bonus() -> float:
	return _socket_attack_radius_bonus

func get_socket_summon_slots_bonus() -> int:
	return _socket_summon_slots_bonus

func get_socket_defense_effect_multiplier() -> float:
	return _socket_defense_effect_multiplier

func get_socket_spell_effect_multiplier(spell_id: String) -> float:
	var multiplier := _socket_attack_effect_multiplier
	var theme := _spell_theme_for_id(spell_id)
	match theme:
		"Beyond":
			multiplier *= _socket_beyond_effect_multiplier
		"Flame":
			multiplier *= _socket_flame_effect_multiplier
		"Ice":
			multiplier *= _socket_ice_effect_multiplier
		"Electricity":
			multiplier *= _socket_electricity_effect_multiplier
	return multiplier

func get_skill_damage_multiplier() -> float:
	var bonus := 0.0
	for node_key in unlocked_skill_nodes:
		match node_key:
			"damage":
				bonus += 0.15
			"inf_1":
				bonus += 0.06
			"inf_2":
				bonus += 0.08
			"inf_3":
				bonus += 0.10
			"inf_major":
				bonus += 0.15
			"mys_chain_1":
				bonus += 0.05
			"cur_1":
				bonus += 0.04
			"cur_2":
				bonus += 0.05
			"cur_3":
				bonus += 0.06
			"cur_major":
				bonus += 0.08
			"cur_dot_1":
				bonus += 0.04
			"cur_buff_1":
				bonus += 0.05
			"bridge_inf_cur":
				bonus += 0.07
			"whisper_3":
				bonus += 0.10
	if unlocked_skill_nodes.has("damage"):
		return 1.0 + bonus
	return 1.0 + bonus

func get_skill_radius_bonus() -> float:
	var bonus := 0.0
	for node_key in unlocked_skill_nodes:
		match node_key:
			"radius":
				bonus += 0.9
			"mys_1":
				bonus += 0.2
			"mys_2":
				bonus += 0.25
			"mys_major":
				bonus += 0.45
			"mys_aoe_1":
				bonus += 0.45
			"bridge_mys_soul":
				bonus += 0.2
	if unlocked_skill_nodes.has("radius"):
		return bonus
	return bonus

func get_skill_cooldown_reduction() -> float:
	var reduction := 0.0
	for node_key in unlocked_skill_nodes:
		match node_key:
			"cooldown":
				reduction += 0.4
			"mys_1":
				reduction += 0.05
			"mys_3":
				reduction += 0.15
			"mys_major":
				reduction += 0.15
			"mys_cd_1":
				reduction += 0.25
			"cur_major":
				reduction += 0.1
			"cur_control_1":
				reduction += 0.05
			"whisper_2":
				reduction += 0.15
	if unlocked_skill_nodes.has("cooldown"):
		return reduction
	return reduction

func get_skill_damage_taken_multiplier() -> float:
	var reduction := 0.0
	if unlocked_skill_nodes.has("soul_1"):
		reduction += 0.03
	if unlocked_skill_nodes.has("soul_3"):
		reduction += 0.05
	return clampf(1.0 - reduction, 0.72, 1.0)

func get_skill_healing_received_multiplier() -> float:
	var bonus := 0.0
	if unlocked_skill_nodes.has("soul_1"):
		bonus += 0.05
	if unlocked_skill_nodes.has("soul_2"):
		bonus += 0.10
	if unlocked_skill_nodes.has("soul_regen_1"):
		bonus += 0.12
	if unlocked_skill_nodes.has("bridge_mys_soul"):
		bonus += 0.06
	return 1.0 + bonus

func get_skill_heal_on_kill_ratio() -> float:
	var ratio := 0.0
	if unlocked_skill_nodes.has("soul_major"):
		ratio += 0.04
	if unlocked_skill_nodes.has("soul_lifesteal_1"):
		ratio += 0.03
	if unlocked_skill_nodes.has("whisper_4"):
		ratio += 0.05
	return ratio

func get_skill_spell_theme_multiplier(spell_id: String) -> float:
	var multiplier := 1.0
	var theme := _spell_theme_for_id(spell_id)
	match theme:
		"Flame":
			if unlocked_skill_nodes.has("inf_fire_1"):
				multiplier += 0.10
		"Ice":
			if unlocked_skill_nodes.has("inf_ice_1"):
				multiplier += 0.10
		"Electricity":
			if unlocked_skill_nodes.has("inf_lightning_1"):
				multiplier += 0.10
		"Beyond":
			if unlocked_skill_nodes.has("whisper_1"):
				multiplier += 0.10
	return multiplier

func get_active_attack_spell_name() -> String:
	return _spell_display_name(get_active_attack_spell_id())

func get_active_attack_spell_damage() -> int:
	var active_spell_id := get_active_attack_spell_id()
	var total_damage := ProgressionConfigScript.player_damage(level)
	match active_spell_id:
		"icesmash":
			total_damage = int(round(float(total_damage) * 2.35))
	total_damage = int(round(float(total_damage) * _damage_multiplier))
	total_damage = int(round(float(total_damage) * _socket_damage_multiplier))
	total_damage = int(round(float(total_damage) * _socket_attack_damage_multiplier))
	total_damage = int(round(float(total_damage) * get_socket_spell_effect_multiplier(active_spell_id)))
	total_damage = int(round(float(total_damage) * get_skill_spell_theme_multiplier(active_spell_id)))
	if active_spell_id == "fire_storm" and has_spell("fire_storm"):
		total_damage = int(round(float(total_damage) * 1.25))
	total_damage = int(round(float(total_damage) * get_skill_damage_multiplier()))
	return total_damage

func get_active_attack_spell_cooldown_duration() -> float:
	return _firestorm_cooldown_duration()

func _sync_progression_stats(heal_to_full: bool) -> void:
	xp_to_next = ProgressionConfigScript.xp_to_next(level)
	max_life = _progression_max_life()
	if heal_to_full:
		life = max_life
	else:
		life = mini(life, max_life)

func _progression_max_life() -> int:
	return maxi(35, ProgressionConfigScript.player_hp(level) - _max_life_penalty)

func _spell_category_for_id(spell_id: String) -> String:
	if SPELL_GROUP_CATEGORY_BY_ID.has(spell_id):
		return String(SPELL_GROUP_CATEGORY_BY_ID[spell_id])
	return "attack"

func _spell_display_name(spell_id: String) -> String:
	if SPELL_ID_TO_DISPLAY_NAME.has(spell_id):
		return String(SPELL_ID_TO_DISPLAY_NAME[spell_id])
	return spell_id.replace("_", " ").capitalize()

func _spell_theme_for_id(spell_id: String) -> String:
	match spell_id:
		"fire_storm", "wide_flame":
			return "Flame"
		"absolute_zero", "icesmash", "killing_radius", "curse_of_laziness", "titanium":
			return "Ice"
		"electricity_vortex", "mark_of_weakness", "reincarnation":
			return "Electricity"
		_:
			return "Beyond"

func set_move_target(target: Vector3) -> void:
	move_target = target
	move_target.y = global_position.y
	has_move_target = true
	var facing_direction := Vector2(move_target.x - global_position.x, move_target.z - global_position.z)
	if facing_direction.length() > 0.08:
		_update_visual_facing(facing_direction.normalized())

func prepare_clean_start() -> void:
	move_target = global_position
	has_move_target = false
	velocity = Vector3.ZERO
	_ignore_mouse_until_released = Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)

func set_attacks_enabled(enabled: bool) -> void:
	_attacks_enabled = enabled

func set_mouse_block_check(callback: Callable) -> void:
	_mouse_block_check = callback

func _handle_input() -> void:
	if _control_lapse_timer > 0.0:
		has_move_target = false
		var lapse_speed := _effective_move_speed() * 0.42
		velocity.x = move_toward(velocity.x, _control_lapse_direction.x * lapse_speed, ACCELERATION * get_physics_process_delta_time())
		velocity.z = move_toward(velocity.z, _control_lapse_direction.z * lapse_speed, ACCELERATION * get_physics_process_delta_time())
		return

	var movement_blocked_by_ui := _is_mouse_blocked_by_ui()
	if movement_blocked_by_ui:
		has_move_target = false

	var input_vector := Vector2.ZERO
	if not movement_blocked_by_ui and Input.is_key_pressed(KEY_W):
		input_vector.y -= 1.0
	if not movement_blocked_by_ui and Input.is_key_pressed(KEY_S):
		input_vector.y += 1.0
	if not movement_blocked_by_ui and Input.is_key_pressed(KEY_A):
		input_vector.x -= 1.0
	if not movement_blocked_by_ui and Input.is_key_pressed(KEY_D):
		input_vector.x += 1.0

	if input_vector.length() > 0.0:
		has_move_target = false
		var world_direction := Vector3(input_vector.x, 0.0, input_vector.y).normalized()
		var move_speed := _effective_move_speed()
		velocity.x = move_toward(velocity.x, world_direction.x * move_speed, ACCELERATION * get_physics_process_delta_time())
		velocity.z = move_toward(velocity.z, world_direction.z * move_speed, ACCELERATION * get_physics_process_delta_time())

	var can_use_mouse := true
	if _ignore_mouse_until_released:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			can_use_mouse = false
		else:
			_ignore_mouse_until_released = false

	if movement_blocked_by_ui and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		_ignore_mouse_until_released = true
		can_use_mouse = false

	if can_use_mouse and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		var target: Variant = _mouse_ground_position()
		if target is Vector3:
			set_move_target(target)

	if _attacks_enabled and Input.is_key_pressed(KEY_SPACE) and firestorm_cooldown <= 0.0:
		var cast_target := move_target
		var mouse_target: Variant = _mouse_ground_position()
		if mouse_target is Vector3:
			cast_target = mouse_target
		attack_spell_requested.emit(cast_target)
		firestorm_cooldown = get_active_attack_spell_cooldown_duration()

func _apply_movement(delta: float) -> void:
	if has_move_target:
		var offset := move_target - global_position
		offset.y = 0.0
		if offset.length() < 0.25:
			has_move_target = false
			velocity.x = move_toward(velocity.x, 0.0, ACCELERATION * delta)
			velocity.z = move_toward(velocity.z, 0.0, ACCELERATION * delta)
		else:
			var direction := offset.normalized()
			var move_speed := _effective_move_speed()
			velocity.x = move_toward(velocity.x, direction.x * move_speed, ACCELERATION * delta)
			velocity.z = move_toward(velocity.z, direction.z * move_speed, ACCELERATION * delta)

	if not has_move_target and not _has_keyboard_movement():
		velocity.x = move_toward(velocity.x, 0.0, ACCELERATION * delta)
		velocity.z = move_toward(velocity.z, 0.0, ACCELERATION * delta)

	if not is_on_floor():
		velocity.y -= GRAVITY * delta
	else:
		velocity.y = -0.1

	move_and_slide()
	if has_move_target:
		var visual_offset := move_target - global_position
		visual_offset.y = 0.0
		if visual_offset.length() > 0.12:
			_update_visual_facing(Vector2(visual_offset.x, visual_offset.z).normalized())
	elif Vector2(velocity.x, velocity.z).length() > 0.2:
		_update_visual_facing(Vector2(velocity.x, velocity.z).normalized())
	_face_visuals_to_camera()
	_animate_hover()
	_animate_wings(delta)
	_animate_flames(delta)
	_update_possession_flash(delta)

func _has_keyboard_movement() -> bool:
	return Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_D)

func _handle_regen(delta: float) -> void:
	_heal_timer += delta
	var heal_interval := HEAL_INTERVAL / maxf(_socket_healing_rate_multiplier, 0.1)
	if _heal_timer >= heal_interval:
		_heal_timer = 0.0
		var regen_amount := maxi(1, int(round(float(HEAL_AMOUNT) * get_skill_healing_received_multiplier())))
		life = mini(life + regen_amount, max_life)
		stats_changed.emit(get_stats())

func _update_cooldowns(delta: float) -> void:
	firestorm_cooldown = maxf(firestorm_cooldown - delta, 0.0)
	if _damage_multiplier_timer > 0.0:
		_damage_multiplier_timer = maxf(_damage_multiplier_timer - delta, 0.0)
		if _damage_multiplier_timer <= 0.0:
			_damage_multiplier = 1.0
	if _move_speed_timer > 0.0:
		_move_speed_timer = maxf(_move_speed_timer - delta, 0.0)
		if _move_speed_timer <= 0.0:
			_move_speed_multiplier = 1.0
	if _lifesteal_timer > 0.0:
		_lifesteal_timer = maxf(_lifesteal_timer - delta, 0.0)
		if _lifesteal_timer <= 0.0:
			_lifesteal_ratio = 0.0
	if _control_lapse_timer > 0.0:
		_control_lapse_timer = maxf(_control_lapse_timer - delta, 0.0)
	if _hunger_unbound and _hunger_timer > 0.0:
		_hunger_timer = maxf(_hunger_timer - delta, 0.0)
		if _hunger_timer <= 0.0 and _hunger_stacks > 0:
			_hunger_stacks = 0
			apply_timed_slow(0.42, 3.2)

func _effective_move_speed() -> float:
	var spell_speed_bonus := 1.0
	if has_spell("ember_stride"):
		spell_speed_bonus = 1.12
	return MOVE_SPEED * _move_speed_multiplier * spell_speed_bonus * _socket_move_speed_multiplier

func _is_mouse_blocked_by_ui() -> bool:
	if not _mouse_block_check.is_valid():
		return false
	var result: Variant = _mouse_block_check.call()
	if result is bool:
		return result
	return false

func _firestorm_cooldown_duration() -> float:
	var cooldown := 4.5
	match get_active_attack_spell_id():
		"icesmash":
			cooldown = 3.4
	if has_spell("quickened_ritual"):
		cooldown = 3.2
	cooldown = maxf(0.8, cooldown - get_skill_cooldown_reduction() - _socket_cooldown_reduction)
	return cooldown

func _mouse_ground_position() -> Variant:
	if _camera == null:
		return null
	var mouse := get_viewport().get_mouse_position()
	var from := _camera.project_ray_origin(mouse)
	var direction := _camera.project_ray_normal(mouse)
	if abs(direction.y) < 0.001:
		return null
	var distance := -from.y / direction.y
	if distance < 0.0:
		return null
	return from + direction * distance

func _make_collision() -> void:
	var collider := CollisionShape3D.new()
	var capsule := CapsuleShape3D.new()
	capsule.radius = 0.45
	capsule.height = 1.45
	collider.shape = capsule
	collider.position.y = 0.75
	add_child(collider)

func _load_optional_textures() -> void:
	if ResourceLoader.exists(DEMON_BODY_BACK_PATH):
		_body_back_texture = load(DEMON_BODY_BACK_PATH) as Texture2D

func _make_visuals() -> void:
	_visual_root = Node3D.new()
	_visual_root.position.y = DEMON_HOVER_HEIGHT
	add_child(_visual_root)

	add_child(_make_ground_shadow())
	_make_demon_wings()
	_make_demon_flames()

	_body_sprite = _make_character_sprite(DEMON_BODY_TEXTURE, 0.0088)
	_body_sprite.name = "DemonBody"
	_body_sprite.position = Vector3(0.0, 1.08, 0.0)
	_body_sprite.rotation_degrees.x = -10.0
	_body_sprite.modulate = Color(1.08, 0.95, 0.95, 1.0)
	_visual_root.add_child(_body_sprite)
	_apply_visual_facing(FACING_FRONT)
	_face_visuals_to_camera()

func _make_ground_shadow() -> MeshInstance3D:
	var shadow := MeshInstance3D.new()
	shadow.name = "GroundContactShadow"
	var mesh := CylinderMesh.new()
	mesh.top_radius = 0.72
	mesh.bottom_radius = 0.72
	mesh.height = 0.012
	mesh.radial_segments = 40
	shadow.mesh = mesh
	shadow.position = Vector3(0.0, 0.018, 0.02)
	shadow.scale = Vector3(1.25, 1.0, 0.58)
	shadow.material_override = _transparent_material(Color(0.0, 0.0, 0.0, 0.42))
	shadow.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	return shadow

func _make_demon_wings() -> void:
	_left_wing_pivot = _make_wing_pivot(-1, DEMON_LEFT_WING_TEXTURE)
	_right_wing_pivot = _make_wing_pivot(1, DEMON_RIGHT_WING_TEXTURE)
	_visual_root.add_child(_left_wing_pivot)
	_visual_root.add_child(_right_wing_pivot)

func _make_wing_pivot(side: int, texture: Texture2D) -> Node3D:
	var pivot: Node3D = Node3D.new()
	pivot.position = Vector3(float(side) * 0.34, 1.35, -0.14)
	pivot.rotation_degrees = Vector3(-8.0, float(side) * 16.0, float(side) * 8.0)

	var wing: Sprite3D = _make_character_sprite(texture, 0.0102)
	wing.name = "DemonWing"
	wing.position = Vector3(float(side) * 0.52, -0.28, -0.05)
	wing.modulate = Color(1.0, 0.88, 0.88, 1.0)
	pivot.add_child(wing)
	pivot.add_child(_make_wing_socket(side))
	if side < 0:
		_left_wing_sprite = wing
	else:
		_right_wing_sprite = wing

	return pivot

func _make_wing_socket(side: int) -> MeshInstance3D:
	var socket := MeshInstance3D.new()
	socket.name = "DemonWingSocket"
	var mesh := SphereMesh.new()
	mesh.radius = 0.15
	mesh.height = 0.22
	mesh.radial_segments = 12
	mesh.rings = 6
	socket.mesh = mesh
	socket.position = Vector3(float(side) * 0.03, -0.02, 0.02)
	socket.rotation_degrees = Vector3(0.0, 0.0, float(side) * 12.0)
	socket.scale = Vector3(1.25, 0.72, 0.58)
	socket.material_override = _material(
		Color(0.055, 0.034, 0.034, 1.0),
		Color(0.55, 0.06, 0.015, 1.0),
		0.18
	)
	socket.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	return socket

func _make_demon_flames() -> void:
	var fire_texture := _make_soft_particle_texture(
		Color(1.0, 0.88, 0.34, 1.0),
		Color(1.0, 0.18, 0.015, 0.0),
		0.46
	)
	var ember_texture := _make_soft_particle_texture(
		Color(1.0, 0.55, 0.12, 1.0),
		Color(0.95, 0.08, 0.01, 0.0),
		0.28
	)
	var smoke_texture := _make_soft_particle_texture(
		Color(0.16, 0.12, 0.1, 0.48),
		Color(0.02, 0.015, 0.012, 0.0),
		0.62
	)
	var glow_texture := _make_soft_particle_texture(
		Color(1.0, 0.34, 0.04, 0.52),
		Color(1.0, 0.08, 0.0, 0.0),
		0.78
	)

	var glow_layers := [
		{
			"position": Vector3(0.0, 0.78, -0.06),
			"scale": Vector3(0.9, 1.12, 1.0),
			"alpha": 0.36,
			"phase": 0.0,
			"tilt": -5.0
		},
		{
			"position": Vector3(-0.18, 0.96, -0.08),
			"scale": Vector3(0.48, 0.78, 1.0),
			"alpha": 0.24,
			"phase": 1.8,
			"tilt": 9.0
		},
		{
			"position": Vector3(0.2, 0.92, -0.08),
			"scale": Vector3(0.52, 0.82, 1.0),
			"alpha": 0.24,
			"phase": 3.4,
			"tilt": -10.0
		}
	]

	for layer in glow_layers:
		var glow := _make_flame_sprite(glow_texture)
		glow.position = layer["position"]
		glow.scale = layer["scale"]
		glow.rotation_degrees.z = layer["tilt"]
		glow.modulate = Color(1.0, 0.36, 0.08, layer["alpha"])
		_visual_root.add_child(glow)
		_flame_glow_sprites.append({
			"sprite": glow,
			"position": layer["position"],
			"scale": layer["scale"],
			"alpha": layer["alpha"],
			"phase": layer["phase"],
			"tilt": layer["tilt"]
		})

	var flame_layers := [
		{
			"texture": DEMON_FLAME_TEXTURE,
			"position": Vector3(0.0, 0.78, -0.11),
			"scale": Vector3(0.28, 0.48, 1.0),
			"alpha": 0.22,
			"phase": 0.0,
			"tilt": -8.0
		},
		{
			"texture": DEMON_FLAME_TEXTURE,
			"position": Vector3(0.18, 0.96, -0.1),
			"scale": Vector3(0.22, 0.38, 1.0),
			"alpha": 0.17,
			"phase": 2.5,
			"tilt": 11.0
		},
		{
			"texture": DEMON_FLAME_TEXTURE,
			"position": Vector3(-0.18, 0.92, -0.1),
			"scale": Vector3(0.2, 0.36, 1.0),
			"alpha": 0.15,
			"phase": 4.2,
			"tilt": -13.0
		}
	]

	for layer in flame_layers:
		var flame := _make_flame_sprite(layer["texture"])
		flame.position = layer["position"]
		flame.scale = layer["scale"]
		flame.rotation_degrees.z = layer["tilt"]
		flame.modulate = Color(1.0, 0.62, 0.18, layer["alpha"])
		_visual_root.add_child(flame)
		_flame_sprites.append({
			"sprite": flame,
			"position": layer["position"],
			"scale": layer["scale"],
			"alpha": layer["alpha"],
			"phase": layer["phase"],
			"tilt": layer["tilt"]
		})

	_flame_particles.append(_make_fire_particles(
		"DemonFireCore",
		Vector3(0.0, 0.54, -0.08),
		fire_texture,
		42,
		0.68,
		Vector2(0.22, 0.46),
		Vector2(0.55, 0.9),
		0.2,
		0.1,
		1.45,
		Vector2(0.16, 0.34),
		Color(1.0, 0.56, 0.12, 0.82),
		Color(1.0, 0.32, 0.035),
		2.9
	))
	_flame_particles.append(_make_fire_particles(
		"DemonFireLicks",
		Vector3(0.0, 0.72, -0.1),
		fire_texture,
		30,
		0.95,
		Vector2(0.16, 0.34),
		Vector2(0.42, 0.74),
		0.34,
		0.18,
		1.9,
		Vector2(0.1, 0.24),
		Color(1.0, 0.24, 0.03, 0.62),
		Color(1.0, 0.16, 0.02),
		2.1
	))
	_flame_particles.append(_make_fire_particles(
		"DemonFireEmbers",
		Vector3(0.0, 0.62, -0.04),
		ember_texture,
		24,
		1.2,
		Vector2(0.06, 0.12),
		Vector2(0.26, 0.44),
		0.42,
		0.4,
		1.25,
		Vector2(0.035, 0.08),
		Color(1.0, 0.42, 0.06, 0.88),
		Color(1.0, 0.22, 0.035),
		3.2
	))
	_flame_particles.append(_make_fire_particles(
		"DemonFireSmoke",
		Vector3(0.0, 0.88, 0.02),
		smoke_texture,
		14,
		1.35,
		Vector2(0.05, 0.16),
		Vector2(0.18, 0.32),
		0.36,
		0.05,
		0.52,
		Vector2(0.2, 0.42),
		Color(0.11, 0.08, 0.07, 0.28),
		Color(0.18, 0.055, 0.025),
		0.45,
		BaseMaterial3D.BLEND_MODE_MIX
	))

	_flame_light = OmniLight3D.new()
	_flame_light.name = "DemonFireLight"
	_flame_light.light_color = Color(1.0, 0.44, 0.13)
	_flame_light.light_energy = 1.35
	_flame_light.omni_range = 3.25
	_flame_light.position = Vector3(0.0, 0.82, 0.14)
	_visual_root.add_child(_flame_light)

func _make_flame_sprite(texture: Texture2D) -> Sprite3D:
	var sprite := Sprite3D.new()
	sprite.texture = texture
	sprite.pixel_size = 0.0018
	sprite.shaded = false
	sprite.double_sided = true
	sprite.billboard = BaseMaterial3D.BILLBOARD_DISABLED
	sprite.texture_filter = BaseMaterial3D.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS
	sprite.alpha_cut = SpriteBase3D.ALPHA_CUT_DISABLED
	return sprite

func _make_fire_particles(
	particle_name: String,
	particle_position: Vector3,
	texture: Texture2D,
	amount: int,
	lifetime: float,
	size: Vector2,
	speed: Vector2,
	emission_radius: float,
	swirl: float,
	lift: float,
	scale_range: Vector2,
	albedo: Color,
	emission: Color,
	emission_energy: float,
	blend_mode: BaseMaterial3D.BlendMode = BaseMaterial3D.BLEND_MODE_ADD
) -> GPUParticles3D:
	var particles := GPUParticles3D.new()
	particles.name = particle_name
	particles.position = particle_position
	particles.amount = amount
	particles.lifetime = lifetime
	particles.preprocess = lifetime
	particles.fixed_fps = 60
	particles.explosiveness = 0.0
	particles.randomness = 0.68
	particles.transform_align = 3
	particles.emitting = true

	var quad := QuadMesh.new()
	quad.size = size
	particles.draw_pass_1 = quad
	particles.material_override = _make_particle_material(texture, albedo, emission, emission_energy, blend_mode)

	var process := ParticleProcessMaterial.new()
	process.emission_shape = 1
	process.emission_sphere_radius = emission_radius
	process.direction = Vector3(0.0, 1.0, 0.0)
	process.spread = 18.0
	process.initial_velocity_min = speed.x
	process.initial_velocity_max = speed.y
	process.gravity = Vector3(0.0, lift, 0.0)
	process.scale_min = scale_range.x
	process.scale_max = scale_range.y
	process.set("orbit_velocity", Vector2(-swirl, swirl))
	process.set("radial_accel", Vector2(-0.12, 0.18))
	process.alpha_curve = _make_particle_alpha_curve()
	process.scale_curve = _make_particle_scale_curve()
	particles.process_material = process

	_visual_root.add_child(particles)
	return particles

func _make_particle_material(
	texture: Texture2D,
	albedo: Color,
	emission: Color,
	emission_energy: float,
	blend_mode: BaseMaterial3D.BlendMode
) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	material.albedo_texture = texture
	material.albedo_color = albedo
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	material.blend_mode = blend_mode
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.cull_mode = BaseMaterial3D.CULL_DISABLED
	material.emission_enabled = true
	material.emission_texture = texture
	material.emission = emission
	material.emission_energy_multiplier = emission_energy
	return material

func _make_particle_alpha_curve() -> CurveTexture:
	var curve := Curve.new()
	curve.add_point(Vector2(0.0, 0.0))
	curve.add_point(Vector2(0.14, 1.0))
	curve.add_point(Vector2(0.72, 0.62))
	curve.add_point(Vector2(1.0, 0.0))
	var texture := CurveTexture.new()
	texture.curve = curve
	return texture

func _make_particle_scale_curve() -> CurveTexture:
	var curve := Curve.new()
	curve.add_point(Vector2(0.0, 0.42))
	curve.add_point(Vector2(0.28, 1.0))
	curve.add_point(Vector2(1.0, 0.2))
	var texture := CurveTexture.new()
	texture.curve = curve
	return texture

func _make_soft_particle_texture(inner: Color, outer: Color, core_radius: float) -> Texture2D:
	var image := Image.create(FLAME_DISC_TEXTURE_SIZE, FLAME_DISC_TEXTURE_SIZE, false, Image.FORMAT_RGBA8)
	var center := Vector2(FLAME_DISC_TEXTURE_SIZE - 1, FLAME_DISC_TEXTURE_SIZE - 1) * 0.5
	var radius := float(FLAME_DISC_TEXTURE_SIZE - 1) * 0.5
	for y in FLAME_DISC_TEXTURE_SIZE:
		for x in FLAME_DISC_TEXTURE_SIZE:
			var offset := (Vector2(x, y) - center) / radius
			offset.y *= 1.12
			var distance := offset.length()
			var fade: float = clampf(1.0 - smoothstep(core_radius, 1.0, distance), 0.0, 1.0)
			var heat: float = clampf(1.0 - distance * 1.2, 0.0, 1.0)
			var color := outer.lerp(inner, pow(heat, 0.7))
			color.a *= fade * fade
			image.set_pixel(x, y, color)
	image.generate_mipmaps()
	return ImageTexture.create_from_image(image)

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

func _animate_wings(delta: float) -> void:
	if _left_wing_pivot == null or _right_wing_pivot == null:
		return
	var movement_speed: float = Vector2(velocity.x, velocity.z).length()
	var movement_ratio: float = clampf(movement_speed / MOVE_SPEED, 0.0, 1.0)
	var idle_ratio: float = 1.0 - movement_ratio
	_wing_time += delta * (3.1 + movement_ratio * 5.0)
	var flap: float = sin(_wing_time) * (IDLE_WING_FLAP + movement_ratio * 6.0)
	var lift: float = sin(_wing_time + PI * 0.5) * (IDLE_WING_LIFT + movement_ratio * 1.8)
	var fold: float = sin(_wing_time * 0.47 + 0.6) * IDLE_WING_FOLD * idle_ratio
	_left_wing_pivot.rotation_degrees = _left_wing_base_rotation + Vector3(-lift, -flap, -fold - movement_ratio * 2.5)
	_right_wing_pivot.rotation_degrees = _right_wing_base_rotation + Vector3(-lift, flap, fold + movement_ratio * 2.5)
	if _left_wing_sprite != null and _right_wing_sprite != null:
		var wing_spread: float = sin(_wing_time) * 0.055 * idle_ratio
		var wing_bob: float = sin(_wing_time + PI * 0.5) * 0.04 * idle_ratio
		var wing_scale: float = 1.0 + sin(_wing_time * 0.72 + 0.4) * 0.035 * idle_ratio
		_left_wing_sprite.position = _left_wing_base_position + Vector3(-wing_spread, wing_bob, 0.0)
		_right_wing_sprite.position = _right_wing_base_position + Vector3(wing_spread, wing_bob, 0.0)
		_left_wing_sprite.scale = _left_wing_base_scale * wing_scale
		_right_wing_sprite.scale = _right_wing_base_scale * wing_scale

func _animate_flames(delta: float) -> void:
	if _flame_sprites.is_empty() and _flame_glow_sprites.is_empty():
		return
	var movement_ratio: float = clampf(Vector2(velocity.x, velocity.z).length() / MOVE_SPEED, 0.0, 1.0)
	_flame_time += delta * (6.4 + movement_ratio * 2.6)
	for flame_data in _flame_sprites:
		var sprite := flame_data["sprite"] as Sprite3D
		if sprite == null:
			continue
		var phase: float = float(flame_data["phase"])
		var pulse := sin(_flame_time + phase)
		var lick := sin(_flame_time * 1.73 + phase * 0.61)
		var base_position: Vector3 = flame_data["position"]
		var base_scale: Vector3 = flame_data["scale"]
		var alpha: float = float(flame_data["alpha"])
		var tilt: float = float(flame_data["tilt"])
		sprite.position = base_position + Vector3(lick * 0.028, absf(pulse) * 0.065, 0.0)
		sprite.scale = base_scale * (1.0 + pulse * 0.11 + movement_ratio * 0.05)
		sprite.rotation_degrees.z = tilt + lick * 7.0
		sprite.modulate = Color(1.0, 0.42 + absf(lick) * 0.26, 0.07, alpha + absf(pulse) * 0.08)
	for glow_data in _flame_glow_sprites:
		var glow := glow_data["sprite"] as Sprite3D
		if glow == null:
			continue
		var glow_phase: float = float(glow_data["phase"])
		var breath := sin(_flame_time * 0.78 + glow_phase)
		var flicker := sin(_flame_time * 2.15 + glow_phase * 0.73)
		var glow_position: Vector3 = glow_data["position"]
		var glow_scale: Vector3 = glow_data["scale"]
		var glow_alpha: float = float(glow_data["alpha"])
		var glow_tilt: float = float(glow_data["tilt"])
		glow.position = glow_position + Vector3(flicker * 0.025, absf(breath) * 0.045, 0.0)
		glow.scale = glow_scale * (1.0 + breath * 0.08 + absf(flicker) * 0.05)
		glow.rotation_degrees.z = glow_tilt + flicker * 5.5
		glow.modulate = Color(1.0, 0.32 + absf(flicker) * 0.16, 0.045, glow_alpha + absf(breath) * 0.08)
	if _flame_light != null:
		var light_flicker := absf(sin(_flame_time * 1.2)) * 0.42 + absf(sin(_flame_time * 3.7)) * 0.16
		_flame_light.light_energy = 1.15 + light_flicker + movement_ratio * 0.25

func _update_possession_flash(delta: float) -> void:
	if _possession_flash_timer <= 0.0:
		return
	_possession_flash_timer = maxf(_possession_flash_timer - delta, 0.0)
	var fade := clampf(_possession_flash_timer / POSSESSION_FLASH_DURATION, 0.0, 1.0)
	var flicker := 0.65 + 0.35 * absf(sin(Time.get_ticks_msec() * 0.026))
	_apply_possession_flash_tint(fade * flicker)
	if _possession_flash_timer <= 0.0:
		var current_facing := _visual_facing
		_visual_facing = -1
		_apply_visual_facing(current_facing)
		if _flame_light != null:
			_flame_light.light_color = Color(1.0, 0.44, 0.13)

func _apply_possession_flash_tint(intensity: float) -> void:
	intensity = clampf(intensity, 0.0, 1.0)
	var demon_red := Color(1.0, 0.02, 0.0, 1.0)
	if _body_sprite != null:
		_body_sprite.modulate = _base_body_modulate().lerp(demon_red, intensity)
	if _left_wing_sprite != null:
		_left_wing_sprite.modulate = _base_wing_modulate(-1).lerp(demon_red, intensity)
	if _right_wing_sprite != null:
		_right_wing_sprite.modulate = _base_wing_modulate(1).lerp(demon_red, intensity)
	if _flame_light != null:
		_flame_light.light_color = Color(1.0, 0.04 + 0.4 * (1.0 - intensity), 0.02)
		_flame_light.light_energy = maxf(_flame_light.light_energy, 1.4 + intensity * 3.8)

func _base_body_modulate() -> Color:
	if _visual_facing == FACING_BACK and _body_back_texture == null:
		return Color(0.34, 0.22, 0.22, 1.0)
	return Color(1.08, 0.95, 0.95, 1.0)

func _base_wing_modulate(side: int) -> Color:
	if _visual_facing == FACING_LEFT and side > 0:
		return Color(0.72, 0.58, 0.58, 1.0)
	if _visual_facing == FACING_RIGHT and side < 0:
		return Color(0.72, 0.58, 0.58, 1.0)
	return Color(1.0, 0.88, 0.88, 1.0)

func _animate_hover() -> void:
	if _visual_root == null:
		return
	var movement_ratio: float = clampf(Vector2(velocity.x, velocity.z).length() / MOVE_SPEED, 0.0, 1.0)
	var bob_speed: float = 0.006 + movement_ratio * 0.002
	_visual_root.position.y = DEMON_HOVER_HEIGHT + sin(Time.get_ticks_msec() * bob_speed) * DEMON_HOVER_BOB

func _face_visuals_to_camera() -> void:
	if _visual_root == null or _camera == null:
		return
	var offset := _camera.global_position - global_position
	offset.y = 0.0
	if offset.length_squared() <= 0.001:
		return
	_visual_root.rotation.y = atan2(offset.x, offset.z)

func _update_visual_facing(direction: Vector2) -> void:
	var next_facing := FACING_FRONT
	if absf(direction.x) > absf(direction.y) * 1.15:
		if direction.x < 0.0:
			next_facing = FACING_LEFT
		else:
			next_facing = FACING_RIGHT
	elif direction.y < 0.0:
		next_facing = FACING_BACK
	_apply_visual_facing(next_facing)

func _apply_visual_facing(next_facing: int) -> void:
	if next_facing == _visual_facing and _body_sprite != null:
		return
	_visual_facing = next_facing
	if _body_sprite == null or _left_wing_pivot == null or _right_wing_pivot == null:
		return

	_body_sprite.flip_h = false
	_body_sprite.texture = DEMON_BODY_TEXTURE
	_body_sprite.scale = Vector3.ONE
	_body_sprite.position = Vector3(0.0, 1.08, 0.0)
	_body_sprite.rotation_degrees.x = -10.0
	_body_sprite.modulate = Color(1.08, 0.95, 0.95, 1.0)
	_left_wing_sprite.texture = DEMON_LEFT_WING_TEXTURE
	_right_wing_sprite.texture = DEMON_RIGHT_WING_TEXTURE
	_left_wing_sprite.scale = Vector3.ONE
	_right_wing_sprite.scale = Vector3.ONE
	_left_wing_sprite.modulate = Color(1.0, 0.88, 0.88, 1.0)
	_right_wing_sprite.modulate = Color(1.0, 0.88, 0.88, 1.0)
	_left_wing_sprite.position = Vector3(-0.54, -0.28, -0.08)
	_right_wing_sprite.position = Vector3(0.5, -0.28, -0.1)
	_left_wing_pivot.position = Vector3(-0.3, 1.35, -0.16)
	_right_wing_pivot.position = Vector3(0.22, 1.35, -0.18)
	_left_wing_base_rotation = Vector3(-10.0, -28.0, -11.0)
	_right_wing_base_rotation = Vector3(-10.0, 32.0, 12.0)

	match next_facing:
		FACING_BACK:
			if _body_back_texture != null:
				_body_sprite.texture = _body_back_texture
			_body_sprite.position = Vector3(0.0, 1.08, -0.02)
			_body_sprite.scale = Vector3(0.9, 1.0, 1.0)
			if _body_back_texture == null:
				_body_sprite.modulate = Color(0.34, 0.22, 0.22, 1.0)
			_left_wing_pivot.position = Vector3(-0.36, 1.35, 0.03)
			_right_wing_pivot.position = Vector3(0.28, 1.35, 0.03)
			_left_wing_sprite.position = Vector3(-0.62, -0.22, 0.02)
			_right_wing_sprite.position = Vector3(0.56, -0.22, 0.02)
			_left_wing_base_rotation = Vector3(-4.0, -12.0, -3.0)
			_right_wing_base_rotation = Vector3(-4.0, 12.0, 3.0)
		FACING_LEFT:
			_body_sprite.flip_h = true
			_body_sprite.scale = Vector3(0.88, 1.0, 1.0)
			_left_wing_pivot.position = Vector3(-0.28, 1.34, -0.04)
			_right_wing_pivot.position = Vector3(0.08, 1.28, -0.24)
			_left_wing_sprite.position = Vector3(-0.38, -0.25, 0.02)
			_right_wing_sprite.position = Vector3(0.28, -0.24, -0.06)
			_right_wing_sprite.scale = Vector3(0.78, 0.88, 1.0)
			_right_wing_sprite.modulate = Color(0.72, 0.58, 0.58, 1.0)
			_left_wing_base_rotation = Vector3(-8.0, -24.0, -9.0)
			_right_wing_base_rotation = Vector3(-12.0, 10.0, 3.0)
		FACING_RIGHT:
			_body_sprite.scale = Vector3(0.88, 1.0, 1.0)
			_left_wing_pivot.position = Vector3(-0.08, 1.28, -0.24)
			_right_wing_pivot.position = Vector3(0.28, 1.34, -0.04)
			_left_wing_sprite.position = Vector3(-0.28, -0.24, -0.06)
			_right_wing_sprite.position = Vector3(0.38, -0.25, 0.02)
			_left_wing_sprite.scale = Vector3(0.78, 0.88, 1.0)
			_left_wing_sprite.modulate = Color(0.72, 0.58, 0.58, 1.0)
			_left_wing_base_rotation = Vector3(-12.0, -10.0, -3.0)
			_right_wing_base_rotation = Vector3(-8.0, 24.0, 9.0)
	_left_wing_base_position = _left_wing_sprite.position
	_right_wing_base_position = _right_wing_sprite.position
	_left_wing_base_scale = _left_wing_sprite.scale
	_right_wing_base_scale = _right_wing_sprite.scale

func _material(albedo: Color, emission: Color = Color.BLACK, emission_energy: float = 0.0) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	material.albedo_color = albedo
	if emission_energy > 0.0:
		material.emission_enabled = true
		material.emission = emission
		material.emission_energy_multiplier = emission_energy
	return material

func _transparent_material(albedo: Color) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	material.albedo_color = albedo
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	return material
