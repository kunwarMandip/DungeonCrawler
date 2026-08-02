extends Panel

signal slot_unhovered
signal slot_hovered(slot_index: int)
signal slot_dropped(from_index: int, to_index: int)

var slot_index: int = -1
var inventory: Inventory = null

func setup(index: int, inv: Inventory) -> void:
	slot_index = index
	inventory = inv
	mouse_entered.connect(func(): slot_hovered.emit(slot_index))
	mouse_exited.connect(func(): slot_unhovered.emit())

func _get_drag_data(_at_position: Vector2) -> Variant:
	var item: Item = inventory.slots[slot_index]
	if item.is_empty():
		return null
	
	var preview := ColorRect.new()
	preview.color = item.color
	preview.custom_minimum_size = Vector2(32, 32)
	set_drag_preview(preview)
	
	return {"slot_index": slot_index}

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	return typeof(data) == TYPE_DICTIONARY and data.has("slot_index")

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	slot_dropped.emit(data["slot_index"], slot_index)
