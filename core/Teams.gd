extends Node

enum Team {PLAYER, ENEMY, NEUTRAL}

func is_hostile(a: Team, b: Team) -> bool:
	if a == Team.NEUTRAL or b == Team.NEUTRAL:
		return true
	return a != b
