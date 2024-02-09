extends Node

class_name Command

var HELP := ""
var MAN := """This commands does not contain man"""

func trigger(_arguments: Array[String], _api: TerminalAPI) -> String:
	return ""
