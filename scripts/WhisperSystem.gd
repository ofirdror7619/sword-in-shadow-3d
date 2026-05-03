extends Node
class_name SISWhisperSystem

signal offer_presented(offer: Dictionary)
signal offer_closed
signal directive_started(directive: Dictionary)
signal directive_updated(progress_text: String, time_ratio: float)
signal directive_closed
signal corruption_changed(corruption: float, ratio: float)
signal reaction_requested(text: String)
signal effect_requested(effect_id: String, data: Dictionary)

const MAX_CORRUPTION := 100.0
const FAST_KILL_WINDOW := 4.8
const OFFER_COOLDOWN := 18.0
const DIRECTIVE_COOLDOWN := 16.0
const FIRST_KILL_CORRUPTION := 6.0
const KILL_CORRUPTION := 2.2
const FAST_KILL_CORRUPTION := 1.8
const DESPERATE_KILL_CORRUPTION := 1.2

var corruption := 0.0
var kill_streak := 0
var kill_streak_timer := 0.0
var active_offer: Dictionary = {}
var active_directive: Dictionary = {}
var offer_cooldown := 8.0
var directive_cooldown := 12.0
var _rng := RandomNumberGenerator.new()
var _late_control_cooldown := 28.0

func _ready() -> void:
	_rng.randomize()
	_emit_corruption()

func update(delta: float, player: Node) -> void:
	offer_cooldown = maxf(offer_cooldown - delta, 0.0)
	directive_cooldown = maxf(directive_cooldown - delta, 0.0)
	_late_control_cooldown = maxf(_late_control_cooldown - delta, 0.0)
	if kill_streak_timer > 0.0:
		kill_streak_timer = maxf(kill_streak_timer - delta, 0.0)
		if kill_streak_timer <= 0.0:
			kill_streak = 0
	_process_directive(delta, player)
	if corruption >= 92.0 and _late_control_cooldown <= 0.0:
		_late_control_cooldown = _rng.randf_range(22.0, 34.0)
		effect_requested.emit("control_lapse", {"duration": 0.9})
		reaction_requested.emit("A moment. I will move us.")
	if active_offer.is_empty() and active_directive.is_empty() and offer_cooldown <= 0.0 and _is_player_desperate(player):
		_present_offer(_choose_offer(player))

func record_kill(total_kills: int, player: Node) -> void:
	if kill_streak_timer > 0.0:
		kill_streak += 1
	else:
		kill_streak = 1
	kill_streak_timer = FAST_KILL_WINDOW
	_add_corruption(_kill_corruption_gain(total_kills, player))
	if kill_streak >= 3:
		_add_corruption(3.0)
		effect_requested.emit("hunger_kill", {})
	if active_directive.is_empty():
		if active_offer.is_empty() and offer_cooldown <= 0.0 and _should_offer(total_kills, player):
			_present_offer(_choose_offer(player))
		elif directive_cooldown <= 0.0 and _should_start_directive(total_kills):
			_start_directive(_choose_directive(player))
	else:
		_record_directive_kill(player)

func record_player_damage(_amount: int, _player: Node) -> void:
	if active_directive.is_empty():
		return
	if active_directive.get("id", "") == "no_mercy":
		_fail_directive("Disappointing.")
	elif active_directive.get("id", "") == "martyr_mark":
		active_directive["progress"] = 1
		_complete_directive()

func accept_offer() -> void:
	if active_offer.is_empty():
		return
	var offer := active_offer.duplicate(true)
	active_offer.clear()
	offer_closed.emit()
	_add_corruption(float(offer.get("corruption", 12.0)))
	effect_requested.emit(String(offer.get("accepted_effect", "")), offer)
	reaction_requested.emit("Good... you're learning.")
	offer_cooldown = OFFER_COOLDOWN + corruption * 0.08
	directive_cooldown = maxf(directive_cooldown - 5.0, 2.0)

func reject_offer() -> void:
	if active_offer.is_empty():
		return
	active_offer.clear()
	offer_closed.emit()
	_add_corruption(-6.0)
	reaction_requested.emit("...you still pretend.")
	offer_cooldown = OFFER_COOLDOWN * 0.72

func get_corruption_ratio() -> float:
	return clampf(corruption / MAX_CORRUPTION, 0.0, 1.0)

