extends Node3D

@export var case_cam: PhantomCamera3D
@export var main_cam: PhantomCamera3D
@export var player: CharacterBody3D
@export var alert: Sprite3D
#@onready var note_interaction = $Note
@export var cam_anim : AnimationPlayer
@export var interact_area: Area2D
@export var UI : CanvasLayer


@export var interior_interact_area_1 : Area2D
@export var interior_interact_area_2 : Area2D
@export var interior_interact_area_3 : Area2D
@export var interior_interact_area_4 : Area2D

@export var dalton_marker: Marker2D
@export var theo_marker: Marker2D
@export var character_marker: Marker2D

@export var dialogue_file: String

@export var in_case_dialogue_1 : String
@export var in_case_dialogue_2 : String
@export var in_case_dialogue_choices : String
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
			var game_dialogue = Dialogic.start(dialogue_file)
			Dialogic.signal_event.connect(caseUI)
			Dialogic.timeline_ended.connect(_on_timeline_ended)
			game_dialogue.register_character(load(load_Dalton_dialogue), dalton_marker)
			game_dialogue.register_character(load(load_Theo_dialogue), theo_marker)
			game_dialogue.register_character(load(load_char_dialogue), character_marker)
		elif GlobalVars.opened_jun_case == true:
			GlobalVars.in_interaction = interact_type
			#print("look " + str(GlobalVars.in_look_screen))
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			alert.hide()
			player.stop_player()
			case_cam.priority = 30
			main_cam.priority = 0 
			cam_anim.play("Cam_Idle")
			interior_interact_area_1.show()
			interior_interact_area_2.show()
			interior_interact_area_3.show()
			interior_interact_area_4.show()
		else:
			GlobalVars.in_interaction = interact_type
			GlobalVars.in_dialogue = true
			alert.hide()
			player.stop_player()
			var game_dialogue = Dialogic.start(dialogue_file, "choices")
			Dialogic.signal_event.connect(caseUI)
			Dialogic.timeline_ended.connect(_on_timeline_ended)
			game_dialogue.register_character(load(load_Dalton_dialogue), dalton_marker)
			game_dialogue.register_character(load(load_Theo_dialogue), theo_marker)
			game_dialogue.register_character(load(load_char_dialogue), character_marker)


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
	GlobalVars.in_look_screen = false
	UI.hide()
	interact_area.show()
	GlobalVars.viewing = ""

func _input(event):
	var finished_letter = Dialogic.VAR.get_variable("Juniper.finished_letter")
	var finished_tag = Dialogic.VAR.get_variable("Juniper.finished_name_tag")
	if GlobalVars.in_dialogue == false:
		if Input.is_action_just_pressed("Exit") and GlobalVars.in_interaction == interact_type and GlobalVars.viewing == "":
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			case_cam.priority = 0
			main_cam.priority = 30
			cam_anim.play("RESET")
			player.show()
			if GlobalVars.opened_jun_case == true:
				interior_interact_area_1.hide()
				interior_interact_area_2.hide()
				interior_interact_area_3.hide()
				interior_interact_area_4.hide()
				print("viewed letter" + str(GlobalVars.view_letter_juniper))
				print("viewed name" + str(GlobalVars.view_nametag_juniper))
				if finished_letter == true or finished_tag == true:
					if finished_tag == true:
						GlobalVars.in_interaction = ""
						GlobalVars.in_dialogue = true
						alert.hide()
						player.stop_player()
						var game_dialogue = Dialogic.start(in_case_dialogue_1)
						Dialogic.timeline_ended.connect(_on_timeline_ended)
						game_dialogue.register_character(load(load_Dalton_dialogue), dalton_marker)
						game_dialogue.register_character(load(load_Theo_dialogue), theo_marker)
						game_dialogue.register_character(load(load_char_dialogue), character_marker)
					elif finished_letter == true:
						GlobalVars.in_interaction = ""
						GlobalVars.in_dialogue = true
						alert.hide()
						player.stop_player()
						var game_dialogue = Dialogic.start(in_case_dialogue_2)
						Dialogic.timeline_ended.connect(_on_timeline_ended)
						game_dialogue.register_character(load(load_Dalton_dialogue), dalton_marker)
						game_dialogue.register_character(load(load_Theo_dialogue), theo_marker)
						game_dialogue.register_character(load(load_char_dialogue), character_marker)
				else:
					if GlobalVars.view_letter_juniper == true and GlobalVars.view_nametag_juniper == true:
						GlobalVars.in_interaction = ""
						GlobalVars.in_dialogue = true
						alert.hide()
						player.stop_player()
						var game_dialogue = Dialogic.start(in_case_dialogue_choices)
						Dialogic.timeline_ended.connect(_on_timeline_ended)
						game_dialogue.register_character(load(load_Dalton_dialogue), dalton_marker)
						game_dialogue.register_character(load(load_Theo_dialogue), theo_marker)
						game_dialogue.register_character(load(load_char_dialogue), character_marker)
					elif GlobalVars.view_letter_juniper == true and GlobalVars.view_nametag_juniper == false:
						print("enteredddd else")
						GlobalVars.in_interaction = ""
						GlobalVars.in_dialogue = true
						alert.hide()
						player.stop_player()
						var game_dialogue = Dialogic.start(in_case_dialogue_1)
						Dialogic.timeline_ended.connect(_on_timeline_ended)
						game_dialogue.register_character(load(load_Dalton_dialogue), dalton_marker)
						game_dialogue.register_character(load(load_Theo_dialogue), theo_marker)
						game_dialogue.register_character(load(load_char_dialogue), character_marker)
					elif GlobalVars.view_letter_juniper == false and GlobalVars.view_nametag_juniper == true:
						print("enteredddd")
						GlobalVars.in_interaction = ""
						GlobalVars.in_dialogue = true
						alert.hide()
						player.stop_player()
						var game_dialogue = Dialogic.start(in_case_dialogue_2)
						Dialogic.timeline_ended.connect(_on_timeline_ended)
						game_dialogue.register_character(load(load_Dalton_dialogue), dalton_marker)
						game_dialogue.register_character(load(load_Theo_dialogue), theo_marker)
						game_dialogue.register_character(load(load_char_dialogue), character_marker)
			else:
				GlobalVars.in_interaction = ""
				player.start_player()
				alert.show()
				interact_area.hide()
		elif Input.is_action_just_pressed("Exit") and GlobalVars.in_interaction == interact_type and GlobalVars.viewing == "case_ui": 
			UI.hide()
			GlobalVars.in_look_screen = false
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
