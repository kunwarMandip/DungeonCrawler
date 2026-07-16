extends State
class_name EnemyPatrol

@export var patrol_speed: float = 60.0
@onready var enemy: CharacterBody2D = owner

func Enter() -> void:
	#print("Enemy Patrol")
	$"../../StateLabel".text = "Enemy Patrol"
	
func Physics_update(_delta: float) -> void:
	if enemy.detection_component.target:
		Transitioned.emit(self, "EnemyChase")
		return
	
	if not enemy.patrol_component.has_points():
		return
		
	var target_point = enemy.patrol_component.get_current_target()
	var dir = enemy.navigation_component.get_direction_to(target_point)

	enemy.velocity = dir * patrol_speed
	enemy.move_and_slide()

	enemy.patrol_component.check_arrival(enemy.global_position)
