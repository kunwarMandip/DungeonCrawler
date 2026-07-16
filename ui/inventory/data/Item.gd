extends Resource
class_name Item

enum Type { WEAPON, ARMOR, CONSUMABLE }

@export var id: String = ""
@export var display_name: String = ""
@export var description: String = ""
@export var item_type: Type = Type.CONSUMABLE
@export var color: Color = Color.WHITE
@export var max_stack: int = 1
@export var attack_bonus: int = 0
@export var defense_bonus: int = 0
