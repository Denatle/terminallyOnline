extends Node

class_name State

signal _state_changed(next_state: State)

func enter():
	pass

func exit():
	pass

func update(_delta: float):
	pass

func physics_update(_delta: float):
	pass

func _check_for_state():
	pass
