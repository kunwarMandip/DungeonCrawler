extends CharacterBody2D

@export var speed: float = 200.0

var inventory: Inventory = Inventory.new()

@onready var camera_2d: Camera2D = $Camera2D
@onready var health_component: HealthComponent = $HealthComponent
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent
@onready var input_component: InputComponent = $InputComponent
@onready var gun: Node2D = $Gun

func _ready() -> void:
	add_to_group("player")
	camera_2d.make_current()
	input_component.shoot_pressed.connect(func():gun.shoot())
	health_component.health_changed.emit(_print)

func setup(pool: ProjectilePool) -> void:
	gun.setup(self, pool)
	
func _print():
	print("healt changed")
func _process(_delta: float) -> void:
	gun.aim_at(get_global_mouse_position())
