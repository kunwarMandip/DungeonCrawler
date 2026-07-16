extends Node
class_name ShooterComponent

var _bullet_container:Node2D

@export var bullet_scene: PackedScene
@export var fire_rate: float = 0.2
@export var bullet_damage: float = 20.0

var can_shoot: bool = true
var _fire_timer: Timer

signal fired(bullet: Node)

func _ready() -> void:
	_fire_timer = Timer.new()
	_fire_timer.one_shot = true
	_fire_timer.wait_time = fire_rate
	_fire_timer.timeout.connect(func():can_shoot = true)
	add_child(_fire_timer)

func setup(container: Node2D) -> void:
	_bullet_container = container 

func shoot(muzzle_position: Vector2, muzzle_rotation: float) -> void:
	if not can_shoot:
		print("cant shoot")
		return
	
	if bullet_scene == null:
		print("not found")
		return
	
	can_shoot = false
	_fire_timer.start()
	var bullet := bullet_scene.instantiate()
	_bullet_container.add_child(bullet)
	bullet.global_position = muzzle_position
	bullet.global_rotation = muzzle_rotation
	bullet.set_meta("damage", bullet_damage)
	fired.emit(bullet)
	
#func shoot() -> void:
	#if not can_shoot:
		#print("cant shoot")
		#return
	#
	#if bullet_scene == null or _aim == null:
		#print("not found")
		#return
	#
	#can_shoot = false
	#_fire_timer.start()
	#var bullet := bullet_scene.instantiate()
	#_bullet_container.add_child(bullet)
	#bullet.global_position = _aim.get_muzzle_position()
	#bullet.global_rotation = _aim.get_aim_rotation()
	#bullet.set_meta("damage", bullet_damage)
	#fired.emit(bullet)
