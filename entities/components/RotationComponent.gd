extends Node
class_name RotationComponent

@export var target_body: Node2D
@export var rotation_speed: float = 20.0

@export var follow_mouse: bool = true

var _has_target: bool = false
var _aim_point: Vector2

func set_aim_target(point: Vector2) -> void:
	_aim_point = point
	_has_target = true

func clear_aim_target() -> void:
	_has_target = false

func _process(delta: float) -> void:
	if not _has_target:
		return
		
	var desired := (_aim_point - target_body.global_position).angle()
	target_body.global_rotation = lerp_angle(target_body.global_rotation, desired, rotation_speed * delta)
