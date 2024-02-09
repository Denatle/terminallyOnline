extends Command

func _ready():
	HELP = "clear: clears console"
	MAN = """clear: clears console"""

func trigger(_arguments: Array[String], api: TerminalAPI) -> String:
	api.clear()
	return ""
