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
@export var fainted_player : Marker3D
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
var quincy_greet := false
var faint_dalton := false
var waterfall_scene := false
var sofa_scene := false
var juniper_clear := true
var needs_seven := false

var stopped_theo_for_tea := false

@export var drunk_marker : Marker3D
@export var theo_node : CharacterBody3D
@export var stairMarker : Marker3D

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
var force_idle_closet := false
@export var timeout_pos : Marker3D

@export var secret_location := false

@export var quincy_house := false 

@export var juniper_house = false

@export var note_timer: Timer

signal dalton_enter_level
signal look_at_activate
signal look_at_disactivate
signal force_quincy_bar

signal two_targ_dalton(targ: int)

var in_nav_danger := false

signal block_stairs

enum {
	IDLE, 
	FOLLOW,
	SITTING,
	INVESTIGATE,
	ADJUST,
	NOTES
}

var allow_QH_switch := false

func _ready() -> void:
	add_to_group("theo")
	print(GlobalVars.theo_pos)
	if GlobalVars.in_level:
		match GlobalVars.current_level:
			"micah":
				if GlobalVars.micah_kicked_out == true or GlobalVars.micah_time_out == true:
					GlobalVars.theo_pos = timeout_pos.position
			"juniper":
				if GlobalVars.juniper_kicked_out == true or GlobalVars.juniper_time_out == true:
					GlobalVars.theo_pos = timeout_pos.position
			"quincy":
				if GlobalVars.quincy_kicked_out == true or GlobalVars.quincy_time_out == true:
					GlobalVars.theo_pos = timeout_pos.position
	if GlobalVars.from_save_file == true:
		global_position = GlobalVars.theo_pos
		await get_tree().process_frame
		GlobalVars.from_save_file = false
	#global_position = GlobalVars.theo_pos
	# Initialize the navigation target to the player's position
	nav.target_position = player.global_transform.origin
	
	if quincy_house:
		Dialogic.signal_event.connect(_on_dialogic_signal)
		if GlobalVars.in_level == true:
			print("in_level_quincy")
			#force investigate
			greeting_finished = true
			animation_choice = rng.randi_range(0, 10)
			investigate_choice = rng.randi_range(0, 2)
			is_investigating = true
			nav.target_position = marker_list[investigate_choice].global_position
			is_navigating = true
			STOPPING_DISTANCE = 0.0
			state = INVESTIGATE
			allow_activation = false
	
	if secret_location:
		global_position = marker_list[0].global_position
		is_navigating = false
		
	await get_tree().create_timer(2.0).timeout
	allow_QH_switch = true

func _physics_process(delta: float) -> void:
	GlobalVars.theo_pos = global_position
	
	if is_investigating == true or going_to_bar == true:
		distance_to_target = global_transform.origin.distance_to(marker_list[investigate_choice].global_transform.origin)
	elif waterfall_scene:
		distance_to_target = global_transform.origin.distance_to(marker_list[0].global_transform.origin)
	else:
		distance_to_target = global_transform.origin.distance_to(player.global_transform.origin)
		if GlobalVars.in_level and quincy_house and allow_QH_switch: #if following in quincy's house block stairs once
			quincy_house = false 
			emit_signal("block_stairs")

	#teleportTest
	#if Input.is_action_just_pressed("meeting_done"):
		#_on_bar_theo_enter_bar()
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
		if waterfall_scene or sofa_scene:
			emit_signal("look_at_activate")
			#theo_adjustment = true
			quick_adjust()
		state = IDLE
		
	if not nav.is_navigation_finished():
		var next_point = nav.get_next_path_position()
		var direction = (next_point - armature.global_transform.origin).normalized()
		#direction.y = 0
		var velocity = direction * speed
		anim_tree.set("parameters/BlendSpace1D/blend_position", velocity.length() / speed)
		floor_type_walk()
		nav.set_velocity(velocity)

func quick_adjust():
	theo_adjustment = true
	await get_tree().create_timer(1.0).timeout
	theo_adjustment = false

