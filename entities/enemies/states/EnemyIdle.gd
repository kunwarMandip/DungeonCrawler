extends State
class_name EnemyIdle

@onready var enemy: CharacterBody2D = owner

@export var IDLE_TIME: float = 2.5
var idle_timer: float = 0.0

func Enter() -> void:
	print("Enemy Idle")
	
func Physics_update(_delta: float) -> void:
	if enemy.target:
		Transitioned.emit(self, "EnemyChase")
		return
	
	enemy.velocity = Vector2.ZERO
	enemy.move_and_slide()

	idle_timer += _delta
	if idle_timer >= IDLE_TIME:
		Transitioned.emit(self, "EnemyPatrol")
