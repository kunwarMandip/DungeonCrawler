extends CharacterBody2D

@onready var detection_component: DetectionComponent = $DetectionComponent
@onready var navigation_component: NavigationComponent = $NavigationComponent
@onready var state_machine: StateMachine = $StateMachine
@onready var patrol_component: PatrolComponent = $PatrolComponent

@export var patrol_points: Array[Vector2] = []

var target = null

func _ready() -> void:
	detection_component.target_spotted.connect(_on_target_spotted)
	detection_component.target_lost.connect(_on_target_lost)

func _on_target_spotted(body: Node2D) -> void:
	target = body

func _on_target_lost() -> void:
	target = null
