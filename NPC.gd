extends CharacterBody3D

@export var anim_tree : AnimationTree
@export var player : CharacterBody3D
@export var armature = CharacterBody3D
#@export var WaitTimer : Timer
@export var NPC : String
@onready var object_interaction = false
@export var nav: NavigationAgent3D
@export var target: Marker3D

const STOPPING_DISTANCE = 1.0  # Distance at which we stop following
const STOPPING_BUFFER = 0.4  # Small buffer to prevent jittering
const MIN_STOP_THRESHOLD = 0.05  # Minimum velocity to consider NPC as stationary
#const FOLLOW_DISTANCE = 1.2 

var idle_blend = 0.0
var is_navigating = false
var targ_reach = false
var accel = 8

enum {
	IDLE, 
	FOLLOW,
	WANDER,
	CAUGHT,
	FIXING
}

var state = IDLE
var see_player = false
var at_door = false
var SPEED = 1.15
var LERP_VAL = .15
var rotation_speed = 70

func _ready() -> void:
	state = IDLE
	
func _process(delta: float) -> void:
	var distance_to_target = armature.global_transform.origin.distance_to(player.global_transform.origin)
	match state:
		IDLE:
			_process_idle_state(distance_to_target, delta)
		FOLLOW:
			_process_follow_state(distance_to_target)
	
func _physics_process(delta: float) -> void:

	if is_navigating:
		var direction = Vector3()
		nav.target_position = player.global_position
		direction = nav.get_next_path_position() - global_position
		direction = direction.normalized()
		#direction.y = 0
		velocity = velocity.lerp(direction * SPEED, accel * delta)
		anim_tree.set("parameters/BlendSpace1D/blend_position", velocity.length() / SPEED)
		nav.set_velocity(velocity)

	if velocity.length() > MIN_STOP_THRESHOLD:
		_rotate_towards_velocity()

func _process_idle_state(distance_to_target: float, delta: float) -> void:
	#print("idle")
	# Prevent old path issues
	velocity = velocity.lerp(Vector3.ZERO, LERP_VAL)
	idle_blend = lerp(idle_blend, 0.0, LERP_VAL)
	anim_tree.set("parameters/BlendSpace1D/blend_position", idle_blend)

	#if idle for await timer 4 seconds and num == 1, 2, 3 prob
	#casual
	#yawn anim
	#scratch butt anim
	#looking ani
	
	#marker3D options
	#active marker index from dialogic signal
	
	# play animation 1: put tool in
	# play anim 2: look at photo
	# anim 3: look out window
	# if 4 go to sitting state
	
	#marker 3D at couch, sit method, restart nav upon int
	

	#if velocity.length() <= MIN_STOP_THRESHOLD:
		#idle_blend = lerp(idle_blend, 0.0, LERP_VAL)
		#anim_tree.set("parameters/BlendSpace1D/blend_position", idle_blend)
	#else:
		# Ensure blend position matches slight movement
		#anim_tree.set("parameters/BlendSpace1D/blend_position", velocity.length() / speed
	
func _process_follow_state(distance_to_target: float) -> void:
	# Follow the target
	# Stop following if within stopping distance
	if distance_to_target <= STOPPING_DISTANCE:
			is_navigating = false
			state = IDLE

func _process_wander_state(distance_to_target: float) -> void:
	return
	
func _process_fixing_state(distance_to_target: float) -> void:
	return
	
func _process_caught_state(distance_to_target: float) -> void:
	return
		
func _rotate_towards_velocity() -> void:
	armature.rotation.y = lerp_angle(armature.rotation.y, atan2(velocity.x, velocity.z), LERP_VAL)
		
func _on_interactable_interacted(interactor: Interactor) -> void:
	is_navigating = true
	state = FOLLOW

func _on_navigation_agent_3d_velocity_computed(safe_velocity: Vector3) -> void:
	velocity = velocity.move_toward(safe_velocity, 0.25)
	if is_navigating:
		move_and_slide()
