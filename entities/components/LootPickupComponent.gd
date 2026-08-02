extends Area2D
class_name ItemPickupComponent

signal item_collected(item: Item, quantity: int)

@export var enabled: bool = true

var inventory: Inventory

func setup(inv: Inventory):
	inventory = inv
	
func collect_item(item: Item, quantity: int) -> bool:
	print("trying to collect item")
	if not enabled or inventory == null:
		print("something off")
		return false
	
	var is_valid = inventory.try_add_item(item)
	if not is_valid:
		return false
	
	item_collected.emit(item, quantity)
	print("Collected: ", item.display_name, " x", quantity)
	return true
	
