extends CharacterBody2D

const SPEED: float = 180.0
const MELEE_DAMAGE: float = 25.0
const BULLET_SCENE = preload("uid://ch4tl0p73fb7d")

signal died
signal health_changed(current: float, maximum: float)

var health: float = 100.0
var max_health: float = 100.0
var is_dead: bool = false
var can_shoot: bool = true
var inventory: Inventory = Inventory.new()

@onready var camera_2d: Camera2D = $Camera2D
@onready var hurt_box: Area2D = $HurtBox
@onready var attack_hitbox: Area2D = $AttackHitbox
@onready var shoot_timer: Timer = $ShootTimer
@onready var gun_pivot: Node2D = $GunPivot
@onready var muzzle: Marker2D = $GunPivot/Muzzle

func _ready() -> void:
	add_to_group("player")
	camera_2d.make_current()
	hurt_box.area_entered.connect(_on_hurtbox_entered)
	attack_hitbox.monitoring = false
	shoot_timer.timeout.connect(_on_shoot_timer_timeout)

func _physics_process(_delta: float) -> void:
	if is_dead:
		return
	
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * SPEED
	move_and_slide()
	gun_pivot.look_at(get_global_mouse_position())
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot") and can_shoot and not is_dead:
		_shoot()
	if event.is_action_pressed("melee"):
		_melee_attack()

func _shoot() -> void:
	can_shoot = false
	shoot_timer.start()
	var bullet = BULLET_SCENE.instantiate()
	var current_room := get_tree().current_scene.get_node("CurrentRoom").get_child(0)
	current_room.get_node("ItemDrops").add_child(bullet)
	bullet.global_position = $GunPivot/Muzzle.global_position
	bullet.global_rotation = $GunPivot.global_rotation

func _melee_attack() -> void:
	attack_hitbox.monitoring = true
	await get_tree().create_timer(0.15).timeout
	attack_hitbox.monitoring = false

func take_damage(amount: float) -> void:
	if is_dead:
		return
	
	health = max(0.0, health - amount)
	health_changed.emit(health, max_health)
	_screen_shake()
	if health <= 0:
		_die()

func heal(amount: float) -> void:
	health = min(max_health, health + amount)
	health_changed.emit(health, max_health)
	
func _die() -> void:
	is_dead = true
	died.emit()
	
func _screen_shake() -> void:
	var tween := create_tween()
	for i in 6:
		tween.property(camera_2d, "offset", Vector2(randf_range(-6, 6), randf_range(-6, 6)), 0.04)
		tween.tween_property(camera_2d, "offset", Vector2.ZERO, 0.04)

func _on_hurtbox_entered(area: Area2D) -> void:
	if area.is_in_group("enemey_attack"):
		take_damage(area.get_meta("damage", 10.0))

func _on_shoot_timer_timeout() -> void:
	can_shoot = true

func on_attack_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy_hitbox"):
		area.get_parent().take_damage(MELEE_DAMAGE)
