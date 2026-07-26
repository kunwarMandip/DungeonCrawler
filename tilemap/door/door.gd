extends StaticBody2D
class_name Door

signal player_crossed(target_room_id: String)

@export var target_room_id: String = ""

@onready var trigger_zone: Area2D = $TriggerZone
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var is_locked = true

func _ready() -> void:
	trigger_zone.body_entered.connect(_on_trigger_area_body_entered)

func lock() -> void:
	is_locked = true
	collision_shape_2d.set_deferred("disabled", false)
	
func unlock() -> void:
	is_locked = false
	collision_shape_2d.set_deferred("disabled", true)

func _on_trigger_area_body_entered(body: Node2D) -> void:
	print("body entered")
	if is_locked:
		print("body locked")
		return
		
	if body.is_in_group("player"):
		print("emitting")
		player_crossed.emit(target_room_id)
	else:
		print("none")
