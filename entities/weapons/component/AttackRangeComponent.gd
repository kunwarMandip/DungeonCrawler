extends Node2D
class_name AttackRangeComponent

@export var attack_range: float = 100.0

func in_range(target_pos: Vector2) -> bool:
	return global_position.distance_to(target_pos) <= attack_range
