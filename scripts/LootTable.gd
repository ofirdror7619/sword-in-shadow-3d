extends RefCounted
class_name SISLootTable

const TYPE_GOLD := "gold"
const TYPE_DIAMOND := "diamond"
const TYPE_RELIC := "relic"
const TYPE_SPELL := "spell"

const TIER_FADED := "faded"
const TIER_WHISPERING := "whispering"
const TIER_CORRUPTED := "corrupted"
const TIER_ABYSSAL := "abyssal"
const TIER_DIVINE := "divine"

const DIAMOND_TIERS := [
	{"id": TIER_FADED, "name": "Faded", "weight": 780.0, "min_level": 1, "min_toughness": 0.0},
	{"id": TIER_WHISPERING, "name": "Whispering", "weight": 155.0, "min_level": 2, "min_toughness": 0.9},
	{"id": TIER_CORRUPTED, "name": "Corrupted", "weight": 48.0, "min_level": 4, "min_toughness": 1.45},
	{"id": TIER_ABYSSAL, "name": "Abyssal", "weight": 13.0, "min_level": 6, "min_toughness": 2.1},
	{"id": TIER_DIVINE, "name": "Divine", "weight": 1.2, "min_level": 8, "min_toughness": 3.0}
]

static func roll_enemy_loot(
	rng: RandomNumberGenerator,
	player: Node,
	enemy: Node,
	diamond_catalog: Array,
	relic_catalog: Array,
	spell_catalog: Array
) -> Array[Dictionary]:
	var drops: Array[Dictionary] = []
	if rng == null or player == null or enemy == null:
		return drops

	var player_level := maxi(1, int(player.get("level")))
	var loot_luck := _player_loot_luck(player)
	var toughness := _enemy_toughness(enemy, player_level)
	var gold_reward := maxi(1, int(enemy.get("gold_reward")))
	var gold_amount := gold_reward + rng.randi_range(0, 8)
	if rng.randf() < clampf(loot_luck, 0.0, 0.85):
		gold_amount += maxi(1, int(round(float(gold_reward) * 0.5)))
	drops.append({
		"type": TYPE_GOLD,
		"amount": gold_amount,
		"display_name": "%s Gold" % gold_amount,
		"rarity": "common"
	})

	var diamond_chance := clampf(0.075 + toughness * 0.035 + float(player_level - 1) * 0.0045 + loot_luck * 0.38, 0.04, 0.34)
	if rng.randf() < diamond_chance:
		var diamond_drop := _roll_diamond(rng, diamond_catalog, player_level, toughness, loot_luck)
		if not diamond_drop.is_empty():
			drops.append(diamond_drop)

	var relic_chance := clampf(0.003 + toughness * 0.005 + loot_luck * 0.045, 0.0, 0.07)
	if rng.randf() < relic_chance:
		var relic_drop := _roll_relic(rng, relic_catalog)
		if not relic_drop.is_empty():
			drops.append(relic_drop)

	var spell_chance := clampf(0.002 + toughness * 0.004 + float(player_level - 1) * 0.0012 + loot_luck * 0.035, 0.0, 0.055)
	if rng.randf() < spell_chance:
		var spell_drop := _roll_spell(rng, player, spell_catalog)
		if not spell_drop.is_empty():
			drops.append(spell_drop)

	return drops

static func _enemy_toughness(enemy: Node, player_level: int) -> float:
	var enemy_level := maxi(1, int(enemy.get("enemy_level")))
	var max_life := maxf(1.0, float(enemy.get("max_life")))
	var damage := maxf(1.0, float(enemy.get("damage")))
	var xp_reward := maxf(1.0, float(enemy.get("xp_reward")))
	var expected_life := 38.0 + float(maxi(player_level, enemy_level)) * 10.0
	var life_factor := max_life / maxf(1.0, expected_life)
	var damage_factor := damage / maxf(1.0, 8.0 + float(player_level) * 2.0)
	var xp_factor := xp_reward / maxf(1.0, 18.0 + float(player_level) * 7.0)
	var toughness := (life_factor * 0.48) + (damage_factor * 0.28) + (xp_factor * 0.24)
	if bool(enemy.get("elite_enemy")):
		toughness *= 1.75
	return clampf(toughness, 0.35, 4.25)

