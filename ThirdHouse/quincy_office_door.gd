extends Node3D

@export var animation_tree : AnimationTree
@export var collision : CollisionShape3D
@export var FP_Cam: PhantomCamera3D
@export var Exit_Cam: PhantomCamera3D

#First Person cam anim + movement
@export var cam_anim: AnimationPlayer
@export var tilt_up_thres: int
@export var tilt_down_thres: int
@export var tilt_up_angle: Vector3
@export var tilt_down_angle: Vector3
@export var mid_angle: Vector3
@export var thought_dialogue_file: String
@export var key_hole: Area2D
@export var player : CharacterBody3D
@export var alert: Sprite3D
var is_open: bool = false
@onready var entered = false
var cooldown = false
var triggered = false
@onready var mouse_pos = Vector2(0,0) 
@onready var tilt = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func open() -> void:
	print("opening")
	cooldown = true
	animation_tree["parameters/conditions/is_opened"] = true
	animation_tree["parameters/conditions/is_closed"] = false
	is_open = true
	await get_tree().create_timer(2.0).timeout
	cooldown = false
	
	
func close() -> void:
	#print("Opening")
	cooldown = true
	animation_tree["parameters/conditions/is_closed"] = true
	animation_tree["parameters/conditions/is_opened"] = false
	is_open = false
	await get_tree().create_timer(2.0).timeout
	#print("quickCLosing")
	#animation_tree["parameters/conditions/quick_close"] = true
	#await get_tree().create_timer(0.5).timeout
	#animation_tree["parameters/conditions/quick_close"] = false
	#animation_tree["parameters/conditions/is_closed"] = false
	cooldown = false

func _process(delta):
	if GlobalVars.in_look_screen == false and GlobalVars.in_dialogue == false:
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

func _on_interactable_interacted(interactor: Interactor) -> void:
	var unlocked = Dialogic.VAR.get_variable("Quincy.unlocked_office")
	print(is_open)
	print(entered)
	if unlocked == true and is_open == false and cooldown == false:
		open()
		collision.disabled = true
	elif unlocked == true and is_open == true and cooldown == false:
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
	if Input.is_action_just_pressed("Exit") and GlobalVars.in_interaction == "office_door": 
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
		open()
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
		Dialogic.signal_event.disconnect(doorOpen)
		Dialogic.signal_event.disconnect(exitDoor)

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
		Dialogic.signal_event.disconnect(doorOpen)
		Dialogic.signal_event.disconnect(exitDoor)
	pass

func _on_thoughts_ended():
	Dialogic.timeline_ended.disconnect(_on_thoughts_ended)
	GlobalVars.in_dialogue = false
	#await get_tree().create_timer(.5).timeout

func _on_office_door_input_event(viewport, event, shape_idx):
	#var has_key = Dialogic.VAR.get_variable("Asked Questions.has_key")
	if GlobalVars.in_look_screen == false:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed == true:
				Dialogic.timeline_ended.connect(_on_thoughts_ended)
				Dialogic.signal_event.connect(doorOpen)
				Dialogic.signal_event.connect(exitDoor)
				GlobalVars.in_dialogue = true
				Dialogic.start(thought_dialogue_file)
