extends Node2D
class_name AimComponent

func _physics_process(_delta: float) -> void:
	look_at(get_global_mouse_position())

func get_muzzle_position() -> Vector2:
	return $Muzzle.global_position

func get_aim_rotation() -> float:
	return global_rotation