func _process_investigate_state(distance_to_target) -> void:
	if needs_seven: #forceful gating
		investigate_choice = 7
		
	if nav.is_navigation_finished() or distance_to_target <= STOPPING_DISTANCE:
		if investigate_choice == 7:
			faint_dalton = true #neededcondition
			theo_adjustment = false
			is_investigating = false
			is_navigating = true 
			nav.path_desired_distance = 0.75
			nav.target_desired_distance = 1.0
			STOPPING_DISTANCE = 1.0
			state = FOLLOW
	
	
		
	
	
	if (nav.is_navigation_finished() or distance_to_target <= STOPPING_DISTANCE or is_navigating == false) and faint_dalton == false:
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
			await get_tree().create_timer(0.5).timeout
			armature.visible = false
			collision_theo.disabled = true
			emit_signal("force_quincy_bar")
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
		if patio_sit and GlobalVars.in_dialogue == false:
			is_navigating = true
			patio_sit = false
			going_to_bar = false
			armature.visible = true
			collision_theo.disabled = false
			emit_signal("TheoStand")
			state = IDLE
	
	#if Input.is_action_pressed("meeting_done"): old test
		#emit_signal("allow_stairs")
		#patio_sit = false
		#going_to_bar = false
		#armature.visible = true
		#collision_theo.disabled = false
		#animation_choice = rng.randi_range(0, 10)
		#investigate_choice = rng.randi_range(0, 3)
		#is_investigating = true
		#nav.target_position = marker_list[investigate_choice].global_position
		#is_navigating = true
		#nav.path_desired_distance = 0.75
		#nav.target_desired_distance = 1.0
		#STOPPING_DISTANCE = 0.0
		#emit_signal("TheoStand")
		#state = INVESTIGATE
		
		
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

	if ((distance_to_target > FOLLOW_DISTANCE and is_navigating and is_investigating == false and going_to_bar == false) and in_kitchen == false and theo_adjustment == false and (quincy_greet == false or faint_dalton) and waterfall_scene == false):
		print("Switching to FOLLOW state", " Theo")
		
		#print("is_nav" + str(is_navigating))
		#print("is_inv" + str(is_investigating))
		#print("got_greeting" + str(quincy_greet))
		#print("faint_var" + str(faint_dalton))
		
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
	if quincy_greet == false:
		nav.target_position = player.global_transform.origin
		
	if faint_dalton:
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
	if body.is_in_group("player") and is_investigating == false and going_to_bar == false and greeting_finished and secret_location == false:
		print("waiting for interact")
		see_player = true
		#state = IDLE
		#Possibly causing freezing in certain scenarios, need to be careful
		
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
	if faint_dalton == false:
		var direct = (player.global_position - armature.global_position).normalized()
		armature.rotation.y = lerp_angle(armature.rotation.y, atan2(direct.x, direct.z), LERP_VAL)
	else:
		var direct = (fainted_player.global_position - armature.global_position).normalized()
		armature.rotation.y = lerp_angle(armature.rotation.y, atan2(direct.x, direct.z), LERP_VAL)

func _on_interact_area_area_entered(area: Area3D) -> void:
	if area.is_in_group("int_area") and theo_adjustment == false:
		if stop_coll_b == false:
			print("theo investigating")
			anim_tree["parameters/Blend2/blend_amount"] = 1
			is_navigating = false
			emit_signal("stop_coll")
			stop_coll_b = true
			
			if micahBack and theo_adjustment:
				anim_tree["parameters/Blend2/blend_amount"] = 0
				adjust_direction = "front"
				print("change front")
				if closet_area:
					print("change frontC")
					return
					#if collision_danger:
						##print("weareindanger")
						#nav.target_position = adjustment_list[6].global_position
					#else:
						#print("thischoice")
						#return
						##nav.target_position = adjustment_list[0].global_position
					#is_navigating = true
					##STOPPING_DISTANCE = 0.2
					##nav.path_desired_distance = 0.4
					##nav.target_desired_distance = 0.6
					#print("stateChange")
					#state = ADJUST
				elif book_area:
					print("frontChangeBOOK")
					return
					#nav.target_position = adjustment_list[1].global_position
					#is_navigating = true
					##STOPPING_DISTANCE = 0.2
					##nav.path_desired_distance = 0.4
					##nav.target_desired_distance = 0.6
					#state = ADJUST
			if micahFront and theo_adjustment:
				anim_tree["parameters/Blend2/blend_amount"] = 0
				adjust_direction = "back"
				print("change back")
				if closet_area:
					return
					#print("change backC")
					#nav.target_position = adjustment_list[2].global_position
					#is_navigating = true
					##STOPPING_DISTANCE = 0.2
					##nav.path_desired_distance = 0.4
					##nav.target_desired_distance = 0.6
					#state = ADJUST
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
	if body.is_in_group("player") and in_nav_danger == false:
		emit_signal("look_at_activate")
		emit_signal("two_targ_dalton", 2)
		in_kitchen = true
		is_navigating = false
		state = IDLE
	elif body.is_in_group("theo"):
			#in_kitchen = false
			in_nav_danger = true
			nav.target_position = adjustment_list[8].global_position
			is_navigating = true
			state = ADJUST
			#hopefully micah is never behind sofa
		#force_idle_closet = true
		#if around sofa then force idle and look at dalton

