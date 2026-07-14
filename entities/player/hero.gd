extends CharacterBody2D

signal died
signal health_changed(current_health: float, max_health: float)

@export var speed: float = 200.0

var inventory: Inventory = Inventory.new()

@onready var camera_2d: Camera2D = $Camera2D
@onready var health_component: HealthComponent = $HealthComponent
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent
@onready var input_component: InputComponent = $InputComponent

func _ready() -> void:
	add_to_group("player")
	camera_2d.make_current()
	hurtbox_component.hit.connect(_on_hurtbox_hit)

func _on_hurtbox_hit(damage: float, source: Node) -> void:
	health_component.take_damage(damage)
