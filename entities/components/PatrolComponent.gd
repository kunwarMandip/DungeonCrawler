extends Node
class_name PatrolComponent

@export var patrol_loop: bool = true
const ARRIVAL_THRESHOLD: float = 16.0

var patrol_points: Array[Vector2] = []
var patrol_index: int = 0

signal patrol_point_reached(index: int)

func _ready() -> void:
	for child in owner.get_children():
		if child is Marker2D:
			patrol_points.append(child.global_position)
			print("Patrol points found: ", child.name)

func has_points() -> bool:
	return not patrol_points.is_empty()

func get_current_target() -> Vector2:
	if patrol_points.is_empty():
		return get_parent().global_position
	
	return patrol_points[patrol_index]

func check_arrival(current_position: Vector2) -> void:
	if patrol_points.is_empty():
		return 
	
	if current_position.distance_to(patrol_points[patrol_index]) < ARRIVAL_THRESHOLD:
		patrol_point_reached.emit(patrol_index)
		_advance()
	
func _advance() -> void:
	if patrol_loop:
		patrol_index = (patrol_index + 1) % patrol_points.size()
		return
	
	if patrol_index == patrol_points.size() - 1:
		patrol_points.reverse()
		patrol_index = 1
	else:
		patrol_index += 1

func find_nearest_point(position: Vector2) -> int:
	var nearest := 0
	var nearest_dist := INF
	for i in patrol_points.size():
		var dist := position.distance_squared_to(patrol_points[i])
		if dist < nearest_dist:
			nearest_dist = dist
			nearest = i
	return nearest
