extends Node2D

signal game_won
signal game_lost

const ROOMS: Array[String] = [
	"res://world/rooms/Room_1.tscn"
]

var current_room_index: int = 0
var current_room: Node2D = null
var player: CharacterBody2D = null

func setup(p: CharacterBody2D) -> void:
	player = p
	player.health_component.died.connect(_on_player_died)
	_load_room(0)

func _load_room(index: int) -> void:
	current_room_index = index
	var current_room_node := get_parent().get_node("CurrentRoom")
	for child in current_room_node.get_children():
		child.queue_free()
	
	await get_tree().process_frame
	
	var room_scene = load(ROOMS[index])
	current_room = room_scene.instantiate()
	current_room_node.add_child(current_room)
	current_room.room_cleared.connect(_on_room_cleared)
	current_room.door_entered.connect(_on_door_entered)
	if current_room.has_node("Enemies/Boss"):
		var boss := current_room.get_node("Enemies/Boss")
		boss.died.connect(_on_boss_died)
		boss.health_changed.connect(func (c, m):
			get_parent().get_node("HUD").update_boss_health(c, m)
		)
		get_parent().get_node("HUD").show_boss_health()
	_place_player_at_spawn()                                                               

func _place_player_at_spawn() -> void:
	var spawn := current_room.get_node_or_null("SpawnPoints/PlayerSpawn")
	if spawn:
		player.global_position = spawn.global_position
		
func _on_door_entered(_direction: String) -> void:
	var next := current_room_index + 1
	if next < ROOMS.size():
		_load_room(next)
		
func _on_room_cleared() -> void:
	print("Room ", current_room_index + 1, " cleared")
	
func _on_boss_died() -> void:
	game_won.emit()
	
func _on_player_died() -> void:
	game_lost.emit()
	 
