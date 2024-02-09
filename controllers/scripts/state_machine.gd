extends Node

class_name StateMachine

@export var first_state: State

var _current_state: State

func _ready():
	_enter_state(first_state)

func _process(delta):
	if !_current_state:
		return
	_current_state.update(delta)

func _physics_process(delta):
	if !_current_state:
		return
	_current_state.physics_update(delta)

func _on_state_change(next_state: State):
	_exit_state()
	_enter_state(next_state)

func _enter_state(next_state: State):
	_current_state = next_state
	_current_state._state_changed.connect(_on_state_change)
	_current_state.enter()
	
func _exit_state():
	_current_state.exit()
	_current_state._state_changed.disconnect(_on_state_change)
