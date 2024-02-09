extends Command

func _ready():
	HELP = "echo [args]: returns arguments"
	MAN = """echo [args]: returns arguments"""

func trigger(arguments: Array[String], _api: TerminalAPI) -> String:
	return " ".join(arguments)

func local_trigger(arguments, api: TerminalAPI) -> String:
	remote_trigger.rpc(arguments, api.get_path())
	return trigger(arguments, api)

@rpc("reliable", "any_peer", "call_remote", 0)
func remote_trigger(arguments, api_path: String):
	trigger(arguments, get_node(api_path))
