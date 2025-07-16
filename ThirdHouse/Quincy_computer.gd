extends Node3D

@export var FP_Cam: PhantomCamera3D
@export var Exit_Cam: PhantomCamera3D
@export var tilt_up_thres: int
@export var tilt_down_thres: int
@export var tilt_up_angle: Vector3
@export var tilt_down_angle: Vector3
@export var mid_angle: Vector3
#First Person cam anim + movement
@export var cam_anim: AnimationPlayer

@export var player: CharacterBody3D
#@onready var note_interaction = $Note
@export var UI : CanvasLayer
@export var alert : Sprite3D

@export var dalton_marker: Marker2D
@export var interact_area: Area2D
@export var dialogue_file: String
@export var react_dialogue_file: String
@export var load_Dalton_dialogue: String
@onready var mouse_pos = Vector2(0,0)
@export var interact_type: String

signal exit_interact
# Called when the node enters the scene tree for the first time.
func _ready():
	UI.hide()
	interact_area.hide()
	pass # Replace with function body.

func _process(delta):
	mouse_pos = get_viewport().get_mouse_position()
	if GlobalVars.in_look_screen == false and GlobalVars.in_dialogue == false:
		if mouse_pos.y >= tilt_up_thres:
			FP_Cam.set_rotation_degrees(tilt_up_angle)
		elif mouse_pos.y < tilt_down_thres:
			FP_Cam.set_rotation_degrees(tilt_down_angle)
		else:
			FP_Cam.set_rotation_degrees(mid_angle)
				#pass
	else:
			FP_Cam.set_rotation_degrees(mid_angle)

func _on_interactable_interacted(interactor):
	if GlobalVars.in_dialogue == false and GlobalVars.in_interaction == "":
		alert.hide()
		GlobalVars.in_dialogue = true
		player.stop_player()
		var computer_dialogue = Dialogic.start(dialogue_file)
		Dialogic.signal_event.connect(compFP)
		Dialogic.timeline_ended.connect(_on_timeline_ended)
		computer_dialogue.register_character(load(load_Dalton_dialogue), dalton_marker)


func _on_timeline_ended():
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	GlobalVars.in_dialogue = false
	if GlobalVars.Quincy_in_computer == false:
		player.start_player()
		alert.show()
#
func compFP(argument: String):
	if argument == "switch_cam":
		cam_anim.play("Cam_Idle")
		FP_Cam.priority = 30
		Exit_Cam.priority = 0
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		player.hide()
		interact_area.show()
		#GlobalVars.Quincy_in_computer = true
		player.stop_player()
		GlobalVars.in_interaction = "computer"
		#UI.show()
		Dialogic.signal_event.disconnect(compFP)
		

func _input(event):
	if Input.is_action_just_pressed("Exit") and GlobalVars.in_interaction == "computer" and GlobalVars.quincy_kicked_out == false and GlobalVars.quincy_time_out == false: 
		FP_Cam.priority = 0
		Exit_Cam.priority = 30
		var computer_react = Dialogic.start(react_dialogue_file)
		Dialogic.timeline_ended.connect(_on_timeline_ended)
		computer_react.register_character(load(load_Dalton_dialogue), dalton_marker)
		GlobalVars.in_dialogue = true
		interact_area.hide()
		GlobalVars.Quincy_in_computer = false
		player.start_player()
		player.show()
		GlobalVars.in_interaction = ""


func _on_computer_input_event(viewport, event, shape_idx):
	if GlobalVars.in_look_screen == false:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed == true:
				GlobalVars.Quincy_in_computer = true
				UI.show()


func _on_quincy_caught_in_view():
	interact_area.hide()
	Exit_Cam.set_tween_duration(0)
	FP_Cam.priority = 0
	Exit_Cam.priority = 30 
	Exit_Cam.set_tween_duration(1)
	GlobalVars.in_interaction = ""
	player.show()
	emit_signal("exit_interact")
