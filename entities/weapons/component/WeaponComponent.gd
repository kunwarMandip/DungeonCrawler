extends Node
class_name WeaponComponent

signal fired(bullet: Node)

@export var bullet_scene: PackedScene
@export var fire_rate_component: FireRateComponent
var _bullet_container: Node2D

func setup(p_bullet_container: Node2D) -> void:
	_bullet_container = p_bullet_container
	
func try_shoot(muzzle_position: Vector2, muzzle_rotation: float, attack_info: AttackInfo) -> void:
	if  bullet_scene == null or _bullet_container == null:
		return
	
	if fire_rate_component != null and not fire_rate_component.can_shoot():
		return
		
	var bullet := bullet_scene.instantiate()
	_bullet_container.add_child(bullet)
	bullet.global_position = muzzle_position
	bullet.global_rotation = muzzle_rotation
	bullet.setup(attack_info)
	fired.emit(bullet)
	
