class_name Inventory
extends RefCounted

const BAG_SIZE: int = 20

signal inventory_changed

var slots: Array[ItemStack] = []
var weapon_slot: ItemStack = ItemStack.new()
var armor_slot: ItemStack = ItemStack.new()

func _init() -> void:
	for i in BAG_SIZE:
		slots.append(ItemStack.new())

func add_item(item: Item, quantity: int = 1) -> int:
	for slot in slots:
		if not slot.is_empty() and slot.item.id == item.id and slot.quantity < item.max_stack:
			var space := item.max_stack - slot.quantity
			var to_add := mini(space, quantity)
			slot.quantity += to_add
			quantity -= to_add
			if quantity <= 0:
				inventory_changed.emit()
				return 0
	for slot in slots:
		if slot.is_empty():
			slot.item = item.duplicate()
			slot.quantity = mini(quantity, item.max_stack)
			quantity -= slot.quantity
			if quantity <= 0:
				inventory_changed.emit()
				return 0
	inventory_changed.emit()
	return quantity

func remove_item(slot_index: int, quantity: int = 1) -> void:
	var slot := slots[slot_index]
	if slot.is_empty():
		return
	slot.quantity -= quantity
	if slot.quantity <= 0:
		slot.item = null
		slot.quantity = 0
	inventory_changed.emit()

func swap_slots(from_index: int, to_index: int) -> void:
	var temp_item := slots[from_index].item
	var temp_qty := slots[from_index].quantity
	slots[from_index].item = slots[to_index].item
	slots[from_index].quantity = slots[to_index].quantity
	slots[to_index].item = temp_item
	slots[to_index].quantity = temp_qty
	inventory_changed.emit()

func equip_from_bag(slot_index: int) -> void:
	var slot := slots[slot_index]
	if slot.is_empty():
		return
	var target_equip_slot: ItemStack
	if slot.item.item_type == Item.Type.WEAPON:
		target_equip_slot = weapon_slot
	elif slot.item.item_type == Item.Type.ARMOR:
		target_equip_slot = armor_slot
	else:
		return
	var old_item := target_equip_slot.item
	var old_qty := target_equip_slot.quantity
	target_equip_slot.item = slot.item
	target_equip_slot.quantity = slot.quantity
	slot.item = old_item
	slot.quantity = old_qty
	inventory_changed.emit()

func unequip_to_bag(equip_slot: ItemStack) -> void:
	if equip_slot.is_empty():
		return
	var leftover := add_item(equip_slot.item, equip_slot.quantity)
	if leftover == 0:
		equip_slot.item = null
		equip_slot.quantity = 0
	inventory_changed.emit()

func get_attack_bonus() -> int:
	return 0 if weapon_slot.is_empty() else weapon_slot.item.attack_bonus

func get_defense_bonus() -> int:
	return 0 if armor_slot.is_empty() else armor_slot.item.defense_bonus
