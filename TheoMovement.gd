extends CharacterBody3D

@export var anim_tree: AnimationTree
@export var player: Node3D
@export var armature: Node3D
@export var nav: NavigationAgent3D
@export var marker_list: Array[Node3D]
@export var cooldownTime: Timer
@export var InvestigateTime: Timer
@export var wine_area_control: CollisionShape3D
@export var wAcontrol2: Area3D
var animation_choice = 0
@export var adjustment_list: Array[Node3D]
var theo_adjustment = false 
var book_area = false 
var closet_area = false
var adjust_direction

const speed = 0.92
const LERP_VAL = 0.15
var STOPPING_DISTANCE = 1.0  # Distance at which we stop following
const FOLLOW_DISTANCE = 1.2 # Distance at which we resume following (hysteresis buffer)
const STOPPING_BUFFER = 0.2  # Small buffer to prevent jittering
const MIN_STOP_THRESHOLD = 0.05  # Minimum velocity to consider NPC as stationary

var idle_blend = 0.0
var state = IDLE  # Current state of the NPC
var see_player = false
var is_navigating = true
var in_kitchen = false
var rng = RandomNumberGenerator.new()
var investigate_choice = 0
var is_investigating = false 
var going_to_bar = false
var distance_to_target
signal TheoSit 
signal TheoStand
var cooldown = false
var dalton_entered = false
var direct

@export var note_timer: Timer

enum {
	IDLE, 
	FOLLOW,
	SITTING,
	INVESTIGATE,
	ADJUST,
	NOTES
}

func _ready() -> void:
	add_to_group("theo")
	# Initialize the navigation target to the player's position
	nav.target_position = player.global_transform.origin

func _physics_process(delta: float) -> void:
	if is_investigating == true or going_to_bar == true:
		distance_to_target = global_transform.origin.distance_to(marker_list[investigate_choice].global_transform.origin)
	else:
		distance_to_target = global_transform.origin.distance_to(player.global_transform.origin)

	# State management for smoother transitions
	match state:
		IDLE:
			_process_idle_state(distance_to_target)
		FOLLOW:
			_process_follow_state(distance_to_target)
		INVESTIGATE:
			_process_investigate_state(distance_to_target)
		SITTING:
			_process_sitting_state()
		ADJUST:
			_process_adjust_state()
		NOTES:
			_process_notes_state()

	if velocity.length() > MIN_STOP_THRESHOLD:
		_rotate_towards_velocity()
		
		
func _process_notes_state() -> void:
	velocity = velocity.lerp(Vector3.ZERO, 0.0)
	idle_blend = lerp(idle_blend, 0.0, 0.0)
	anim_tree.set("parameters/BlendSpace1D/blend_position", idle_blend)
		

func _process_adjust_state() -> void:
	if nav.is_navigation_finished():
		#if nav.target_position == adjustment_list[4].global_position or nav.target_position == adjustment_list[5].global_position:
			#print("notesTime")
			#is_navigating = false
			#anim_tree["parameters/Blend2/blend_amount"] = 1
			#note_timer.start()
			#state = NOTES
		print("adjusted")
		nav.path_desired_distance = 0.75
		nav.target_desired_distance = 1.0
		STOPPING_DISTANCE = 1.0
		state = IDLE
		
	if not nav.is_navigation_finished():
		var next_point = nav.get_next_path_position()
		var direction = (next_point - armature.global_transform.origin).normalized()
		#direction.y = 0
		var velocity = direction * speed
		anim_tree.set("parameters/BlendSpace1D/blend_position", velocity.length() / speed)
		nav.set_velocity(velocity)

func _process_investigate_state(distance_to_target) -> void:
	if nav.is_navigation_finished() or distance_to_target <= STOPPING_DISTANCE or is_navigating == false:
		if going_to_bar:
			armature.visible = false
			emit_signal("TheoSit")
		if not going_to_bar and animation_choice >= 3:
			anim_tree.set("parameters/NoteAlt/request", true)
		if not going_to_bar and animation_choice <= 2:
			anim_tree.set("parameters/Scratch/request", true)
		velocity = velocity.lerp(Vector3.ZERO, 0.2)
		cooldown = true
		cooldownTime.start()
		InvestigateTime.start()
		state = IDLE
		return
			
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

func _process_sitting_state() -> void:
	wine_area_control.disabled = true
	wAcontrol2.monitoring = false
	
	if Input.is_action_pressed("meeting_done"):
		going_to_bar = false
		armature.visible = true
		is_investigating = true
		investigate_choice = 0
		emit_signal("TheoStand")
		state = IDLE
		
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
	if going_to_bar:
		state = SITTING

	if ((distance_to_target > FOLLOW_DISTANCE and is_navigating and is_investigating == false and going_to_bar == false) and in_kitchen == false):
		print("Switching to FOLLOW state")
		nav.path_desired_distance = 0.75
		nav.target_desired_distance = 1.0
		STOPPING_DISTANCE = 1.0
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
	if body.is_in_group("player") and is_investigating == false:
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

