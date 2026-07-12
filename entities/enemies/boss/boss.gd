# boss.gd
extends CharacterBody2D

enum Phase { MELEE, RANGED, COMBINED }

const BULLET_SCENE = preload("uid://ch4tl0p73fb7d")

const MAX_HEALTH: float = 300.0
const MELEE_SPEED: float = 140.0
const MELEE_DAMAGE: float = 20.0
const BULLET_DAMAGE: float = 8.0

var health: float = MAX_HEALTH
var phase: Phase = Phase.MELEE
var player: Node2D = null
var active: bool = false


signal died
signal health_changed(current: float, maximum: float)

@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var detection_zone: Area2D = $DetectionZone
@onready var melee_zone: Area2D = $MeleeZone
@onready var phase_timer: Timer = $PhaseTimer
@onready var attack_timer: Timer = $AttackTimer
@onready var bullet_pool: Node2D = $BulletPool
@onready var health_bar: ProgressBar = $BossHealthBar

func _ready() -> void:
	add_to_group("enemy")
	add_to_group("boss")
	health_bar.max_value = MAX_HEALTH
	health_bar.value = MAX_HEALTH
	detection_zone.body_entered.connect(_on_detect_entered)
	melee_zone.body_entered.connect(_on_melee_entered)
	phase_timer.wait_time = 8.0
	phase_timer.timeout.connect(_next_phase)
	attack_timer.timeout.connect(_do_attack)
	_setup_bullet_pool()

func _setup_bullet_pool() -> void:
	for i in 30:
		var b = BULLET_SCENE.instantiate()
		bullet_pool.add_child(b)
		b.visible = false
		b.process_mode = Node.PROCESS_MODE_DISABLED

func _physics_process(_delta: float) -> void:
	if not active or player == null:
		return
	match phase:
		Phase.MELEE, Phase.COMBINED:
			nav_agent.target_position = player.global_position
			velocity = (nav_agent.get_next_path_position() - global_position).normalized() * MELEE_SPEED
			move_and_slide()
		Phase.RANGED:
			velocity = Vector2.ZERO
			move_and_slide()

func _next_phase() -> void:
	phase = Phase.values()[(phase + 1) % Phase.size()]
	attack_timer.start()
	phase_timer.start()

func _do_attack() -> void:
	match phase:
		Phase.MELEE: pass
		Phase.RANGED: _fire_spread()
		Phase.COMBINED: _fire_spread()
	attack_timer.start()

func _fire_spread() -> void:
	var count := 8
	for i in count:
		var angle := (TAU / count) * i
		var b = _get_bullet()
		if b == null:
			continue
		b.global_position = global_position
		b.visible = true
		b.process_mode = Node.PROCESS_MODE_INHERIT
		b.set_meta("velocity", Vector2.RIGHT.rotated(angle) * 180.0)
		b.set_meta("damage", BULLET_DAMAGE)

func _get_bullet() -> Node:
	for b in bullet_pool.get_children():
		if not b.visible:
			return b
	return null

func take_damage(amount: float) -> void:
	health -= amount
	health_bar.value = health
	health_changed.emit(health, MAX_HEALTH)
	if health <= MAX_HEALTH * 0.5 and phase == Phase.MELEE:
		phase = Phase.RANGED
	if health <= 0.0:
		died.emit()
		queue_free()

func _on_detect_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = body
		active = true
		phase_timer.start()
		attack_timer.start()

func _on_melee_entered(body: Node2D) -> void:
	if body.is_in_group("player") and phase in [Phase.MELEE, Phase.COMBINED]:
		body.take_damage(MELEE_DAMAGE)
