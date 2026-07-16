extends Area2D

@export var item: Item = null
@export var quantity: int = 1

signal pickup_requested(item: Item, quantity: int, pickup_node: Node)

#func _ready() -> void:
	#add_to_group("pickup")
	#if item != null:
		#
