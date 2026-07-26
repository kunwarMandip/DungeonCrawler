extends Node
class_name DamageSourceComponent

@export var damage: float = 20.0
@export var team: Teams.Team = Teams.Team.PLAYER
@export var self_damage: bool = false
var owner_entity: Node2D

func setup(p_owner: Node2D) -> void:
	owner_entity = p_owner

func build_damage_info() -> AttackInfo:
	return AttackInfo.new(damage, team, owner_entity, self_damage)
