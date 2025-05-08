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
var cant_follow = false
var tea_walking = false
var pour = false
var putDown = false
@export var tea_kitchen: Node3D
@export var tea_living: Node3D
@export var door_marker: Marker3D

#tea anims
@export var kettle: Node3D
@export var kettle_top: Node3D
@export var tray: Node3D
@export var tray_anim: Node3D
@export var tray_anim_player: AnimationPlayer

#tea static
@export var kettle_static: Node3D
@export var top_static: Node3D
@export var tray_static: Node3D
@export var tray_static_initial: Node3D

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
var sharply_turn = false
var greeting = false
var greet_rotation = false
signal juniper_open_door
var interaction : bool = false
var bookshelf = false

#sounds and footsteps
@export var sound_player : AnimationPlayer


enum {
	IDLE, 
	FOLLOW,
	WANDER,
	SITTING,
	TEA,
	TEADOWN,
	ANIMPROCESS
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
	#var target_position = player.global_position
	#var target_direction = (target_position - global_transform.origin).normalized()
	#look_at(global_transform.origin + -target_direction, Vector3.UP)
	wander_timer.start()
	#await get_tree().create_timer(10).timeout
	#anim_tree.set("parameters/Yawn/request", true)
	
func _process(delta: float) -> void:

	if not is_wandering:
		if greeting == true:
			distance_to_target = armature.global_transform.origin.distance_to(player.global_transform.origin)
		else:
			distance_to_target = armature.global_transform.origin.distance_to(marker_positions[5].global_transform.origin)
			
	else:
		distance_to_target = armature.global_transform.origin.distance_to(marker_positions[wander_choice].global_position)

	match state:
		IDLE:
			_process_idle_state(distance_to_target, delta)
		FOLLOW:
			_process_follow_state(distance_to_target)
		WANDER:
			_process_wander_state(distance_to_target, wander_choice)
		TEA:
			_process_tea_state(distance_to_target, wander_choice)
		TEADOWN:
			_process_teaDown_state(distance_to_target, wander_choice)
		ANIMPROCESS:
			_process_anim()
			
	
func _physics_process(delta: float) -> void:

	if is_navigating:
		var direction = Vector3()
		if not is_wandering:
			if greeting == true:
				STOPPING_DISTANCE = 1.0
				if bookshelf == false:
					nav.target_position = player.global_position
				else:
					nav.target_position = marker_positions[6].global_position
			else:
				STOPPING_DISTANCE = 1.0
				nav.target_position = marker_positions[5].global_position
				
		else:
			STOPPING_DISTANCE = 0.0
		direction = nav.get_next_path_position() - global_position
		direction = direction.normalized()
		#direction.y = 0
		velocity = velocity.lerp(direction * SPEED, accel * delta)
		floor_type_walk()
		if not tea_walking:
			anim_tree.set("parameters/BlendSpace1D/blend_position", velocity.length() / SPEED)
		else:
			print("intoState")
			anim_tree.set("parameters/Blend2/blend_amount", 1)
		nav.set_velocity(velocity)
		
		if (velocity.length() > MIN_STOP_THRESHOLD or wander_rotate == false) and at_door == false:
			#look_at(global_transform.origin + -direction, Vector3.UP)
			#print("velocityR")
			_rotate_towards_velocity()

	if wander_rotate == true:
		_rotate_towards_object(wander_choice)
	
