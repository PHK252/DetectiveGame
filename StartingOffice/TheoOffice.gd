extends CharacterBody3D

@export var anim_tree : AnimationTree
@export var player : Node3D
@export var armature = Node3D
@export var path : PathFollow3D

const speed = 0.3
const LERP_VAL = 0.15
var rotation_speed = 70
var stop_walk := false
var come_in := false
var dalton_rotation := false

enum {
	IDLE, 
	WALK
}

var state = IDLE
var see_player = false

func _ready() -> void:
	state = IDLE
	path.progress_ratio = 0
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if dalton_rotation:
		_rotate_dalton(delta)

	move_and_slide()
	
func _rotate_dalton(delta):
	pass
	#var direct = (player.global_position - armature.global_position).normalized()
	#armature.rotation.y = lerp_angle(armature.rotation.y, atan2(-direct.x, -direct.z), LERP_VAL)
	

func _process(delta):
	if state == WALK:
		var flipped_basis = path.global_transform.basis
		flipped_basis.x = -flipped_basis.x  # Flip the X basis vector to mirror rotation on the Y-axis
		flipped_basis.z = -flipped_basis.z  # Flip the Z basis vector to mirror rotation on the Y-axis

	# Apply the flipped basis to the NPC
		global_transform.basis = flipped_basis
	
	if see_player and Input.is_action_just_pressed("interact"):
		print("interacted")
		state = IDLE

		# Get the target direction to the player position
		
		
	if path.progress_ratio < 1 and come_in:
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
			anim_tree.set("parameters/BlendSpace1D/blend_position", 0)
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
						path.progress_ratio = 1
						state = IDLE
				else:
					state = IDLE
	
func _on_interact_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		see_player = true
	#if body is in group player and input interact pressed, state = idle

func _on_interact_area_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		print("left")
		#state = WALK
		#see_player = false

func _on_exposition_theo_move() -> void:
	come_in = true
