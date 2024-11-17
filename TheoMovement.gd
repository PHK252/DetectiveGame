extends CharacterBody3D

@export var anim_tree : AnimationTree
@export var player : Node3D
@export var armature = Node3D
@export var WaitTimer : Timer
@export var nav : NavigationAgent3D
const speed = 1.15
const LERP_VAL = 0.15
const STOPPING_DISTANCE = 1  # Distance at which we start slowing down
const STOPPING_BUFFER = 0.2   # Small buffer to prevent jittering
var idle_blend = 0.0
var is_stopping = false
var stopping_velocity = Vector3.ZERO  # We use this for smoothing out velocity deceleration

func _ready() -> void:
	# No need to set the target position here. It will be updated dynamically.
	pass

func _physics_process(delta: float) -> void:
	# Ensure NPC gets gravity applied if not on the floor
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Dynamically update the target position to the player's current position
	nav.target_position = player.global_transform.origin

	# Calculate distance to the target
	var distance_to_target = global_transform.origin.distance_to(nav.target_position)

	if distance_to_target <= STOPPING_DISTANCE:
		if is_stopping == false:
			is_stopping = true
			stopping_velocity = velocity.lerp(Vector3.ZERO, LERP_VAL)
			velocity = stopping_velocity
			print("stopped")
			idle_blend = lerp(idle_blend, 0.0, LERP_VAL)
			anim_tree.set("parameters/BlendSpace1D/blend_position", idle_blend)
	else:
		is_stopping = false
		anim_tree.set("parameters/BlendSpace1D/blend_position", velocity.length() / speed)

	# Check if there's a valid path to follow
	if nav.is_navigation_finished():
		return  # Pathfinding is complete; no need to move further

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