func _kill_corruption_gain(total_kills: int, player: Node) -> float:
	var gain := FIRST_KILL_CORRUPTION if total_kills == 1 else KILL_CORRUPTION
	if kill_streak >= 2:
		gain += FAST_KILL_CORRUPTION
	if _is_player_desperate(player):
		gain += DESPERATE_KILL_CORRUPTION
	return gain

func _should_offer(total_kills: int, player: Node) -> bool:
	if total_kills <= 1:
		return false
	if _is_player_desperate(player):
		return true
	if kill_streak >= 3:
		return true
	if corruption >= 35.0 and _rng.randf() < 0.42:
		return true
	return total_kills % 5 == 0

func _should_start_directive(total_kills: int) -> bool:
	if total_kills < 2:
		return false
	var chance := 0.22 + get_corruption_ratio() * 0.45
	return _rng.randf() <= chance

func _is_player_desperate(player: Node) -> bool:
	if player == null:
		return false
	var life := float(player.get("life"))
	var max_life := maxf(float(player.get("max_life")), 1.0)
	return life / max_life <= 0.28

func _choose_offer(player: Node) -> Dictionary:
	var offers := _offers()
	if _is_player_desperate(player):
		return offers[3]
	if corruption >= 55.0 and _rng.randf() < 0.45:
		return offers[2]
	return offers[_rng.randi_range(0, offers.size() - 1)]

func _offers() -> Array[Dictionary]:
	return [
		{
			"id": "blood_surge",
			"title": "Blood Surge",
			"description": "Take what they have left behind...",
			"reward": "Killing power rises for a short time.",
			"cost_hint": "...you will not remain unchanged.",
			"accepted_effect": "blood_surge",
			"corruption": 14.0
		},
		{
			"id": "shared_sight",
			"title": "Shared Sight",
			"description": "Let me see for you...",
			"reward": "Every remaining enemy is marked on the map.",
			"cost_hint": "...your sight will learn my shape.",
			"accepted_effect": "shared_sight",
			"corruption": 12.0
		},
		{
			"id": "hunger_unbound",
			"title": "Hunger Unbound",
			"description": "Do not stop...",
			"reward": "Each quick kill pulls the next one closer.",
			"cost_hint": "...stillness will remember you.",
			"accepted_effect": "hunger_unbound",
			"corruption": 16.0
		},
		{
			"id": "borrowed_life",
			"title": "Borrowed Life",
			"description": "You don't need all of it...",
			"reward": "Your body is made whole at once.",
			"cost_hint": "...some debts are paid in flesh.",
			"accepted_effect": "borrowed_life",
			"corruption": 18.0
		},
		{
			"id": "borrowed_hands",
			"title": "Borrowed Hands",
			"description": "Let me do the killing cleanly...",
			"reward": "Your strikes become violent for a short time.",
			"cost_hint": "...your hands may answer before you do.",
			"accepted_effect": "borrowed_hands",
			"corruption": 20.0
		},
		{
			"id": "open_wound",
			"title": "Open Wound",
			"description": "Pain is a door. Hold it open.",
			"reward": "Gain fierce lifesteal for a short time.",
			"cost_hint": "...your body will have less room for you.",
			"accepted_effect": "open_wound",
			"corruption": 18.0
		}
	]

func _present_offer(offer: Dictionary) -> void:
	active_offer = offer.duplicate(true)
	offer_presented.emit(active_offer)

func _choose_directive(player: Node) -> Dictionary:
	var directives := _directives()
	if _is_player_desperate(player) and _rng.randf() < 0.5:
		return directives[2]
	if corruption >= 65.0 and _rng.randf() < 0.35:
		return directives[3]
	return directives[_rng.randi_range(0, directives.size() - 1)]

func _directives() -> Array[Dictionary]:
	return [
		{
			"id": "relentless",
			"text": "Kill 5 without pause.",
			"duration": 18.0,
			"target": 5,
			"progress": 0,
			"reward_effect": "relentless_reward",
			"failure_effect": "relentless_fail"
		},
		{
			"id": "no_mercy",
			"text": "Do not take damage for 15 seconds.",
			"duration": 15.0,
			"target": 15,
			"progress": 0,
			"reward_effect": "no_mercy_reward",
			"failure_effect": "no_mercy_fail"
		},
		{
			"id": "gluttony",
			"text": "Kill while below 30% health.",
			"duration": 20.0,
			"target": 1,
			"progress": 0,
			"reward_effect": "gluttony_reward",
			"failure_effect": "gluttony_fail"
		},
		{
			"id": "obedience",
			"text": "Stand still... and wait.",
			"duration": 8.0,
			"target": 4.0,
			"progress": 0.0,
			"reward_effect": "obedience_reward",
			"failure_effect": "obedience_fail"
		},
		{
			"id": "martyr_mark",
			"text": "Bleed for me.",
			"duration": 10.0,
			"target": 1,
			"progress": 0,
			"reward_effect": "martyr_mark_reward",
			"failure_effect": "martyr_mark_fail"
		}
	]

