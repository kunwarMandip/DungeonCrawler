extends State
class_name EnemyChase

@onready var enemy: CharacterBody2D = owner

@export var chase_speed: float = 50.0
@export var target_lost_chase_grace_time: float = 2.0

var target_last_position: Vector2
var target_lost_chase_grace_timer: float = 0.0

func Enter() -> void:
	#print("Enemy Chase")
	$"../../StateLabel".text = "Enemy Chase"
func Physics_update(_delta: float) -> void:
	var dir: Vector2 

	if enemy.detection_component.target:
		#enemy.gun.shoot()
		target_lost_chase_grace_timer = 0.0
		target_last_position = enemy.detection_component.target.global_position
		
		dir = enemy.navigation_component.get_direction_to(enemy.detection_component.target.global_position)
		enemy.velocity = dir * chase_speed
		enemy.move_and_slide()
		return
	
	target_lost_chase_grace_timer += _delta
	if target_lost_chase_grace_timer >= target_lost_chase_grace_time:
		Transitioned.emit(self, "EnemyIdle")
		return
	
	dir = enemy.navigation_component.get_direction_to(target_last_position)
	enemy.velocity = dir * chase_speed
	enemy.move_and_slide()
