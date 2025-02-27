extends CharacterBody3D

@export var anim_tree : AnimationTree
@export var anim_player : AnimationPlayer
@export var player : CharacterBody3D
@export var armature = CharacterBody3D
#@export var WaitTimer : Timer
@export var NPC : String
@onready var object_interaction = false
@export var nav: NavigationAgent3D
@export var one_shots: Array[String]
var rng = RandomNumberGenerator.new()
@export var cooldown: Timer
@export var wander_timer: Timer
var cooldown_bool = false
signal collision_danger
signal collision_safe
@export var Coffee_Static: Node3D
@export var FirePlace: Node3D
@export var BookShelf: Node3D
@export var Coffee_Anim: Node3D
var outside_player = false


var STOPPING_DISTANCE = 0.5  # Distance at which we stop following
const STOPPING_BUFFER = 0.4  # Small buffer to prevent jittering
const MIN_STOP_THRESHOLD = 0.05  # Minimum velocity to consider NPC as stationary
#const FOLLOW_DISTANCE = 1.2 

var idle_blend = 0.0
var is_navigating = false
var targ_reach = false
var accel = 10
@export var marker_positions: Array[Node3D]
var wander_choice = 0

enum {
	IDLE, 
	FOLLOW,
	WANDER,
	SITTING
}

var state = IDLE
var see_player = false
var at_door = false
var SPEED = 0.8
var LERP_VAL = 0.1
var rotation_speed = 70
var is_wandering = false
var distance_to_target
var wander_rotate = false


func _ready() -> void:
	add_to_group("juniper")
	anim_player.play("idle_chain")
	state = IDLE
	var target_position = player.global_position
	var target_direction = (target_position - global_transform.origin).normalized()
	look_at(global_transform.origin + -target_direction, Vector3.UP)
	wander_timer.start()
	#await get_tree().create_timer(10).timeout
	#anim_tree.set("parameters/Yawn/request", true)
	
func _process(delta: float) -> void:

	if not is_wandering:
		distance_to_target = armature.global_transform.origin.distance_to(player.global_transform.origin)
	else:
		distance_to_target = armature.global_transform.origin.distance_to(marker_positions[wander_choice].global_position)

	match state:
		IDLE:
			_process_idle_state(distance_to_target, delta)
		FOLLOW:
			_process_follow_state(distance_to_target)
		WANDER:
			_process_wander_state(distance_to_target, wander_choice)
			
	
func _physics_process(delta: float) -> void:

	if is_navigating:
		var direction = Vector3()
		if not is_wandering:
			STOPPING_DISTANCE = 1.0
			nav.target_position = player.global_position
		else:
			STOPPING_DISTANCE = 0.0
		direction = nav.get_next_path_position() - global_position
		direction = direction.normalized()
		#direction.y = 0
		velocity = velocity.lerp(direction * SPEED, accel * delta)
		anim_tree.set("parameters/BlendSpace1D/blend_position", velocity.length() / SPEED)
		look_at(global_transform.origin + -direction, Vector3.UP)
		nav.set_velocity(velocity)

func _process_idle_state(distance_to_target: float, delta: float) -> void:
	# Prevent old path issues
	velocity = velocity.lerp(Vector3.ZERO, LERP_VAL)
	idle_blend = lerp(idle_blend, 0.0, LERP_VAL)
	anim_tree.set("parameters/BlendSpace1D/blend_position", idle_blend)

func _process_follow_state(distance_to_target: float) -> void:
	if distance_to_target <= STOPPING_DISTANCE:
			#emit_signal("collision_safe")
			is_navigating = false
			cooldown_bool = true
			cooldown.start()
			wander_timer.start()
			state = IDLE
	
	if outside_player:
		state = IDLE

func _process_wander_state(distance_to_target: float, wander_choice: int) -> void:
	#print("wandering")
	var current_anim = one_shots[wander_choice]
	
	if distance_to_target <= STOPPING_DISTANCE or nav.is_target_reached():
		print("gotthere")
		if current_anim == "Fireplace":
			wander_rotate = true
		if current_anim == "Coffee":
			wander_rotate = true
			_beer_visible()
		_rotate_towards_object(wander_choice)
		anim_tree.set("parameters/" + current_anim + "/request", true)
		is_navigating = false 
		cooldown_bool = true
		cooldown.start()
		wander_timer.start()
		state = IDLE
	
func _rotate_towards_velocity() -> void:
	armature.rotation.y = lerp_angle(armature.rotation.y, atan2(velocity.x, velocity.z), LERP_VAL)
		
