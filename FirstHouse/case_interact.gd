extends Node3D

@export var case_cam: PhantomCamera3D
@export var main_cam: PhantomCamera3D
@export var player: CharacterBody3D
@export var alert: Sprite3D
#@onready var note_interaction = $Note
@export var cam_anim : AnimationPlayer
@export var interact_area: Area2D
@export var UI : CanvasLayer

@export var case_top_1 : MeshInstance3D
@export var case_bottom_1 : MeshInstance3D

@export var case_top_2 : MeshInstance3D
@export var case_bottom_2 : MeshInstance3D
@export var case_hair : MeshInstance3D
@export var case_note : MeshInstance3D
@export var case_key : MeshInstance3D

#@export var case_open_anim : AnimationPlayer

@export var interior_interact_area_1 : Area2D
@export var interior_interact_area_2 : Area2D
@export var interior_interact_area_3 : Area2D

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

@export var case_pickup : AudioStreamPlayer3D
signal general_quit

signal disable_look
signal enable_look
# Called when the node enters the scene tree for the first time.
func _ready():
	UI.hide()
	interact_area.hide()
	hide_open_case()
	#show_open_case()
	pass # Replace with function body.

func hide_open_case():
	case_top_2.hide()
	case_bottom_2.hide()
	case_hair.hide()
	case_note.hide()
	case_key.hide()

func show_open_case():
	case_top_2.show()
	case_bottom_2.show()
	if Dialogic.VAR.get_variable("Asked Questions.has_hair") == true:
		case_hair.hide()
	else:
		case_hair.show()
	case_note.show()
	case_key.show()
	
func  hide_closed_case():
	case_top_1.hide()
	case_bottom_1.hide()
	
func  show_closed_case():
	case_top_1.show()
	case_bottom_1.show()

func _on_interactable_interacted(interactor):
	
	var case_asked = Dialogic.VAR.get_variable("Asked Questions.Micah_Asked_Case")
	print(alert.visible, "alert")
	if GlobalVars.in_dialogue == false:
		if GlobalVars.opened_micah_case == true:
			player.hide()
			show_open_case()
			GlobalVars.in_interaction = interact_type
			#print("look " + str(GlobalVars.in_look_screen))
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			player.stop_player()
			case_cam.priority = 30
			main_cam.priority = 0 
			cam_anim.play("Case_look")
			interior_interact_area_1.show()
			if Dialogic.VAR.get_variable("Asked Questions.has_hair") == true:
				interior_interact_area_2.hide()
			else:
				interior_interact_area_2.show()
			interior_interact_area_3.show()
			await get_tree().process_frame
			await get_tree().process_frame
			await get_tree().process_frame
			alert.hide()
			return
		if case_asked == false:
			GlobalVars.in_dialogue = true
			GlobalVars.in_interaction = interact_type
			player.stop_player()
			emit_signal("enable_look")
			Dialogic.start(dialogue_file)
			Dialogic.signal_event.connect(caseUI)
			Dialogic.timeline_ended.connect(_on_timeline_ended)
			await get_tree().process_frame
			await get_tree().process_frame
			await get_tree().process_frame
			alert.hide()
			return
		else:
			GlobalVars.in_interaction = interact_type
			GlobalVars.in_dialogue = true
			alert.set_deferred("visible", false)
			player.stop_player()
			emit_signal("enable_look")
			Dialogic.start(dialogue_file, "choices")
			Dialogic.signal_event.connect(caseUI)
			Dialogic.timeline_ended.connect(_on_timeline_ended)
			await get_tree().process_frame
			await get_tree().process_frame
			await get_tree().process_frame
			alert.hide()
			return

func _on_timeline_ended():
	emit_signal("disable_look")
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	GlobalVars.in_dialogue = false
	if GlobalVars.Micah_in_case == false:
		player.start_player()
		alert.show()
