extends Node3D
@onready var gun: Node3D = $Gun
@onready var ray_cast_3d: RayCast3D = $"../RayCast3D"


func _ready() -> void:
	if !is_multiplayer_authority():
		set_view_layer(gun, 1, true)
		set_view_layer(gun, 3, false)

func set_view_layer(node: Node, layer: int, value: bool):
	var children = node.get_children()[0].get_children()
	for child in children:
		var mesh: MeshInstance3D = child
		mesh.set_layer_mask_value(layer, value)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		shoot()

func shoot():
	if !ray_cast_3d.is_colliding():
		return
	print(ray_cast_3d.get_collider().name)
