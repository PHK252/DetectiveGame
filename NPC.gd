extends CharacterBody3D

@export var ap : AnimationPlayer
@export var player : Node3D
@onready var armature = %Micah
@export var path : PathFollow3D

enum {
	IDLE, 
	WALK
}

var state = IDLE
var see_player = false
var at_door = false
const SPEED = 0.2
const LERP_VAL = .15
var rotation_speed = 70

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	move_and_slide()
	
	if state == WALK:
		#rotation y to 106 degrees
		path.progress += SPEED * delta
		

func look():
	pass
	#look_at(GlobalVars.player_position)

func _process(delta):
	if see_player and Input.is_action_just_pressed("interact"):
		print("interacted")
		state = IDLE
		#rotation y to 0
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
	#if see player true then look at player
	#check player position player.globalposition
	
	match state:
		IDLE:
			ap.play("IdleSkylar")
		WALK:
			ap.play("WalkingSkylar")


func _on_interact_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		see_player = true
	#if body is in group player and input interact pressed, state = idle

func _on_interact_area_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		print("left")
		state = WALK
		see_player = false
