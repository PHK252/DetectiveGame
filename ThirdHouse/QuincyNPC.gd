extends CharacterBody3D

#Visibility Controls
@export var packofcigs: Node3D
@export var cig: Node3D
@export var lighter: Node3D

#Animation Controls
@export var tail_anim: AnimationTree
@export var cig_anim: AnimationPlayer
@export var quincy_tree: AnimationTree

#AI NAV controls
@export var nav: NavigationAgent3D
@export var player: CharacterBody3D
@export var armature: Node3D
@export var distraction_timer: Timer
var distance_to_target
var STOPPING_DISTANCE = 1.0 
const STOPPING_BUFFER = 0.4  
const MIN_STOP_THRESHOLD = 0.05 
const FOLLOW_DISTANCE = 1.2 
var idle_blend = 0.0
var is_navigating = false
var accel = 10
var wander_choice = 0
@export var marker_positions: Array[Node3D]
var see_player = false
var at_door = false
var SPEED = 0.8
var LERP_VAL = 0.1
var rotation_speed = 70
var is_distracted = false
var distraction_rotate = false
var wine_fall = false
var catch_possibility = false

enum {
	IDLE, 
	FOLLOW,
	DISTRACTED
}

var state = IDLE

func _ready() -> void:
	add_to_group("quincy")
	packofcigs.visible = false
	cig.visible = false
	lighter.visible = false
	
func _process(delta: float) -> void:
	if is_distracted == false:
		distance_to_target = armature.global_transform.origin.distance_to(player.global_transform.origin)
	else:
		distance_to_target = armature.global_transform.origin.distance_to(marker_positions[wander_choice].global_position)

	match state:
		IDLE:
			_process_idle_state(distance_to_target, delta)
		FOLLOW:
			_process_follow_state(distance_to_target)
	
func _physics_process(delta: float) -> void:
	if is_navigating:
		var direction = Vector3()
		if is_distracted == false:
			nav.path_desired_distance = 0.75
			nav.target_desired_distance = 1.0
			STOPPING_DISTANCE = 1.0
			nav.target_position = player.global_position
		else:
			nav.path_desired_distance = 0.5
			nav.target_desired_distance = 0.5
			STOPPING_DISTANCE = 0.5
		direction = nav.get_next_path_position() - global_position
		direction = direction.normalized()
		#direction.y = 0
		velocity = velocity.lerp(direction * SPEED, accel * delta)
		quincy_tree.set("parameters/BlendSpace1D/blend_position", velocity.length() / SPEED)
		_rotate_towards_velocity()
		nav.set_velocity(velocity)

func _on_navigation_agent_3d_velocity_computed(safe_velocity: Vector3) -> void:
	velocity = velocity.move_toward(safe_velocity, 0.25)
	if is_navigating:
		move_and_slide()
		
func _rotate_towards_velocity() -> void:
	if is_navigating:
		armature.rotation.y = lerp_angle(armature.rotation.y, atan2(velocity.x, velocity.z), LERP_VAL)

#States
func _process_idle_state(distance_to_target: float, delta: float) -> void:
	# Prevent old path issues
	#print("q_idle")
	velocity = velocity.lerp(Vector3.ZERO, LERP_VAL)
	idle_blend = lerp(idle_blend, 0.0, LERP_VAL)
	quincy_tree.set("parameters/BlendSpace1D/blend_position", idle_blend)
	
	if wander_choice == 1: 
		quincy_tree.set("parameters/Blend3/blend_amount", 1)
	
	if ((distance_to_target > FOLLOW_DISTANCE) and is_navigating and not is_distracted):
		print("Switching to FOLLOW state")
		state = FOLLOW
		return
	
func _process_follow_state(distance_to_target: float) -> void:
	#print("q_follow")
	#print(distance_to_target)
	if distance_to_target <= STOPPING_DISTANCE:
			catch_possibility = false
			#emit_signal("collision_safe")
			#is_navigating = false
			#cooldown_bool = true
			#cooldown.start()
			#wander_timer.start()
			state = IDLE

func _on_theo_wander_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		is_navigating = true

func _on_wine_area_quincy_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		if wine_fall == false: 
			is_distracted = true
			is_navigating = true
			wander_choice = 0
			nav.target_position = marker_positions[0].global_position
			state = FOLLOW
		
		if wine_fall == true:
			is_distracted = true
			is_navigating = true
			wander_choice = 1
			nav.target_position = marker_positions[1].global_position
			state = FOLLOW
			distraction_timer.start()
		
func _on_fixed_wine_distraction() -> void:
	wine_fall = true

func _on_dalton_caught_body_entered(body: Node3D) -> void:
	#print("quincy_entered")
	if body.name == "Quincy":
		print("quincy_entered")
		if catch_possibility:
			print("quincy caught you")

func _on_distraction_time_timeout() -> void:
	print("finished")
	catch_possibility = true
	if wander_choice == 1:
		quincy_tree.set("parameters/Blend3/blend_amount", 0)
		wander_choice = 10
		is_distracted = false
		is_navigating = true
