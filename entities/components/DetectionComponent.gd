extends Area2D
class_name DetectionComponent

signal target_lost
signal target_spotted(target: Node2D)

var target: Node2D = null

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		target = body
		target_spotted.emit(body)

func _on_body_exited(body: Node2D) -> void:
	if body == target:
		target = null
		target_lost.emit()
