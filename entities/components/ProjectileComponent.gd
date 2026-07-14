extends Node
class_name ProjectileComponent

@export var speed: float = 550.0
@export var lifetime: float = 3.0

var _body: Node2D
var _lifetime_timer: Timer

signal expired

func _ready() -> void:
	_body = get_parent()
	_lifetime_timer = Timer.new()
	_lifetime_timer.one_shot = true
	_lifetime_timer.wait_time = lifetime
	_lifetime_timer.timeout.connect(func(): expired.emit())
	add_child(_lifetime_timer)
	_lifetime_timer.start()

func _physics_process(delta: float) -> void:
	_body.position += _body.transform.x * speed * delta
