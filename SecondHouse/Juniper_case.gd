extends Node3D

@export var case_cam: PhantomCamera3D
@export var main_cam: PhantomCamera3D
@export var player: CharacterBody3D
@export var alert: Sprite3D
#@onready var note_interaction = $Note
@export var cam_anim : AnimationPlayer
@export var interact_area: Area2D
@export var UI : CanvasLayer

@export var dalton_marker: Marker2D
@export var theo_marker: Marker2D
@export var character_marker: Marker2D

@export var dialogue_file: String
@export var load_Dalton_dialogue: String
@export var load_Theo_dialogue: String
@export var load_char_dialogue: String

@export var interact_type: String
# Called when the node enters the scene tree for the first time.
func _ready():
	UI.hide()
	interact_area.hide()
	pass # Replace with function body.


func _on_interactable_interacted(interactor):
	var case_asked = Dialogic.VAR.get_variable("Juniper.Juniper_asked_case")
	print(case_asked)
	if GlobalVars.in_dialogue == false:
		if case_asked == false:
			GlobalVars.in_dialogue = true
			GlobalVars.in_interaction = interact_type
			alert.hide()
			player.stop_player()
			var closet_dialogue = Dialogic.start(dialogue_file)
			Dialogic.signal_event.connect(caseUI)
			Dialogic.timeline_ended.connect(_on_timeline_ended)
			closet_dialogue.register_character(load(load_Dalton_dialogue), dalton_marker)
			closet_dialogue.register_character(load(load_Theo_dialogue), theo_marker)
			closet_dialogue.register_character(load(load_char_dialogue), character_marker)
		elif GlobalVars.opened_jun_case == true:
			GlobalVars.in_interaction = interact_type
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			alert.hide()
			player.stop_player()
			case_cam.priority = 30
			main_cam.priority = 0 
			cam_anim.play("Cam_Idle")
		else:
			GlobalVars.in_interaction = interact_type
			GlobalVars.in_dialogue = true
			alert.hide()
			player.stop_player()
			var closet_dialogue = Dialogic.start(dialogue_file, "choices")
			Dialogic.signal_event.connect(caseUI)
			Dialogic.timeline_ended.connect(_on_timeline_ended)
			closet_dialogue.register_character(load(load_Dalton_dialogue), dalton_marker)
			closet_dialogue.register_character(load(load_Theo_dialogue), theo_marker)
			closet_dialogue.register_character(load(load_char_dialogue), character_marker)


func _on_timeline_ended():
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	GlobalVars.in_dialogue = false
	if GlobalVars.Juniper_in_case == false:
		player.start_player()
		alert.show()
#
func caseUI(argument: String):
	if argument == "look_case":
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		player.hide()
		GlobalVars.Juniper_in_case = true
		player.stop_player()
		GlobalVars.viewing = "case_ui"
		interact_area.show()
		case_cam.priority = 30
		main_cam.priority = 0 
		cam_anim.play("Cam_Idle")
		Dialogic.signal_event.disconnect(caseUI)
		


func _on_exit_pressed():
	#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	GlobalVars.Juniper_in_case = false
	UI.hide()
	interact_area.show()
	GlobalVars.viewing = ""

func _input(event):
	if GlobalVars.in_dialogue == false:
		if Input.is_action_just_pressed("Exit") and GlobalVars.in_interaction == interact_type and GlobalVars.viewing == "":
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			#print("enter")
			GlobalVars.in_interaction = ""
			case_cam.priority = 0
			main_cam.priority = 30
			cam_anim.play("RESET")
			player.show()
			player.start_player()
			alert.show()
			interact_area.hide()
		elif Input.is_action_just_pressed("Exit") and GlobalVars.in_interaction == interact_type and GlobalVars.viewing == "case_ui": 
			UI.hide()
			GlobalVars.Juniper_in_case = false
			await get_tree().create_timer(.03).timeout
			GlobalVars.viewing = ""
			interact_area.show()

func _on_input_event(viewport, event, shape_idx):
	if GlobalVars.in_look_screen == false:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed == true:
				if GlobalVars.in_interaction == "":
					GlobalVars.in_interaction = interact_type
				UI.show()
				GlobalVars.in_look_screen = true
				GlobalVars.clicked_case_Juniper = GlobalVars.clicked_case_Juniper + 1
				interact_area.hide()
