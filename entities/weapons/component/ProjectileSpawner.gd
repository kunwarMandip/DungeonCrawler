extends Node
class_name ProjectileSpawner

@export var projectile_scene: PackedScene
var _pool: ProjectilePool

func _ready() -> void:
	_pool = get_tree().get_first_node_in_group("projectile_pool") as ProjectilePool
	
func spawn(position: Vector2, rotation: float, info: AttackInfo) -> Node:
	if projectile_scene == null or _pool == null:
		return null
	
	var projectile := _pool.get_projectile(projectile_scene)
	projectile.activate(position, rotation, info)
	return projectile