static func _player_loot_luck(player: Node) -> float:
	if player.has_method("get_socket_loot_luck_bonus"):
		return maxf(0.0, float(player.call("get_socket_loot_luck_bonus")))
	return 0.0

static func _roll_diamond(
	rng: RandomNumberGenerator,
	diamond_catalog: Array,
	player_level: int,
	toughness: float,
	loot_luck: float
) -> Dictionary:
	if diamond_catalog.is_empty():
		return {}
	var source := diamond_catalog[rng.randi_range(0, diamond_catalog.size() - 1)] as Dictionary
	var tier := _roll_diamond_tier(rng, player_level, toughness, loot_luck)
	var tier_id := String(tier.get("id", TIER_FADED))
	var tier_name := String(tier.get("name", "Faded"))
	var source_id := String(source.get("id", ""))
	var base_id := source_id
	if source_id.begins_with("%s_" % TIER_FADED):
		base_id = source_id.substr(("%s_" % TIER_FADED).length())
	if base_id.is_empty():
		return {}
	var item_id := "%s_%s" % [tier_id, base_id]
	var base_name := String(source.get("name", "Diamond")).replace("Faded ", "")
	return {
		"type": TYPE_DIAMOND,
		"id": item_id,
		"tier": tier_id,
		"display_name": "%s %s" % [tier_name, base_name],
		"rarity": tier_id,
		"color": source.get("color", Color(0.9, 0.78, 0.58))
	}

static func _roll_diamond_tier(rng: RandomNumberGenerator, player_level: int, toughness: float, loot_luck: float) -> Dictionary:
	var candidates: Array[Dictionary] = []
	var total_weight := 0.0
	for tier_variant in DIAMOND_TIERS:
		var tier := tier_variant as Dictionary
		var min_level := int(tier.get("min_level", 1))
		var min_toughness := float(tier.get("min_toughness", 0.0))
		if player_level < min_level and toughness < min_toughness:
			continue
		var rarity_index := float(candidates.size())
		var weight := float(tier.get("weight", 0.0))
		var toughness_bonus := maxf(0.08, toughness / maxf(min_toughness, 0.85))
		var luck_bonus := 1.0 + loot_luck * (1.2 + rarity_index * 0.75)
		weight *= clampf(toughness_bonus, 0.08, 2.8) * luck_bonus
		if weight <= 0.0:
			continue
		candidates.append({"tier": tier, "weight": weight})
		total_weight += weight
	if candidates.is_empty():
		return DIAMOND_TIERS[0]
	var roll := rng.randf() * total_weight
	for candidate in candidates:
		roll -= float(candidate["weight"])
		if roll <= 0.0:
			return candidate["tier"] as Dictionary
	return candidates.back()["tier"] as Dictionary

static func _roll_relic(rng: RandomNumberGenerator, relic_catalog: Array) -> Dictionary:
	var candidates: Array[Dictionary] = []
	for relic_variant in relic_catalog:
		if not (relic_variant is Dictionary):
			continue
		var relic := relic_variant as Dictionary
		var relic_id := String(relic.get("id", ""))
		if relic_id.is_empty() or bool(relic.get("mission_only", false)):
			continue
		candidates.append(relic)
	if candidates.is_empty():
		return {}
	var choice := candidates[rng.randi_range(0, candidates.size() - 1)]
	return {
		"type": TYPE_RELIC,
		"id": String(choice.get("id", "")),
		"display_name": String(choice.get("name", "Relic")),
		"rarity": String(choice.get("rarity", "rare")),
		"image": String(choice.get("image", ""))
	}

static func _roll_spell(rng: RandomNumberGenerator, player: Node, spell_catalog: Array) -> Dictionary:
	var candidates: Array[Dictionary] = []
	for spell_variant in spell_catalog:
		if not (spell_variant is Dictionary):
			continue
		var spell := spell_variant as Dictionary
		var spell_id := String(spell.get("id", ""))
		if spell_id.is_empty() or spell_id == "fire_storm":
			continue
		if player.has_method("has_spell") and bool(player.call("has_spell", spell_id)):
			continue
		candidates.append(spell)
	if candidates.is_empty():
		return {}
	var choice := candidates[rng.randi_range(0, candidates.size() - 1)]
	return {
		"type": TYPE_SPELL,
		"id": String(choice.get("id", "")),
		"display_name": String(choice.get("name", "Spell")),
		"rarity": "spell",
		"image": String(choice.get("image", ""))
	}
