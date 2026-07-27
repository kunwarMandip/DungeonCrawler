extends Projectile

@export var speed: float = 200.0

func _ready() -> void:
	$HitboxComponent.body_entered.connect(_on_body_entered)
	$HitboxComponent.hit_landed.connect(_on_bullet_connected)
	$VisibleOnScreenNotifier2D.screen_exited.connect(queue_free)

func _process(delta: float) -> void:
	global_position += transform.x * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("wall"):
		return_to_pool()

func _on_bullet_connected(_hurtbox: HurtboxComponent, _damage: float):
	return_to_pool()
