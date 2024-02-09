extends LineEdit

class_name ConsoleLineText

const PREFIX = "> "
@onready var terminal: Terminal = $"../../../../../../../.."

func disable():
	process_mode = Node.PROCESS_MODE_DISABLED

func _ready():
	text = PREFIX
	caret_column = len(PREFIX)
	caret_force_displayed = true

func _process(_delta) -> void:
	caret_column = clamp(caret_column, len(PREFIX), INF)
	get_selection_to_column()

func _on_text_changed(new_text: String):
	if !new_text.begins_with("> "):
		text = PREFIX + new_text.lstrip(PREFIX)
	terminal.sync_input.rpc(new_text, caret_column)
