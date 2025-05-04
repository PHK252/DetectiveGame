extends CharacterBody3D

@export var armature = Node3D
@onready var anim_tree = $AnimationTree
@export var camera = Camera3D
@export var idle_time: Timer
@export var idle_time_2: Timer
var SPEED = 1.15
const LERP_VAL = .15
var jogcheck = false
var idle_timer_active: bool = false
@export var force_rotate_list: Array[Marker3D]
@export var sound_player : AnimationPlayer

var gathered = false
var walk_indicate = false
var finished_greet = false

const MAX_STEP_HEIGHT = 1.2
var _snapped_to_stairs_last_frame := false
var _last_frame_was_on_floor = -INF
signal moving
signal stopped
signal theo_adjustment
signal theo_reset
signal knocking
var move_back = false
var is_interacting = false

var move_back_in_progress = false
var move_back_start_position = Vector3()
var move_back_target_position = Vector3()
var move_back_progress = 0.0  # Tracks the progress of the lerp
var cam_rotation = false
var interaction = false
var in_control = true
var control_area = false
var force_rotation = false

var number = 0

@export var tea_wait_marker : Marker3D
var tea_time = false

func _ready() -> void:
	add_to_group("player")
	#doughnut.visible = false

func _physics_process(delta: float) -> void:
	if is_on_floor(): _last_frame_was_on_floor = Engine.get_physics_frames() 
	
	GlobalVars.player_pos = global_position
	
	
	if move_back_in_progress:
		move_back_progress += delta * 3.0  # Adjust multiplier for speed
		if move_back_progress >= 1.0:
			move_back_progress = 1.0
			move_back_in_progress = false
		
		# Smoothly interpolate position
		global_position = move_back_start_position.lerp(move_back_target_position, move_back_progress)
	# Add the gravity.
	if GlobalVars.player_move == true:
		emit_signal("moving")
		
		if not is_on_floor():
			velocity += get_gravity() * delta
			
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var input_dir 
		
		if in_control:
			input_dir = Input.get_vector("Right", "Left", "Back", "Forward")
		else:
			input_dir = Vector2.ZERO
			
		
		if GlobalVars.cam_changed == false:
			#if tea_time:
				#in_control = false
				#var direction = (armature.global_position - tea_wait_marker.global_position).normalized()
				#velocity.x = lerp(velocity.x, -direction.x * SPEED, LERP_VAL)
				#velocity.z = lerp(velocity.z, -direction.z * SPEED, LERP_VAL)
				#armature.rotation.y = lerp_angle(armature.rotation.y, atan2(-direction.x, -direction.z), LERP_VAL)
				#anim_tree.set("parameters/BlendSpace1D/blend_position", velocity.length() / SPEED)
				#floor_type_walk()
			
			
			if input_dir != Vector2.ZERO:
				anim_tree.set("parameters/Thinking/request", 2)
				# Rotate input direction based on the camera's orientation
				var camera_basis = camera.transform.basis
				var rotated_dir = (camera_basis.x * input_dir.x + camera_basis.z * input_dir.y).normalized()
				#if GlobalVars.cam_changed == true:
				
				# Set movement direction and apply smooth movement
				velocity.x = lerp(velocity.x, -rotated_dir.x * SPEED, LERP_VAL)
				velocity.z = lerp(velocity.z, -rotated_dir.z * SPEED, LERP_VAL)
				if SPEED == 2.2:
					floor_type_jog()
				else:
					#sound_player.play("Footsteps")
					floor_type_walk()
				# Smoothly rotate the armature to face the movement direction
				armature.rotation.y = lerp_angle(armature.rotation.y, atan2(-rotated_dir.x, -rotated_dir.z), LERP_VAL)
				jogcheck = true
				idle_timer_active = false
				walk_indicate = true
				gathered = false
				#if anim_tree["parameters/Blend3/blend_amount"] < 0:
					#anim_tree["parameters/Blend3/blend_amount"] = 0
			else:
				if gathered == false and walk_indicate == true:
					sound_player.stop()
					floor_type_gather()
					gathered = true
				velocity.x = lerp(velocity.x, 0.0, LERP_VAL)
				velocity.z = lerp(velocity.z, 0.0, LERP_VAL)
				jogcheck = false
				#idle_time.start()
				#if not idle_timer_active:  # Start timer only if not already active
					#anim_tree.set("parameters/Thinking/request", 2)
					#idle_timer_active = true
					#print("Starting idle timer")
					#await get_tree().create_timer(8).timeout
					#if velocity.length() == 0:  # Verify idle condition
						#print("Entering thinking state")
						#anim_tree.set("parameters/Thinking/request", true)
						#anim_tree["parameters/Blend3/blend_amount"] = -1
						#print("timerfinished")
						#anim_tree["parameters/Blend3/blend_amount"] = 0
						#print("donethinking")
					#await get_tree().create_timer(12).timeout
					#idle_timer_active = false  # Reset for next idle check
			
		anim_tree.set("parameters/BlendSpace1D/blend_position", velocity.length() / SPEED)
		
		if Input.is_action_pressed("jog") and jogcheck and interaction == false and is_interacting == false:
			idle_timer_active = false
			anim_tree.set("parameters/Thinking/request", 2)
			anim_tree["parameters/Blend2/blend_amount"] = 1
			SPEED = 2.2
		elif Input.is_action_just_released("jog") or jogcheck == false or interaction == true or is_interacting == true:
			#anim_tree.set("parameters/Thinking/request", 2)
			anim_tree["parameters/Blend2/blend_amount"] = 0
			SPEED = 1.15
		
		if move_back == true and not move_back_in_progress:
			start_move_back()
		
		if not _snap_up_stairs_check(delta):
			if force_rotation:
				print("rotating")
				force_rotate(number)
			move_and_slide()
			_snap_down_to_stairs_check()
	else:
		emit_signal("stopped")
		anim_tree.set("parameters/BlendSpace1D/blend_position", 0)

