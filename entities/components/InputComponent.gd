extends Node
class_name InputComponent

signal shoot_pressed
signal melee_pressed

var movement: Vector2 = Vector2.ZERO

#@onready var _body: Node2D = get_parent()

func _physics_process(_delta: float) -> void:
	movement = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		shoot_pressed.emit()
	if event.is_action_pressed("melee"):
		melee_pressed.emit()
