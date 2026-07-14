extends CharacterBody2D

enum State {IDLE, PATROL, CHASE, ATTACK}

const PATROL_SPEED: float = 55.0
const CHASE_SPEED: float = 110.0
const ATTACK_DAMAGE: float = 12.0
const MAX_HEALTH: float = 60
const SCORE_VALUE: int = 10

@export var patrol_loop: bool = true
@export var patrol_points: Array[Vector2] = []

var health: float = MAX_HEALTH
var state: State = State.IDLE
var player: Node2D = null
var patrol_index: int = 0

signal died(position: Vector2)

@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var color_rect: ColorRect = $ColorRect
@onready var attack_zone: Area2D = $AttackZone
@onready var detection_zone: Area2D = $DetectionZone
@onready var health_bar: ProgressBar = $HealthBar
@onready var attack_timer: Timer = $AttackTimer
@onready var idle_timer: Timer = $IdleTimer
@onready var state_label: Label = $StateLabel

func _ready() -> void:
	add_to_group("enemy")
	health_bar.max_value = MAX_HEALTH
	health_bar.value = MAX_HEALTH
	detection_zone.body_entered.connect(_on_detect_entered)
	detection_zone.body_exited.connect(_on_detect_exited)
	attack_zone.body_entered.connect(_on_attack_entered)
	attack_zone.body_exited.connect(_on_attack_exited)
	attack_timer.timeout.connect(_on_attack_timeout)
	idle_timer.timeout.connect(_on_idle_timeout)
	
	var parent := get_parent().get_parent()
	if parent.has_node("WayPointA") and parent.has_node("WayPoinB"):
		patrol_points = [
			parent.get_node("WayPointA").global_position,
			parent.get_node("WayPointB").global_position,
		]
	_change_state(State.IDLE)

func _physics_process(_delta: float) -> void:
	match state:
		State.IDLE: move_and_slide()
		State.PATROL: _do_patrol()
		State.CHASE: _do_chase()
		State.ATTACK: move_and_slide()

func _change_state(new_state: State) -> void:
	state = new_state
	match new_state:
		State.IDLE:
			velocity = Vector2.ZERO
			idle_timer.start()
		State.ATTACK:
			velocity = Vector2.ZERO
			if attack_timer.is_stopped():
				attack_timer.start()
	state_label.text = State.keys()[state]

func _do_patrol() -> void:
	#navigation_agent_2d.target_position = patrol_points[patrol_index]
	#velocity = (navigation_agent_2d.get_next_path_position() - global_position).normalized() * PATROL_SPEED
	#move_and_slide()
	#if global_position.distance_to(patrol_points[patrol_index]) < 16.0:
		#patrol_index = 0
		#idle_timer.wait_time = randf_range(PATROL_WAIT_MIN, PATROL_WAIT_MAX)
		#_change_state(State.IDLE)
		
	if patrol_points.is_empty():
		return
	var target := patrol_points[patrol_index]
	navigation_agent_2d.target_position = target
	velocity = (navigation_agent_2d.get_next_path_position() - global_position).normalized() * PATROL_SPEED
	move_and_slide()
	if global_position.distance_to(target) < 16.0:
		patrol_index = (patrol_index + 1) % patrol_points.size()

func _do_chase() -> void:
	if player == null:
		_change_state(State.PATROL)
		return
	navigation_agent_2d.target_position = player.global_position
	velocity = (navigation_agent_2d.get_next_path_position() - global_position).normalized() * CHASE_SPEED
	move_and_slide()

func take_damage(amount: float) -> void:
	health -= amount
	health_bar.value = health
	_flash()
	if health <= 0.0:
		died.emit(global_position)
		queue_free()

func _flash() -> void:
	#$Sprite2D.modulate = Color.WHITE
	#await get_tree().create_timer(0.08).timeout
	#$Sprite2D.modulate = Color(1, 0.3, 0.3)
	#await get_tree().create_timer(0.08).timeout
	#$Sprite2D.modulate = Color.WHITE
	var old_color = color_rect.color
	color_rect.color = Color.WHITE
	await get_tree().create_timer(0.08).timeout
	color_rect.color = Color(1, 0.3, 0.3)
	await get_tree().create_timer(0.08).timeout
	color_rect.color = old_color

func _on_detect_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = body
		if state in [State.IDLE, State.PATROL]:
			_change_state(State.CHASE)

func _on_detect_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = null
		if state == State.CHASE:
			_change_state(State.PATROL)

func _on_attack_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		_change_state(State.ATTACK)

func _on_attack_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		_change_state(State.CHASE if player != null else State.PATROL)

func _on_attack_timeout() -> void:
	if state == State.ATTACK and player != null:
		player.take_damage(ATTACK_DAMAGE)
		attack_timer.start()

func _on_idle_timeout() -> void:
	_change_state(State.PATROL)
