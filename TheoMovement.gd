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
var allow_activation := true
@export var sound_player : AnimationPlayer
@export var note_sound : AudioStreamPlayer3D
@export var collision_theo : CollisionShape3D

signal allow_stairs
var animation_choice := 0
@export var adjustment_list: Array[Node3D]
var theo_adjustment := false 
var book_area := false 
var closet_area := false
var adjust_direction
signal stop_coll
signal dHALL
signal dINSIDE
var stop_coll_b := false
var micahBack := false
var micahFront := false
var collision_danger := false
var door_scene := false
var patio_sit := false
var entered_junipers := false
var living_room_nogo := false

const speed := 0.92
const LERP_VAL := 0.15
var STOPPING_DISTANCE := 1.0  # Distance at which we stop following
const FOLLOW_DISTANCE := 1.2 # Distance at which we resume following (hysteresis buffer)
const STOPPING_BUFFER := 0.2  # Small buffer to prevent jittering
const MIN_STOP_THRESHOLD := 0.05  # Minimum velocity to consider NPC as stationary

var idle_blend := 0.0
var state := IDLE  # Current state of the NPC
var see_player := false
var is_navigating := true
var in_kitchen := false
var rng = RandomNumberGenerator.new()
var investigate_choice := 0
var is_investigating := false 
var going_to_bar := false
var distance_to_target
signal TheoSit 
signal TheoStand
var cooldown := false
var dalton_entered := false
var direct
var greeting_finished := false

@export var juniper_house = false

@export var note_timer: Timer

signal dalton_enter_level

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
		#print("rotateVelocity")
		_rotate_towards_velocity()
		
	if state == IDLE and theo_adjustment:
		#print("adjustingforplayer")
		_rotate_towards_player()
		

func floor_type_walk():
	if $FloorTypeTheo.is_colliding():
		var collider = $FloorTypeTheo.get_collider()
		if collider.is_in_group("wood"):
			sound_player.play("Footsteps")
		if collider.is_in_group("tile"):
			sound_player.play("Footsteps_Tile")
		if collider.is_in_group("carpet"):
			sound_player.play("Footsteps_Carpet")
		if collider.is_in_group("soil"):
			sound_player.play("Footsteps_Soil")
		if collider.is_in_group("grass"):
			sound_player.play("Footsteps_Grass")
		if collider.is_in_group("woodStairs"):
			sound_player.play("Footsteps_WoodStair")
		if collider.is_in_group("snow"):
			sound_player.play("Footsteps_Snow")
		if collider.is_in_group("metal"):
			sound_player.play("Footsteps_Metal")
		if collider.is_in_group("marble"):
			sound_player.play("Footsteps_Marble")
		
# floor type gather
func floor_type_gather():
	if $FloorTypeTheo.is_colliding():
		var collider = $FloorTypeTheo.get_collider()
		if collider.is_in_group("wood"):
			sound_player.play("FootstepsGather_Wood")
		if collider.is_in_group("tile"):
			sound_player.play("FootstepsGather_Tile")
		if collider.is_in_group("carpet"):
			sound_player.play("FootstepsGather_Carpet")
		if collider.is_in_group("soil"):
			sound_player.play("FootstepsGather_Soil")
		if collider.is_in_group("grass"):
			sound_player.play("FootstepsGather_Grass")
		if collider.is_in_group("woodStairs"):
			sound_player.play("FootstepsGather_WoodStair")
		if collider.is_in_group("snow"):
			sound_player.play("FootstepsGather_Snow")
		if collider.is_in_group("metal"):
			sound_player.play("FootstepsGather_Metal")
		if collider.is_in_group("marble"):
			sound_player.play("FootstepsGather_Marble")
		


func _process_notes_state() -> void:
	velocity = velocity.lerp(Vector3.ZERO, 0.0)
	idle_blend = lerp(idle_blend, 0.0, 0.0)
	anim_tree.set("parameters/BlendSpace1D/blend_position", idle_blend)
		
func _process_adjust_state() -> void:
	if door_scene:
		nav.target_position = player.global_transform.origin
		nav.path_desired_distance = 0.75
		nav.target_desired_distance = 1.0
		STOPPING_DISTANCE = 1.0
		state = FOLLOW
	
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
		floor_type_walk()
		nav.set_velocity(velocity)

