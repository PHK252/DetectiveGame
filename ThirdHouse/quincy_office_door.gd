extends Node3D

@export var animation_tree : AnimationTree
@export var collision : CollisionShape3D
@export var FP_Cam: PhantomCamera3D
@export var Exit_Cam: PhantomCamera3D

@export var dalton_marker: Marker2D
@export var theo_marker: Marker2D
@export var character_marker: Marker2D

#key animation
@export var key_animation : AnimationPlayer
@export var key : MeshInstance3D

#First Person cam anim + movement
@export var cam_anim: AnimationPlayer
@export var tilt_up_thres: int
@export var tilt_down_thres: int
@export var tilt_up_angle: Vector3
@export var tilt_down_angle: Vector3
@export var mid_angle: Vector3
@export var thought_dialogue_file: String
@export var cue_distract_dialogue: String
@export var key_hole: Area2D
@export var player : CharacterBody3D
@export var alert: Sprite3D
var is_open: bool = false
@onready var entered = false
var cooldown = false
var triggered = false
@onready var mouse_pos = Vector2(0,0) 
@onready var tilt = ""
@onready var try_open = 0
@onready var in_thoughts = false

#sounds
@export var open_door : AudioStreamPlayer3D
@export var close_door : AudioStreamPlayer3D
@export var key_sound : AudioStreamPlayer3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func open() -> void:
	print("opening")
	cooldown = true
	animation_tree["parameters/conditions/is_opened"] = true
	animation_tree["parameters/conditions/is_closed"] = false
	is_open = true
	open_door.play()
	key_sound.play()
	await get_tree().create_timer(2.0).timeout
	cooldown = false
	
	
func close() -> void:
	#print("Opening")
	cooldown = true
	animation_tree["parameters/conditions/is_closed"] = true
	animation_tree["parameters/conditions/is_opened"] = false
	is_open = false
	await get_tree().create_timer(2.0).timeout
	close_door.play()
	#print("quickCLosing")
	#animation_tree["parameters/conditions/quick_close"] = true
	#await get_tree().create_timer(0.5).timeout
	#animation_tree["parameters/conditions/quick_close"] = false
	#animation_tree["parameters/conditions/is_closed"] = false
	cooldown = false

func _process(delta):
	if GlobalVars.in_look_screen == false and GlobalVars.in_dialogue == false and GlobalVars.in_interaction == "office_door":
		mouse_pos = get_viewport().get_mouse_position()
		if mouse_pos.y >= tilt_up_thres:
			FP_Cam.set_rotation_degrees(tilt_up_angle)
			tilt = "down"
		elif mouse_pos.y < tilt_down_thres:
			FP_Cam.set_rotation_degrees(tilt_down_angle)
			tilt = "up"
		else:
			FP_Cam.set_rotation_degrees(mid_angle)
			tilt = "mid"
	else:
			FP_Cam.set_rotation_degrees(mid_angle)
	if try_open == 2:
		print("need_distract")
		Dialogic.VAR.set_variable("Quincy.needs_distraction", true)

func _on_interactable_interacted(interactor: Interactor) -> void:
	var unlocked = Dialogic.VAR.get_variable("Quincy.unlocked_office")
	print(is_open)
	print(entered)
	if unlocked == true and is_open == false and cooldown == false:
		if Dialogic.VAR.get_variable("Quincy.is_distracted") == true:
			open()
			collision.disabled = true
	elif unlocked == true and is_open == true and cooldown == false:
		if Dialogic.VAR.get_variable("Quincy.is_distracted") == true:
			close()
			collision.disabled = false
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		alert.hide()
		GlobalVars.in_interaction = "office_door"
		FP_Cam.priority = 30
		Exit_Cam.priority = 0 
		key_hole.show()
		cam_anim.play("Cam_Idle")
		player.hide()
		player.stop_player()
	
	#if is_open == true:
		#close()
		#collision.disabled = false

func _input(event):
	if Input.is_action_just_pressed("Exit") and GlobalVars.in_interaction == "office_door" and GlobalVars.quincy_kicked_out == false and GlobalVars.quincy_time_out == false: 
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		Exit_Cam.set_tween_duration(0)
		FP_Cam.priority = 0
		Exit_Cam.priority = 30
		key_hole.hide()
		player.start_player()
		player.show()
		alert.show()
		GlobalVars.in_interaction = ""

func doorOpen(argument: String):
	if not is_open and argument == "open_door":
		Dialogic.signal_event.disconnect(doorOpen)
		print("opening")
		key.show()
		key_animation.play("KeyOffice")
		await key_animation.animation_finished
		key.hide()
		open()
		await get_tree().create_timer(2.5).timeout
		collision.disabled = true
		is_open = true
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		Exit_Cam.set_tween_duration(0)
		FP_Cam.priority = 0
		Exit_Cam.priority = 30
		key_hole.hide()
		player.start_player()
		player.show()
		alert.show()
		GlobalVars.in_interaction = ""
	elif not is_open and argument == "end":
		Dialogic.signal_event.disconnect(doorOpen)

