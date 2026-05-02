extends RefCounted
class_name ProgressionConfig

const MAX_PLAYER_LEVEL := 100
const ENEMY_XP_NORMAL := 1.0
const ENEMY_XP_ELITE := 4.0
const ENEMY_XP_MINI_BOSS := 12.0
const ENEMY_XP_BOSS := 35.0

static func xp_to_next(level: int) -> int:
	var clean_level := clampi(level, 1, MAX_PLAYER_LEVEL)
	if clean_level >= MAX_PLAYER_LEVEL:
		return 0
	return maxi(1, int(82.0 * pow(float(clean_level), 1.58)))

static func enemy_xp(enemy_level: int, enemy_type_multiplier: float = ENEMY_XP_NORMAL) -> int:
	var clean_level := maxi(enemy_level, 1)
	return maxi(1, int(14.0 * pow(float(clean_level), 1.36) * enemy_type_multiplier))

static func player_hp(level: int) -> int:
	var clean_level := clampi(level, 1, MAX_PLAYER_LEVEL)
	return maxi(1, int(104.0 + 19.0 * float(clean_level) + 2.1 * pow(float(clean_level), 1.32)))

static func player_damage(level: int) -> int:
	var clean_level := clampi(level, 1, MAX_PLAYER_LEVEL)
	return maxi(1, int(12.0 + 2.8 * float(clean_level) + 0.16 * pow(float(clean_level), 1.5)))
