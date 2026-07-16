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
	gun.setup($Node2D)
	input_component.shoot_pressed.connect(func():gun.shoot())
	hurtbox_component.hit.connect(func (damage: float, _source: Node):
		health_component.take_damage(damage)
	)
	