func _beer_visible():
	await get_tree().create_timer(2.5).timeout
	Coffee_Static.visible = false
	Coffee_Anim.visible = true
	await get_tree().create_timer(5.8).timeout
	Coffee_Static.visible = true
	Coffee_Anim.visible = false
	
func _rotate_towards_object(wander_choice) -> void:
	if wander_choice == 0:
		var obj_direction = FirePlace.global_position - global_position
		obj_direction = obj_direction.normalized()
		obj_direction.y = 0
		look_at(global_transform.origin + -obj_direction, Vector3.UP)
		#armature.rotation.y = lerp_angle(fmod(armature.rotation.y - PI, TAU) - PI, atan2(-1, 0), 0.05)
	elif wander_choice == 1:
		var obj_direction = Coffee_Static.global_position - global_position
		obj_direction = obj_direction.normalized()
		obj_direction.y = 0
		look_at(global_transform.origin + -obj_direction, Vector3.UP) 
	elif wander_choice == 2:
		var obj_direction = BookShelf.global_position - global_position
		obj_direction = obj_direction.normalized()
		obj_direction.y = 0
		look_at(global_transform.origin + -obj_direction, Vector3.UP)
		#armature.rotation.y = lerp_angle(fmod(armature.rotation.y + PI, TAU) - PI, atan2(0, 1), 0.05)
		
func _on_interactable_interacted(interactor: Interactor) -> void:
	wander_rotate = false
	#emit_signal("collision_danger")
	var current_anim = one_shots[wander_choice]
	anim_tree.set("parameters/" + current_anim + "/request", 2)
	#set all one shots to abort
	is_navigating = true
	is_wandering = false
	state = FOLLOW

func _on_navigation_agent_3d_velocity_computed(safe_velocity: Vector3) -> void:
	velocity = velocity.move_toward(safe_velocity, 0.25)
	if is_navigating:
		move_and_slide()

func _on_interact_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		#emit_signal("collision_danger")
		see_player = true

func _on_interact_area_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		#emit_signal("collision_safe")
		see_player = false
	
func _on_cooldown_timeout() -> void:
	print("timeout")
	cooldown_bool = false

func _on_wander_timeout() -> void:
	print(cooldown_bool)
	var choice = rng.randi_range(-10, 10)
	wander_choice = rng.randi_range(0, 2)
	if state == IDLE and see_player == false and cooldown_bool == false and state != FOLLOW:
		wander_rotate = false
		#if choice > 0:
		nav.target_position = marker_positions[wander_choice].global_position
		is_navigating = true
		is_wandering = true
		state = WANDER

func _on_bookshelf_interacted(interactor: Interactor) -> void:
	wander_rotate = false
	#emit_signal("collision_danger")
	var current_anim = one_shots[wander_choice]
	anim_tree.set("parameters/" + current_anim + "/request", 2)
	#set all one shots to abort
	is_navigating = true
	is_wandering = false
	state = FOLLOW

func _on_house_pic_interacted(interactor: Interactor) -> void:
	wander_rotate = false
	#emit_signal("collision_danger")
	var current_anim = one_shots[wander_choice]
	anim_tree.set("parameters/" + current_anim + "/request", 2)
	#set all one shots to abort
	is_navigating = true
	is_wandering = false
	state = FOLLOW

func _on_cafe_pic_interacted(interactor: Interactor) -> void:
	wander_rotate = false
	#emit_signal("collision_danger")
	var current_anim = one_shots[wander_choice]
	anim_tree.set("parameters/" + current_anim + "/request", 2)
	#set all one shots to abort
	is_navigating = true
	is_wandering = false
	state = FOLLOW

func _on_resumes_interacted(interactor: Interactor) -> void:
	wander_rotate = false
	#emit_signal("collision_danger")
	var current_anim = one_shots[wander_choice]
	anim_tree.set("parameters/" + current_anim + "/request", 2)
	#set all one shots to abort
	is_navigating = true
	is_wandering = false
	state = FOLLOW

func _on_case_interacted(interactor: Interactor) -> void:
	wander_rotate = false
	#emit_signal("collision_danger")
	var current_anim = one_shots[wander_choice]
	anim_tree.set("parameters/" + current_anim + "/request", 2)
	#set all one shots to abort
	is_navigating = true
	is_wandering = false
	state = FOLLOW
	

func _on_door_point_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		outside_player = true
		await get_tree().create_timer(1).timeout
		outside_player = false