func _process_investigate_state(distance_to_target) -> void:
	if nav.is_navigation_finished() or distance_to_target <= STOPPING_DISTANCE or is_navigating == false:
		if patio_sit:
			armature.visible = false
			collision_theo.disabled = true
			emit_signal("TheoSit")
			is_navigating = false
			state = IDLE
			return
		if going_to_bar:
			velocity = velocity.lerp(Vector3.ZERO, 0.2)
			idle_blend = lerp(idle_blend, 0.0, 0.0)
			anim_tree.set("parameters/BlendSpace1D/blend_position", idle_blend)
			await get_tree().create_timer(3).timeout
			armature.visible = false
			collision_theo.disabled = true
			emit_signal("TheoSit")
			is_navigating = false
			state = IDLE
		if not going_to_bar and animation_choice >= 3 and patio_sit == false:
			anim_tree.set("parameters/NoteAlt/request", true)
			#await get_tree().create_timer(6).timeout
			#note_sound.play()
			#await get_tree().create_timer(4).timeout
		if not going_to_bar and animation_choice <= 2 and patio_sit == false:
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
		floor_type_walk()
		nav.set_velocity(velocity)
		if is_navigating == false:
			state = IDLE
	else:
		state = IDLE

func _process_sitting_state() -> void:
	if going_to_bar:
		wine_area_control.disabled = true
		wAcontrol2.monitoring = false
	
	if Input.is_action_pressed("Exit"):
		if patio_sit:
			is_navigating = true
			patio_sit = false
			going_to_bar = false
			armature.visible = true
			collision_theo.disabled = false
			emit_signal("TheoStand")
			state = IDLE
	
	if Input.is_action_pressed("meeting_done"):
		emit_signal("allow_stairs")
		patio_sit = false
		going_to_bar = false
		armature.visible = true
		collision_theo.disabled = false
		animation_choice = rng.randi_range(0, 10)
		investigate_choice = rng.randi_range(0, 3)
		is_investigating = true
		nav.target_position = marker_list[investigate_choice].global_position
		is_navigating = true
		nav.path_desired_distance = 0.75
		nav.target_desired_distance = 1.0
		STOPPING_DISTANCE = 0.0
		emit_signal("TheoStand")
		state = INVESTIGATE
		
		
# Handles behavior when NPC is in the IDLE state
func _process_idle_state(distance_to_target: float) -> void:
	# Transition to idle animation only if NPC is stationary
	#print("idling")
	if juniper_house:
		nav.radius = 0.01
		#nav.neighbor_distance = 0.1
	velocity = velocity.lerp(Vector3.ZERO, 0.0)
	idle_blend = lerp(idle_blend, 0.0, 0.0)
	anim_tree.set("parameters/BlendSpace1D/blend_position", idle_blend)
	#else:
		# Ensure blend position matches slight movement
		#anim_tree.set("parameters/BlendSpace1D/blend_position", velocity.length() / speed)
		
	if going_to_bar or patio_sit:
		state = SITTING

	if ((distance_to_target > FOLLOW_DISTANCE and is_navigating and is_investigating == false and going_to_bar == false) and in_kitchen == false and theo_adjustment == false):
		print("Switching to FOLLOW state")
		nav.path_desired_distance = 0.75
		nav.target_desired_distance = 1.0
		STOPPING_DISTANCE = 1.0
		anim_tree["parameters/Blend2/blend_amount"] = 0
		note_sound.stop()
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
	# Update navigation target dynamically
	nav.target_position = player.global_transform.origin

	if juniper_house:
		nav.radius = 0.5
		#nav.neighbor_distance = 50
	# Stop following if within stopping distance
	if nav.is_navigation_finished() or distance_to_target <= STOPPING_DISTANCE or is_navigating == false:
		floor_type_gather()
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
		floor_type_walk()
		nav.set_velocity(velocity)
		if is_navigating == false:
			state = IDLE
	else:
		state = IDLE

func _on_interact_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player") and is_investigating == false and going_to_bar == false:
		print("waiting for interact")
		see_player = true
		state = IDLE
		
	if body.is_in_group("micah") and theo_adjustment:
		print("abort")
		is_navigating = false
		state = IDLE

func _on_interact_area_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		print("left")
		see_player = false

# Smoothly rotate the armature to face the movement direction
func _rotate_towards_velocity() -> void:
	if is_navigating:
		armature.rotation.y = lerp_angle(armature.rotation.y, atan2(velocity.x, velocity.z), LERP_VAL)

func _rotate_towards_player() -> void:
	var direct = (player.global_position - armature.global_position).normalized()
	armature.rotation.y = lerp_angle(armature.rotation.y, atan2(direct.x, direct.z), LERP_VAL)

