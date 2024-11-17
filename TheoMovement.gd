extends CharacterBody3D

@export var anim_tree : AnimationTree
@export var player : Node3D
@export var armature = Node3D
@export var WaitTimer : Timer
@export var nav : NavigationAgent3D
const speed = 1.15
const LERP_VAL = .15
const STOPPING_DISTANCE = 0.7
const STOPPING_BUFFER = 0.2

var is_stopping = false

func _ready() -> void:
	nav.target_position = player.global_transform.origin

func _physics_process(delta: float) -> void:
	if not is_on_floor():
			velocity += get_gravity() * delta
	# Update the target position dynamically to follow the player
	nav.target_position = player.global_transform.origin

	# Check if there's a valid path to follow
	if nav.is_navigation_finished():
		return  # Pathfinding is complete; no need to move further

	var distance_to_target = global_transform.origin.distance_to(nav.target_position)

	# If within the stopping distance, stop moving
	if distance_to_target <= STOPPING_DISTANCE:
		if not is_stopping:
			velocity = velocity.lerp(Vector3.ZERO, LERP_VAL)  # Gradually reduce velocity
			if velocity.length() < 0.1:
				is_stopping = true  # Fully stop when velocity is almost zero
		return
	else:
		is_stopping = false

	# Get the next point on the path
	var next_point = nav.get_next_path_position()

	# Calculate direction to the next point
	var direction = (next_point - global_transform.origin).normalized()

	# Move towards the next point
	velocity = direction * speed
	move_and_slide()

	# Smoothly rotate to face the direction
	if direction.length() > 0.1:
		armature.rotation.y = lerp_angle(armature.rotation.y, atan2(direction.x, direction.z), LERP_VAL)
	
	
