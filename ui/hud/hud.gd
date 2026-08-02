extends CanvasLayer

@onready var top_bar: HBoxContainer = $TopBar
@onready var health_bar: ProgressBar = $TopBar/HealthContainer/HealthBar

@onready var boss_container: VBoxContainer = $BossContainer
@onready var boss_health_bar: ProgressBar = $BossContainer/BossHealthBar

@onready var inventory_panel: Panel = $InventoryPanel
@onready var tooltip: Panel = $Tooltip

func setup(inventory: Inventory) -> void:
	inventory_panel.setup(inventory)
	boss_container.visible = false

func update_health(current_health:float, max_health: float) -> void:
	health_bar.max_value = max_health
	health_bar.value = current_health

func update_boss_health(current: float, maximum: float) -> void:
	boss_health_bar.max_value = maximum
	boss_health_bar.value = current

func show_boss_health() -> void:
	boss_container.visible = true

func show_win_screen() -> void:
	get_node("WinScreen").visible = true

func show_game_over() -> void:
	pass
	#get_node("GameOverScreen").visible = true
	#get_tree().paused = true

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_inventory"):
		inventory_panel.rebuild_ui()
		inventory_panel.visible = not inventory_panel.visible
