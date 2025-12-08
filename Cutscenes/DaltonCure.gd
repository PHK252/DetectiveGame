extends CharacterBody3D

@export var armature = Node3D
@export var anim_tree : AnimationTree
@export var camera = Camera3D
var SPEED = 1.15
const LERP_VAL = .15
@export var force_rotate_list: Array[Marker3D]
@export var knockSound : AudioStreamPlayer3D
signal open_door_brother

signal moving
signal stopped
var move_back = false
var is_interacting = false

var cam_rotation = false
var interaction = false
var in_control = true
var force_rotation = false
var move_out = false
var number = 0

var is_walking : bool = false

@export var sound_player : AnimationPlayer

func _ready() -> void:
	add_to_group("player")
	in_control = false
	await get_tree().create_timer(2.0).timeout
	move_out = true
	await get_tree().create_timer(3.0).timeout
	in_control = true
	move_out = false

func _physics_process(delta: float) -> void:
	GlobalVars.player_pos = global_position
	
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
			if input_dir != Vector2.ZERO:
				# Rotate input direction based on the camera's orientation
				var camera_basis = camera.transform.basis
				var rotated_dir = (camera_basis.x * input_dir.x + camera_basis.z * input_dir.y).normalized()
				#if GlobalVars.cam_changed == true:
				
				# Set movement direction and apply smooth movement
				velocity.x = lerp(velocity.x, -rotated_dir.x * SPEED, LERP_VAL)
				velocity.z = lerp(velocity.z, -rotated_dir.z * SPEED, LERP_VAL)
				floor_type_walk()
				# Smoothly rotate the armature to face the movement direction
				armature.rotation.y = lerp_angle(armature.rotation.y, atan2(-rotated_dir.x, -rotated_dir.z), LERP_VAL)
				#if anim_tree["parameters/Blend3/blend_amount"] < 0:
					#anim_tree["parameters/Blend3/blend_amount"] = 0
				is_walking = true
			else:
				if is_walking:
					floor_type_gather()
					is_walking = false 
				velocity.x = lerp(velocity.x, 0.0, LERP_VAL)
				velocity.z = lerp(velocity.z, 0.0, LERP_VAL)
		anim_tree.set("parameters/BlendSpace1D/blend_position", velocity.length() / SPEED)
		
		if force_rotation:
			#print("rotating")
			force_rotate(number)
		
		if move_out:
			var direction = (armature.global_position - force_rotate_list[number].global_position).normalized()
			velocity.x = lerp(velocity.x, -direction.x * SPEED, LERP_VAL)
			velocity.z = lerp(velocity.z, -direction.z * SPEED, LERP_VAL)
			armature.rotation.y = lerp_angle(armature.rotation.y, atan2(-direction.x, -direction.z), LERP_VAL)
			anim_tree.set("parameters/BlendSpace1D/blend_position", velocity.length() / SPEED)
			floor_type_walk()
			
		move_and_slide()
	else:
		emit_signal("stopped")
		anim_tree.set("parameters/BlendSpace1D/blend_position", 0)
			
			
func floor_type_walk():
	if $rayFloor.is_colliding() and move_back == false:
		var collider = $rayFloor.get_collider()
		if collider.is_in_group("carpet"):
			sound_player.play("CarpetStep")
		if collider.is_in_group("tile"):
			sound_player.play("MarbleStep")
# floor type gather
func floor_type_gather():
	if $rayFloor.is_colliding():
		var collider = $rayFloor.get_collider()
		if collider.is_in_group("carpet"):
			sound_player.play("MarbleStep_gather")
		if collider.is_in_group("tile"):
			sound_player.play("CarpetStep_gather")

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
	in_control = false
	force_rotation = true
	anim_tree.set("parameters/Knock/request", true)
	await get_tree().create_timer(2.3).timeout
	knockSound.play()
	await get_tree().create_timer(2.7).timeout
	force_rotation = false
	in_control = true
	emit_signal("open_door_brother")
	
	#in_control = false
	#playAnim
	#number = 1
	#move_out = true

func _on_characters_walkoutdalton() -> void:
	await get_tree().create_timer(0.8).timeout
	GlobalVars.player_move = true
	#SPEED = 0.8
	in_control = false
	number = 1
	move_out = true
	await get_tree().create_timer(3.5).timeout
	move_out = false
