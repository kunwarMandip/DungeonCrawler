extends Area2D

signal pickup_requested(item: Item, quantity: int, pickup_node: Node)

@export var item: Item = null
@export var quantity: int = 1

@onready var icon: ColorRect = $Icon
@onready var pickup_label: Label = $PickupLabel

func _ready() -> void:
	add_to_group("pickup")
	if item != null:
		icon.color = item.color
		pickup_label.text = item.display_name
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		pickup_requested.emit(item, quantity, self)
