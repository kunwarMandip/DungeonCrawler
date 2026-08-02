extends Node
class_name LootSpawner

const ITEM_PICKUP_SCENE = preload("uid://mkxcrtbmaib7")

func spawn_loot(loot_table: LootTable, spawn_position: Vector2, parent: Node) -> void:
	if loot_table == null:
		return 
	
	var items: Array[Item]= loot_table.roll()
	for item in items:
		_spawn_pickup(item, spawn_position, parent)
	
func _spawn_pickup(item: Item, spawn_position: Vector2, parent: Node) -> void:
	var pickup := ITEM_PICKUP_SCENE.instantiate()
	pickup.item = item
	pickup.quantity = 1
	parent.add_child.call_deferred(pickup)
	pickup.global_position = spawn_position
