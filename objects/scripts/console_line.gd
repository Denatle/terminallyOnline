extends LineEdit

class_name ConsoleLine

const PREFIX = "> "
@onready var terminal: Terminal = $"../../../../../../.."

func disable():
	process_mode = Node.PROCESS_MODE_DISABLED

func _ready():
	text = PREFIX
	caret_column = len(PREFIX)

func _process(delta: float) -> void:
	caret_column = clamp(caret_column, len(PREFIX), INF)

func _on_text_changed(new_text: String):
	if !new_text.begins_with("> "):
		text = PREFIX + new_text.lstrip(PREFIX)
	terminal.sync_input.rpc(new_text, caret_column)
