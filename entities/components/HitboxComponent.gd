extends Area2D
class_name HitboxComponent

signal hit_landed(hurtbox: HurtboxComponent, damage: float)

@export var attack_info: AttackInfo

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	print("body entered")
	
	if not area is HurtboxComponent:
		print("not hurtbox")
		return
	
	if attack_info == null:
		push_warning("HitboxComponent: attack_info not set")
		return
	
	print("sending attack")
	var hurtbox := area as HurtboxComponent
	var was_valid := hurtbox.take_damage(attack_info, self)

	if was_valid:
		hit_landed.emit(hurtbox, attack_info.damage_amount)
