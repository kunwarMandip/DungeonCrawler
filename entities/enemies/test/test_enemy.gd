extends CharacterBody2D

signal died(position: Vector2)

@onready var gun: Node2D = $Gun
@onready var health_bar: ProgressBar = $HealthBar
@onready var health_component: HealthComponent = $HealthComponent
@onready var detection_component: DetectionComponent = $DetectionComponent

func _ready() -> void:
	add_to_group("enemy")
	health_component.health_changed.connect(_on_health_changed)
	health_component.died.connect(_on_death)
	_on_health_changed(health_component.current_health, health_component.max_health)
	gun.setup(self)

func _process(_delta: float) -> void:
	if detection_component.target:
		gun.aim_at(detection_component.target.global_position)

func _on_health_changed(current_health: float, max_health: float):
	health_bar.max_value = max_health
	health_bar.value = current_health

func _on_death():
	died.emit(global_position)
	queue_free()
