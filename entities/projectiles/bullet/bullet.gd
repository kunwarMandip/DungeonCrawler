extends Area2D

@onready var projectile_component: ProjectileComponent = $ProjectileComponent
@export var speed: float = 200.0
@export var damage_amount: float = 20.0

func _ready() -> void:
	#print("bullet ready, monitoring: ", monitoring)
	area_entered.connect(_on_area_entered)
	$VisibleOnScreenNotifier2D.screen_exited.connect(queue_free)

func _process(delta: float) -> void:
	position += transform.x * speed * delta
	
func _on_area_entered(area: Area2D) -> void:
	#print("something entered: ", area.name, " - ", area.get_class())
	if area is HurtboxComponent:
		print("entered")
		area.hit.emit(damage_amount, self)
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("wall"):
		queue_free()
