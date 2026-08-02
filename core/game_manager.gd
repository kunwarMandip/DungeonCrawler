extends Node2D

signal game_won
signal game_lost
signal room_loaded(room: Node)

const ROOMS: Dictionary = {
	"room_1": "res://tilemap/rooms/Room_1.tscn",
	"room_2": "res://tilemap/rooms/Room_2.tscn"
}

var current_room_id: String = ""
var current_room: Node2D = null
var player: CharacterBody2D = null

func setup(p: CharacterBody2D) -> void:
	player = p
	player.health_component.died.connect(_on_player_died)
	player.setup()
	_load_room("room_1")

func _load_room(room_id: String) -> void:
	if not ROOMS.has(room_id):
		push_warning("GameManager: unknown room_id '%s'" % room_id)
		return
		
	current_room_id = room_id
	var current_room_node := get_parent().get_node("CurrentRoom")
	for child in current_room_node.get_children():
		child.queue_free()
	
	await get_tree().process_frame
	
	var room_scene = load(ROOMS[room_id])
	current_room = room_scene.instantiate()
	current_room_node.add_child(current_room)
	current_room.room_cleared.connect(_on_room_cleared)
	current_room.player_exited.connect(_on_door_entered)
	

	_place_player_at_spawn()                                       
	room_loaded.emit(current_room)
	
func _place_player_at_spawn() -> void:
	var spawn := current_room.get_node_or_null("PlayerSpawn")
	if spawn:
		player.global_position = spawn.global_position
	else:
		push_warning("GameManager: no SpawnPoint found in room '%s'" % current_room_id)
		
func _on_door_entered(target_room_id: String) -> void:
	_load_room(target_room_id)
		
func _on_room_cleared() -> void:
	print("Room '%s' cleared" % current_room_id)
	
func _on_boss_died() -> void:
	game_won.emit()
	
func _on_player_died() -> void:
	game_lost.emit()
	 