func _on_k_control_body_exited(body: Node3D) -> void:
	if body.is_in_group("player") and in_nav_danger == false:
		emit_signal("look_at_disactivate")
		emit_signal("two_targ_dalton", 1)
		in_kitchen = false
		if anim_tree["parameters/Blend2/blend_amount"] == 0:
			is_navigating = true
			state = FOLLOW
	elif body.is_in_group("theo"):
		in_nav_danger = false
	#if body.is_in_group("theo"):
		#force_idle_closet = false

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
	if greeting_finished == false:
		quincy_greet = true
		nav.target_position = marker_list[6].global_position
		STOPPING_DISTANCE = 0.0
	#if allow_activation:
		#print("ENTEREDWANDER")
		#animation_choice = rng.randi_range(0, 10)
		#investigate_choice = rng.randi_range(0, 2)
		#is_investigating = true
		#nav.target_position = marker_list[investigate_choice].global_position
		#is_navigating = true
		#STOPPING_DISTANCE = 0.0
		#state = INVESTIGATE
		#allow_activation = false
	

func _on_investigate_timer_timeout() -> void:
	#print("timerCheck")
	#print(investigate_choice)
	if living_room_nogo == false and faint_dalton == false and going_to_bar == false:
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
	#print("entered")
	#if body.is_in_group("player"):
		#print("wine_time")
		#anim_tree.set("parameters/Scratch/request", 2)
		#anim_tree.set("parameters/NoteAlt/request", 2)
		#is_investigating = false
		#going_to_bar = true
		#is_navigating = true
		#investigate_choice = 3
		#nav.target_position = marker_list[investigate_choice].global_position
		#nav.path_desired_distance = 0.2
		#nav.target_desired_distance = 0.2
		#STOPPING_DISTANCE = 0.0
		#state = INVESTIGATE
		pass

func _sofa_drink_dalton():
	theo_adjustment = true
	in_kitchen = true
	nav.target_position = adjustment_list[2].global_position
	is_navigating = true
	STOPPING_DISTANCE = 0.0
	nav.path_desired_distance = 0.2
	nav.target_desired_distance = 0.4
	state = ADJUST
	
func _sofa_exit_dalton():
	theo_adjustment = false
	#in_kitchen = false 

