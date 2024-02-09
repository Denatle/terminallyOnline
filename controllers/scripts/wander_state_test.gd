extends State

class_name WanderStateTest

@export var guy: CharacterBody3D

#signal _state_changed(next_state: State)

var _move_direction: Vector2
var _wander_time: float

func _randomize_wander():
	_move_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	_wander_time = randf_range(1, 3)

func enter():
	_randomize_wander()

func update(delta: float):
	_check_for_state()
	
	if _wander_time > 0:
		_wander_time -= delta
		return
	

func physics_update(_delta: float):
	var velocity = _move_direction * 10
	guy.velocity = Vector3(velocity.x, 0, velocity.y)
	guy.move_and_slide()

func _check_for_state():
	pass
