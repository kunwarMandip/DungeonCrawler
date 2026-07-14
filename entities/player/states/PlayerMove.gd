extends State
class_name PlayerMove

@onready var player: CharacterBody2D = owner

func Physics_update(_delta: float) -> void:
	player.velocity = player.input_component.movement * player.speed
	player.move_and_slide()
	
	if player.input_component.movement == Vector2.ZERO:
		Transitioned.emit(self, "PlayerIdle")
