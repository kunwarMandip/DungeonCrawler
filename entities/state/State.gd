extends Node
class_name State

signal Transitioned(state, new_state_name)

func Enter() -> void:
	pass

func Exit() -> void:
	pass

func Update(_delta: float) -> void:
	pass

func Physics_update(_delta: float) -> void:
	pass
