extends Area2D

@export var item: Item = null
@export var quantity: int = 1

@onready var icon: ColorRect = $Icon
@onready var pickup_label: Label = $PickupLabel

func _ready() -> void:
	add_to_group("pickup")
	if item != null:
		icon.color = item.color
		pickup_label.text = item.display_name


func _on_area_entered(area: Area2D) -> void:
	if not area is ItemPickupComponent:
		return
	
	var item_pickup_component = area as ItemPickupComponent
	if item_pickup_component.collect_item(item, quantity):
		queue_free()
