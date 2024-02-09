extends Node

@export var TerminalCast: RayCast3D
@export var PlayerNode: CharacterBody3D
@export var PlayerCamera: Camera3D

var _terminal: Terminal = null
var _previous_camera_transform = null
var _previous_camera_fov = null
var _in_animation := false

func _unhandled_key_input(event):
	if !event.is_action_pressed("terminal") or _in_animation:
		return
	if _terminal == null:
		_enter_terminal()
	else:
		_leave_terminal()

func _enter_terminal():
	if TerminalCast.get_collider() == null:
		return
	_terminal = TerminalCast.get_collider()
	if _terminal.get_use() and !PlayerNode._lock_in:
		_terminal = null
		return
	var tween = create_tween()
	tween.finished.connect(_enter_finished)
	tween.set_ease(Tween.EASE_OUT)
	tween.set_parallel()
	_previous_camera_transform = PlayerCamera.global_transform
	_previous_camera_fov = PlayerCamera.fov
	tween.tween_property(PlayerCamera, "global_transform", _terminal.get_camera().global_transform, 0.1)
	tween.tween_property(PlayerCamera, "fov", _terminal.get_camera().fov, 0.1)
	
	_in_animation = true 
	
	PlayerNode.toggle_lock_in()
	
func _leave_terminal():
	var tween = create_tween()
	tween.finished.connect(_leave_finished)
	tween.set_ease(Tween.EASE_IN)
	tween.set_parallel()
	tween.tween_property(PlayerCamera, "global_transform", _previous_camera_transform, 0.1)
	tween.tween_property(PlayerCamera, "fov", _previous_camera_fov, 0.1)
	_in_animation = true 
	_terminal.toggle_terminal()
	_terminal = null

func _enter_finished():
	_in_animation = false
	PlayerCamera.visible = false
	PlayerCamera.current = false
	_terminal.toggle_terminal()
	
func _leave_finished():
	_in_animation = false
	PlayerCamera.visible = true
	PlayerCamera.current = true
	PlayerNode.toggle_lock_in()
	
