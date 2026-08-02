extends Node
class_name ProjectilePool

@export var prewarm: Dictionary[PackedScene, int] = {}

var _pools: Dictionary[PackedScene, Array] = {}

func _ready() -> void:
	add_to_group("projectile_pool")
	for scene in prewarm:
		_pools[scene] = []
		for i in prewarm[scene]:
			_pools[scene].append(_instantiate(scene))

func get_projectile(scene: PackedScene) -> Projectile:
	if not _pools.has(scene):
		_pools[scene] = []
	
	var pool: Array = _pools[scene]
	var projectile: Projectile
	
	while not pool.is_empty():
		var candidate = pool.pop_back()
		if is_instance_valid(candidate):
			projectile = candidate
			break
			
	if projectile == null:
		projectile = _instantiate(scene)
	
	return projectile
	
func release(projectile: Projectile) -> void:
	var scene: PackedScene = projectile.source_scene
	if not _pools.has(scene):
		_pools[scene] = []
	_pools[scene].append(projectile)
	
func _instantiate(scene: PackedScene) -> Projectile:
	var projectile := scene.instantiate() as Projectile
	projectile.pool = self
	projectile.source_scene = scene
	add_child(projectile)
	projectile.deactivate()
	return projectile
