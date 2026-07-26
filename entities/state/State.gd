extends Node
class_name State

@warning_ignore("unused_signal")
signal Transitioned(state, new_state_name)

func Enter() -> void:
	pass

func Exit() -> void:
	pass

func Update(_delta: float) -> void:
	pass

func Physics_update(_delta: float) -> void:
	pass
