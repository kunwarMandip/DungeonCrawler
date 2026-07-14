extends Node
class_name AttackComponent

@export var damage: float  = 12.0
@export var attack_rate: float = 1.5

var _target: Node2D = null
var _attack_timer: Timer

signal attack_triggered(damage: float, target: Node2D)

func _ready() -> void:
	_attack_timer = Timer.new()
	_attack_timer.one_shot = true
	_attack_timer.wait_timer = attack_rate
	_attack_timer.timeout.connect(_on_timer_timeout)
	add_child(_attack_timer)

func set_target(target: Node2D) -> void:
	_target = target

func clear_target() -> void:
	_target= null
	_attack_timer.stop()
 
func start_attacking() -> void:
	if _attack_timer.is_stopped():
		_attack_timer.start()

func stop_attacking() -> void:
	_attack_timer.stop()

func _on_timer_timeout() -> void:
	if _target != null and is_instance_valid(_target):
		attack_triggered.emit(damage, _target)
		_attack_timer.start()
