extends Resource
class_name LootTable

@export var drops: Array[LootDrop] = []

func roll() -> Array[Item]:
	var results: Array[Item] = []
	for drop in drops:
		if randf() <= drop.chance:
			results.append(drop.item)
		
	return results
