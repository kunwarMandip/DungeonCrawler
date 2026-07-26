extends Projectile

@export var speed: float = 200.0

func _ready() -> void:
	$HitboxComponent.body_entered.connect(_on_body_entered)
	$VisibleOnScreenNotifier2D.screen_exited.connect(queue_free)

func _process(delta: float) -> void:
	global_position += transform.x * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("wall"):
		return_to_pool()