	if greet_rotation:
		_rotate_towards_dalton()
		

func floor_type_walk():
	if $FloorTypeJuniper.is_colliding():
		var collider = $FloorTypeJuniper.get_collider()
		if collider.is_in_group("wood"):
			sound_player.play("Footsteps")
		if collider.is_in_group("tile"):
			sound_player.play("Footsteps_Tile")
		if collider.is_in_group("carpet"):
			sound_player.play("Footsteps_Carpet")
		
# floor type gather
func floor_type_gather():
	if $FloorTypeJuniper.is_colliding():
		var collider = $FloorTypeJuniper.get_collider()
		if collider.is_in_group("wood"):
			sound_player.play("FootstepsGather")
		if collider.is_in_group("tile"):
			sound_player.play("FootstepsGather_Tile")
		if collider.is_in_group("carpet"):
			sound_player.play("FootstepsGather_Carpet")
		



func _rotate_towards_dalton():
	var targ_dir = player.global_position
	var target = (armature.global_position - player.global_position).normalized()
	armature.rotation.y = (lerp_angle(armature.rotation.y, atan2(-target.x, -target.z), LERP_VAL))

func _process_tea_state(distance_to_target: float, wander_choice) -> void:
	if distance_to_target <= STOPPING_DISTANCE or nav.is_target_reached():
		anim_tree.set("parameters/Pour/request", true)
		pour = true
		state = ANIMPROCESS
		
func _process_teaDown_state(distance_to_target: float, wander_choice) -> void:
	if distance_to_target <= STOPPING_DISTANCE or nav.is_target_reached():
		tray.visible = false
		tray_anim.visible = true
		tea_walking = false
		anim_tree.set("parameters/Blend2/blend_amount", 0)
		anim_tree.set("parameters/PutDown/request", true)
		putDown = true
		state = ANIMPROCESS
	
func _process_anim():
	if pour:
		is_navigating = false
		anim_tree.set("parameters/BlendSpace1D/blend_position", 0)
		wander_rotate = true
		pour = false
		await get_tree().create_timer(3.0).timeout
		kettle.visible = true
		kettle_static.visible = false
		await get_tree().create_timer(2.0).timeout
		top_static.visible = false
		kettle_top.visible = true
		await get_tree().create_timer(1.5).timeout
		kettle_top.visible = false
		top_static.visible = true
		await get_tree().create_timer(2.0).timeout
		kettle_static.visible = true
		kettle.visible = false
		await get_tree().create_timer(2.5).timeout
		tray_static_initial.visible = false
		tray.visible = true
		wander_rotate = false
		nav.target_position = marker_positions[4].global_position
		tea_walking = true
		is_navigating = true
		state = TEADOWN
	elif putDown:
		wander_choice = 4
		is_navigating = false
		wander_rotate = true
		putDown = false
		await get_tree().create_timer(1.5).timeout
		tray_anim_player.play("trayDown")
		await get_tree().create_timer(1.7).timeout
		tray_anim.visible = false
		tray_static.visible = true
		#tea_walking = false
		wander_rotate = false
		cant_follow = false
		is_navigating = false
		wander_rotate = false
		wander_choice = 0
		cooldown_bool = true
		cooldown.start()
		wander_timer.start()
		floor_type_gather()
		state = IDLE
		
func _process_idle_state(distance_to_target: float, delta: float) -> void:
	# Prevent old path issues
	velocity = velocity.lerp(Vector3.ZERO, LERP_VAL)
	idle_blend = lerp(idle_blend, 0.0, LERP_VAL)
	anim_tree.set("parameters/BlendSpace1D/blend_position", idle_blend)

func _process_follow_state(distance_to_target: float) -> void:
	if distance_to_target <= STOPPING_DISTANCE or nav.is_target_reached():
			#emit_signal("collision_safe")
			if greeting == false:
				emit_signal("juniper_open_door")
				greet_rotation = true
			if bookshelf:
				bookshelf = false
				greet_rotation = true
				await get_tree().create_timer(0.5).timeout
				greet_rotation = false
			is_navigating = false
			cooldown_bool = true
			cooldown.start()
			wander_timer.start()
			floor_type_gather()
			state = IDLE
	
	if outside_player and greeting == true:
		floor_type_gather()
		state = IDLE

func _process_wander_state(distance_to_target: float, wander_choice: int) -> void:
	#print("wandering")
	var current_anim 
	if wander_choice < 3:
		current_anim = one_shots[wander_choice]
	
	if distance_to_target <= STOPPING_DISTANCE or nav.is_target_reached():
		print("gotthere")
		if current_anim == "Fireplace":
			wander_rotate = true
		if current_anim == "Coffee":
			sound_player.play("Coffee")
			wander_rotate = true
			_beer_visible()
		#_rotate_towards_object(wander_choice)
		anim_tree.set("parameters/" + current_anim + "/request", true)
		is_navigating = false 
		cooldown_bool = true
		cooldown.start()
		wander_timer.start()
		if current_anim != "Coffee":
			floor_type_gather()
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
		#look_at(global_transform.origin + -obj_direction, Vector3.UP)
		#armature.rotation.y = lerp_angle(fmod(armature.rotation.y - PI, TAU) - PI, atan2(-1, 0), 0.05)
		armature.rotation.y = lerp_angle(armature.rotation.y, atan2(obj_direction.x, obj_direction.z), LERP_VAL)
	elif wander_choice == 1:
		var obj_direction = Coffee_Static.global_position - global_position
		obj_direction = obj_direction.normalized()
		obj_direction.y = 0
		#look_at(global_transform.origin + -obj_direction, Vector3.UP) 
		armature.rotation.y = lerp_angle(armature.rotation.y, atan2(obj_direction.x, obj_direction.z), LERP_VAL)
	elif wander_choice == 2:
		var obj_direction = BookShelf.global_position - global_position
		obj_direction = obj_direction.normalized()
		obj_direction.y = 0
		#look_at(global_transform.origin + -obj_direction, Vector3.UP)
		armature.rotation.y = lerp_angle(armature.rotation.y, atan2(obj_direction.x, obj_direction.z), LERP_VAL)
		#armature.rotation.y = lerp_angle(fmod(armature.rotation.y + PI, TAU) - PI, atan2(0, 1), 0.05)
	elif wander_choice == 3:
		var obj_direction = tea_kitchen.global_position - global_position
		obj_direction = obj_direction.normalized()
		obj_direction.y = 0
		armature.rotation.y = lerp_angle(armature.rotation.y, atan2(obj_direction.x, obj_direction.z), LERP_VAL)
		