func _on_bar_theo_enter_bar():
	print("wine_time")
	theo_node.global_position = stairMarker.global_position
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
			return
			#if collision_danger:
				##print("dangerhere")
				#is_navigating = true
				#state = IDLE
				#return
				##nav.target_position = adjustment_list[6].global_position
			#else:
				#return
				##nav.target_position = adjustment_list[0].global_position
			#is_navigating = true
			##STOPPING_DISTANCE = 0.2
			##nav.path_desired_distance = 0.4
			##nav.target_desired_distance = 0.6
			#state = ADJUST
		elif book_area:
			print("frontChangeBOOK")
			return
			#nav.target_position = adjustment_list[1].global_position
				#
			#is_navigating = true
			##STOPPING_DISTANCE = 0.2
			##nav.path_desired_distance = 0.4
			##nav.target_desired_distance = 0.6
			#state = ADJUST
	if micahFront and theo_adjustment:
		return
		#if anim_tree["parameters/Blend2/blend_amount"] == 1:
			#state = IDLE
			#return
		#adjust_direction = "back"
		#print("change back")
		#if closet_area:
			#print("change backC")
			#if collision_danger:
				##print("dangerhere")
				#is_navigating = true
				#state = IDLE
				##nav.target_position = adjustment_list[6].global_position
			#else:
				#nav.target_position = adjustment_list[2].global_position
			#is_navigating = true
			#STOPPING_DISTANCE = 0.2
			#nav.path_desired_distance = 0.4
			#nav.target_desired_distance = 0.6
			#state = ADJUST
		#elif book_area:
			#print("backChangeBOOK")
			#nav.target_position = adjustment_list[3].global_position
			#is_navigating = true
			#STOPPING_DISTANCE = 0.0
			#nav.path_desired_distance = 0.2
			#nav.target_desired_distance = 0.4
			#state = ADJUST

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
	if body.is_in_group("player") and stopped_theo_for_tea == false:
		#print("adjustMiddle")
		#theo_adjustment = true
		sofa_scene = true
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
	#theo_adjustment = false
	if stopped_theo_for_tea == false:
		emit_signal("look_at_disactivate")
		sofa_scene = false
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
	if juniper_clear == true:
		nav.target_position = adjustment_list[3].global_position
		is_navigating = true
		STOPPING_DISTANCE = 0.0
		nav.path_desired_distance = 0.2
		nav.target_desired_distance = 0.4
		state = ADJUST

func _on_cam_books_became_active() -> void:
	#await get_tree().create_timer(1.5).timeout
	#if entered_junipers:
	pass
		

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
	theo_adjustment = false
	#######
	is_navigating = false
	await get_tree().create_timer(1.0).timeout
	#is_navigating = true
	nav.target_position = adjustment_list[4].global_position
	is_navigating = true
	STOPPING_DISTANCE = 0.0
	nav.path_desired_distance = 0.2
	nav.target_desired_distance = 0.4
	state = ADJUST
	########
	

func _on_door_second_juniper_greeting() -> void:
	print("adjustingTheocentrally")
	theo_adjustment = true
	nav.target_position = adjustment_list[5].global_position
	is_navigating = true
	STOPPING_DISTANCE = 0.0
	nav.path_desired_distance = 0.2
	nav.target_desired_distance = 0.4
	state = ADJUST
	

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
	if body.is_in_group("player") and faint_dalton == false and needs_seven == false:
		if nav.is_inside_tree() == false:
			return
		living_room_nogo = true
		anim_tree.set("parameters/Scratch/request", 2)
		anim_tree.set("parameters/NoteAlt/request", 2)
		investigate_choice = 0
		nav.target_position = marker_list[investigate_choice].global_position
		is_navigating = true
		STOPPING_DISTANCE = 0.0
		state = INVESTIGATE

func _on_living_room_no_go_theo_body_exited(body: Node3D) -> void:
	if body.is_in_group("player") and faint_dalton == false and needs_seven == false:
		if nav.is_inside_tree() == false:
			return
		living_room_nogo = false
		anim_tree.set("parameters/Scratch/request", 2)
		anim_tree.set("parameters/NoteAlt/request", 2)
		investigate_choice = 2
		nav.target_position = marker_list[investigate_choice].global_position
		is_navigating = true
		STOPPING_DISTANCE = 0.0
		state = INVESTIGATE

func _on_painting_adjustment_body_entered(body: Node3D) -> void:
	if body.is_in_group("player") and faint_dalton == false and needs_seven == false:
		if nav.is_inside_tree() == false:
			return
		living_room_nogo = true
		anim_tree.set("parameters/Scratch/request", 2)
		anim_tree.set("parameters/NoteAlt/request", 2)
		investigate_choice = 2
		nav.target_position = marker_list[investigate_choice].global_position
		is_navigating = true
		STOPPING_DISTANCE = 0.0
		state = INVESTIGATE