func _on_interact_area_area_entered(area: Area3D) -> void:
	if area.is_in_group("int_area") and theo_adjustment == false:
		if stop_coll_b == false:
			print("theo investigating")
			anim_tree["parameters/Blend2/blend_amount"] = 1
			is_navigating = false
			emit_signal("stop_coll")
			stop_coll_b = true
			await get_tree().create_timer(6).timeout
			note_sound.play()
			await get_tree().create_timer(4).timeout
			
			if micahBack and theo_adjustment:
				anim_tree["parameters/Blend2/blend_amount"] = 0
				adjust_direction = "front"
				print("change front")
				if closet_area:
					print("change frontC")
					if collision_danger:
						#print("weareindanger")
						nav.target_position = adjustment_list[6].global_position
					else:
						print("thischoice")
						nav.target_position = adjustment_list[0].global_position
					is_navigating = true
					#STOPPING_DISTANCE = 0.2
					#nav.path_desired_distance = 0.4
					#nav.target_desired_distance = 0.6
					print("stateChange")
					state = ADJUST
				elif book_area:
					print("frontChangeBOOK")
					nav.target_position = adjustment_list[1].global_position
					is_navigating = true
					#STOPPING_DISTANCE = 0.2
					#nav.path_desired_distance = 0.4
					#nav.target_desired_distance = 0.6
					state = ADJUST
			if micahFront and theo_adjustment:
				anim_tree["parameters/Blend2/blend_amount"] = 0
				adjust_direction = "back"
				print("change back")
				if closet_area:
					print("change backC")
					nav.target_position = adjustment_list[2].global_position
					is_navigating = true
					#STOPPING_DISTANCE = 0.2
					#nav.path_desired_distance = 0.4
					#nav.target_desired_distance = 0.6
					state = ADJUST
				elif book_area:
					print("backChangeBOOK")
					nav.target_position = adjustment_list[3].global_position
					
					is_navigating = true
					#STOPPING_DISTANCE = 0.2
					#nav.path_desired_distance = 0.2
					#nav.target_desired_distance = 0.4
					state = ADJUST
			
			
			if in_kitchen == false:
				is_navigating = true
			print("stopped interacting")
			anim_tree["parameters/Blend2/blend_amount"] = 0
			state = FOLLOW
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
		if anim_tree["parameters/Blend2/blend_amount"] == 0:
			is_navigating = true
			state = FOLLOW

func _on_micah_body_collision_danger() -> void:
	print("micahCollide")
	collision_danger = true
	#is_navigating = false
	#anim_tree["parameters/Blend2/blend_amount"] = 1

func _on_micah_body_collision_safe() -> void:
	print("micahSafe")
	collision_danger = false
	#anim_tree["parameters/Blend2/blend_amount"] = 0
	#is_navigating = true
	#state = FOLLOW

func _on_theo_wander_body_entered(body: Node3D) -> void:
	if allow_activation:
		print("ENTEREDWANDER")
		animation_choice = rng.randi_range(0, 10)
		investigate_choice = rng.randi_range(0, 2)
		is_investigating = true
		nav.target_position = marker_list[investigate_choice].global_position
		is_navigating = true
		STOPPING_DISTANCE = 0.0
		state = INVESTIGATE
		allow_activation = false
	

func _on_investigate_timer_timeout() -> void:
	#print("timerCheck")
	#print(investigate_choice)
	if living_room_nogo == false:
		var choice = rng.randi_range(-10, 10)
		investigate_choice = rng.randi_range(0, 2)
		animation_choice = rng.randi_range(0, 10)
		if is_investigating == true and cooldown == false and going_to_bar == false and patio_sit == false:
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
		anim_tree.set("parameters/Scratch/request", 2)
		anim_tree.set("parameters/NoteAlt/request", 2)
		is_investigating = false
		going_to_bar = true
		is_navigating = true
		investigate_choice = 3
		nav.target_position = marker_list[investigate_choice].global_position
		nav.path_desired_distance = 0.2
		nav.target_desired_distance = 0.2
		STOPPING_DISTANCE = 0.0
		state = INVESTIGATE
		
func _on_cool_down_timer_timeout() -> void:
	cooldown = false

func _on_d_entered_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		print("DaltonLeft")
		dalton_entered = false
		emit_signal("dHALL")

func _on_d_entered_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		emit_signal("dINSIDE")
		print("DaltonEntered")
		dalton_entered = true
		emit_signal("dalton_enter_level")
		#animation_choice = rng.randi_range(0, 10)
		#is_investigating = true
		nav.target_position = marker_list[3].global_position
		is_navigating = true
		STOPPING_DISTANCE = 0.0
		state = ADJUST

