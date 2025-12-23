extends CharacterBody3D

#Visibility Controls
@export var packofcigs: Node3D
@export var cig: Node3D
@export var lighter: Node3D
@export var smoke: GPUParticles3D
@export var smoke_release: GPUParticles3D
@export var phone: Node3D
@export var quincyTransform: Node3D
var transform_quincy := false
var just_wentUp := false
var dalton_clear := true
signal stop_dalton
@export var timer_check : Timer
@export var entrance_timer : Timer

@export var wineStatic: Node3D
@export var wineAnim: Node3D
@export var winepoint: Marker3D
@export var after_clog: Node3D

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
var STOPPING_DISTANCE := 1.0 
const STOPPING_BUFFER := 0.4  
const MIN_STOP_THRESHOLD := 0.05 
const FOLLOW_DISTANCE := 0.9 
var idle_blend := 0.0
var is_navigating := false
var accel := 1
var wander_choice := 0
@export var marker_positions: Array[Node3D]
@export var rotate_positions: Array[Node3D]
var see_player := false
var at_door := false
var SPEED := 1.2
var LERP_VAL := 0.1
var rotation_speed := 70
var is_distracted := false
var distraction_rotate := false
var wine_fall := false
var catch_possibility := false
var is_drinking := false
var snowmobile_distraction := false
var general_distraction := false
var poolTable := false
var poolPos
var greeting := false
var rotate_forced := false
var drunk_dalton := false
var entered_catch_zone := false

var fall_allowed := true
var distraction_allowed := true
var rotate_number := 0
var is_activated := false

var sound_allowed := true
@export var leave_position : Marker3D
@export var entrance_position : Marker3D

var in_danger = false
var alarm_active = false
signal play_caught
signal pause_timeout
signal time_out_resume
signal caught_in_view
signal open_doors

@export var sound_player : AnimationPlayer
var end_time := false
var start_time := false
#
signal enable_look
signal disable_look

enum {
	IDLE, 
	FOLLOW,
	DISTRACTED
}

var state := IDLE

func _ready() -> void:
	if GlobalVars.from_save_file == true:
		GlobalVars.from_save_file = false
		global_position = GlobalVars.quincy_pos
	add_to_group("quincy")
	wander_choice = 11
	packofcigs.visible = false
	cig.visible = false
	lighter.visible = false
	wineAnim.visible = false
	smoke.emitting = false 
	phone.visible = false
	rotate_number = 3
	rotate_forced = true
	await get_tree().create_timer(2.0).timeout
	rotate_forced = false
	rotate_number = 0


func _process(delta: float) -> void:
	#print(is_navigating)
	
	if is_distracted == false:
		distance_to_target = armature.global_transform.origin.distance_to(player.global_transform.origin)
	else:
		if end_time == false and start_time == false:
			distance_to_target = armature.global_transform.origin.distance_to(marker_positions[wander_choice].global_position)
		elif end_time:
			distance_to_target = armature.global_transform.origin.distance_to(leave_position.global_position)
		elif start_time:
			distance_to_target = armature.global_transform.origin.distance_to(entrance_position.global_position)

	match state:
		IDLE:
			_process_idle_state(distance_to_target, delta)
		FOLLOW:
			_process_follow_state(distance_to_target)
	
	if is_distracted == true:
		safe_distract_drop()
		toilet_distract_drop()
	
func _physics_process(delta: float) -> void:
	GlobalVars.quincy_pos = global_position
	if is_navigating:
		var direction = Vector3()
		if is_distracted == false and end_time == false and start_time == false:
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
		if velocity.length() > 0.05 and rotate_forced == false:
			if sound_allowed:
				floor_type_walk()
			_rotate_towards_velocity()
		nav.set_velocity(velocity)
	
	#if transform_quincy:
		#quincyTransform.position.y = quincyTransform.position.y - 0.05
		#transform_quincy = false
	
	
	if rotate_forced:
		force_rotate(rotate_number)
		