func floor_type_walk():
	if $FloorType.is_colliding() and move_back == false:
		var collider = $FloorType.get_collider()
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
		
# floor type jog 
func floor_type_jog():
	if $FloorType.is_colliding():
		var collider = $FloorType.get_collider()
		if collider.is_in_group("wood"):
			sound_player.play("FootstepsJog")
		if collider.is_in_group("tile"):
			sound_player.play("FootstepsJog_Tile")
		if collider.is_in_group("carpet"):
			sound_player.play("FootstepsJog_Carpet")
		if collider.is_in_group("soil"):
			sound_player.play("FootstepsJog_Soil")
		if collider.is_in_group("grass"):
			sound_player.play("FootstepsJog_Grass")
		if collider.is_in_group("woodStairs"):
			sound_player.play("FootstepsJog_WoodStair")
		if collider.is_in_group("snow"):
			sound_player.play("FootstepsJog_Snow")
		if collider.is_in_group("metal"):
			sound_player.play("FootstepsJog_Metal")
		if collider.is_in_group("marble"):
			sound_player.play("FootstepsJog_Marble")
		

# floor type gather
func floor_type_gather():
	if $FloorType.is_colliding():
		var collider = $FloorType.get_collider()
		if collider.is_in_group("wood"):
			sound_player.play("FootstepsGather")
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
		

func force_rotate(number : int):
	var target = force_rotate_list[number].global_position
	var dir = (armature.global_position - target).normalized()
	armature.rotation.y = lerp_angle(armature.rotation.y, atan2(-dir.x, -dir.z), LERP_VAL)
		

func stop_player():
	anim_tree["parameters/Blend2/blend_amount"] = 0
	GlobalVars.player_move = false
	emit_signal("theo_adjustment")

func start_player():
	is_interacting = false
	GlobalVars.player_move = true
	emit_signal("theo_reset")
	
func is_surface_too_steep(normal : Vector3) -> bool:
	return normal.angle_to(Vector3.UP) > self.floor_max_angle
	
func _run_body_test_motion(from : Transform3D, motion : Vector3, result = null) -> bool:
	if not result: result = PhysicsTestMotionResult3D.new()
	var params = PhysicsTestMotionParameters3D.new()
	params.from = from
	params.motion = motion
	return PhysicsServer3D.body_test_motion(self.get_rid(),params,result)
	
