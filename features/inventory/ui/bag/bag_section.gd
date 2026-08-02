#extends VBoxContainer
#
#var slot_nodes: Array = []
#var inventory: Inventory = null
#
#@onready var slot_grid: GridContainer = %SlotGrid
#
#func setup(inv: Inventory) -> void:
	#inventory = inv
	#
	#slot_nodes = slot_grid.get_children()
	#for i in slot_nodes.size():
		#var slot = slot_nodes[i]
		#var index := i
		#slot.set_drag_forwarding(
			#func(pos): return _get_drag_data(index, pos),
			#func(pos, data): return _can_drop(data),
			#func(pos, data): _drop(index, data)
		#)
	#
	#_rebuild_ui()
#
#func _get_drag_data(slot_index: int, _at_position: Vector2) -> Variant:
	#var item := inventory.slots[slot_index]
	#if item.is_empty():
		#return null
	#
	#var preview: = ColorRect.new()
	#preview.color = item.color
	#preview.custom_minimum_size = Vector2(32, 32)
	#set_drag_preview(preview)
	#return{"source": "bag", "slot_index": slot_index}
#
#func _can_drop(data: Variant) -> bool:
	#return typeof(data) == TYPE_DICTIONARY and data.has("source")
#
#func _drop(target_index: int, data: Variant) -> void:
	#if data["source"] == "bag":
		#inventory.swap_slots(data)
#func _build_ui():
	#return
	#
