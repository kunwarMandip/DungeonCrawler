extends Resource
class_name AttackInfo

@export var damage_amount: float = 10.0
@export var team: Teams.Team
@export var allow_self_damage: bool = false

var owner_entity: Node2D

func _init(p_damange_amount: float, p_team: Teams.Team, p_owner: Node2D, p_allow_self_damage: bool = false) -> void:
	damage_amount = p_damange_amount
	team = p_team
	owner_entity = p_owner
	allow_self_damage = p_allow_self_damage
