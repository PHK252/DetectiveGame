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
@export var paperSound : AudioStreamPlayer3D
@export var think : AudioStreamPlayer3D
@export var coll_shape : CollisionShape3D

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
var spec_rotate := false
var sound_allowed := true

var blend_target = 1.0


func _ready() -> void:
	add_to_group("player")
	anim_tree.set("parameters/Blend2/blend_amount", blend_target)
	#in_control = false
	#await get_tree().create_timer(10).timeout
	# Start lerping to 0
	sound_allowed = true
	blend_target = 0.0
	await get_tree().create_timer(1).timeout
	in_control = true

func _process(delta: float) -> void:
	var current_blend = anim_tree.get("parameters/Blend2/blend_amount")
	var speed = 2.0  # how fast it fades out
	var new_blend = blend_target #lerp(current_blend, blend_target, delta * speed)
	anim_tree.set("parameters/Blend2/blend_amount", new_blend)
	#doughnut.visible = false

func _physics_process(delta: float) -> void:
	GlobalVars.player_pos = global_position
	GlobalVars.dalton_pos = global_position
	# Add the gravity.
	if GlobalVars.player_move == true or spec_rotate:
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
				if sound_allowed:
					sound_player.play("wood_walk")
				just_walked = true
			else:
				if just_walked:
					if sound_allowed:
						sound_player.play("wood_gather")
					just_walked = false
				velocity.x = lerp(velocity.x, 0.0, LERP_VAL)
				velocity.z = lerp(velocity.z, 0.0, LERP_VAL)
		anim_tree.set("parameters/BlendSpace1D/blend_position", velocity.length() / SPEED)
		
		if force_rotation:
			#print("rotating")
			force_rotate(number)
		
		if move_out:
			var direction = (armature.global_position - force_rotate_list[1].global_position).normalized()
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

#func _on_interactable_interacted(interactor: Interactor) -> void:
	#number = 0
	#force_rotation = true
	#in_control = false
	#await get_tree().create_timer(6).timeout
	#force_rotation = false
	#SPEED = 1.5
	#collision.disabled = true
	#number = 1
	#force_rotate(number)
	#move_out = true

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		paperSound.play()
		

func _on_dalton_to_walk_out():
	coll_shape.disabled = true
	number = 0
	force_rotation = true
	in_control = false
	await get_tree().create_timer(4.5).timeout
	force_rotation = false
	SPEED = 1.5
	collision.disabled = true
	number = 1
	force_rotate(number)
	move_out = true
	await get_tree().create_timer(3.5).timeout
	sound_allowed = false
	Loading.load_scene(self, GlobalVars.office_path, false, "", "")
	GlobalVars.day = 1


func _on_Isaac_interacted(interactor: Interactor) -> void:
	number = 0
	spec_rotate = true
	force_rotation = true
	in_control = false
	await get_tree().create_timer(4.5).timeout
	force_rotation = false
	spec_rotate = false
	in_control = true
