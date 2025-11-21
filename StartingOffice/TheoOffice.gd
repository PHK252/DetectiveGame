extends CharacterBody3D

@export var anim_tree : AnimationTree
@export var player : Node3D
@export var armature = Node3D
@export var path : PathFollow3D
@export var walk_target : Marker3D
@export var sound_anims : AnimationPlayer

const speed = 0.3
const LERP_VAL = 0.15
var rotation_speed = 70
var stop_walk := false
var come_in := false
var dalton_rotation := false
var blend_speed := 5.0
signal look_dalton
var in_later : bool = false
var is_there : bool = false
enum {
	IDLE, 
	WALK,
	OUT
}

var state = OUT
var see_player = false

func _ready() -> void:
	state = OUT
	path.progress_ratio = 0
	if GlobalVars.from_save_file == true:
		global_position = GlobalVars.theo_pos
		GlobalVars.from_save_file == false
		return
	#print("placed " + str(GlobalVars.dalton_pos))
	await get_tree().process_frame
	if (GlobalVars.day == 1 and Dialogic.VAR.get_variable("Global.went_to_Micah") == false and Dialogic.VAR.get_variable("Global.went_to_Juniper") == false) or in_later == true:
		in_later = false
		return
	if is_there == true:
		is_there = false
		print("theo in")
		return
		#set position
	_return_office()
	
func _return_office():
	print("returningTheo")
	await get_tree().create_timer(1.0).timeout
	state = WALK
	come_in = true
	

func _on_delay_theo_in():
	in_later = true

func _on_theo_there():
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
	armature.rotation.y = lerp_angle(armature.rotation.y, atan2(dir.x, dir.z), LERP_VAL)
		

func force_walk(delta):
	var dir_marker = (armature.global_position - walk_target.global_position).normalized()
	velocity.x = lerp(velocity.x, dir_marker.x * speed, LERP_VAL)
	velocity.z = lerp(velocity.z, dir_marker.z * speed, LERP_VAL)


func _rotate_dalton(delta):
	pass
	#var direct = (player.global_position - armature.global_position).normalized()
	#armature.rotation.y = lerp_angle(armature.rotation.y, atan2(-direct.x, -direct.z), LERP_VAL)
	

func _process(delta):
	#print(state)
	if state == WALK:
		sound_anims.play("WoodWalk")
		var flipped_basis = path.global_transform.basis
		flipped_basis.x = -flipped_basis.x  # Flip the X basis vector to mirror rotation on the Y-axis
		flipped_basis.z = -flipped_basis.z  # Flip the Z basis vector to mirror rotation on the Y-axis
	# Apply the flipped basis to the NPC
		global_transform.basis = flipped_basis
	
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
