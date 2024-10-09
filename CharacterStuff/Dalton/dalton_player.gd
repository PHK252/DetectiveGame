extends CharacterBody3D

@export var speed = 7.0
@export var jump_velocity = 20
@export var gravity = 50.0

var _velocity = Vector3.ZERO
var _snap_vector = Vector3.DOWN

@onready var _spring_arm = $SpringArm3D
@onready var _model = $Detective

func _physics_process(delta: float) -> void:
	var move_direction = Vector3.ZERO
	move_direction.x = Input.get_action_strength("Right") - Input.get_action_strength("Left")
	move_direction.z = Input.get_action_strength("Back") - Input.get_action_strength("Forward")
	move_direction = move_direction.rotated(Vector3.UP, _spring_arm.rotation.y).normalized()
	
	_velocity.x = move_direction.x * speed
	_velocity.z = move_direction.z * speed
	_velocity.y -= gravity * delta
	
	var just_landed = is_on_floor() and _snap_vector == Vector3.ZERO
	var is_jumping = is_on_floor() and Input.is_action_just_pressed("Jump")
	if is_jumping:
		_velocity.y = jump_velocity
		_snap_vector = Vector3.ZERO
	elif just_landed:
		_snap_vector = Vector3.DOWN
	#_velocity = move_and_slide_with_snap(_velocity, _snap_vector, Vector3.UP, true)
	#floor_stop_on_slope(true)
	if _velocity.length() > 0.2:
		var look_direction = Vector2(_velocity.z, _velocity.x)
		_model.rotation.y = look_direction.angle()
	pass

func _process(_delta: float) -> void:
	_spring_arm.position = position
	pass