func _snap_down_to_stairs_check() -> void: 
	var did_snap := false
	# Modified slightly from tutorial. I don't notice any visual difference but I think this is correct.
	# Since it is called after move_and_slide, _last_frame_was_on_floor should still be current frame number.
	# After move_and_slide off top of stairs, on floor should then be false. Update raycast incase it's not already.
	%StairsBelowRayCast3D.force_raycast_update()
	var floor_below : bool = %StairsBelowRayCast3D.is_colliding() and not is_surface_too_steep(%StairsBelowRayCast3D.get_collision_normal())
	var was_on_floor_last_frame = Engine.get_physics_frames() == _last_frame_was_on_floor
	if not is_on_floor() and velocity.y <= 0 and (was_on_floor_last_frame or _snapped_to_stairs_last_frame) and floor_below:
		var body_test_result = KinematicCollision3D.new()
		if self.test_move(self.global_transform, Vector3(0,-MAX_STEP_HEIGHT,0), body_test_result):
			var translate_y = body_test_result.get_travel().y
			self.position.y += translate_y
			apply_floor_snap()
			did_snap = true
	_snapped_to_stairs_last_frame = did_snap
	
func _snap_up_stairs_check(delta) -> bool:
	if not is_on_floor() and not _snapped_to_stairs_last_frame: return false
	# Don't snap stairs if trying to jump, also no need to check for stairs ahead if not moving
	if self.velocity.y > 0 or (self.velocity * Vector3(1,0,1)).length() == 0: return false
	var expected_move_motion = self.velocity * Vector3(1,0,1) * delta
	var step_pos_with_clearance = self.global_transform.translated(expected_move_motion + Vector3(0, MAX_STEP_HEIGHT * 2, 0))
	# Run a body_test_motion slightly above the pos we expect to move to, towards the floor.
	#  We give some clearance above to ensure there's ample room for the player.
	#  If it hits a step <= MAX_STEP_HEIGHT, we can teleport the player on top of the step
	#  along with their intended motion forward.
	var down_check_result = KinematicCollision3D.new()
	if (self.test_move(step_pos_with_clearance, Vector3(0,-MAX_STEP_HEIGHT*2,0), down_check_result)
	and (down_check_result.get_collider().is_class("StaticBody3D") or down_check_result.get_collider().is_class("CSGShape3D"))):
		var step_height = ((step_pos_with_clearance.origin + down_check_result.get_travel()) - self.global_position).y
		# Note I put the step_height <= 0.01 in just because I noticed it prevented some physics glitchiness
		# 0.02 was found with trial and error. Too much and sometimes get stuck on a stair. Too little and can jitter if running into a ceiling.
		# The normal character controller (both jolt & default) seems to be able to handled steps up of 0.1 anyway
		if step_height > MAX_STEP_HEIGHT or step_height <= 0.01 or (down_check_result.get_position() - self.global_position).y > MAX_STEP_HEIGHT: return false
		%StairsAheadRayCast3D.global_position = down_check_result.get_position() + Vector3(0,MAX_STEP_HEIGHT,0) + expected_move_motion.normalized() * 0.1
		%StairsAheadRayCast3D.force_raycast_update()
		if %StairsAheadRayCast3D.is_colliding() and not is_surface_too_steep(%StairsAheadRayCast3D.get_collision_normal()):
			self.global_position = step_pos_with_clearance.origin + down_check_result.get_travel()
			apply_floor_snap()
			_snapped_to_stairs_last_frame = true
			return true
	return false
			
		
func start_move_back():
	# Initialize lerp for move back
	print("movedback")
	number = 0
	force_rotation = true
	var move_distance = 0.2  # Adjust as needed
	move_back_start_position = global_position
	move_back_target_position = global_position + Vector3(move_distance, 0, 0)  # Adjust for X-axis movement in 3D
	move_back_progress = 0.0
	anim_tree.set("parameters/OneShot/request", true)
	sound_player.play("Footsteps_Carpet_Back")
	await get_tree().create_timer(0.45).timeout
	force_rotation = false
	move_back_in_progress = true
	move_back = false
	is_interacting = true

func _on_closet_stepback() -> void:
	move_back = true
	
func _on_camera_system_camera_changed() -> void:
	cam_rotation = true

func _on_player_interactor_interacted_now() -> void:
	interaction = true
	await get_tree().create_timer(0.45).timeout
	interaction = false