func _on_back_move_body_entered(body: Node3D) -> void:
	if body.is_in_group("micah"):
		print("backtM")
		micahBack = true
		micahFront = false
	#if theo_adjustment:
		#if body.is_in_group("micah"):
			#adjust_direction = "front"
			#print("change")
			#if closet_area:
				#nav.target_position = adjustment_list[0].global_position
			#elif book_area:
				#nav.target_position = adjustment_list[1].global_position
				
			#is_navigating = true
			#STOPPING_DISTANCE = 0.0
			#nav.path_desired_distance = 0.2
			#nav.target_desired_distance = 0.4
			#state = ADJUST
func _on_front_move_body_entered(body: Node3D) -> void:
	if body.is_in_group("micah"):
		print("frontM")
		micahFront = true 
		micahBack = false
	
	#if theo_adjustment:
		#if body.is_in_group("micah"):
			#adjust_direction = "back"
			#print("change")
			#if closet_area:
				#nav.target_position = adjustment_list[2].global_position
			#elif book_area:
				#nav.target_position = adjustment_list[3].global_position
			
			#is_navigating = true
			#STOPPING_DISTANCE = 0.0
			#nav.path_desired_distance = 0.2
			#nav.target_desired_distance = 0.4
			#state = ADJUST
		
func _on_character_body_3d_theo_adjustment() -> void:
	#print("ADJUSTTT")
	theo_adjustment = true
	await get_tree().create_timer(1.5).timeout
	if micahBack and theo_adjustment:
		if anim_tree["parameters/Blend2/blend_amount"] == 1:
			state = IDLE
			return
		adjust_direction = "front"
		print("change front")
		if closet_area:
			print("change frontC")
			if collision_danger:
				#print("dangerhere")
				is_navigating = true
				state = IDLE
				#nav.target_position = adjustment_list[6].global_position
			else:
				nav.target_position = adjustment_list[0].global_position
			is_navigating = true
			#STOPPING_DISTANCE = 0.2
			#nav.path_desired_distance = 0.4
			#nav.target_desired_distance = 0.6
			state = ADJUST
		elif book_area:
			print("frontChangeBOOK")
			nav.target_position = adjustment_list[1].global_position
				
			is_navigating = true
			#STOPPING_DISTANCE = 0.2
			#nav.path_desired_distance = 0.4
			#nav.target_desired_distance = 0.6
			state = ADJUST
	if micahFront and theo_adjustment:
		if anim_tree["parameters/Blend2/blend_amount"] == 1:
			state = IDLE
			return
		adjust_direction = "back"
		print("change back")
		if closet_area:
			print("change backC")
			if collision_danger:
				#print("dangerhere")
				is_navigating = true
				state = IDLE
				#nav.target_position = adjustment_list[6].global_position
			else:
				nav.target_position = adjustment_list[2].global_position
			is_navigating = true
			STOPPING_DISTANCE = 0.2
			nav.path_desired_distance = 0.4
			nav.target_desired_distance = 0.6
			state = ADJUST
		elif book_area:
			print("backChangeBOOK")
			nav.target_position = adjustment_list[3].global_position
			is_navigating = true
			STOPPING_DISTANCE = 0.0
			nav.path_desired_distance = 0.2
			nav.target_desired_distance = 0.4
			state = ADJUST

func _on_character_body_3d_theo_reset() -> void:
	theo_adjustment = false
	if in_kitchen == false:
		is_navigating = true
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

func _on_micah_interact_tstart() -> void:
	print("STARTEDTHEO")
	door_scene = false
	#state = FOLLOW

func _on_micah_interact_tstop() -> void:
	print("STOPPEDTHEO")
	door_scene = true

func _on_sitting_ppl_theo_out() -> void:
	if is_investigating == false:
		is_investigating = false
		patio_sit = true
		is_navigating = true
		investigate_choice = 4
		nav.target_position = marker_list[investigate_choice].global_position
		STOPPING_DISTANCE = 0.0
		state = INVESTIGATE


func _on_left_porch_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		#print("adjustRight")
		theo_adjustment = true
		nav.target_position = adjustment_list[0].global_position
		is_navigating = true
		STOPPING_DISTANCE = 0.0
		nav.path_desired_distance = 0.2
		nav.target_desired_distance = 0.4
		state = ADJUST

func _on_right_porch_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		#print("adjustLeft")
		theo_adjustment = true
		nav.target_position = adjustment_list[1].global_position
		is_navigating = true
		STOPPING_DISTANCE = 0.0
		nav.path_desired_distance = 0.2
		nav.target_desired_distance = 0.4
		state = ADJUST

