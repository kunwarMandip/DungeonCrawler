extends Node
class_name NavigationComponent

var _nav_agent: NavigationAgent2D
var _body: Node2D

func _ready() -> void:
	_body = get_parent()
	_nav_agent = get_parent().get_node("NavigationAgent2D")
	if _nav_agent == null:
		push_error("NavigationComponent requires NavigationAgent2D as a sibling under parent")

func get_direction_to(target_position: Vector2) -> Vector2:
	_nav_agent.target_position = target_position
	var next := _nav_agent.get_next_path_position()
	return (next - _body.global_position).normalized()
