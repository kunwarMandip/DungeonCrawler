extends CharacterBody2D

signal died(position: Vector2)

@onready var gun: Node2D = $Gun
@export var patrol_points: Array[Vector2] = []
@onready var health_bar: ProgressBar = $HealthBar
@onready var state_machine: StateMachine = $StateMachine
@onready var health_component: HealthComponent = $HealthComponent
@onready var patrol_component: PatrolComponent = $PatrolComponent
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent
@onready var detection_component: DetectionComponent = $DetectionComponent
@onready var navigation_component: NavigationComponent = $NavigationComponent
@onready var shoot_range_detection: DetectionComponent = $ShootRangeDetection

func _ready() -> void:
	add_to_group("enemy")
	health_component.health_changed.connect(_on_health_changed)
	health_component.died.connect(_on_death)
	_on_health_changed(health_component.current_health, health_component.max_health)
	hurtbox_component.hit.connect(_on_hurtbox_hit)
	gun.setup(self)

func _process(_delta: float) -> void:
	if detection_component.target:
		gun.aim_at(detection_component.target.global_position)
		
func _on_hurtbox_hit(attack_info: AttackInfo, source: Node):
	health_component.take_damage(attack_info, source)

func _on_health_changed(current_health: float, max_health: float):
	health_bar.max_value = max_health
	health_bar.value = current_health

func _on_death():
	died.emit(global_position)
	queue_free()
