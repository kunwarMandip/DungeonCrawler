extends Area2D

@onready var projectile_component: ProjectileComponent = $ProjectileComponent



#func _ready() -> void:
	#body_entered.connect(_on_body_entered)
	#$VisibleOnScreenNotifier2D.screen_exited.connect(queue_free)
#
#func _process(delta: float) -> void:
	#position += transform.x * SPEED * delta
	#
#func _on_body_entered(body: Node2D) -> void:
	#print("body_hit")
	#
	#if body.is_in_group("enemy"):
		#body.take_damage(20.0)
		#queue_free()
		#return
		#
	#if body.is_in_group("wall"):
		#queue_free()
