extends Area2D
class_name HurtboxComponent

signal hit(attack_info: AttackInfo, source: Node)

@export var owner_entity: Node2D
@export var team: Teams.Team = Teams.Team.NEUTRAL
@export var health_component: HealthComponent

func take_damage(attack_info: AttackInfo, source: Node) -> bool:
	#print("Hurtbox attacked")
	health_component.take_damage(attack_info, source)
	hit.emit(attack_info, source)
	return true