#
func caseUI(argument: String):
	if argument == "look_case":
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		player.hide()
		GlobalVars.Micah_in_case = true
		player.stop_player()
		GlobalVars.viewing = "case_ui"
		interact_area.show()
		case_cam.priority = 30
		main_cam.priority = 0 
		cam_anim.play("Cam_Idle")
		Dialogic.signal_event.disconnect(caseUI)
	else:
		GlobalVars.in_interaction = ""
		Dialogic.signal_event.disconnect(caseUI)
		


func _on_exit_pressed():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	GlobalVars.Micah_in_case = false
	GlobalVars.in_look_screen = false
	UI.hide()
	interact_area.show()
	show_closed_case()
	GlobalVars.viewing = ""

func _input(event):
	var finished_letter = Dialogic.VAR.get_variable("Asked Questions.Micah_asked_letter")
	var finished_key = Dialogic.VAR.get_variable("Asked Questions.Micah_Asked_Key")
	if GlobalVars.in_dialogue == false:
		if Input.is_action_just_pressed("Exit") and GlobalVars.in_interaction == interact_type and GlobalVars.viewing == "" and GlobalVars.micah_time_out == false and GlobalVars.micah_kicked_out == false:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			case_cam.priority = 0
			main_cam.priority = 30
			emit_signal("general_quit")
			cam_anim.play("RESET")
			player.show()
			if GlobalVars.opened_micah_case == true:
				interior_interact_area_1.hide()
				interior_interact_area_2.hide()
				interior_interact_area_3.hide()
				if finished_letter == true or finished_key == true:
					if finished_key == true:
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
				elif GlobalVars.viewed_Micah_letter == true or GlobalVars.viewed_Micah_key == true:
					if GlobalVars.viewed_Micah_letter == true and GlobalVars.viewed_Micah_key == true:
						GlobalVars.in_interaction = ""
						GlobalVars.in_dialogue = true
						alert.hide()
						player.stop_player()
						var game_dialogue = Dialogic.start(in_case_dialogue_choices)
						Dialogic.timeline_ended.connect(_on_timeline_ended)
						game_dialogue.register_character(load(load_Dalton_dialogue), dalton_marker)
						game_dialogue.register_character(load(load_Theo_dialogue), theo_marker)
						game_dialogue.register_character(load(load_char_dialogue), character_marker)
					elif GlobalVars.viewed_Micah_letter == true and GlobalVars.viewed_Micah_key == false:
						GlobalVars.in_interaction = ""
						GlobalVars.in_dialogue = true
						alert.hide()
						player.stop_player()
						var game_dialogue = Dialogic.start(in_case_dialogue_1)
						Dialogic.timeline_ended.connect(_on_timeline_ended)
						game_dialogue.register_character(load(load_Dalton_dialogue), dalton_marker)
						game_dialogue.register_character(load(load_Theo_dialogue), theo_marker)
						game_dialogue.register_character(load(load_char_dialogue), character_marker)
					elif GlobalVars.viewed_Micah_letter == false and GlobalVars.viewed_Micah_key == true:
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
			else:
				GlobalVars.in_interaction = ""
				player.start_player()
				alert.show()
				interact_area.hide()
				show_closed_case()
		elif Input.is_action_just_pressed("Exit") and GlobalVars.in_interaction == interact_type and GlobalVars.viewing == "case_ui": 
			UI.hide()
			GlobalVars.in_look_screen = false
			GlobalVars.Micah_in_case = false
			await get_tree().create_timer(.03).timeout
			GlobalVars.viewing = ""
			interact_area.show()
			show_closed_case()
			await get_tree().create_timer(.1).timeout
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_input_event(viewport, event, shape_idx):
	if GlobalVars.in_look_screen == false:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed == true:
				case_pickup.play()
				if GlobalVars.in_interaction == "":
					GlobalVars.in_interaction = interact_type
				GlobalVars.viewing = "case_ui"
				UI.show()
				hide_closed_case()
				GlobalVars.in_look_screen = true
				GlobalVars.Micah_in_case = true
				GlobalVars.clicked_case_Micah = GlobalVars.clicked_case_Micah + 1
				interact_area.hide()
