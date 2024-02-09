extends CharacterBody3D

class_name Player1

signal died(peer_id: String)

@export var SPEED: float = 12.0
@export var default_acceleration: float = 150
@export var JUMP_VELOCITY: float = 4
@export var MOUSE_SENSITIVITY: float = 0.15
@export var TILT_LOWER_LIMIT:= deg_to_rad(-90.0)
@export var TILT_UPPER_LIMIT:= deg_to_rad(90.0)
@export var strafe_camera_rotation_aplifier: float = 0.06
@export var strafe_rotation_speed: float = 15

@onready var CAMERA_CONTROLLER = $Smoothing/Camera3D
@onready var view_model: Camera3D = $Smoothing/Camera3D/SubViewportContainer/SubViewport/ViewModel
@onready var sub_viewport: SubViewport = $Smoothing/Camera3D/SubViewportContainer/SubViewport
@onready var sub_viewport_container: SubViewportContainer = $Smoothing/Camera3D/SubViewportContainer
@onready var gun_controller: Node3D = $Smoothing/Camera3D/GunController

var _mouse_input: bool = false
var _rotation_input: float
var _tilt_input: float
var _mouse_rotation: Vector3
var _player_rotation: float
var _camera_rotation: float
var _current_acceleration: float = default_acceleration
var _current_decceleration: float = default_acceleration / SPEED

var health = 3

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var _active := false

func _enter_tree() -> void:
	set_multiplayer_authority(str(name).to_int())
	_active = true

func _ready():
	sub_viewport.size = DisplayServer.window_get_size()
	# Get mouse input
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if !is_multiplayer_authority():
		sub_viewport_container.hide()
	pass

func _unhandled_input(event: InputEvent) -> void:
	if !_active or !is_multiplayer_authority():
		return
		
	_mouse_input = event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	if _mouse_input:
		_rotation_input = -event.relative.x * MOUSE_SENSITIVITY
		_tilt_input = -event.relative.y * MOUSE_SENSITIVITY
		
func _update_camera(delta):
	### Rotates camera using euler rotation
	_mouse_rotation.x += _tilt_input * 0.008
	_mouse_rotation.x = clamp(_mouse_rotation.x, TILT_LOWER_LIMIT, TILT_UPPER_LIMIT)
	_mouse_rotation.y += _rotation_input * 0.008
	
	_player_rotation = _mouse_rotation.y
	_camera_rotation = _mouse_rotation.x

	CAMERA_CONTROLLER.rotation.x = _camera_rotation
	global_rotation.y = _player_rotation

	var axis = Input.get_axis("move_right", "move_left") * strafe_camera_rotation_aplifier
	var new_rotation = Vector3(_camera_rotation, CAMERA_CONTROLLER.rotation.y, axis)
	CAMERA_CONTROLLER.rotation = lerp(CAMERA_CONTROLLER.rotation, new_rotation, delta*strafe_rotation_speed)
	gun_controller.rotation.z = CAMERA_CONTROLLER.rotation.z*2.5

	_rotation_input = 0.0
	_tilt_input = 0.0
	

func _process(delta):
	if !_active or !is_multiplayer_authority():
		return
		
	_update_camera(delta)

func _physics_process(delta):
	if !_active or !is_multiplayer_authority():
		return
	print(velocity.length())
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	velocity.x += direction.x * _current_acceleration * delta
	velocity.z += direction.z * _current_acceleration * delta
	velocity.x -= velocity.x * _current_decceleration * delta
	velocity.z -= velocity.z * _current_decceleration * delta
	
	if abs(velocity.x) < 1 and is_on_floor() and direction == Vector3.ZERO:
		velocity.x = 0
	if abs(velocity.z) < 1 and is_on_floor() and direction == Vector3.ZERO:
		velocity.z = 0
		
	move_and_slide()
