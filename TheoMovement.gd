extends CharacterBody3D

@export var anim_tree: AnimationTree
@export var player: Node3D
@export var armature: Node3D
@export var nav: NavigationAgent3D

const speed = 1.15
const LERP_VAL = 0.15
const STOPPING_DISTANCE = 0.8  # Distance at which we stop following
const FOLLOW_DISTANCE = 1.2  # Distance at which we resume following (hysteresis buffer)
const STOPPING_BUFFER = 0.2  # Small buffer to prevent jittering
const MIN_STOP_THRESHOLD = 0.05  # Minimum velocity to consider NPC as stationary

var idle_blend = 0.0
var state = IDLE  # Current state of the NPC
var see_player = false
var is_navigating = true

enum {
	IDLE, 
	FOLLOW,
	NOTES
}

func _ready() -> void:
	add_to_group("theo")
	# Initialize the navigation target to the player's position
	nav.target_position = player.global_transform.origin

func _physics_process(delta: float) -> void:
	# Ensure NPC gets gravity applied if not on the floor
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Calculate distance to the target
	var distance_to_target = global_transform.origin.distance_to(player.global_transform.origin)

	# State management for smoother transitions
	match state:
		IDLE:
			_process_idle_state(distance_to_target)
		FOLLOW:
			_process_follow_state(distance_to_target)
			

	# Apply movement and rotation
	if is_navigating:
		move_and_slide()
	if velocity.length() > MIN_STOP_THRESHOLD:
		_rotate_towards_velocity()

# Handles behavior when NPC is in the IDLE state
func _process_idle_state(distance_to_target: float) -> void:
	# Transition to idle animation only if NPC is stationary
	if velocity.length() <= MIN_STOP_THRESHOLD:
		idle_blend = lerp(idle_blend, 0.0, LERP_VAL)
		anim_tree.set("parameters/BlendSpace1D/blend_position", idle_blend)
	else:
		# Ensure blend position matches slight movement
		anim_tree.set("parameters/BlendSpace1D/blend_position", velocity.length() / speed)

	if distance_to_target > FOLLOW_DISTANCE:
		print("Switching to FOLLOW state")
		state = FOLLOW
		
	if see_player:
		if Input.is_action_just_pressed("interact"):
			print("interacted")
			anim_tree["parameters/Blend2/blend_amount"] = 1
			is_navigating = false
			await get_tree().create_timer(10).timeout
			is_navigating = true
			print("stopped interacting")
			anim_tree["parameters/Blend2/blend_amount"] = 0
			see_player = false
		if Input.is_action_just_pressed("Exit"):
			is_navigating = true
			print("stopped interacting")
			anim_tree["parameters/Blend2/blend_amount"] = 0
			see_player = false
		

# Handles behavior when NPC is in the FOLLOW state
func _process_follow_state(distance_to_target: float) -> void:
	# Update navigation target dynamically
	nav.target_position = player.global_transform.origin

	# Stop following if within stopping distance
	if distance_to_target <= STOPPING_DISTANCE:
		print("Switching to IDLE state")
		state = IDLE
		return

	# Follow the target
	if not nav.is_navigation_finished():
		var next_point = nav.get_next_path_position()
		var direction = (next_point - global_transform.origin).normalized()
		velocity = direction * speed
		anim_tree.set("parameters/BlendSpace1D/blend_position", velocity.length() / speed)

func _on_interact_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		print("waiting for interact")
		see_player = true
		state = IDLE

func _on_interact_area_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		print("left")
		see_player = false

# Smoothly rotate the armature to face the movement direction
func _rotate_towards_velocity() -> void:
	if is_navigating:
		armature.rotation.y = lerp_angle(armature.rotation.y, atan2(velocity.x, velocity.z), LERP_VAL)

func _on_interact_area_area_entered(area: Area3D) -> void:
	if area.is_in_group("int_area"):
		print("theo investigating")
		anim_tree["parameters/Blend2/blend_amount"] = 1
		is_navigating = false
		await get_tree().create_timer(10).timeout
		is_navigating = true
		print("stopped interacting")
		anim_tree["parameters/Blend2/blend_amount"] = 0
