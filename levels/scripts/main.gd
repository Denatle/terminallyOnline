extends Node

@onready var scene_container: Node = $SceneContainer
@onready var menu: CanvasLayer = $Menu
@onready var ip_entry: LineEdit = $Menu/PanelContainer/MarginContainer/VBoxContainer/IPEntry


var previous_scene = null
var enet_peer = ENetMultiplayerPeer.new()

const PORT = 9999

const PLAYER = preload("res://controllers/player.tscn")
const MULTIPLAYER_TEST = preload("res://levels/multiplayer_test.tscn")
const TEST = preload("res://levels/test.tscn")


func _unhandled_key_input(event):
	if !event.is_action_pressed("exit"):
		return
	get_tree().quit()

func _on_exit_button_pressed() -> void:
	get_tree().quit()

func _on_single_button_pressed() -> void:
	menu.hide()
	load_scene(TEST)
	add_player(multiplayer.get_unique_id())

func _on_host_button_pressed() -> void:
	menu.hide()
	
	load_scene(MULTIPLAYER_TEST)
	
	enet_peer.create_server(PORT)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(remove_player)
	
	add_player(multiplayer.get_unique_id())
	
	#upnp_setup()

func _on_join_button_pressed() -> void:
	menu.hide()
	
	load_scene(MULTIPLAYER_TEST)
	
	enet_peer.create_client(ip_entry.text, PORT)
	multiplayer.multiplayer_peer = enet_peer
	
	add_player(multiplayer.get_unique_id())

func load_scene(scene: PackedScene):
	if previous_scene:
		scene_container.remove_child(previous_scene)
	
	var new_scene = scene.instantiate()
	scene_container.add_child(new_scene)
	previous_scene = new_scene

func add_player(peer_id):
	previous_scene.add_player(peer_id)

func remove_player(peer_id):
	previous_scene.remove_player(peer_id)

#func upnp_setup():
	#var upnp = UPNP.new()
	#var discover_result = upnp.discover()
	#
	#assert(discover_result == UPNP.UPNP_RESULT_SUCCESS, \
		#"UPNP Discover Failed! Error %s" % discover_result)
#
	#assert(upnp.get_gateway() and upnp.get_gateway().is_valid_gateway(), \
		#"UPNP Invalid Gateway!")
#
	#var map_result = upnp.add_port_mapping(PORT)
	#assert(map_result == UPNP.UPNP_RESULT_SUCCESS, \
		#"UPNP Port Mapping Failed! Error %s" % map_result)
	#
	#print("Success! Join Address: %s" % upnp.query_external_address())
