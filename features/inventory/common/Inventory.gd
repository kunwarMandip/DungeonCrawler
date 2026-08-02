extends Resource
class_name Inventory

const BAG_SIZE: int = 20

signal inventory_changed

var slots: Array[Item] = []
var equipped: Dictionary[Item.Type, Item] = {}

#var weapon_slot: Item = Item.new()
#var armor_slot: Item = Item.new()

func _init() -> void:
	for i in BAG_SIZE:
		slots.append(Item.new())
	for type in Item.EQUIPPABLE_TYPES:
		equipped[type] = Item.new()
		
func equip_from_bag(slot_index: int) -> bool:
	if slot_index < 0 or slot_index >= slots.size():
		push_error("equip_from_bag: index %d out of bounds" % slot_index)
		return false
	
	var item := slots[slot_index]
	if item.is_empty() or not Item.EQUIPPABLE_TYPES.has(item.item_type):
		return false
	
	var previously_equipped: Item = equipped[item.item_type]
	slots[slot_index] = previously_equipped
	equipped[item.item_type] = item
	
	inventory_changed.emit()
	return true

func unequip_to_bag(equip_type: Item.Type) -> bool:
	if not equipped.has(equip_type):
		push_error("unequip_to_bag: %s is not an equippable type" % equip_type)
		return false
	
	var item: Item = equipped[equip_type]
	if item.is_empty():
		return false
	
	var empty_index := _find_empty_slot()
	if empty_index == -1:
		return false
	
	slots[empty_index] = item
	equipped[equip_type] = Item.new()
	
	inventory_changed.emit()
	return true

func _find_empty_slot() -> int:
	for i in slots.size():
		if slots[i].is_empty():
			return i
	
	return -1
	
func try_add_item(item: Item) -> bool:
	for i in slots.size():
		if slots[i].is_empty():
			slots[i] = item.duplicate()
			inventory_changed.emit()
			print("added item")
			return true
	return false
	
func remove_item(slot_index: int) -> void:
	if slot_index < 0 or slot_index >= slots.size():
		push_error("remove_item: index %d out of bounds" % slot_index)
		return
		
	var slot := slots[slot_index]
	if slot.is_empty():
		return
	
	slots[slot_index] = Item.new()
	inventory_changed.emit()

func swap_slots(from_index: int, to_index: int) -> void:
	if from_index < 0 or from_index >= slots.size() or to_index < 0 or to_index >= slots.size():
		push_error("swap_slots: index out of bounds (%d, %d)" %[from_index, to_index])
		return
		
	var temp_item := slots[from_index]
	slots[from_index] = slots[to_index]
	slots[to_index] = temp_item
	inventory_changed.emit()