	elif wander_choice == 4:
		var obj_direction = tea_living.global_position - global_position
		obj_direction = obj_direction.normalized()
		obj_direction.y = 0
		armature.rotation.y = lerp_angle(armature.rotation.y, atan2(obj_direction.x, obj_direction.z), LERP_VAL)
		
func _on_interactable_interacted(interactor: Interactor) -> void:
	if cant_follow == false:
		wander_rotate = false
		#emit_signal("collision_danger")
		if wander_choice < 3:
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
	if greeting == true:
		if state == IDLE and see_player == false and cooldown_bool == false and state != FOLLOW and interaction == false:
			wander_choice = rng.randi_range(0, 2)
			wander_rotate = false
			#if choice > 0:
			nav.target_position = marker_positions[wander_choice].global_position
			is_navigating = true
			is_wandering = true
			state = WANDER

func _on_bookshelf_interacted(interactor: Interactor) -> void:
	wander_rotate = false
	bookshelf = true
	#emit_signal("collision_danger")
	if wander_choice < 3:
		var current_anim = one_shots[wander_choice]
		anim_tree.set("parameters/" + current_anim + "/request", 2)
	#set all one shots to abort
	is_navigating = true
	is_wandering = false
	state = FOLLOW

func _on_house_pic_interacted(interactor: Interactor) -> void:
	wander_rotate = false
	#emit_signal("collision_danger")
	if wander_choice < 3:
		var current_anim = one_shots[wander_choice]
		anim_tree.set("parameters/" + current_anim + "/request", 2)
	#set all one shots to abort
	is_navigating = true
	is_wandering = false
	state = FOLLOW

func _on_cafe_pic_interacted(interactor: Interactor) -> void:
	wander_rotate = false
	#emit_signal("collision_danger")
	if wander_choice < 3:
		var current_anim = one_shots[wander_choice]
		anim_tree.set("parameters/" + current_anim + "/request", 2)
	#set all one shots to abort
	is_navigating = true
	is_wandering = false
	state = FOLLOW

func _on_resumes_interacted(interactor: Interactor) -> void:
	wander_rotate = false
	#emit_signal("collision_danger")
	if wander_choice < 3:
		var current_anim = one_shots[wander_choice]
		anim_tree.set("parameters/" + current_anim + "/request", 2)
	#set all one shots to abort
	is_navigating = true
	is_wandering = false
	state = FOLLOW

func _on_case_interacted(interactor: Interactor) -> void:
	wander_rotate = false
	#emit_signal("collision_danger")
	if wander_choice < 3:
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

#func _on_tea_activate_temp_interacted(interactor: Interactor) -> void:
	#print("interactedTea")
	#var current_anim = one_shots[wander_choice]
	#anim_tree.set("parameters/" + current_anim + "/request", 2)
	#cant_follow = true
	#is_navigating = true
	#is_wandering = true
	#wander_choice = 3
	#nav.target_position = marker_positions[3].global_position
	#state = TEA

func _on_door_second_juniper_greeting() -> void:
	print("coming to door")
	if cant_follow == false:
		wander_rotate = false
		#emit_signal("collision_danger")
		if wander_choice < 3:
			var current_anim = one_shots[wander_choice]
			anim_tree.set("parameters/" + current_anim + "/request", 2)
		#set all one shots to abort
		is_navigating = true
		is_wandering = false
		state = FOLLOW
	
func _on_juniper_interact_finish_greeting() -> void:
	if greeting == false:
		greet_rotation = false
		greeting = true
		
		wander_choice = rng.randi_range(0, 2)
		wander_rotate = false
		#if choice > 0:
		nav.target_position = marker_positions[wander_choice].global_position
		is_navigating = true
		is_wandering = true
		state = WANDER
		#print("interactedTea")
		#var current_anim = one_shots[wander_choice]
		#anim_tree.set("parameters/" + current_anim + "/request", 2)
		#cant_follow = true
		#is_navigating = true
		#is_wandering = true
		#wander_choice = 3
		#nav.target_position = marker_positions[3].global_position
		#state = TEA


func _on_house_interact_general_interact() -> void:
	pass # Replace with function body.

func _on_resume_interact_juniper_wander() -> void:
	interaction = false
	var choice = rng.randi_range(-10, 10)
	if greeting == true:
		if cant_follow == false:
			wander_choice = rng.randi_range(0, 2)
		if state == IDLE and see_player == false and cooldown_bool == false and state != FOLLOW:
			wander_rotate = false
			#if choice > 0:
			nav.target_position = marker_positions[wander_choice].global_position
			is_navigating = true
			is_wandering = true
			state = WANDER

func _on_resume_interact_general_interact() -> void:
	interaction = true
