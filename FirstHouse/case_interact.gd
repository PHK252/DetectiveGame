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

@export var interior_interact_area_1 : Area2D
@export var interior_interact_area_2 : Area2D

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
	case_top_2.hide()
	case_bottom_2.hide()
	case_hair.hide()
	case_note.hide()
	case_key.hide()
	pass # Replace with function body.


func _on_interactable_interacted(interactor):
	var case_asked = Dialogic.VAR.get_variable("Asked Questions.Micah_Asked_Case")
	print(case_asked)
	if GlobalVars.in_dialogue == false:
		if case_asked == false:
			case_top_2.hide()
			case_bottom_2.hide()
			case_hair.hide()
			case_note.hide()
			case_key.hide()
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
			cam_anim.play("Case_look")
			interior_interact_area_1.show()
			interior_interact_area_2.show()
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
	var finished_letter = Dialogic.VAR.get_variable("Asked Questions.finished_letter")
	var finished_tag = Dialogic.VAR.get_variable("Asked Questions.finished_key")
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
				GlobalVars.clicked_case_Micah = GlobalVars.clicked_case_Micah + 1
				interact_area.hide()

#extends Node3D
#
#@onready var case_cam = $"../../../SubViewport/CameraSystem/Case"
#@onready var main_cam = $"../../../SubViewport/CameraSystem/livingroom"
#@onready var player = $"../../../../Characters/Dalton/CharacterBody3D"
##@onready var note_interaction = $Note
#@onready var cam_anim = $"../../../SubViewport/CameraSystem/Case/AnimationPlayer"
#@onready var case = $".."
#@onready var casetop = $"../../casebone"
#@onready var UI = $"../../../../UI/Case UI"
#@onready var dalton_maker = $"../../../../UI/Dalton_marker"
#@onready var micah_marker = $"../../../../UI/Micah_marker"
#
#
## Called when the node enters the scene tree for the first time.
#func _ready():
	#UI.hide()
	#pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass
#
#
#func _on_interactable_interacted(interactor):
	#var case_asked = Dialogic.VAR.get_variable("Asked Questions.Micah_Asked_Case")
	#print(case_asked)
	#if GlobalVars.in_dialogue == false:
		#if case_asked == false:
			#GlobalVars.in_dialogue = true
			#player.stop_player()
			#var closet_dialogue = Dialogic.start("Micah_case_ask")
			#Dialogic.signal_event.connect(caseUI)
			#Dialogic.timeline_ended.connect(_on_timeline_ended)
			#closet_dialogue.register_character(load("res://Dialogic Characters/Dalton.dch"), dalton_maker)
			#closet_dialogue.register_character(load("res://Dialogic Characters/Micah.dch"), micah_marker)
		#else:
			#GlobalVars.in_dialogue = true
			#player.stop_player()
			#var closet_dialogue = Dialogic.start("Micah_case_ask", "choices")
			#Dialogic.signal_event.connect(caseUI)
			#Dialogic.timeline_ended.connect(_on_timeline_ended)
			#closet_dialogue.register_character(load("res://Dialogic Characters/Dalton.dch"), dalton_maker)
			#closet_dialogue.register_character(load("res://Dialogic Characters/Micah.dch"), micah_marker)
#
#
#func _on_timeline_ended():
	#Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	#GlobalVars.in_dialogue = false
	#if GlobalVars.Micah_in_case == false:
		#player.start_player()
##
#func caseUI(argument: String):
	#if argument == "look_case":
		#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		#player.hide()
		#case.hide()
		#casetop.hide()
		#GlobalVars.Micah_in_case = true
		#player.stop_player()
		#GlobalVars.in_interaction = "case"
		#UI.show()
		#case_cam.priority = 30
		#main_cam.priority = 0 
		#cam_anim.play("Cam_Idle")
		#
#
#
#func _on_exit_pressed():
	#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	#GlobalVars.Micah_in_case = false
	#player.start_player()
	#player.show()
	#GlobalVars.in_interaction = ""
	#case_cam.priority = 0
	#main_cam.priority = 30
	#cam_anim.play("RESET")
#
#func _input(event):
	#if Input.is_action_just_pressed("Exit") and GlobalVars.in_interaction == "case": 
		##print("funk")
		#UI.hide()
		#GlobalVars.Micah_in_case = false
		#player.start_player()
		#player.show()
		#GlobalVars.in_interaction = ""
		#case_cam.priority = 0
		#main_cam.priority = 30
		#cam_anim.play("RESET")
