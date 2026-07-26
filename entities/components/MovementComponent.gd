extends Node
class_name MovementComponent

@export var owner_body: CharacterBody2D

func move(direction: Vector2, speed: float) -> void:
	owner_body.velocity = direction * speed
	owner_body.move_and_slide()

func stop() -> void:
	owner_body.velocity = Vector2.ZERO
	owner_body.move_and_slide()
	
func get_position() -> Vector2:
	return owner_body.global_position