func _on_painting_adjustment_body_exited(body: Node3D) -> void:
	if body.is_in_group("player") and faint_dalton == false and needs_seven == false:
		if nav.is_inside_tree() == false:
			return
		living_room_nogo = false
		anim_tree.set("parameters/Scratch/request", 2)
		anim_tree.set("parameters/NoteAlt/request", 2)
		investigate_choice = 1
		nav.target_position = marker_list[investigate_choice].global_position
		is_navigating = true
		STOPPING_DISTANCE = 0.0
		state = INVESTIGATE

func _on_quincy_interact_finish_greeting() -> void:
	greeting_finished = true
	animation_choice = rng.randi_range(0, 10)
	investigate_choice = rng.randi_range(0, 2)
	is_investigating = true
	nav.target_position = marker_list[investigate_choice].global_position
	is_navigating = true
	STOPPING_DISTANCE = 0.0
	state = INVESTIGATE
	allow_activation = false
	
func _on_theo_wander_body_exited(body: Node3D) -> void:
	if greeting_finished == false:
		quincy_greet = false
		STOPPING_DISTANCE = 1.0

func _on_cutscene_cams_faint_disable() -> void:
	#need to handle sitting state
	#emit signal stop sitting
	# set global position to drunk marker position
	# should automatically handle edge cases
	patio_sit = false
	going_to_bar = false
	armature.visible = true
	collision_theo.disabled = false
	nav.path_desired_distance = 0.75
	nav.target_desired_distance = 1.0
	STOPPING_DISTANCE = 0.0
	emit_signal("TheoStand")
	theo_node.global_position = drunk_marker.global_position
	InvestigateTime.stop()
	faint_dalton = true
	is_navigating = true
	nav.target_position = drunk_marker.global_position
	anim_tree.set("parameters/Scratch/request", 2)
	anim_tree.set("parameters/NoteAlt/request", 2)
	STOPPING_DISTANCE = 0.0
	theo_adjustment = true
	state = INVESTIGATE

func _on_cutscene_cams_theo_follow() -> void:
	pass
	#if faint_dalton == true:
		#nav.path_desired_distance = 0.75
		#nav.target_desired_distance = 1.0
		#STOPPING_DISTANCE = 1.0
		#state = FOLLOW

func _on_dialogic_signal(argument: String):
	if argument == "follow_dalton":
		emit_signal("look_at_disactivate")
		theo_adjustment = false
		is_investigating = false
		is_navigating = true 
		nav.path_desired_distance = 0.75
		nav.target_desired_distance = 1.0
		STOPPING_DISTANCE = 1.0
		state = FOLLOW
	
	if argument == "work_time_theo":
		emit_signal("look_at_disactivate")
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
		

func _on_main_door_theo_follow() -> void:
	InvestigateTime.stop()
	anim_tree.set("parameters/Scratch/request", 2)
	anim_tree.set("parameters/NoteAlt/request", 2)
	is_investigating = true
	needs_seven = true
	investigate_choice = 7
	nav.target_position = marker_list[investigate_choice].global_position
	is_navigating = true
	STOPPING_DISTANCE = 0.0
	state = INVESTIGATE
	
	
func _on_waterfall_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		state = IDLE
		waterfall_scene = true
		nav.target_position = marker_list[0].global_transform.origin
		state = ADJUST

func _on_waterfall_area_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		#follow
		waterfall_scene = false
		#theo_adjustment = false
		emit_signal("look_at_disactivate")
		is_navigating = true
		state = FOLLOW


func _on_sc_nogo_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		in_kitchen = true
		is_navigating = false
		state = IDLE
		#theo_adjustment = true

func _on_sc_nogo_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		in_kitchen = false
		if anim_tree["parameters/Blend2/blend_amount"] == 0:
			is_navigating = true
			state = FOLLOW


func _on_MicahDoor_greeting() -> void:
	theo_adjustment = true
	nav.target_position = adjustment_list[7].global_position
	is_navigating = true
	STOPPING_DISTANCE = 0.0
	nav.path_desired_distance = 0.2
	nav.target_desired_distance = 0.4
	state = ADJUST

