extends CharacterBody3D

@export var armature = Node3D
@export var anim_tree : AnimationTree
@export var camera = Camera3D
var SPEED = 1.15
const LERP_VAL = .15
@export var force_rotate_list: Array[Marker3D]
@export var collision : CollisionShape3D
@export var sound_player : AnimationPlayer
var just_walked : bool = false

var blend_worry : bool = false
var blend_crouch : bool = false
var worry_blend_target := 1.0
var crouch_blend_target := 1.0

const MAX_STEP_HEIGHT := 1.2
var _snapped_to_stairs_last_frame := false
var _last_frame_was_on_floor = -INF

signal moving
signal stopped
signal activate_hall
signal cam_bed

signal start_kitchen_dialogue

var move_back := false
var is_interacting := false

var cam_rotation := false
var interaction := false
var in_control := true
var force_rotation := false
var move_out := false
var number := 0
var blend_target := 1.0
var checking_start := true
var not_stairs := true

@export var crouch_sound : AudioStreamPlayer3D

func _ready() -> void:
	global_position = GlobalVars.isaac_pos
	add_to_group("player")
	in_control = false
	force_rotation = true
	await get_tree().create_timer(.5).timeout
	blend_target = 0.0
	emit_signal("start_kitchen_dialogue")
	#await get_tree().create_timer(1).timeout
	#force_rotation = false
	#in_control = true
	#checking_start = false

func _on_start_isaac():
	await get_tree().create_timer(1).timeout
	force_rotation = false
	in_control = true
	checking_start = false


func floor_type_walk():
	if $FloorType.is_colliding():
		var collider = $FloorType.get_collider()
		if collider.is_in_group("wood"):
			sound_player.play("FootstepsWood")
		if collider.is_in_group("woodStairs"):
			sound_player.play("FootstepsStairs")
		
func floor_type_gather():
	if $FloorType.is_colliding():
		var collider = $FloorType.get_collider()
		if collider.is_in_group("wood"):
			sound_player.play("FootstepsWood_gather")
		

func _process(delta: float) -> void:
	if checking_start:
		var current_blend = anim_tree.get("parameters/Blend2/blend_amount")
		var speed = 2.0  # how fast it fades out
		var new_blend = lerp(current_blend, blend_target, delta * speed)
		anim_tree.set("parameters/Blend2/blend_amount", new_blend)

	if blend_worry:
		var current_blend = anim_tree["parameters/worry_idle/blend_amount"]
		var new_blend = lerp(current_blend, worry_blend_target, delta * 2.0)
		anim_tree["parameters/worry_idle/blend_amount"] = new_blend

	if blend_crouch:
		var current_blend = anim_tree["parameters/crouch/blend_amount"]
		var new_blend = lerp(current_blend, worry_blend_target, delta * 2.0)
		anim_tree["parameters/crouch/blend_amount"] = new_blend

func _physics_process(delta: float) -> void:
	GlobalVars.player_pos = global_position
	GlobalVars.isaac_pos = global_position
	# Add the gravity.
	if GlobalVars.player_move == true:
		emit_signal("moving")
		if not is_on_floor() and not_stairs:
			velocity += get_gravity() * delta
			
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var input_dir 
		
		if in_control:
			input_dir = Input.get_vector("Right", "Left", "Back", "Forward")
		else:
			input_dir = Vector2.ZERO
			
		
		if GlobalVars.cam_changed == false:
			if input_dir != Vector2.ZERO:
				# Rotate input direction based on the camera's orientation
				var camera_basis = camera.transform.basis
				var rotated_dir = (camera_basis.x * input_dir.x + camera_basis.z * input_dir.y).normalized()
				#if GlobalVars.cam_changed == true:
				
				# Set movement direction and apply smooth movement
				velocity.x = lerp(velocity.x, -rotated_dir.x * SPEED, LERP_VAL)
				velocity.z = lerp(velocity.z, -rotated_dir.z * SPEED, LERP_VAL)

				# Smoothly rotate the armature to face the movement direction
				armature.rotation.y = lerp_angle(armature.rotation.y, atan2(-rotated_dir.x, -rotated_dir.z), LERP_VAL)
				#if anim_tree["parameters/Blend3/blend_amount"] < 0:
					#anim_tree["parameters/Blend3/blend_amount"] = 0
				#sound_player.play("wood_walk")
				floor_type_walk()
				just_walked = true
			else:
				if just_walked:
					#sound_player.play("wood_gather")
					floor_type_gather()
					just_walked = false
				if not_stairs == true:
					velocity.x = lerp(velocity.x, 0.0, LERP_VAL)
					velocity.z = lerp(velocity.z, 0.0, LERP_VAL)
		anim_tree.set("parameters/BlendSpace1D/blend_position", velocity.length() / SPEED)
		
		if force_rotation:
			#print("rotating")
			force_rotate(number)
		
		if move_out:
			floor_type_walk()
			var direction = (armature.global_position - force_rotate_list[3].global_position).normalized()
			velocity.x = lerp(velocity.x, -direction.x * SPEED, LERP_VAL)
			velocity.z = lerp(velocity.z, -direction.z * SPEED, LERP_VAL)
			armature.rotation.y = lerp_angle(armature.rotation.y, atan2(-direction.x, -direction.z), LERP_VAL)
			anim_tree.set("parameters/BlendSpace1D/blend_position", velocity.length() / SPEED)
			
		move_and_slide()
	else:
		emit_signal("stopped")
		anim_tree.set("parameters/BlendSpace1D/blend_position", 0)
			
func force_rotate(number):
	var target = force_rotate_list[number].global_position
	var dir = (armature.global_position - target).normalized()
	armature.rotation.y = lerp_angle(armature.rotation.y, atan2(-dir.x, -dir.z), LERP_VAL)
		
func stop_player():
	anim_tree["parameters/Blend2/blend_amount"] = 0
	GlobalVars.player_move = false

func start_player():
	is_interacting = false
	GlobalVars.player_move = true
	
func _on_camera_system_camera_changed() -> void:
	cam_rotation = true

func _on_player_interactor_interacted_now() -> void:
	interaction = true
	await get_tree().create_timer(0.45).timeout
	interaction = false

func _on_interactable_interacted(interactor: Interactor) -> void:
	number = 0
	force_rotation = true
	in_control = false
	await get_tree().create_timer(6).timeout
	force_rotation = false
	SPEED = 1.5
	collision.disabled = true
	number = 1
	force_rotate(number)
	move_out = true

func _on_walk_up_body_entered(body: Node3D) -> void:
	emit_signal("activate_hall")
	#not_stairs = false
	#in_control = false
	#number = 1
	#force_rotation = true
	#anim_tree.set("parameters/UpStairs/request", true)

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

func _on_control_areas_check_on_isaac() -> void:
	in_control = false
	#move_out = true
#	await get_tree().create_timer(1.0).timeout
	#emit_signal("cam_bed")
	#await get_tree().create_timer(1.5).timeout
	#move_out = false
	#blend_worry = true
	#await get_tree().create_timer(2.5).timeout
	crouch_sound.play()
	#blend_worry = false
	blend_crouch = true
	await get_tree().create_timer(7.625).timeout
	anim_tree["parameters/CrouchIdle/blend_amount"] = 1
	
	
