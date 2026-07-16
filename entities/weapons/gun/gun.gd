extends Node2D

@export var muzzle: Marker2D
@onready var shooter_component: ShooterComponent = $ShooterComponent

func setup(projectile_container: Node2D) -> void:
	shooter_component.setup(projectile_container)
	
func _process(_delta: float) -> void:
	look_at(get_global_mouse_position())

func shoot():
	shooter_component.shoot(muzzle.global_position, muzzle.global_rotation)
