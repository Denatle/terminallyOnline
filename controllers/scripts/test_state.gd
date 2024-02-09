extends State

class_name TestState

@export var idle: State

var count = 0

func enter():
	pass

func exit():
	pass

func update(_delta: float):
	pass

func physics_update(_delta: float):
	#print("yep"+str(count))
	count+=1
	_check_for_state()

func _check_for_state():
	_state_changed.emit(idle)
