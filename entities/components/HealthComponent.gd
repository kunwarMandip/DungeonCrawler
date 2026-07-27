extends Node
class_name HealthComponent

signal died
signal health_changed(current_health: float, max_health: float)

@export var max_health: float = 100.0
var current_health: float

func _ready() -> void:
	current_health = max_health
	
func take_damage(attack_info: AttackInfo, _source: Node):
	#print("Calculating damage")
	if current_health <= 0.0:
		died.emit()
	
	current_health = max(0.0 , current_health - attack_info.damage_amount)
	health_changed.emit(current_health, max_health)
	if current_health <= 0.0:
		died.emit()
	
func heal(amount: float) -> void:
	current_health = min(max_health, current_health + amount)
	health_changed.emit(current_health, max_health)

func is_dead() -> bool:
	return current_health <= 0.0
