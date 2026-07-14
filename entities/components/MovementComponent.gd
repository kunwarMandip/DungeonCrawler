extends Node
class_name MovementComponent

@export var speed: float = 200.0

var _body: CharacterBody2D

func _ready() -> void:
	_body = get_parent() as CharacterBody2D
	if _body == null:
		push_error("MovementComponent must be a child of CharacterBody2D")
	
func move(direction: Vector2) -> void:
	_body.velocity = direction * speed
	_body.move_and_slide()

func stop() -> void:
	_body.velocity = Vector2.ZERO
	_body.move_and_slide()

func set_speed(new_speed: float) -> void:
	speed = new_speed
