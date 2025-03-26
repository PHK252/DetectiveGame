extends CharacterBody3D

@export var anim_tree : AnimationTree
@export var anim_player : AnimationPlayer
@export var player : CharacterBody3D
@export var armature = CharacterBody3D
#@export var WaitTimer : Timer
@export var NPC : String
@onready var object_interaction = false
@export var nav: NavigationAgent3D
@export var target: Marker3D
@export var one_shots: Array[String]
var rng = RandomNumberGenerator.new()
@export var cooldown: Timer
@export var wander_timer: Timer
var cooldown_bool = false
signal collision_danger
signal collision_safe
@export var Beer_Static: Node3D
@export var Beer_Anim: Node3D
var current_anim 
var intDalton = false

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
var SPEED = 1.15
var LERP_VAL = 0.1
var rotation_speed = 100
var is_wandering = false
var distance_to_target
var wander_rotate = false

signal sit_visible
signal sit_invisible

func _ready() -> void:
	add_to_group("micah")
	anim_player.play("basketball_default")
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
		nav.set_velocity(velocity)

	if velocity.length() > MIN_STOP_THRESHOLD or wander_rotate == false:
		_rotate_towards_velocity()
	else:
		_rotate_towards_object(wander_choice)

func _process_idle_state(distance_to_target: float, delta: float) -> void:
	# Prevent old path issues
	velocity = velocity.lerp(Vector3.ZERO, LERP_VAL)
	idle_blend = lerp(idle_blend, 0.0, LERP_VAL)
	anim_tree.set("parameters/BlendSpace1D/blend_position", idle_blend)
	
	#if wander_choice == 2:
			#state = SITTING

func _process_follow_state(distance_to_target: float) -> void:
	if distance_to_target <= STOPPING_DISTANCE:
			#emit_signal("collision_safe")
			is_navigating = false
			cooldown_bool = true
			cooldown.start()
			wander_timer.start()
			state = IDLE

func _process_wander_state(distance_to_target: float, wander_choice: int) -> void:
	anim_player.play("basketball_default")
	anim_tree.set("parameters/Yawn/request", 2)
	anim_tree.set("parameters/Scratch/request", 2)
	#print("wandering")
	if wander_choice < 2:
		current_anim = one_shots[wander_choice]

	if distance_to_target <= STOPPING_DISTANCE or nav.is_target_reached():
		#print("gotthere")
		if current_anim == "Basketball":
			wander_rotate = true
			anim_player.play("basketball")
			#Beer_Static.visible = false
			#Beer_Anim.visible = true
		if current_anim == "DrinkBeer":
			anim_player.play("basketball_default")
			wander_rotate = true
			_beer_visible()
			
		if wander_choice < 2:
			anim_tree.set("parameters/" + current_anim + "/request", true)

		is_navigating = false 
		cooldown_bool = true
		cooldown.start()
		wander_timer.start()
		if wander_choice == 2:
			anim_player.play("basketball_default")
			emit_signal("sit_visible")
			armature.visible = false
		state = IDLE
	
func _rotate_towards_velocity() -> void:
	armature.rotation.y = lerp_angle(armature.rotation.y, atan2(velocity.x, velocity.z), LERP_VAL)
		
func _beer_visible():
	await get_tree().create_timer(2.5).timeout
	Beer_Static.visible = false
	Beer_Anim.visible = true
	await get_tree().create_timer(5.0).timeout
	Beer_Static.visible = true
	Beer_Anim.visible = false
	
func _rotate_towards_object(wander_choice) -> void:
	if wander_choice == 0:
		#armature.rotation.y = -90
		#armature.rotation.y = lerp_angle(fmod(armature.rotation.y - PI, TAU) - PI, atan2(-1, 0), 0.05)
		armature.rotation.y = lerp_angle(armature.rotation.y, atan2(-1, 0), LERP_VAL)
	elif wander_choice == 1:
		#armature.rotation.y = 0
		#armature.rotation.y = lerp_angle(fmod(armature.rotation.y + PI, TAU) - PI, atan2(0, 1), 0.05)
		armature.rotation.y = lerp_angle(armature.rotation.y, atan2(0, 1), LERP_VAL)
		
func _on_interactable_interacted(interactor: Interactor) -> void:
	wander_rotate = false
	#emit_signal("collision_danger")
	if wander_choice < 2:
		var current_anim = one_shots[wander_choice]
		anim_tree.set("parameters/" + current_anim + "/request", 2)
	if wander_choice == 2:
		emit_signal("sit_invisible")
		armature.visible = true
	anim_tree.set("parameters/Yawn/request", 2)
	anim_tree.set("parameters/Scratch/request", 2)
	anim_player.play("basketball_default")
	#set all one shots to abort
	is_navigating = true
	is_wandering = false
	state = FOLLOW

func _on_navigation_agent_3d_velocity_computed(safe_velocity: Vector3) -> void:
	velocity = velocity.move_toward(safe_velocity, 0.25)
	if is_navigating:
		move_and_slide()

func _on_interact_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("theo"):
		print("theoEnter")
		emit_signal("collision_danger")
	
	if body.is_in_group("player"):
		print("see")
		#emit_signal("collision_danger")
		see_player = true

func _on_interact_area_body_exited(body: Node3D) -> void:
	if body.is_in_group("theo"):
		emit_signal("collision_safe")
		
	if body.is_in_group("player"):
		print("notsee")
		#emit_signal("collision_safe")
		see_player = false

func _on_timer_timeout() -> void:
	print(cooldown_bool)
	var choice = rng.randi_range(-10, 10)
	wander_choice = rng.randi_range(0, 2)
	if state == IDLE and see_player == false and cooldown_bool == false and state != FOLLOW and intDalton == false:
		wander_rotate = false
		emit_signal("sit_invisible")
		armature.visible = true
		
		if choice > 0:
			anim_tree.set("parameters/Yawn/request", true)
			await get_tree().create_timer(9).timeout
			nav.target_position = marker_positions[wander_choice].global_position
			is_navigating = true
			is_wandering = true
			state = WANDER
		else:
			anim_tree.set("parameters/Scratch/request", true)
			await get_tree().create_timer(5).timeout
			nav.target_position = marker_positions[wander_choice].global_position
			is_navigating = true
			is_wandering = true
			state = WANDER
		
func _on_cooldown_timeout() -> void:
	print("timeout")
	cooldown_bool = false

func _on_character_body_3d_theo_adjustment() -> void:
	intDalton = true

func _on_character_body_3d_theo_reset() -> void:
	intDalton = false
	wander_choice = 2
	nav.target_position = marker_positions[wander_choice].global_position
	is_navigating = true
	is_wandering = true
	state = WANDER
