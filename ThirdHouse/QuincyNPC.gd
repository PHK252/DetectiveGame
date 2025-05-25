extends CharacterBody3D

#Visibility Controls
@export var packofcigs: Node3D
@export var cig: Node3D
@export var lighter: Node3D
@export var smoke: GPUParticles3D
@export var smoke_release: GPUParticles3D
@export var phone: Node3D

@export var wineStatic: Node3D
@export var wineAnim: Node3D
@export var winepoint: Marker3D

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
const FOLLOW_DISTANCE = 0.9 
var idle_blend = 0.0
var is_navigating = false
var accel = 1
var wander_choice = 0
@export var marker_positions: Array[Node3D]
var see_player = false
var at_door = false
var SPEED = 1.2
var LERP_VAL = 0.1
var rotation_speed = 70
var is_distracted = false
var distraction_rotate = false
var wine_fall = false
var catch_possibility = false
var is_drinking = false
var snowmobile_distraction = false
var bathroom_distraction = false
var poolTable = false
var poolPos
var greeting = false

var fall_allowed = true
var distraction_allowed = true

#sounds
@export var sound_player : AnimationPlayer

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
	wineAnim.visible = false
	smoke.emitting = false 
	phone.visible = false
	#is_navigating = false
	
func _process(delta: float) -> void:
	#print(is_navigating)
	
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
		if velocity.length() > 0.5:
			floor_type_walk()
			_rotate_towards_velocity()
		nav.set_velocity(velocity)

func _on_navigation_agent_3d_velocity_computed(safe_velocity: Vector3) -> void:
	velocity = velocity.move_toward(safe_velocity, 0.25)
	if is_navigating:
		move_and_slide()
		
func _rotate_towards_velocity() -> void:
	if is_navigating:
		armature.rotation.y = lerp_angle(armature.rotation.y, atan2(velocity.x, velocity.z), LERP_VAL)

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



#States
func _process_idle_state(distance_to_target: float, delta: float) -> void:
	# Prevent old path issues
	#print("q_idle")
	velocity = velocity.lerp(Vector3.ZERO, LERP_VAL)
	idle_blend = lerp(idle_blend, 0.0, LERP_VAL)
	quincy_tree.set("parameters/BlendSpace1D/blend_position", idle_blend)
	#if Input.is_action_just_pressed("meeting_done"):
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
			wander_choice = 10
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
		
	if ((distance_to_target > FOLLOW_DISTANCE) and is_navigating and not is_distracted):
		print("Switching to FOLLOW state")
		quincy_tree.set("parameters/Smoking/request", 2)
		state = FOLLOW
		return
	
func _process_follow_state(distance_to_target: float) -> void:
	#print("q_follow")
	#print(distance_to_target)
	if poolTable:
		state = IDLE
	
	if distance_to_target <= STOPPING_DISTANCE:
			catch_possibility = false
			#emit_signal("collision_safe")
			#is_navigating = false
			#cooldown_bool = true
			#cooldown.start()
			#wander_timer.start()
			if snowmobile_distraction:
				quincy_tree.set("parameters/Call/request", true)
				phone.visible = true
			
			if wander_choice == 8:
				is_navigating = false
			state = IDLE

#entrance area
func _on_theo_wander_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		is_navigating = true

func _on_wine_area_quincy_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		if distraction_allowed:
			if wine_fall == false: 
				is_distracted = true
				is_navigating = true
				wander_choice = 2
				nav.target_position = marker_positions[2].global_position
				state = FOLLOW
				distraction_allowed = false
		
		if fall_allowed:
			if wine_fall == true:
				is_distracted = true
				is_navigating = true
				wander_choice = 1
				nav.target_position = marker_positions[1].global_position
				state = FOLLOW
				distraction_timer.start()
				fall_allowed = false
		
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
		state = FOLLOW
	
	if wander_choice == 4:
		quincy_tree.set("parameters/Blend3/blend_amount", 0)
		wander_choice = 10
		is_distracted = false
		is_navigating = true
		bathroom_distraction = false
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
		quincy_tree.set("parameters/Wine/request", true)
		await get_tree().create_timer(2.2).timeout
		wineStatic.visible = false
		wineAnim.visible = true
		await get_tree().create_timer(4.0).timeout
		wineStatic.visible = true
		wineAnim.visible = false

func _on_smoke_time_timeout() -> void:
	if state == IDLE and is_distracted == false and is_navigating:
		is_navigating = false
		quincy_tree.set("parameters/Smoking/request", true)
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
	if body.is_in_group("player"):
		#if bathroom_distraction == false:
			#is_distracted = false
			#is_navigating = true
			#state = FOLLOW
		
		if bathroom_distraction == true:
			is_navigating = true
			wander_choice = 4
			nav.target_position = marker_positions[4].global_position
			state = FOLLOW
			distraction_timer.start()

func _on_toilet_stuff_distraction() -> void:
	bathroom_distraction = true

func _on_snowmobile_distraction() -> void:
	snowmobile_distraction = true
	is_distracted = true
	wander_choice = 5
	nav.target_position = marker_positions[5].global_position
	state = FOLLOW
	distraction_timer.start()

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
	is_distracted = true
	is_navigating = true
	wander_choice = 1
	nav.target_position = marker_positions[1].global_position
	state = FOLLOW
	distraction_timer.start()
	fall_allowed = false

func _on_theo_quincy_no_go_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		if state == FOLLOW and is_distracted == false and is_navigating:
			is_navigating = false
			state = IDLE

func _on_theo_quincy_no_go_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		if state == IDLE and is_distracted == false and is_navigating == false and greeting == true:
			is_navigating = true
			state = FOLLOW

func _on_hallway_check_body_entered(body: Node3D) -> void:
	is_distracted = true
	is_navigating = true
	wander_choice = 8
	nav.target_position = marker_positions[8].global_position
	state = FOLLOW

func _on_hallway_check_body_exited(body: Node3D) -> void:
	wander_choice = 0
	is_distracted = false
	is_navigating = true
	#state = FOLLOW
