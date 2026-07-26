extends Node2D

signal room_cleared
signal player_exited(target_room_id: String)
signal pickup_spawned(pickup: Node)

#const PICKUP_SCENE = preload("res://entities/item_pickup.tscn")
#const HEALTH_POTION = preload("res://items/health_potion.tres")
#const SWORD = preload("res://items/sword.tres")
const HEALTH_POTION = preload("uid://36cowm0y6hgl")
const SWORD = preload("uid://bjc3ghbxrdofd")
const PICKUP_SCENE = preload("uid://mkxcrtbmaib7")

@onready var enemies_node: Node2D = $EnemiesNode
@onready var doors_node: Node2D = $DoorsNode
@onready var item_drops: Node2D = $ItemDrops

var enemies_alive: int = 0
var is_cleared: bool = false

func _ready() -> void:
	for enemy in enemies_node.get_children():
		enemies_alive += 1
		enemy.died.connect(_on_enemy_died)
		
	for door in doors_node.get_children():
		door.lock()
		door.player_crossed.connect(func(room_id: String):
			player_exited.emit(room_id)
		)
	
	if enemies_alive == 0:
		_clear_room()
	
		
		
func _on_enemy_died(entity_position: Vector2) -> void:
	enemies_alive -= 1
	_try_spawn_drop(entity_position)
	if enemies_alive <= 0:
		_clear_room()

func _try_spawn_drop(entity_position: Vector2) -> void:
	var roll := randf()
	var item: Item = null
	var qty: int = 1
	if roll < 0.3:
		item = HEALTH_POTION
		qty = randi_range(1, 2)
	elif roll < 0.45:
		item = SWORD
		qty = 1
	if item == null:
		return
	var pickup = PICKUP_SCENE.instantiate()
	item_drops.add_child(pickup)
	pickup.global_position = entity_position
	pickup.item = item
	pickup.quantity = qty
	pickup_spawned.emit(pickup)


func _clear_room() -> void:
	if is_cleared:
		return
	
	is_cleared = true
	print("room cleared")
	room_cleared.emit()
	for door in doors_node.get_children():
		door.unlock()
