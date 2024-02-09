extends Command

func _ready():
	HELP = "echo [args]: returns arguments"
	MAN = """echo [args]: returns arguments"""

func trigger(arguments: Array[String], _api: TerminalAPI) -> String:
	return " ".join(arguments)
