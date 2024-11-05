extends CharacterBody3D

@onready var armature = %DetectiveT7
@onready var anim_tree = $AnimationTree
@onready var pos_x = 0
@onready var pos_y = 0
@onready var marker = $Marker2D
@onready var camera = $"../../SubViewportContainer/SubViewport/CameraSystem/Camera3D"
const SPEED = 1.15
const LERP_VAL = .15

func _ready() -> void:
	add_to_group("player")

func _physics_process(delta: float) -> void:
	GlobalVars.player_pos = global_position
	# Add the gravity.
	if GlobalVars.player_move == true:
		if not is_on_floor():
			velocity += get_gravity() * delta
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var input_dir := Input.get_vector("Right", "Left", "Back", "Forward")
		var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			velocity.x = lerp(velocity.x, direction.x * SPEED, LERP_VAL)
			velocity.z = lerp(velocity.z, direction.z * SPEED, LERP_VAL)
			armature.rotation.y = lerp_angle(armature.rotation.y, atan2(velocity.x, velocity.z), LERP_VAL)

		else:
			velocity.x = lerp(velocity.x, 0.0, LERP_VAL)
			velocity.z = lerp(velocity.z, 0.0, LERP_VAL)
		
		
		#var pos = global_transform.origin
		#var marker_pos = camera.unproject_position(pos)
		#marker_pos = marker_pos * 6
		#marker_pos.x = marker_pos.x + 90
		#marker_pos.y = marker_pos.y - 550
		#print(marker_pos)
		#marker.position = marker_pos

		
		anim_tree.set("parameters/BlendSpace1D/blend_position", velocity.length() / SPEED)

		move_and_slide()
	else:
		anim_tree.set("parameters/BlendSpace1D/blend_position", 0)

func stop_player():
	GlobalVars.player_move = false

func start_player():
	GlobalVars.player_move = true
	
