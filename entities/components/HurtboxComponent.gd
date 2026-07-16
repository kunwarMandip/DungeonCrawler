extends Area2D
class_name HurtboxComponent

signal hit(damage: float, source: Node)

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	print("entered")
	hit.emit(area.damage_amount, area)
