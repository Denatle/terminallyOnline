extends Command


func _ready():
	HELP = "help [command]: returns command help"
	MAN = """help: returns all commands
	help [command]: returns command help"""

func trigger(arguments: Array[String], api: TerminalAPI) -> String:
	var command_container: Node = api.get_command_container()
	var return_text = ""
	if arguments == [""]:
		return_text = _get_helps(command_container)
	else:
		return_text = _get_man(arguments[0], command_container)
	return return_text
	
func _get_helps(command_container):
	var command_nodes = command_container.get_children().filter(func(node): return node is Command)
	var return_text = ""
	for command in command_nodes:
		return_text += command.HELP + "\n"
	return return_text.trim_suffix("\n")
	
func _get_man(command: String, command_container):
	var command_node = command_container.get_children().filter(
		func(node): return node is Command and node.name == command.capitalize())
	if command_node.is_empty():
		return 'Unknown command "%s".' % command
	return command_node[0].MAN

func local_trigger(arguments, api: TerminalAPI) -> String:
	remote_trigger.rpc(arguments, api.get_path())
	return trigger(arguments, api)

@rpc("reliable", "any_peer", "call_remote", 0)
func remote_trigger(arguments, api_path: String):
	trigger(arguments, get_node(api_path))