func _on_navigation_agent_3d_velocity_computed(safe_velocity: Vector3) -> void:
	velocity = velocity.move_toward(safe_velocity, 0.25)
	if is_navigating and velocity.length() > 0.5:
		move_and_slide()
		
func _rotate_towards_velocity() -> void:
	if is_navigating:
		armature.rotation.y = lerp_angle(armature.rotation.y, atan2(velocity.x, velocity.z), LERP_VAL)

func force_rotate(number : int):
	var target = rotate_positions[number].global_position
	var dir = (armature.global_position - target).normalized()
	armature.rotation.y = lerp_angle(armature.rotation.y, atan2(-dir.x, -dir.z), LERP_VAL)
	
#sound handle
func floor_type_walk():
	if $FloorTypeQuincy.is_colliding():
		var collider = $FloorTypeQuincy.get_collider()
		if collider.is_in_group("carpet"):
			sound_player.play("Footsteps_Carpet")
		if collider.is_in_group("snow"):
			sound_player.play("Footsteps_Snow")
		if collider.is_in_group("metal"):
			sound_player.play("Footsteps_Metal")
		if collider.is_in_group("marble"):
			sound_player.play("Footsteps_Marble")
		if collider.is_in_group("wood"):
			sound_player.play("WoodFootsteps")
		
# floor type gather
func floor_type_gather():
	if $FloorTypeQuincy.is_colliding():
		var collider = $FloorTypeQuincy.get_collider()
		if collider.is_in_group("carpet"):
			sound_player.play("FootstepsGather_Carpet")
		if collider.is_in_group("snow"):
			sound_player.play("FootstepsGather_Snow")
		if collider.is_in_group("metal"):
			sound_player.play("FootstepsGather_Metal")
		if collider.is_in_group("marble"):
			sound_player.play("FootstepsGather_Marble")
		if collider.is_in_group("wood"):
			sound_player.play("WoodFootsteps_Gather")


#States
func _process_idle_state(distance_to_target: float, delta: float) -> void:
	# Prevent old path issues
	#print("q_idle")
	velocity = velocity.lerp(Vector3.ZERO, LERP_VAL)
	idle_blend = lerp(idle_blend, 0.0, LERP_VAL)
	quincy_tree.set("parameters/BlendSpace1D/blend_position", idle_blend)
	#if Input.is_action_just_pressed("meeting_done"):
	if end_time:
		is_navigating = false
	
	
	if wander_choice == 2:
		is_navigating = false
		var playPos = (winepoint.global_position - global_transform.origin).normalized()
		armature.rotation.y = lerp_angle(armature.rotation.y, atan2(playPos.x, playPos.z), LERP_VAL)
		is_drinking = true
		#quincy_tree.set("parameters/Blend3/blend_amount", 1)
		
		if Input.is_action_just_pressed("meeting_done"):
			quincy_tree.set("parameters/Wine/request", 2)
			is_drinking = false
			#is_distracted = true
			#is_navigating = true
			#wander_choice = 0
			#nav.target_position = marker_positions[0].global_position
			#state = FOLLOW
			wander_choice = 11
			is_distracted = false
			is_navigating = true
			state = FOLLOW
			

	if wander_choice == 1: 
		quincy_tree.set("parameters/Blend3/blend_amount", 1)
		
	if wander_choice == 4:
		quincy_tree.set("parameters/Blend3/blend_amount", -1)
		
	if wander_choice == 5:
		is_navigating = false
		var snow_pos = (marker_positions[6].global_position - global_transform.origin).normalized()
		armature.rotation.y = lerp_angle(armature.rotation.y, atan2(snow_pos.x, snow_pos.z), LERP_VAL)
	
	if poolTable:
		is_navigating = false
		poolPos = (marker_positions[7].global_position - global_transform.origin).normalized()
		armature.rotation.y = lerp_angle(armature.rotation.y, atan2(poolPos.x, poolPos.z), LERP_VAL)
		
	if ((distance_to_target > FOLLOW_DISTANCE) and is_navigating and not is_distracted and not end_time):
		print("Switching to FOLLOW state")
		quincy_tree.set("parameters/Smoking/request", 2)
		smoke.emitting = false
		packofcigs.visible = false
		lighter.visible = false
		cig.visible = false
		state = FOLLOW
		return
	
