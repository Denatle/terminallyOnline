class_name ConsoleLine extends HBoxContainer

@onready var console_line_text: LineEdit = $ConsoleLineText
@onready var prefix_label: Label = $Prefix
@onready var terminal: Terminal = $"../../../../../../.."

func _ready() -> void:
	console_line_text.set_focus_mode(Control.FOCUS_ALL)
	console_line_text.grab_focus()
	
func get_text():
	return console_line_text.text

func grab_text_focus() -> void:
	console_line_text.grab_focus()

func release_text_focus():
	console_line_text.release_focus()

func set_text_caret_column(caret_collum):
	console_line_text.caret_column = caret_collum
	
func get_caret_column():
	return console_line_text.caret_column

func remove_prefix():
	prefix_label.queue_free()

func set_text(text: String, prefix: String) -> void:
	if !prefix:
		remove_prefix()
	console_line_text.text = text


func _on_console_line_text_text_changed(new_text: String) -> void:
	if prefix_label != null:
		terminal.sync_input.rpc(new_text, prefix_label.text, console_line_text.caret_column)
		return
	terminal.sync_input.rpc(new_text, "", console_line_text.caret_column)
	
