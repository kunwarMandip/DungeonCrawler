extends CharacterBody2D

@export var speed: float = 200.0

var inventory: Inventory = Inventory.new()

@onready var gun: Node2D = $Gun
@onready var camera_2d: Camera2D = $Camera2D
@onready var health_component: HealthComponent = $HealthComponent
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent
@onready var input_component: InputComponent = $InputComponent
@onready var item_pickup_component: ItemPickupComponent = $ItemPickupComponent

func _ready() -> void:
	add_to_group("player")
	camera_2d.make_current()
	input_component.shoot_pressed.connect(func():gun.shoot())

func setup() -> void:
	print("running")
	#gun.setup(self, pool)
	item_pickup_component.setup(inventory)
	
func _process(_delta: float) -> void:
	gun.aim_at(get_global_mouse_position())
