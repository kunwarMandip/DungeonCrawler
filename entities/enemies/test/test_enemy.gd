extends CharacterBody2D

@onready var detection_component: DetectionComponent = $DetectionComponent
@onready var navigation_component: NavigationComponent = $NavigationComponent
@onready var patrol_component: PatrolComponent = $PatrolComponent
@onready var state_machine: StateMachine = $StateMachine
@onready var health_component: HealthComponent = $HealthComponent
@onready var health_bar: ProgressBar = $HealthBar
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent
@export var patrol_points: Array[Vector2] = []
@onready var gun: Node2D = $Gun

func _ready() -> void:
	add_to_group("enemy")
	health_component.health_changed.connect(_on_health_changed)
	_on_health_changed(health_component.current_health, health_component.max_health)
	hurtbox_component.hit.connect(func(damage: float, _source: Node):
		health_component.take_damage(damage)
	)
	gun.setup($Node2D)

func _on_health_changed(current_health: float, max_health: float):
	health_bar.max_value = max_health
	health_bar.value = current_health
