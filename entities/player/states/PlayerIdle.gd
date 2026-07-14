extends State
class_name PlayerIdle

@onready var player: CharacterBody2D = owner

func Enter() -> void:
	pass

func Physics_update(_delta: float) -> void:
	player.velocity = Vector2.ZERO
	player.move_and_slide()
	
	if player.input_component.movement != Vector2.ZERO:
		Transitioned.emit(self, "PlayerMove")
