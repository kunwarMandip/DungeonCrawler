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