func _on_micah_body_collision_danger() -> void:
	print("micahCollide")
	#is_navigating = false
	#anim_tree["parameters/Blend2/blend_amount"] = 1

func _on_micah_body_collision_safe() -> void:
	print("micahSafe")
	#anim_tree["parameters/Blend2/blend_amount"] = 0
	#is_navigating = true
	#state = FOLLOW

func _on_theo_wander_body_entered(body: Node3D) -> void:
	animation_choice = rng.randi_range(0, 10)
	is_investigating = true
	nav.target_position = marker_list[investigate_choice].global_position
	is_navigating = true
	STOPPING_DISTANCE = 0.0
	state = INVESTIGATE

func _on_investigate_timer_timeout() -> void:
	#print("timerCheck")
	#print(investigate_choice)
	var choice = rng.randi_range(-10, 10)
	investigate_choice = rng.randi_range(0, 2)
	animation_choice = rng.randi_range(0, 10)
	if is_investigating == true and cooldown == false and going_to_bar == false:
		nav.target_position = marker_list[investigate_choice].global_position
		anim_tree.set("parameters/Scratch/request", 2)
		anim_tree.set("parameters/NoteAlt/request", 2)
		is_navigating = true
		STOPPING_DISTANCE = 0.0
		state = INVESTIGATE

func _on_wine_time_body_entered(body: Node3D) -> void:
	print("entered")
	if body.is_in_group("player"):
		print("wine_time")
		is_investigating = false
		going_to_bar = true
		is_navigating = true
		investigate_choice = 3
		nav.target_position = marker_list[investigate_choice].global_position
		STOPPING_DISTANCE = 0.0
		state = INVESTIGATE
		
func _on_cool_down_timer_timeout() -> void:
	cooldown = false

func _on_d_entered_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		print("DaltonLeft")
		dalton_entered = false

func _on_d_entered_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		print("DaltonEntered")
		dalton_entered = true
		#animation_choice = rng.randi_range(0, 10)
		#is_investigating = true
		nav.target_position = marker_list[3].global_position
		is_navigating = true
		STOPPING_DISTANCE = 0.0
		state = ADJUST

func _on_back_move_body_entered(body: Node3D) -> void:
	if theo_adjustment:
		if body.is_in_group("micah"):
			adjust_direction = "front"
			print("change")
			if closet_area:
				nav.target_position = adjustment_list[0].global_position
			elif book_area:
				nav.target_position = adjustment_list[1].global_position
				
			is_navigating = true
			STOPPING_DISTANCE = 0.0
			nav.path_desired_distance = 0.2
			nav.target_desired_distance = 0.4
			state = ADJUST

func _on_front_move_body_entered(body: Node3D) -> void:
	if theo_adjustment:
		if body.is_in_group("micah"):
			adjust_direction = "back"
			print("change")
			if closet_area:
				nav.target_position = adjustment_list[2].global_position
			elif book_area:
				nav.target_position = adjustment_list[3].global_position
			
			is_navigating = true
			STOPPING_DISTANCE = 0.0
			nav.path_desired_distance = 0.2
			nav.target_desired_distance = 0.4
			state = ADJUST
		
func _on_character_body_3d_theo_adjustment() -> void:
	theo_adjustment = true

func _on_character_body_3d_theo_reset() -> void:
	pass
	#if book_area and theo_adjustment:
		#if adjust_direction == "back":
			#nav.target_position = adjustment_list[5].global_position
		#elif adjust_direction == "front":
			#nav.target_position = adjustment_list[4].global_position
		
		#is_navigating = true
		#STOPPING_DISTANCE = 0.0
		#nav.path_desired_distance = 0.2
		#nav.target_desired_distance = 0.4
		#theo_adjustment = false
		#state = ADJUST
		
	#elif closet_area and theo_adjustment:
		#if adjust_direction == "back":
			#nav.target_position = adjustment_list[5].global_position
		#elif adjust_direction == "front":
			#nav.target_position = adjustment_list[4].global_position
	
		#is_navigating = true
		#STOPPING_DISTANCE = 0.0
		#nav.path_desired_distance = 0.2
		#nav.target_desired_distance = 0.4
		#theo_adjustment = false
		#state = ADJUST
	
	#theo_adjustment = false

func _on_bookshelf_became_active() -> void:
	print("Books")
	book_area = true

func _on_bookshelf_became_inactive() -> void:
	print("notBooks")
	book_area = false

func _on_closet_became_active() -> void:
	print("Closet")
	closet_area = true

func _on_closet_became_inactive() -> void:
	print("notCloset")
	closet_area = false

func _on_timer_timeout() -> void:
	pass
	#print("timeFollowAgain")
	#anim_tree["parameters/Blend2/blend_amount"] = 0
	#nav.path_desired_distance = 0.75
	#nav.target_desired_distance = 1.0
	#STOPPING_DISTANCE = 1.0
	#is_navigating = true
	#state = FOLLOW
