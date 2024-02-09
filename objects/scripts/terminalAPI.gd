extends Node

class_name TerminalAPI

@export var TerminalNode: Terminal

func clear() -> void:
	for child in TerminalNode.LinesContainer.get_children():
		TerminalNode.LinesContainer.remove_child(child)

func get_command_container() -> Node:
	return TerminalNode.CommandContainer