func _process_follow_state(distance_to_target: float) -> void:
	#print("q_follow")
	#print(distance_to_target)
	quincy_tree.set("parameters/Smoking/request", 2)
	smoke.emitting = false
	packofcigs.visible = false
	lighter.visible = false
	cig.visible = false
	
	if entered_catch_zone and catch_possibility:
		print("StopQuincyCuzHeCaughtU")
		emit_signal("enable_look")
		is_navigating = false
		state = IDLE
	
	if poolTable:
		state = IDLE
	if distance_to_target <= STOPPING_DISTANCE:
			catch_possibility = false
			#emit_signal("collision_safe")
			#is_navigating = false
			#cooldown_bool = true
			#cooldown.start()
			#wander_timer.start()
			if end_time:
				rotate_number = 4
				rotate_forced = true
			
			if start_time:
				rotate_number = 4
				rotate_forced = true
				entrance_timer.start()
			
			if snowmobile_distraction:
				quincy_tree.set("parameters/Call/request", true)
				phone.visible = true
			
			if wander_choice == 8 or wander_choice == 9:
				is_navigating = false
			
			if wander_choice == 9:
				rotate_number = 0 
				rotate_forced = true
				#await get_tree().create_timer(0.5).timeout
				#rotate_forced = false
			if wander_choice == 10:
				rotate_number = 1
				rotate_forced = true
			
			if wander_choice == 0:
				rotate_number = 2
				rotate_forced = true
				timer_check.start()
					
			if wander_choice == 1:
				sound_player.play("CleanUp")
				
			state = IDLE

#entrance area
func _on_theo_wander_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		pass
		#is_distracted = false
		#rotate_number = 0
		#rotate_forced = false
		#start_time = false
		

func _on_wine_area_quincy_body_entered(body: Node3D) -> void:
	pass
	#if body.is_in_group("player"):
		#is_distracted = true
		#is_navigating = true
		#wander_choice = 0
		#nav.target_position = marker_positions[0].global_position
		#state = FOLLOW
		#if distraction_allowed:
			#if wine_fall == false: 
				#is_distracted = true
				#is_navigating = true
				#wander_choice = 0
				#nav.target_position = marker_positions[0].global_position
				#state = FOLLOW
				#distraction_allowed = false
		
		#if fall_allowed:
			#if wine_fall == true:
				#pass
				#is_distracted = true
				#is_navigating = true
				#wander_choice = 1
				#nav.target_position = marker_positions[1].global_position
				#state = FOLLOW
				#distraction_timer.start()
				#fall_allowed = false
		
func _on_fixed_wine_distraction() -> void:
	wine_fall = true

func _on_dalton_caught_body_entered(body: Node3D) -> void:
	if body.name == "Quincy":
		print("entered catch")
		if catch_possibility and in_danger == true:
			print("quincy caught you")
			if GlobalVars.in_interaction != "":
				emit_signal("caught_in_view")
			else:
				emit_signal("play_caught")
			emit_signal("open_doors")
			

func _on_distraction_time_timeout() -> void:
	print("finished")
	if in_danger == false:
		print("no danger resume")
		is_distracted = false
		Dialogic.VAR.set_variable("Quincy.needs_distraction", true) 
		Dialogic.VAR.set_variable("Quincy.is_distracted", false) 
		emit_signal("time_out_resume")
		catch_possibility = true
	print("catch_possibility")
	if wander_choice == 1:
		quincy_tree.set("parameters/Blend3/blend_amount", 0)
		wander_choice = 11
		is_distracted = false
		is_navigating = true
		general_distraction = false
		state = FOLLOW
	
	if wander_choice == 4:
		after_clog.visible = false
		quincy_tree.set("parameters/Blend3/blend_amount", 0)
		wander_choice = 11
		is_distracted = false
		is_navigating = true
		general_distraction = false
		state = FOLLOW
		
	if wander_choice == 5:
		phone.visible = false
		quincy_tree.set("parameters/Call/request", 2)
		snowmobile_distraction = false
		is_distracted = false
		is_navigating = true
		state = FOLLOW
		