func _start_directive(directive: Dictionary) -> void:
	active_directive = directive.duplicate(true)
	active_directive["elapsed"] = 0.0
	active_directive["stand_time"] = 0.0
	directive_started.emit(active_directive)
	_emit_directive_progress()
	reaction_requested.emit("Do this. Prove you are mine.")

func _record_directive_kill(player: Node) -> void:
	var id := String(active_directive.get("id", ""))
	if id == "relentless":
		active_directive["progress"] = int(active_directive.get("progress", 0)) + 1
		if int(active_directive["progress"]) >= int(active_directive.get("target", 1)):
			_complete_directive()
	elif id == "gluttony":
		var life := float(player.get("life"))
		var max_life := maxf(float(player.get("max_life")), 1.0)
		if life / max_life <= 0.3:
			active_directive["progress"] = 1
			_complete_directive()
	_emit_directive_progress()

func _process_directive(delta: float, player: Node) -> void:
	if active_directive.is_empty():
		return
	active_directive["elapsed"] = float(active_directive.get("elapsed", 0.0)) + delta
	var id := String(active_directive.get("id", ""))
	if id == "no_mercy" and float(active_directive["elapsed"]) >= float(active_directive.get("duration", 1.0)):
		_complete_directive()
		return
	if id == "obedience":
		if _is_player_still(player):
			active_directive["stand_time"] = float(active_directive.get("stand_time", 0.0)) + delta
		else:
			active_directive["stand_time"] = maxf(float(active_directive.get("stand_time", 0.0)) - delta * 1.8, 0.0)
		active_directive["progress"] = active_directive["stand_time"]
		if float(active_directive["stand_time"]) >= float(active_directive.get("target", 4.0)):
			_complete_directive()
			return
	if float(active_directive["elapsed"]) >= float(active_directive.get("duration", 1.0)):
		_fail_directive("Disappointing.")
		return
	_emit_directive_progress()

func _is_player_still(player: Node) -> bool:
	if player == null:
		return false
	var velocity_value: Variant = player.get("velocity")
	if velocity_value is Vector3:
		var horizontal := Vector2(velocity_value.x, velocity_value.z)
		if horizontal.length() > 0.18:
			return false
	return not bool(player.get("has_move_target"))

func _complete_directive() -> void:
	var directive := active_directive.duplicate(true)
	active_directive.clear()
	directive_closed.emit()
	_add_corruption(8.0 + get_corruption_ratio() * 4.0)
	effect_requested.emit(String(directive.get("reward_effect", "")), directive)
	reaction_requested.emit("Yes. Just like that.")
	directive_cooldown = DIRECTIVE_COOLDOWN

func _fail_directive(reaction: String) -> void:
	var directive := active_directive.duplicate(true)
	active_directive.clear()
	directive_closed.emit()
	_add_corruption(-4.0)
	effect_requested.emit(String(directive.get("failure_effect", "")), directive)
	reaction_requested.emit(reaction)
	directive_cooldown = DIRECTIVE_COOLDOWN * 0.82

func _emit_directive_progress() -> void:
	if active_directive.is_empty():
		return
	var id := String(active_directive.get("id", ""))
	var progress_text := ""
	if id == "no_mercy":
		var remaining := maxf(float(active_directive.get("duration", 0.0)) - float(active_directive.get("elapsed", 0.0)), 0.0)
		progress_text = "%.0fs" % remaining
	else:
		progress_text = "%s/%s" % [
			int(ceil(float(active_directive.get("progress", 0.0)))),
			int(ceil(float(active_directive.get("target", 1.0))))
		]
	var ratio := 1.0 - clampf(float(active_directive.get("elapsed", 0.0)) / maxf(float(active_directive.get("duration", 1.0)), 1.0), 0.0, 1.0)
	directive_updated.emit(progress_text, ratio)

func _add_corruption(amount: float) -> void:
	corruption = clampf(corruption + amount, 0.0, MAX_CORRUPTION)
	_emit_corruption()

func _emit_corruption() -> void:
	corruption_changed.emit(corruption, get_corruption_ratio())