func exitDoor(argument: String):
	if not is_open and argument == "exit_door":
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		Exit_Cam.set_tween_duration(0)
		FP_Cam.priority = 0
		Exit_Cam.priority = 30
		key_hole.hide()
		player.start_player()
		player.show()
		alert.show()
		GlobalVars.in_interaction = ""
		Dialogic.signal_event.disconnect(exitDoor)
	elif not is_open and argument == "end":
			Dialogic.signal_event.disconnect(exitDoor)

#func switchCam(argument: String):
	#if not is_open and argument == "cut_cam":
		#Dialogic.signal_event.disconnect(switchCam)
		#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		#Exit_Cam.set_tween_duration(0)
		#FP_Cam.priority = 0
		#Exit_Cam.priority = 30
		#key_hole.hide()
		#player.show()
		#alert.hide()
		#GlobalVars.in_interaction = ""
		#GlobalVars.in_dialogue = true
		#var quincy_dialogue = Dialogic.start(thought_dialogue_file, "quincy talk")
		#Dialogic.timeline_ended.connect(_on_timeline_ended)
		#quincy_dialogue.register_character(load("res://Dialogic Characters/Dalton.dch"), dalton_marker)
		#quincy_dialogue.register_character(load("res://Dialogic Characters/Theo.dch"), theo_marker)
		#quincy_dialogue.register_character(load("res://Dialogic Characters/Quincy.dch"), character_marker)
		#player.stop_player()
	#elif not is_open and argument == "end":
			#Dialogic.signal_event.disconnect(switchCam)

func _on_thoughts_ended():
	Dialogic.timeline_ended.disconnect(_on_thoughts_ended)
	GlobalVars.in_dialogue = false
	#await get_tree().create_timer(.5).timeout

func _on_cue_thoughts_ended():
	Dialogic.timeline_ended.disconnect(_on_cue_thoughts_ended)
	GlobalVars.in_dialogue = false
	in_thoughts = false
	cue_finished()
	#await get_tree().create_timer(.5).timeout
	

func _on_office_door_input_event(viewport, event, shape_idx):
	#var has_key = Dialogic.VAR.get_variable("Asked Questions.has_key")
	if GlobalVars.in_look_screen == false:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed == true:
				if Dialogic.VAR.get_variable("Quincy.is_distracted") == true:
					Dialogic.timeline_ended.connect(_on_thoughts_ended)
					Dialogic.signal_event.connect(doorOpen)
					Dialogic.signal_event.connect(exitDoor)
					GlobalVars.in_dialogue = true
					Dialogic.start(thought_dialogue_file)
				elif Dialogic.VAR.get_variable("Quincy.is_distracted") == false and Dialogic.VAR.get_variable("Quincy.needs_distraction") == true: 
					GlobalVars.in_dialogue = true
					choose_distract_thought_dialogue()
					in_thoughts = true
					Dialogic.start(cue_distract_dialogue)
					Dialogic.timeline_ended.connect(_on_cue_thoughts_ended)
				else:
					try_open += 1
					cue_finished()
				

func _on_timeline_ended():
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	GlobalVars.in_dialogue = false
	GlobalVars.in_interaction = ""
	player.start_player()
	alert.show()

func choose_distract_thought_dialogue():
	if Dialogic.VAR.get_variable("Quincy.first_cue") == true:
		var rng = RandomNumberGenerator.new()
		var random = rng.randi_range(1, 3)
		Dialogic.VAR.set_variable("Quincy.cue_cycle", random)
		print("cue cycle " + str(random))
	else:
		Dialogic.VAR.set_variable("Quincy.first_cue", true)
		Dialogic.VAR.set_variable("Quincy.cue_cycle", 1)
		
func cue_finished():
	if in_thoughts == false and GlobalVars.in_dialogue == false and GlobalVars.in_interaction == "office_door":
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		Exit_Cam.set_tween_duration(0)
		FP_Cam.priority = 0
		Exit_Cam.priority = 30
		key_hole.hide()
		player.show()
		alert.hide()
		GlobalVars.in_interaction = ""
		GlobalVars.in_dialogue = true
		var quincy_dialogue = Dialogic.start(thought_dialogue_file, "quincy talk")
		Dialogic.timeline_ended.connect(_on_timeline_ended)
		quincy_dialogue.register_character(load("res://Dialogic Characters/Dalton.dch"), dalton_marker)
		quincy_dialogue.register_character(load("res://Dialogic Characters/Theo.dch"), theo_marker)
		quincy_dialogue.register_character(load("res://Dialogic Characters/Quincy.dch"), character_marker)
		player.stop_player()
