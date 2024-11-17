extends CharacterBody3D

@export var ap : AnimationPlayer
@export var player : Node3D
@export var armature = Node3D
@export var path : PathFollow3D
@export var WaitTimer : Timer
@export var NPC : String
@onready var object_interaction = false

enum {
	IDLE, 
	WALK,
	WAIT,
}

var state = IDLE
var see_player = false
var at_door = false
const SPEED = 0.4
const LERP_VAL = .15
var rotation_speed = 70

func _ready() -> void:
	state = IDLE

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	move_and_slide()
	
	#if state == WALK:
		
		

func _process(delta):
	if state == WALK:
		var flipped_basis = path.global_transform.basis
		flipped_basis.x = -flipped_basis.x  # Flip the X basis vector to mirror rotation on the Y-axis
		flipped_basis.z = -flipped_basis.z  # Flip the Z basis vector to mirror rotation on the Y-axis

	# Apply the flipped basis to the NPC
		global_transform.basis = flipped_basis
	
	if see_player and Input.is_action_just_pressed("interact") or object_interaction:
		print("interacted")
		state = IDLE

		# Get the target direction to the player position
		var target_position = Vector3(GlobalVars.player_pos.x, global_transform.origin.y, GlobalVars.player_pos.z)
		var target_direction = (target_position - global_transform.origin).normalized()
	
		target_direction = -target_direction
		# Get the current direction the NPC is facing
		var current_direction = -global_transform.basis.z  # Use -Z as the forward direction in Godot
		# Interpolate between the current and target direction smoothly
		var smooth_direction = current_direction.slerp(target_direction, rotation_speed * delta)

		# Update the NPC's rotation to face the interpolated direction
		look_at(global_transform.origin + smooth_direction, Vector3.UP)
		
		if Input.is_action_just_pressed("Exit"):
			#add dialogic signal here to control stop looking
			object_interaction = false
			state = WALK

	#if see player true then look at player
	#check player position player.globalposition
	
	match state:
		IDLE:
			if NPC == "Micah" or NPC == "Skylar":
				ap.play("IdleSkylar")
				
			if NPC == "Juniper":
				ap.play("IdleJuniper")
				
			if NPC == "Quincy":
				ap.play("Idle")
		WALK:
			if NPC == "Micah" or NPC == "Skylar":
				ap.play("WalkingSkylar")
			
			if NPC == "Juniper":
				ap.play("WalkingJuniper")
				
			if NPC == "Quincy":
				ap.play("Walk")
			
			path.progress += SPEED * delta		
		WAIT:
			if NPC == "Micah" or NPC == "Skylar":
				ap.play("IdleSkylar")
			
			if NPC == "Juniper":
				ap.play("IdleJuniper")
				
			if NPC == "Quincy":
				ap.play("Idle")
			
			await get_tree().create_timer(8).timeout
			state = WALK

func set_random_rotation() -> void:
	# Set a random rotation on the Y-axis while waiting
	# Generate a random angle between -90 and 90 degrees in radians
	var random_angle = randf_range(-PI / 2, PI / 2)  # Random angle in radians within -90 to 90 degrees
	
	# Apply the random rotation on the Y-axis
	var new_basis = global_transform.basis
	new_basis = Basis(Vector3.UP, random_angle) * new_basis  # Apply the limited random Y rotation
	global_transform.basis = new_basis

func _on_interact_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		see_player = true
	#if body is in group player and input interact pressed, state = idle

func _on_interact_area_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		print("left")
		state = WALK
		see_player = false


func _on_wait_timer_timeout() -> void:
	if state == WALK:
		set_random_rotation()
		state = WAIT


func _on_interactable_interacted(interactor: Interactor) -> void:
	object_interaction = true


func _on_interactable_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		object_interaction = false
