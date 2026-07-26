extends State
class_name EnemyIdle

@export var IDLE_TIME: float = 2.5
@export var movement_component: MovementComponent
@export var detection_componnent: DetectionComponent

var idle_timer: float = 0.0

func Enter() -> void:
	$"../../StateLabel".text = "EnemyIdle"
	
func Physics_update(_delta: float) -> void:
	if detection_componnent.target:
		Transitioned.emit(self, "EnemyChase")
		return
	
	movement_component.stop()
	idle_timer += _delta
	if idle_timer >= IDLE_TIME:
		Transitioned.emit(self, "EnemyPatrol")