func _on_quincy_one_shot_timer_timeout() -> void:
	if is_drinking:
		emit_signal("disable_look")
		quincy_tree.set("parameters/Wine/request", true)
		sound_player.play("WineSounds")
		await get_tree().create_timer(2.2).timeout
		wineStatic.visible = false
		wineAnim.visible = true
		await get_tree().create_timer(4.0).timeout
		wineStatic.visible = true
		wineAnim.visible = false
		emit_signal("enable_look")

func _on_smoke_time_timeout() -> void:
	if state == IDLE and is_distracted == false and is_navigating and GlobalVars.in_dialogue == false:
		emit_signal("disable_look")
		is_navigating = false
		quincy_tree.set("parameters/Smoking/request", true)
		sound_player.play("SmokeSounds")
		await get_tree().create_timer(2.2).timeout
		packofcigs.visible = true
		await get_tree().create_timer(1.7).timeout
		cig.visible = true
		await get_tree().create_timer(1.7).timeout
		packofcigs.visible = false
		lighter.visible = true
		await get_tree().create_timer(1.2).timeout
		smoke.emitting = true
		await get_tree().create_timer(1.5).timeout
		smoke_release.emitting = true
		smoke.emitting = false
		packofcigs.visible = false
		lighter.visible = false
		cig.visible = false
		is_navigating = true
		emit_signal("enable_look")

func _on_bathroom_q_body_entered(body: Node3D) -> void:
	pass
	#if body.is_in_group("player"):
		#if bathroom_distraction == false:
			#is_distracted = true
			#is_navigating = true
			#wander_choice = 3
			#nav.target_position = marker_positions[3].global_position
			#state = FOLLOW

func _on_bathroom_q_body_exited(body: Node3D) -> void:
	#if body.is_in_group("player"):
		##if bathroom_distraction == false:
			##is_distracted = false
			##is_navigating = true
			##state = FOLLOW
		#
		#if bathroom_distraction == true:
			#is_navigating = true
			#wander_choice = 4
			#nav.target_position = marker_positions[4].global_position
			#state = FOLLOW
			#distraction_timer.start()
	pass

func _on_door_bathroom_replace_quincy_enter_bathroom():
	if general_distraction == true:
		is_navigating = true
		is_distracted = true
		wander_choice = 4
		nav.target_position = marker_positions[4].global_position
		state = FOLLOW
		distraction_timer.start()
		emit_signal("pause_timeout")
			

		
func _on_toilet_stuff_distraction() -> void:
	general_distraction = true

func _on_snowmobile_distraction() -> void:
	snowmobile_distraction = true
	is_distracted = true
	wander_choice = 5
	nav.target_position = marker_positions[5].global_position
	state = FOLLOW
	#distraction_timer.start()

func _on_pool_table_stop_body_entered(body: Node3D) -> void:
	if body.name == "Quincy":
		poolTable = true 
		is_navigating = false
		is_distracted = true
		quincy_tree.set("parameters/Pool/request", true)
		await get_tree().create_timer(15).timeout
		is_distracted = false
		is_navigating = true 
		poolTable = false

func _on_bookshelf_distract(interactor: Interactor) -> void:
	#is_distracted = true
	#is_navigating = true
	#wander_choice = 1
	#nav.target_position = marker_positions[1].global_position
	#state = FOLLOW
	#distraction_timer.start()
	#fall_allowed = false
	pass

func _on_phone_book_distract_quincy():
	is_distracted = true
	is_navigating = true
	general_distraction = true
	wander_choice = 1
	nav.target_position = marker_positions[1].global_position
	state = FOLLOW
	distraction_timer.start()
	emit_signal("pause_timeout")
	fall_allowed = false

func _on_theo_quincy_no_go_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		if state == FOLLOW and is_distracted == false and is_navigating and general_distraction == false:
			emit_signal("enable_look")
			is_navigating = false
			state = IDLE

