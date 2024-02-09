extends State

class_name IdleState

#signal _state_changed(next_state: State)

@export var walk: State
@export var airborn: State
@export var slide: State
@export var dash: State

@onready var machine: StateMachine = get_parent()
@onready var character: CharacterBody3D = machine.get_character()


func physics_update(_delta: float):
	_check_for_state()

func _check_for_state():
	if character.velocity.length() <= 0.0:
		return
	if !character.is_on_floor():
		_state_changed.emit(airborn)
		return
	#if Input.is_action_pressed("dash"):
		#_state_changed.emit(dash)
		#return
	#if Input.is_action_pressed("slide"):
		#_state_changed.emit(slide)
		#return
	_state_changed.emit(walk)

func _unhandled_input(_event):
	_check_for_state()

