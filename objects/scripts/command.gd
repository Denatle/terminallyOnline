extends Node

class_name Command

var HELP := ""
var MAN := """This commands does not contain man"""

func trigger(_arguments: Array[String], _api: TerminalAPI) -> String:
	return ""

func local_trigger(arguments, api: TerminalAPI) -> String:
	remote_trigger.rpc(arguments, api.get_path())
	return trigger(arguments, api)

@rpc("reliable", "any_peer", "call_remote", 0)
func remote_trigger(arguments, api_path: String):
	trigger(arguments, get_node(api_path))
