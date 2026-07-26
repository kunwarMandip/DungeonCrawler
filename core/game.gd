extends Node2D

@onready var game_manager: Node2D = $GameManager
@onready var current_room: Node2D = $CurrentRoom
@onready var player: CharacterBody2D = $Hero
@onready var hud: CanvasLayer = $Hud

func _ready() -> void:
	game_manager.setup(player)
	
	player.health_component.health_changed.connect(hud.update_health)
	game_manager.game_won.connect(_on_win)
	game_manager.game_lost.connect(_on_lose)
	hud.setup(player.inventory)
	hud.update_health(player.health_component.max_health, player.health_component.current_health)
	
func _on_win() -> void:
	hud.show_win_screen()

func _on_lose() -> void:
	hud.show_game_over()

func _process(delta: float) -> void:
	_move_projectiles(delta)

func _move_projectiles(delta: float) -> void:
	if current_room.get_child_count() == 0:
		return
	
	var room := current_room.get_child(0)
	if not room.has_node("ItemDrops"):
		return
	
	var screen := get_viewport_rect()
	for child in room.get_node("ItemDrops").get_children():
		if not child.has_meta("velocity"):
			continue
		if not child.visible:
			continue
		
		var vel: Vector2 = child.get_meta("velocity")
		child.global_position += vel * delta
		var pos :Vector2 = child.global_position
		if pos.x < -60 or pos.x > screen.size.x + 60  or \
			pos.y < -60 or pos.y > screen.size.y + 60:
				child.visible = false
				child.process_mode = Node.PROCESS_MODE_DISABLED
		
