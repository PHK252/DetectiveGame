extends CharacterBody3D

@export var anim_tree: AnimationTree
@export var player: Node3D
@export var armature: Node3D
@export var nav: NavigationAgent3D

const speed = 0.85
const LERP_VAL = 0.15
const STOPPING_DISTANCE = 1.0  # Distance at which we stop following
const FOLLOW_DISTANCE = 1.2 # Distance at which we resume following (hysteresis buffer)
const STOPPING_BUFFER = 0.2  # Small buffer to prevent jittering
const MIN_STOP_THRESHOLD = 0.05  # Minimum velocity to consider NPC as stationary

var idle_blend = 0.0
var state = IDLE  # Current state of the NPC
var see_player = false
var is_navigating = true
var in_kitchen = false

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
	if not is_on_floor():
			velocity += get_gravity() * delta
	# Ensure NPC gets gravity applied if not on the floor
	#if not is_on_floor():
		#velocity += get_gravity() * delta
	# Calculate distance to the target
	var distance_to_target = global_transform.origin.distance_to(player.global_transform.origin)

	# State management for smoother transitions
	match state:
		IDLE:
			_process_idle_state(distance_to_target)
		FOLLOW:
			_process_follow_state(distance_to_target)
			
	# Apply movement and rotation
	#if is_navigating:
		#move_and_slide()
	if velocity.length() > MIN_STOP_THRESHOLD:
		_rotate_towards_velocity()

# Handles behavior when NPC is in the IDLE state
func _process_idle_state(distance_to_target: float) -> void:
	# Transition to idle animation only if NPC is stationary
	#print("idling")
	velocity = velocity.lerp(Vector3.ZERO, 0.0)
	idle_blend = lerp(idle_blend, 0.0, 0.0)
	anim_tree.set("parameters/BlendSpace1D/blend_position", idle_blend)
	#else:
		# Ensure blend position matches slight movement
		#anim_tree.set("parameters/BlendSpace1D/blend_position", velocity.length() / speed)

	if ((distance_to_target > FOLLOW_DISTANCE and is_navigating) and in_kitchen == false):
		print("Switching to FOLLOW state")
		state = FOLLOW
		return
		
	#if Input.is_action_just_pressed("Exit"):
		#is_navigating = true
		#state = FOLLOW
		
	if see_player:
		if Input.is_action_just_pressed("interact"):
			print("interacted with theo")
			#anim_tree["parameters/Blend2/blend_amount"] = 1
			is_navigating = false
			#await get_tree().create_timer(10).timeout
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
	#print("following")
	# Update navigation target dynamically
	nav.target_position = player.global_transform.origin

	# Stop following if within stopping distance
	if nav.is_navigation_finished() or distance_to_target <= STOPPING_DISTANCE or is_navigating == false:
		velocity = velocity.lerp(Vector3.ZERO, 0.2)
		state = IDLE
		return
		#state = IDLE
		#print("Switching to IDLE state")
		#velocity = velocity.lerp(Vector3.ZERO, 0.2) # 0.2 controls smoothness
	# Ensure NPC fully stops when velocity is low enough
		#if velocity.length() < 0.05:  # Threshold to stop movement
			#velocity = velocity.lerp(Vector3.ZERO, 0.2)
			#state = IDLE
			#return
			

	# Follow the target
	if not nav.is_navigation_finished():
		var next_point = nav.get_next_path_position()
		var direction = (next_point - armature.global_transform.origin).normalized()
		#direction.y = 0
		var velocity = direction * speed 
		anim_tree.set("parameters/BlendSpace1D/blend_position", velocity.length() / speed)
		nav.set_velocity(velocity)
		if is_navigating == false:
			state = IDLE
	else:
		state = IDLE

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
		if in_kitchen == false:
			is_navigating = true
		print("stopped interacting")
		anim_tree["parameters/Blend2/blend_amount"] = 0
	#if area.is_in_group("NPC"):
		#is_navigating = false
		#state = IDLE

func _on_navigation_agent_3d_velocity_computed(safe_velocity: Vector3) -> void:
	velocity = velocity.move_toward(safe_velocity, 0.25)
	if is_navigating:
		move_and_slide()
#func _on_interact_area_area_exited(area: Area3D) -> void:
	#if area.is_in_group("NPC"):
		#if anim_tree["parameters/Blend2/blend_amount"] != 1:
			#is_navigating = true
			#state = FOLLOW

func _on_k_control_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		in_kitchen = true
		is_navigating = false
		state = IDLE

func _on_k_control_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		in_kitchen = false
		is_navigating = true
		state = FOLLOW

#func _on_micah_body_collision_danger() -> void:
	#is_navigating = false
	#state = IDLE

#func _on_micah_body_collision_safe() -> void:
	#is_navigating = true
	#state = FOLLOW
