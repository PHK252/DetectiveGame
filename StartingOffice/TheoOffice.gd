extends CharacterBody3D

@export var anim_tree : AnimationTree
@export var player : Node3D
@export var armature = Node3D
@export var path : PathFollow3D
@export var walk_target : Marker3D
@export var sound_anims : AnimationPlayer

@export var walk_target_alt : Marker3D
@export var walk_position_alt : Marker3D

var speed = 0.3
const LERP_VAL = 0.15
var rotation_speed = 70
var stop_walk := false
var come_in := false
var dalton_rotation := false
var blend_speed := 5.0
signal look_dalton
var in_later : bool = false
var is_there : bool = false
var leave_rotation := false
enum {
	IDLE, 
	WALK,
	OUT,
	LEAVE,
	LEAVE_ALT
}

var state = OUT
var see_player := false
var walk_away := false

signal look_away
signal rotate_dalton

func _ready() -> void:
	state = OUT
	path.progress_ratio = 0
	if GlobalVars.from_save_file == true and GlobalVars.in_level == true:
		print("placed " + str(GlobalVars.theo_pos))
		global_position = GlobalVars.theo_pos
		await get_tree().process_frame
		GlobalVars.from_save_file == false
		return
	#print("placed " + str(GlobalVars.dalton_pos))
	await get_tree().process_frame
	await get_tree().process_frame
	if (GlobalVars.day == 1 and Dialogic.VAR.get_variable("Global.went_to_Micah") == false and Dialogic.VAR.get_variable("Global.went_to_Juniper") == false) or in_later == true:
		in_later = false
		return
	if is_there == true:
		print("theo in")
		is_there = false
		global_position = Vector3(0.527486, -0.029458, 0.207)
		return
		
	_return_office()
	
func _return_office():
	print("returningTheo")
	await get_tree().create_timer(1.0).timeout
	if GlobalVars.in_dialogue:
		emit_signal("rotate_dalton")
	state = WALK
	come_in = true
	

func _on_delay_theo_in():
	print("theo out")
	in_later = true

func _on_theo_there():
	print("theo in")
	is_there = true

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if dalton_rotation:
		_rotate_dalton(delta)

	move_and_slide()
	
func force_rotation(delta):
	var target = walk_target.global_position
	var dir = (armature.global_position - target).normalized()
	armature.rotation.y = lerp_angle(armature.rotation.y, atan2(dir.x, -dir.z), LERP_VAL)
		

func force_walk(delta):
	var dir_marker = (armature.global_position - walk_target_alt.global_position).normalized()
	velocity.x = lerp(velocity.x, -dir_marker.x * speed, LERP_VAL)
	velocity.z = lerp(velocity.z, -dir_marker.z * speed, LERP_VAL)

func _rotate_dalton(delta):
	pass
	#var direct = (player.global_position - armature.global_position).normalized()
	#armature.rotation.y = lerp_angle(armature.rotation.y, atan2(-direct.x, -direct.z), LERP_VAL)

func _process(delta):
	GlobalVars.theo_pos = global_position
	#print(state)
	#if Input.is_action_just_pressed("Jump"):
		#state = LEAVE
		#emit_signal("look_away")
		#print("Theoleaving")
		#leave_rotation = true
		#await get_tree().create_timer(0.8).timeout
		#walk_away = true
		#leave_rotation = false
		
	if walk_away:
		sound_anims.play("WoodWalk")
		var c_pos: float = anim_tree.get("parameters/BlendSpace1D/blend_position") as float
		var leave_pos: float = lerp(c_pos, 1.0, delta * blend_speed)
		anim_tree.set("parameters/BlendSpace1D/blend_position", leave_pos)
		
	if state == WALK and not leave_rotation:
		sound_anims.play("WoodWalk")
		var flipped_basis = path.global_transform.basis
		flipped_basis.x = -flipped_basis.x  # Flip the X basis vector to mirror rotation on the Y-axis
		flipped_basis.z = -flipped_basis.z  # Flip the Z basis vector to mirror rotation on the Y-axis
	# Apply the flipped basis to the NPC
		global_transform.basis = flipped_basis
	
	if state == LEAVE_ALT:
		var c_pos: float = anim_tree.get("parameters/BlendSpace1D/blend_position") as float
		var leave_pos: float = lerp(c_pos, 1.0, delta * blend_speed)
		anim_tree.set("parameters/BlendSpace1D/blend_position", leave_pos)
		force_walk(delta)
	
	if state == LEAVE or state == LEAVE_ALT:
		sound_anims.play("WoodWalk")
		
	if leave_rotation:	
		force_rotation(delta)
	
	if see_player and Input.is_action_just_pressed("interact"):
		pass
		#print("interacted")
		#state = IDLE

		# Get the target direction to the player position
		
		
	if path.progress_ratio < 1 and come_in and stop_walk == false:
		stop_walk = false
		state = WALK
	elif path.progress_ratio == 1:
		state = IDLE
		stop_walk = true


	#if see player true then look at player
	#check player position player.globalposition
	
	match state:
		IDLE:
			dalton_rotation = true
			var current_pos: float = anim_tree.get("parameters/BlendSpace1D/blend_position") as float
			var new_pos: float = lerp(current_pos, 0.0, delta * blend_speed)
			anim_tree.set("parameters/BlendSpace1D/blend_position", new_pos)
			stop_walk = true
		WALK:
			dalton_rotation = false
			anim_tree.set("parameters/BlendSpace1D/blend_position", 1)
			if path.progress_ratio < 1 and come_in:
				if stop_walk == false: 
					path.progress_ratio += speed * delta
					if path.progress_ratio == 1 or path.progress > 1.2:
						print("checked for stop")
						stop_walk = true
						#path.progress_ratio = 0.95
						sound_anims.play("WalkGather")
						emit_signal("look_dalton")
						state = IDLE
				else:
					sound_anims.stop()
					emit_signal("look_dalton")
					state = IDLE
		OUT:
			pass
		LEAVE:
			if walk_away:
				if path.progress_ratio > 0:
					path.progress_ratio = clamp(path.progress_ratio - speed * delta, 0.0, 1.0)
				
				if path.progress_ratio == 0.0:
					walk_away = false 
		LEAVE_ALT:
			pass
					
				
	
func _on_interact_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		pass
		#see_player = true
	#if body is in group player and input interact pressed, state = idle

func _on_interact_area_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		print("left")
		pass
		#state = WALK
		#see_player = false

func _on_exposition_theo_move() -> void:
	state = WALK
	come_in = true

func _on_theo_exit() -> void:
	speed = 0.8
	emit_signal("look_away")
	print("Theoleaving")
	leave_rotation = true
	await get_tree().create_timer(0.8).timeout
	state = LEAVE
	walk_away = true
	
	
	

func _on_theo_exit_alt() -> void:
	print("alt")
	speed = 0.8
	state = LEAVE_ALT
