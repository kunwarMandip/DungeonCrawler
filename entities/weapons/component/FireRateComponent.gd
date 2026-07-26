extends Node
class_name FireRateComponent

@export_range(0.001, 100.0) var fire_rate: float  = 1
var _can_shoot: bool = true
var _fire_rate_timer: Timer

func _ready():
	_fire_rate_timer = Timer.new()
	_fire_rate_timer.one_shot = true
	_fire_rate_timer.timeout.connect(func():_can_shoot = true)
	add_child(_fire_rate_timer)

func can_shoot() -> bool:
	if _can_shoot:
		_can_shoot = false
		_fire_rate_timer.wait_time = 1.0 / maxf(fire_rate, 0.001)
		_fire_rate_timer.start()
		return true
	
	return false
	
