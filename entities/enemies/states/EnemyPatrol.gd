extends State
class_name EnemyPatrol

@export var patrol_speed: float = 60.0
@export var patrol_component: PatrolComponent
@export var movement_component: MovementComponent
@export var detection_component: DetectionComponent
@export var navigation_component: NavigationComponent

func Enter() -> void:
	$"../../StateLabel".text = "Enemy Patrol"
	
func Physics_update(_delta: float) -> void:
	if detection_component.target:
		Transitioned.emit(self, "EnemyChase")
		return
	
	if not patrol_component.has_points():
		return
		
	var target_point = patrol_component.get_current_target()
	var dir = navigation_component.get_direction_to(target_point)
	movement_component.move(dir, patrol_speed)
	patrol_component.check_arrival(movement_component.get_position())
