extends Node3D

const PLAYER = preload("res://controllers/player.tscn")

@onready var players: Node = $Players

func add_player(peer_id):
	var player = PLAYER.instantiate()
	player.name = str(peer_id)
	players.add_child(player)
	
func remove_player(peer_id):
	var player = get_node_or_null("Players/"+str(peer_id))
	if player:
		player.queue_free()
