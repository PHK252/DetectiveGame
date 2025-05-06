extends CharacterBody3D

@export var armature = Node3D
@export var anim_tree : AnimationTree
@export var camera = Camera3D
var SPEED = 1.15
const LERP_VAL = .15
@export var force_rotate_list: Array[Marker3D]
@export var collision : CollisionShape3D

signal moving
signal stopped
var move_back = false
var is_interacting = false

var cam_rotation = false
var interaction = false
var in_control = true
var force_rotation = false
var move_out = true
var number = 0
var gathered = true

@export var sound_player : AnimationPlayer

func _ready() -> void:
	add_to_group("player")
	in_control = false
	await get_tree().create_timer(4.0).timeout
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

				# Smoothly rotate the armature to face the movement direction
				armature.rotation.y = lerp_angle(armature.rotation.y, atan2(-rotated_dir.x, -rotated_dir.z), LERP_VAL)
				#if anim_tree["parameters/Blend3/blend_amount"] < 0:
					#anim_tree["parameters/Blend3/blend_amount"] = 0
				floor_type_walk()
				gathered = false
			else:
				if move_out == false and gathered == false:
					floor_type_gather()
					gathered = true 
				velocity.x = lerp(velocity.x, 0.0, LERP_VAL)
				velocity.z = lerp(velocity.z, 0.0, LERP_VAL)
		anim_tree.set("parameters/BlendSpace1D/blend_position", velocity.length() / SPEED)
		
		
		if force_rotation:
			#print("rotating")
			force_rotate(number)
		
		if move_out:
			gathered = false
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
	number = 1
	move_out = true
	collision.disabled = true
	#await get_tree().create_timer(6).timeout
	#force_rotation = false
	#SPEED = 1.5
	#collision.disabled = true
	#number = 1
	#force_rotate(number)
	#move_out = true
