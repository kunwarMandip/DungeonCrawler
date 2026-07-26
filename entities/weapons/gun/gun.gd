extends Node2D

@export var muzzle: Marker2D
@onready var rotation_component: RotationComponent = $RotationComponent
@onready var projectile_spawner: ProjectileSpawner = $ProjectileSpawner
@onready var fire_rate_component: FireRateComponent = $FireRateComponent
@onready var attack_range_component: AttackRangeComponent = $AttackRangeComponent
@onready var damage_source_component: DamageSourceComponent = $DamageSourceComponent

var projectile_owner: Node2D

func setup(p_projectile_owner: Node2D):
	projectile_owner = p_projectile_owner

func aim_at(target_position: Vector2) -> void:
	rotation_component.set_aim_target(target_position)
	
func shoot() -> void:
	if not fire_rate_component.can_shoot():
		return
	
	projectile_spawner.spawn(muzzle.global_position, muzzle.global_rotation, damage_source_component.build_damage_info())
	