func _on_theo_quincy_no_go_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		if state == IDLE and is_distracted == false and is_navigating == false and greeting == true and general_distraction == false:
			emit_signal("disable_look")
			is_navigating = true
			state = FOLLOW

func _on_hallway_check_body_entered(body: Node3D) -> void:
	if general_distraction == false:
		emit_signal("enable_look")
		is_distracted = true
		is_navigating = true
		wander_choice = 8
		nav.target_position = marker_positions[8].global_position
		state = FOLLOW

func _on_hallway_check_body_exited(body: Node3D) -> void:
	if general_distraction == false:
		emit_signal("disable_look")
		wander_choice = 11
		is_distracted = false
		is_navigating = true
		#state = FOLLOW

func _on_living_room_adjustment_body_entered(body: Node3D) -> void:
	if body.is_in_group("player") and drunk_dalton == false and general_distraction == false:
		is_distracted = true
		is_navigating = true
		wander_choice = 9
		nav.target_position = marker_positions[9].global_position
		state = FOLLOW

func _on_living_room_adjustment_body_exited(body: Node3D) -> void:
	if body.is_in_group("player") and drunk_dalton == false and general_distraction == false:
		rotate_forced = false
		wander_choice = 11
		is_distracted = false
		is_navigating = true

func _on_painting_adjustment_body_entered(body: Node3D) -> void:
	if body.is_in_group("player") and drunk_dalton == false and general_distraction == false:
		is_distracted = true
		is_navigating = true
		wander_choice = 10
		nav.target_position = marker_positions[10].global_position
		state = FOLLOW

func _on_painting_adjustment_body_exited(body: Node3D) -> void:
	if body.is_in_group("player") and drunk_dalton == false and general_distraction == false:
		rotate_forced = false
		wander_choice = 11
		is_distracted = false
		is_navigating = true

func _on_quincy_lower_body_entered(body: Node3D) -> void:
	#transform_quincy = true
	armature.position.y = armature.position.y - 0.1

func _on_quincy_lower_body_exited(body: Node3D) -> void:
	#transform_quincy = false
	armature.position.y = armature.position.y + 0.05

func _on_pool_t_cam_became_active() -> void:
	if transform_quincy == false:
		armature.position.y = armature.position.y - 0.12
	transform_quincy = true
	

func _on_upstairs_cam_became_active() -> void:
	if transform_quincy == true:
		armature.position.y = armature.position.y + 0.12
	transform_quincy = false

func _on_wine_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player") and general_distraction == false:
		dalton_clear = false

func _on_wine_area_body_exited(body: Node3D) -> void:
	if body.is_in_group("player") and general_distraction == false:
		dalton_clear = true
		if distraction_allowed and dalton_clear:
			if wine_fall == false: 
				pass
				#rotate_forced = false
				#rotate_number = 0
				#emit_signal("stop_dalton")
				#is_distracted = true
				#is_navigating = true
				#wander_choice = 2
				#nav.target_position = marker_positions[2].global_position
				#state = FOLLOW
				#distraction_allowed = false
		

func _on_timer_check_timeout() -> void:
	if distraction_allowed and dalton_clear and general_distraction == false:
			if wine_fall == false: 
				pass
				#rotate_forced = false
				#rotate_number = 0
				#emit_signal("stop_dalton")
				#is_distracted = true
				#is_navigating = true
				#wander_choice = 2
				#nav.target_position = marker_positions[2].global_position
				#state = FOLLOW
				#distraction_allowed = false

func _on_quincy_interact_finish_greeting() -> void:
	greeting = true
	start_time = true
	is_distracted = true
	is_navigating = true
	nav.target_position = entrance_position.global_position
	state = FOLLOW

func _on_activate_q_wander_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		if is_activated == false:
			is_activated = true
			is_navigating = true
		
func safe_distract_drop():
	if distraction_timer.time_left > 0:
		if Dialogic.VAR.get_variable("Quincy.got_safe") == true:
			drop_distract()