func _on_idle_time_timeout() -> void:
	print("timeforthink")
	if velocity.length() == 0:  # Verify idle condition
		print("Entering thinking time")
		idle_time_2.start()
		
#func _on_door_point_body_exited(body: Node3D) -> void:
	#if body.is_in_group("player"):
		#in_control = false
		#await get_tree().create_timer(0.5).timeout
		#in_control = true

func _on_doorcamarea_body_entered(body: Node3D) -> void:
	if body.is_in_group("player") and control_area:
		in_control = false
		await get_tree().create_timer(0.5).timeout
		in_control = true

func _on_main_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player") and control_area:
		in_control = false
		await get_tree().create_timer(0.5).timeout
		in_control = true

func _on_door_point_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		control_area = true

func _on_door_point_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		control_area = false
		
func _on_sitting_ppl_dalton_invisible() -> void:
	armature.visible = false
	in_control = false

func _on_sitting_ppl_dalton_visible() -> void:
	armature.visible = true
	in_control = true


func _on_detective_anims_dalton_invisible() -> void:
	armature.visible = false
	in_control = false


func _on_detective_anims_dalton_visible() -> void:
	armature.visible = true
	in_control = true


func _on_doughnut_001_time_to_eat() -> void:
	force_rotation = true
	anim_tree.set("parameters/Doughnut/request", true)
	in_control = false
	await get_tree().create_timer(7).timeout
	force_rotation = false
	in_control = true

func _on_toilet_stuff_distraction() -> void:
	anim_tree.set("parameters/StuffToilet/request", true)
	in_control = false
	await get_tree().create_timer(7).timeout
	in_control = true

func _on_snowmobile_distraction() -> void:
	anim_tree.set("parameters/Inspect/request", true)
	in_control = false
	await get_tree().create_timer(7).timeout
	in_control = true

func _on_phone_call_phone_call() -> void:
	anim_tree.set("parameters/CellPhone/request", true)
	in_control = false
	await get_tree().create_timer(7).timeout
	in_control = true

func _on_idle_2_timeout() -> void:
	if velocity.length() == 0: 
		if anim_tree["parameters/Thinking/request"] != 1:
			sound_player.play("thinking")
			anim_tree.set("parameters/Thinking/request", true)


func _on_door_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player") and control_area:
		in_control = false
		await get_tree().create_timer(0.5).timeout
		in_control = true

func _on_forest_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player") and control_area:
		in_control = false
		await get_tree().create_timer(0.5).timeout
		in_control = true

func _on_kitchen_area_jun_body_entered(body: Node3D) -> void:
	if body.is_in_group("player") and control_area:
		in_control = false
		await get_tree().create_timer(0.5).timeout
		in_control = true

func _on_timer_timeout() -> void:
	pass # Replace with function body.

func _on_door_second_juniper_greeting() -> void:
	number = 0
	in_control = false
	force_rotation = true
	#knock anim
	anim_tree.set("parameters/Knock/request", true)
	await get_tree().create_timer(2).timeout
	emit_signal("knocking")
	await get_tree().create_timer(8).timeout
	force_rotation = false
	in_control = true

#signal for dialogue done back in control

func _on_door_micah_rotate() -> void:
	pass # Replace with function body.

func _on_door_greeting() -> void:
	number = 1
	in_control = false
	force_rotation = true
	#knock anim
	anim_tree.set("parameters/Knock/request", true)
	emit_signal("knocking")
	await get_tree().create_timer(4).timeout
	force_rotation = false
	in_control = true
	
	
func _on_juniper_interact_finish_greeting() -> void:
	finished_greet = true
	#in_control = false
	#SPEED = 2.0
	#tea_time = true
	#await get_tree().create_timer(5).timeout
	#tea_time = false
	#SPEED = 1.15
	#floor_type_gather()
	

func _on_cam_books_became_active() -> void:
	pass
	#if control_area:
		#print("controlling")
		#in_control = false
		#await get_tree().create_timer(0.5).timeout
		#in_control = true

func _on_porch_cam_became_active() -> void:
	if control_area and finished_greet == true:
		#print("controlling")
		in_control = false
		await get_tree().create_timer(0.5).timeout
		in_control = true
