extends State
class_name EnemyShoot

@onready var enemy: CharacterBody2D = owner
@onready var gun = enemy.get_node("Gun")

@export var shoot_range_component: DetectionComponent

func Enter() -> void:
	$"../../StateLabel".text = "Enemy Attack"

func Physics_update(_delta: float) -> void:
	var target = shoot_range_component.target
	if not shoot_range_component.target:
		Transitioned.emit(self, "EnemyChase")
		return
	
	#if not enemy.gun.in_range(target.global_position):
		#Transitioned.emit(self, "EnemyChase")
		#return
		
	#gun.aim_at(target.global_position, _delta)
	gun.shoot()
	