func toilet_distract_drop():
	if distraction_timer.time_left > 0:
		if Dialogic.VAR.get_variable("Quincy.got_journal") == true and Dialogic.VAR.get_variable("Quincy.got_phone") == true and Dialogic.VAR.get_variable("Quincy.has_choco") == true and Dialogic.VAR.get_variable("Quincy.got_mail") == true and Dialogic.VAR.get_variable("Quincy.saw_human_pic") == true:
			drop_distract()
			

func drop_distract():
	print("drop")
	distraction_timer.stop()
	distraction_timer.emit_signal("timeout")
	is_distracted = false
	Dialogic.VAR.set_variable("Quincy.needs_distraction", true) 
	Dialogic.VAR.set_variable("Quincy.is_distracted", false) 
	emit_signal("time_out_resume")


func _on_safe_ui_alarm():
	drop_distract()
	alarm_active = true
	in_danger = true


func _on_time_out_drop_distract():
	drop_distract()
	in_danger = false

func _on_danger_body_entered(body):
	if body.is_in_group("player"):
		if is_distracted == true: 
			in_danger = true # Replace with function body.
			print("in danger")


func _on_danger_body_exited(body):
	if body.is_in_group("player"):
		if is_distracted == true and alarm_active == false: 
			in_danger = false
			print("out of danger")
			if catch_possibility == true:
				print("danger resume")
				emit_signal("time_out_resume")
				#Dialogic.VAR.set_variable("Quincy.needs_distraction", false) 
				catch_possibility = false 
		else:
			in_danger = false
				#catch_possibility = false 


func _on_caught_exit_interact():
	emit_signal("play_caught")


func _on_sitting_ppl_dalton_faint() -> void:
	drunk_dalton = true
	is_drinking = false
	is_navigating = false
	armature.visible = false

func _on_cutscene_cams_reposition_dalton() -> void:
	pass

func _on_cutscene_cams_faint_disable() -> void:
	if Dialogic.VAR.get_variable("Juniper.found_skylar") == true:
		pass
		#show quincy
	else:
		#hide quincy
		pass
	sound_allowed = false

func _on_main_door_quincy_reposition() -> void:
	quincy_tree.set("parameters/Smoking/request", 2)
	smoke.emitting = false
	packofcigs.visible = false
	lighter.visible = false
	cig.visible = false
	is_distracted = true
	end_time = true
	is_navigating = true
	nav.path_desired_distance = 0.5
	nav.target_desired_distance = 0.5
	STOPPING_DISTANCE = 0.5
	nav.target_position = leave_position.global_position
	state = FOLLOW

func _on_timer_start_timeout() -> void:
	is_distracted = false
	rotate_number = 0
	rotate_forced = false
	start_time = false
	
	
func _on_bar_interaction_interacted(interactor: Interactor) -> void:
	rotate_forced = false
	rotate_number = 0
	is_distracted = true
	is_navigating = true
	wander_choice = 2
	nav.target_position = marker_positions[2].global_position
	state = FOLLOW
	distraction_allowed = false

func _on_wine_time_body_exited(body: Node3D) -> void:
	if body.is_in_group("player") and general_distraction == false:
		quincy_tree.set("parameters/Wine/request", 2)
		is_drinking = false
		rotate_number = 0
		rotate_forced = false
		wander_choice = 11
		is_distracted = false
		is_navigating = true
		state = FOLLOW

func _on_wine_time_body_entered(body: Node3D) -> void:
	if body.is_in_group("player") and general_distraction == false:
		is_distracted = true
		is_navigating = true
		wander_choice = 0
		nav.target_position = marker_positions[0].global_position
		state = FOLLOW

#handling quincy stoppage after distraction
func _on_catch_navigation_stop_body_entered(body: Node3D) -> void:
	if body.name == "Quincy": #and catch_possibility:
		entered_catch_zone = true

func _on_catch_navigation_stop_body_exited(body: Node3D) -> void:
	if body.name == "Quincy": #and catch_possibility:
		entered_catch_zone = false
