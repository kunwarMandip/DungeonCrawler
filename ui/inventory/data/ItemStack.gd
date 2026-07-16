extends RefCounted
class_name ItemStack

var item: Item = null
var quantity: int = 0

func _init(p_item: Item = null, p_quantity: int = 1) -> void:
	item = p_item
	quantity = p_quantity

func is_empty() -> bool:
	return item == null or quantity <= 0
