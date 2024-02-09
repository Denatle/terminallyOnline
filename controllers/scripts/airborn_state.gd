extends State

class_name AirbornState

@export var idle: State
@export var walk: State
@export var dash: State

@onready var machine: StateMachine = get_parent()
@onready var character: CharacterBody3D = machine.get_character()

func enter():
	character._current_acceleration = character.default_acceleration/8
	character._current_decceleration = (character.default_acceleration/character.SPEED)/10

func exit():
	character._current_acceleration = character.default_acceleration
	character._current_decceleration = character.default_acceleration/character.SPEED
	
func update(_delta: float):
	pass

func physics_update(_delta: float):
	_check_for_state()

func _check_for_state():
	if character.velocity.length() <= 0.0:
		_state_changed.emit(idle)
		return
	if character.velocity.length() > 0.0 and character.is_on_floor():
		_state_changed.emit(walk)
		return
	#if Input.is_action_pressed("dash"):
		#_state_changed.emit(dash)
		#return
