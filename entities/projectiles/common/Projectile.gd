extends Node2D
class_name Projectile

var pool: ProjectilePool
var source_scene: PackedScene
var attack_info: AttackInfo

func activate(spawn_position: Vector2, spawn_rotation: float, info: AttackInfo) -> void:
	global_position = spawn_position
	global_rotation = spawn_rotation
	attack_info = info
	visible = true
	set_process(true)
	set_physics_process(true)
	_set_collision_enabled(true)
	_on_activate()
	
func deactivate() -> void:
	visible = false
	set_process(false)
	set_physics_process(false)
	_set_collision_enabled(false)
	_on_deactivate()
	
func return_to_pool() -> void:
	deactivate()
	pool.release(self)
	
func _set_collision_enabled(enabled: bool) -> void:
	for child in find_children("*", "CollisionShape2D", true, false):
		child.set_deferred("disabled", not enabled)
		
	
# Override in subclasses if a projectile type needs custom reset logic
func _on_activate() -> void:
	pass

func _on_deactivate() -> void:
	pass
	