func _on_door_greet_done() -> void:
	theo_adjustment = false


func _on_JuniperEnterTeaArea(body: Node3D) -> void:
	if body.is_in_group("juniper"):
		print("clearingJFalse")
		juniper_clear = false
		if sofa_scene:
			nav.target_position = adjustment_list[6].global_position
			is_navigating = true
			STOPPING_DISTANCE = 0.0
			nav.path_desired_distance = 0.2
			nav.target_desired_distance = 0.4
			state = ADJUST

func _on_JuniperExitTeaArea(body: Node3D) -> void:
	if body.is_in_group("juniper"):
		print("clearingJ")
		juniper_clear = true

func _on_SecretLocationStart() -> void:
	is_navigating = true

# edge case handling sofa area repos to behind
# so theo doesn't run into micah
func _on_Micahcloset_interacted(interactor: Interactor) -> void:
	pass
	#if force_idle_closet == true:
		#in_kitchen = true
		#is_navigating = false
		#state = IDLE
		
func _on_closet_quit() -> void:
	pass
	#if force_idle_closet == true:
		#force_idle_closet = false
		#in_kitchen = false
		#is_navigating = true
		#state = FOLLOW

func _on_resume_interact_theo_reposition_start() -> void:
	theo_adjustment = true
	in_kitchen = true
	nav.target_position = adjustment_list[7].global_position
	is_navigating = true
	STOPPING_DISTANCE = 0.0
	nav.path_desired_distance = 0.2
	nav.target_desired_distance = 0.4
	state = ADJUST

func _on_resume_interact_theo_reposition_end() -> void:
	theo_adjustment = false
	in_kitchen = false


func _on_hall_theo_body_entered(body: Node3D) -> void:
	if body.is_in_group("player") and faint_dalton:
		is_navigating = false

func _on_hall_theo_body_exited(body: Node3D) -> void:
	if body.is_in_group("player") and faint_dalton:
		is_navigating = true

func _on_sitting_ppl_theo_armature_visible() -> void:
	await get_tree().process_frame
	is_navigating = true
	patio_sit = false
	going_to_bar = false
	armature.visible = true
	collision_theo.disabled = false
	emit_signal("TheoStand")
	state = IDLE

func _on_main_theo_leave() -> void:
	#handle timeout sit
	if state == INVESTIGATE:
		nav.radius = 0.01 #so quincy doesn't force into wall?
		InvestigateTime.stop()
		anim_tree.set("parameters/Scratch/request", 2)
		anim_tree.set("parameters/NoteAlt/request", 2)
		is_investigating = true
		investigate_choice = 7
		nav.target_position = marker_list[investigate_choice].global_position
		is_navigating = true
		STOPPING_DISTANCE = 0.0
		state = INVESTIGATE
		return
	
	if going_to_bar:
		is_navigating = true
		patio_sit = false
		going_to_bar = false
		armature.visible = true
		collision_theo.disabled = false
		emit_signal("TheoStand")
		#also make all sitting ppl invisible
		
	#handle more investigate stuff
	anim_tree.set("parameters/Scratch/request", 2)
	anim_tree.set("parameters/NoteAlt/request", 2)
	
	faint_dalton = true
	emit_signal("look_at_disactivate")
	theo_adjustment = false
	is_investigating = false
	is_navigating = true 
	nav.path_desired_distance = 0.75
	nav.target_desired_distance = 1.0
	STOPPING_DISTANCE = 1.0
	state = FOLLOW


func _on_juniper_stop_theo_for_tea() -> void:
	stopped_theo_for_tea = true
	emit_signal("two_targ_dalton", 1)
	emit_signal("look_at_activate")
	is_navigating = false
	
func _on_juniper_start_theo_after_tea() -> void:
	stopped_theo_for_tea = false
	emit_signal("two_targ_dalton", 1)
	emit_signal("look_at_disactivate")
	is_navigating = true


func _on_theo_nogo_J_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		in_kitchen = true
		is_navigating = false
		state = IDLE


func _on_theo_nogoJ_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		in_kitchen = false
		is_navigating = true
		state = FOLLOW
