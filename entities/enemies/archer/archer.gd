## archer.gd
#extends CharacterBody2D
#
#enum State { IDLE, REPOSITION, FLEE, SHOOT }
#
#const MOVE_SPEED: float = 90.0
#const PREFERRED_RANGE: float = 160.0
#const ARROW_DAMAGE: float = 8.0
#const MAX_HEALTH: float = 40.0
#
#var health: float = MAX_HEALTH
#var state: State = State.IDLE
#var player: Node2D = null
#
#signal died(position: Vector2)
#
#@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
#@onready var detection_zone: Area2D = $DetectionZone
#@onready var flee_zone: Area2D = $FleeZone
#@onready var fire_timer: Timer = $FireTimer
#@onready var arrow_pool: Node2D = $ArrowPool
#@onready var health_bar: ProgressBar = $HealthBar
#
#func _ready() -> void:
	#add_to_group("enemy")
	#health_bar.max_value = MAX_HEALTH
	#health_bar.value = MAX_HEALTH
	#detection_zone.body_entered.connect(_on_detect_entered)
	#flee_zone.body_entered.connect(_on_flee_entered)
	#flee_zone.body_exited.connect(_on_flee_exited)
	#fire_timer.timeout.connect(_on_fire_timeout)
	#fire_timer.wait_time = 1.8
	#_setup_arrow_pool()
#
#func _setup_arrow_pool() -> void:
	#var arrow_scene = preload("res://arrow.tscn")
	#for i in 10:
		#var arrow = arrow_scene.instantiate()
		#arrow_pool.add_child(arrow)
		#arrow.visible = false
		#arrow.process_mode = Node.PROCESS_MODE_DISABLED
#
#func _physics_process(_delta: float) -> void:
	#match state:
		#State.REPOSITION: _do_reposition()
		#State.FLEE: _do_flee()
		#State.SHOOT: move_and_slide()
		#State.IDLE: move_and_slide()
#
#func _do_reposition() -> void:
	#if player == null:
		#return
	#var target := player.global_position + (global_position - player.global_position).normalized() * PREFERRED_RANGE
	#nav_agent.target_position = target
	#velocity = (nav_agent.get_next_path_position() - global_position).normalized() * MOVE_SPEED
	#move_and_slide()
	#if global_position.distance_to(target) < 20.0:
		#_change_state(State.SHOOT)
#
#func _do_flee() -> void:
	#if player == null:
		#return
	#var flee_dir := (global_position - player.global_position).normalized()
	#nav_agent.target_position = global_position + flee_dir * 100.0
	#velocity = (nav_agent.get_next_path_position() - global_position).normalized() * MOVE_SPEED * 1.3
	#move_and_slide()
#
#func _change_state(new_state: State) -> void:
	#state = new_state
	#if new_state == State.SHOOT and fire_timer.is_stopped():
		#fire_timer.start()
	#if new_state != State.SHOOT:
		#fire_timer.stop()
#
#func _fire_arrow() -> void:
	#if player == null:
		#return
	#var arrow = _get_arrow()
	#if arrow == null:
		#return
	#arrow.global_position = global_position
	#arrow.visible = true
	#arrow.process_mode = Node.PROCESS_MODE_INHERIT
	#var dir := (player.global_position - global_position).normalized()
	#arrow.set_meta("velocity", dir * 280.0)
	#arrow.set_meta("damage", ARROW_DAMAGE)
#
#func _get_arrow() -> Node:
	#for arrow in arrow_pool.get_children():
		#if not arrow.visible:
			#return arrow
	#return null
#
#func take_damage(amount: float) -> void:
	#health -= amount
	#health_bar.value = health
	#if health <= 0.0:
		#died.emit(global_position)
		#queue_free()
#
#func _on_detect_entered(body: Node2D) -> void:
	#if body.is_in_group("player"):
		#player = body
		#_change_state(State.REPOSITION)
#
#func _on_flee_entered(body: Node2D) -> void:
	#if body.is_in_group("player"):
		#_change_state(State.FLEE)
#
#func _on_flee_exited(body: Node2D) -> void:
	#if body.is_in_group("player"):
		#_change_state(State.REPOSITION)
#
#func _on_fire_timeout() -> void:
	#if state == State.SHOOT:
		#_fire_arrow()
		#fire_timer.start()