func _on_sofa_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		#print("adjustMiddle")
		theo_adjustment = true
		in_kitchen = true
		nav.target_position = adjustment_list[2].global_position
		is_navigating = true
		STOPPING_DISTANCE = 0.0
		nav.path_desired_distance = 0.2
		nav.target_desired_distance = 0.4
		state = ADJUST

func _on_right_porch_body_exited(body: Node3D) -> void:
	theo_adjustment = false

func _on_left_porch_body_exited(body: Node3D) -> void:
	theo_adjustment = false

func _on_sofa_area_body_exited(body: Node3D) -> void:
	theo_adjustment = false
	in_kitchen = false 

func _on_interactable_interacted_Juniper(interactor: Interactor) -> void:	
	#print("noteTakeStop")
	theo_adjustment = true
	#is_navigating = false
	#state = NOTES
	#print("theo note_take")
	#anim_tree["parameters/Blend2/blend_amount"] = 1
	#anim_tree.set("parameters/NoteAlt/request", true)
	#await get_tree().create_timer(6).timeout
	#note_sound.play()
	await get_tree().create_timer(2).timeout
	#anim_tree["parameters/Blend2/blend_amount"] = 0
	#state = IDLE
	theo_adjustment = false
	#is_navigating = true
	
func _on_interactable_interacted_cafe(interactor: Interactor) -> void:
	nav.target_position = adjustment_list[3].global_position
	is_navigating = true
	STOPPING_DISTANCE = 0.0
	nav.path_desired_distance = 0.2
	nav.target_desired_distance = 0.4
	state = ADJUST

func _on_cam_books_became_active() -> void:
	await get_tree().create_timer(1.5).timeout
	if entered_junipers:
		is_navigating = false
		await get_tree().create_timer(2.5).timeout
		nav.target_position = adjustment_list[4].global_position
		is_navigating = true
		STOPPING_DISTANCE = 0.0
		nav.path_desired_distance = 0.2
		nav.target_desired_distance = 0.4
		state = ADJUST

func _on_door_point_body_entered(body: Node3D) -> void:
	if body.is_in_group("theo"):
		if greeting_finished:
			entered_junipers = true 
			print("doingtheent")

func _on_door_point_body_exited(body: Node3D) -> void:
	if body.is_in_group("theo"):
		if greeting_finished:
			entered_junipers = false
			print("doingtheext")

func _on_juniper_interact_finish_greeting() -> void:
	greeting_finished = true

func _on_door_second_juniper_greeting() -> void:
	theo_adjustment = true
	await get_tree().create_timer(2).timeout
	theo_adjustment = false

func _on_theo_no_go_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		if state == FOLLOW:
			in_kitchen = true
			is_navigating = false
			state = IDLE

func _on_theo_no_go_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		if state == IDLE and is_investigating == false:
			in_kitchen = false
			is_navigating = true
			state = FOLLOW

func _on_living_room_no_go_theo_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		living_room_nogo = true
		anim_tree.set("parameters/Scratch/request", 2)
		anim_tree.set("parameters/NoteAlt/request", 2)
		investigate_choice = 0
		nav.target_position = marker_list[investigate_choice].global_position
		is_navigating = true
		STOPPING_DISTANCE = 0.0
		state = INVESTIGATE

func _on_living_room_no_go_theo_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		living_room_nogo = false
		anim_tree.set("parameters/Scratch/request", 2)
		anim_tree.set("parameters/NoteAlt/request", 2)
		investigate_choice = 2
		nav.target_position = marker_list[investigate_choice].global_position
		is_navigating = true
		STOPPING_DISTANCE = 0.0
		state = INVESTIGATE

func _on_painting_adjustment_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		living_room_nogo = true
		anim_tree.set("parameters/Scratch/request", 2)
		anim_tree.set("parameters/NoteAlt/request", 2)
		investigate_choice = 2
		nav.target_position = marker_list[investigate_choice].global_position
		is_navigating = true
		STOPPING_DISTANCE = 0.0
		state = INVESTIGATE

func _on_painting_adjustment_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		living_room_nogo = false
		anim_tree.set("parameters/Scratch/request", 2)
		anim_tree.set("parameters/NoteAlt/request", 2)
		investigate_choice = 1
		nav.target_position = marker_list[investigate_choice].global_position
		is_navigating = true
		STOPPING_DISTANCE = 0.0
		state = INVESTIGATE
