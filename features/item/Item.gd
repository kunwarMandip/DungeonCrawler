extends Resource
class_name Item

enum Type { WEAPON, ARMOR, HELMET, SHOES, CONSUMABLE }

const EQUIPPABLE_TYPES: Array[Type] = [Type.WEAPON, Type.ARMOR, Type.HELMET, Type.SHOES]

@export var id: String = ""
@export var display_name: String = ""
@export var description: String = ""
@export var item_type: Type = Type.CONSUMABLE
@export var color: Color = Color.WHITE
@export var max_stack: int = 1
@export var attack_bonus: int = 0
@export var defense_bonus: int = 0

func is_empty() -> bool:
	return id == ""
