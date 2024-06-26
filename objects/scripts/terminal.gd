extends Node3D

class_name Terminal

@export var CommandContainer: Node

@onready var Camera = $terminal2/Plane_002/TerminalCamera
@onready var LinesContainer: VBoxContainer = $SubViewportContainer/SubViewport/CanvasLayer/Control/MarginContainer/LinesContainer
@onready var TerminalApi: TerminalAPI = $TerminalAPI
@onready var ViewPort: SubViewport = $SubViewportContainer/SubViewport

@onready var _last_line: ConsoleLine = $SubViewportContainer/SubViewport/CanvasLayer/Control/MarginContainer/LinesContainer/ConsoleLine

const CONSOLE_LINE = preload("res://objects/console_line.tscn")
const PREFIX = "> "
const MAX_LINES = 300

var _is_enabled := false
var _is_beeing_used := false

func get_use():
	return _is_beeing_used

func toggle_terminal():
	_is_enabled = !_is_enabled
	_is_beeing_used = _is_enabled
	sync_use.rpc(_is_beeing_used)
	Camera.visible = _is_enabled
	Camera.current = _is_enabled
	if !_is_enabled:
		_last_line.release_text_focus()
	else:
		_last_line.grab_text_focus()
	ViewPort.gui_disable_input = !_is_enabled
	
func _input(event):
	if !_is_enabled or event.is_released():
		return
	if event.as_text() == "Enter":
		_command(_last_line.get_text())
		_add_local_line("", PREFIX)

func get_camera():
	return Camera

func _add_line(text: String, prefix):
	if LinesContainer.get_child_count() >= MAX_LINES:
		_free_lines()
	_last_line = CONSOLE_LINE.instantiate()
	LinesContainer.add_child(_last_line, true)
	_last_line.grab_text_focus()
	_last_line.set_text(text, prefix)
	
func _free_lines():
	var children = LinesContainer.get_children()
	for i in range(0, int(MAX_LINES / 3)):
		children[i].queue_free()

func _command(text: String):
	if CommandContainer == null:
		push_warning("No command container defined")
		return
	
	var command = text.trim_prefix(PREFIX).strip_edges().split(" ")[0]
	if command == "":
		return
	var arguments = text.trim_prefix(PREFIX).strip_edges().trim_prefix(command).strip_edges().split(" ")
	var command_node: Command = CommandContainer.find_child(command.capitalize())
	if command_node == null:
		_add_local_line("Error: unknown command.", "")
		_add_local_line('Type "help" to view commands.', "")
		return
	for line in command_node.local_trigger(arguments, TerminalApi).split("\n"):
		_add_local_line(line, "")

func _add_local_line(text, prefix):
	add_remote_line.rpc(text, prefix)
	sync_input.rpc(text, prefix, _last_line.get_caret_column())
	_add_line(text, prefix)

@rpc("reliable", "any_peer", "call_remote", 0)
func add_remote_line(text: String, prefix):
	_add_line(text, prefix)
	
@rpc("reliable", "any_peer", "call_remote", 0)
func sync_input(text: String, prefix, caret_column):
	_last_line.set_text(text, prefix)
	_last_line.set_text_caret_column(caret_column)

@rpc("reliable", "any_peer", "call_remote", 0)
func sync_use(val):
	_is_beeing_used = val
