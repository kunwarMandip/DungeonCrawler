extends Node2D

signal room_cleared
signal door_entered(direction: String)

var enemies_alive: int = 0
var is_cleared: bool = false

@onready var enemies_node: Node2D = $EnemiesNode
@onready var doors_node: Node2D = $DropsNode
@onready var item_drops: Node2D = $ItemDrops

func _ready() -> void:
	_lock_doors()
	for enemy in enemies_node.get_children():
		enemies_alive += 1
		if enemy.has_signal("died"):
			enemy.died.connect(_on_enemy_died)
	
	if enemies_alive == 0:
		_unlock_door()
		is_cleared = true
	
	for door in doors_node.get_children():
		door.body_entered.connect(func(body):
			_on_door_entered(body, door.name)
		)

func _lock_doors() -> void:
	for door in doors_node.get_children():
		var blocker := door.get_node_or_null("BlockingBody")
		if blocker:
			blocker.get_node("CollisionShape2D").disabled = false

func _unlock_door() -> void:
	for door in doors_node.get_children():
		var blocker := door.get_node_or_null("BlockingBody")
		if blocker:
			blocker.get_node("CollisionShape2D").disabled = true

func _on_door_entered(body: Node2D, door_name: String) -> void:
	if body.is_in_group("player"):
		door_entered.emit(door_name)
		
func _on_enemy_died(enemy_position: Vector2) -> void:
	enemies_alive -= 1
	_try_drop_item(enemy_position)
	if enemies_alive <= 0:
		is_cleared = true
		_unlock_door()
		room_cleared.emit()

func _try_drop_item(_pos: Vector2) -> void:
	pass
