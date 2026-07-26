extends State
class_name EnemyChase

@export var chase_speed: float = 50.0
@export var target_lost_chase_grace_time: float = 2.0

@export var chase_range_component: DetectionComponent
@export var shoot_range_component: DetectionComponent
@export var navigation_component: NavigationComponent
@export var movement_component: MovementComponent

var target_last_position: Vector2
var target_lost_chase_grace_timer: float = 0.0

func Enter() -> void:
	$"../../StateLabel".text = "Enemy Chase"
	
func Physics_update(_delta: float) -> void:
	var dir: Vector2 
	
	if chase_range_component.target:
		target_lost_chase_grace_timer = 0.0
		target_last_position = chase_range_component.target.global_position
		
		if shoot_range_component.target:
			Transitioned.emit(self, "EnemyShoot")
			return
		
		dir = navigation_component.get_direction_to(chase_range_component.target.global_position)
		movement_component.move(dir, chase_speed)
		return
	
	target_lost_chase_grace_timer += _delta
	if target_lost_chase_grace_timer >= target_lost_chase_grace_time:
		Transitioned.emit(self, "EnemyIdle")
		return
	
	dir = navigation_component.get_direction_to(target_last_position)
	movement_component.move(dir, chase_speed)
