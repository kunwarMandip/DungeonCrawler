extends Area2D
class_name HurtboxComponent

signal hit(attack_info: AttackInfo, source: Node)

@export var owner_entity: Node2D
@export var team: Teams.Team = Teams.Team.NEUTRAL

func take_damage(attack_info: AttackInfo, source: Node) -> bool:
	if attack_info.owner_entity == owner_entity and not attack_info.allow_self_damage:
		return false
	if attack_info.owner_entity != owner_entity and not Teams.is_hostile(attack_info.team, team):
		return false
		
	hit.emit(attack_info, source)
	return true
