extends Node3D

@onready var case_cam = $"../../../SubViewport/CameraSystem/Case"
@onready var main_cam = $"../../../SubViewport/CameraSystem/livingroom"
@onready var player = $"../../../../Characters/Dalton/CharacterBody3D"
#@onready var note_interaction = $Note
@onready var cam_anim = $"../../../SubViewport/CameraSystem/Case/AnimationPlayer"
@onready var case = $".."
@onready var casetop = $"../../casebone"
@onready var UI = $"../../../../UI/Case UI"
@onready var dalton_maker = $"../../../../UI/Dalton_marker"
@onready var micah_marker = $"../../../../UI/Micah_marker"


# Called when the node enters the scene tree for the first time.
func _ready():
	UI.hide()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_interactable_interacted(interactor):
	var case_asked = Dialogic.VAR.get_variable("Asked Questions.Micah_Asked_Case")
	print(case_asked)
	if GlobalVars.in_dialogue == false:
		if case_asked == false:
			GlobalVars.in_dialogue = true
			player.stop_player()
			var closet_dialogue = Dialogic.start("Micah_case_ask")
			Dialogic.signal_event.connect(caseUI)
			Dialogic.timeline_ended.connect(_on_timeline_ended)
			closet_dialogue.register_character(load("res://Dialogic Characters/Dalton.dch"), dalton_maker)
			closet_dialogue.register_character(load("res://Dialogic Characters/Micah.dch"), micah_marker)
		else:
			GlobalVars.in_dialogue = true
			player.stop_player()
			var closet_dialogue = Dialogic.start("Micah_case_ask", "choices")
			Dialogic.signal_event.connect(caseUI)
			Dialogic.timeline_ended.connect(_on_timeline_ended)
			closet_dialogue.register_character(load("res://Dialogic Characters/Dalton.dch"), dalton_maker)
			closet_dialogue.register_character(load("res://Dialogic Characters/Micah.dch"), micah_marker)


func _on_timeline_ended():
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	GlobalVars.in_dialogue = false
	if GlobalVars.Micah_in_case == false:
		player.start_player()
#
func caseUI(argument: String):
	if argument == "look_case":
		player.hide()
		case.hide()
		casetop.hide()
		GlobalVars.Micah_in_case = true
		player.stop_player()
		GlobalVars.in_interaction = "case"
		UI.show()
		case_cam.priority = 15
		main_cam.priority = 0 
		cam_anim.play("Cam_Idle")
		


func _on_exit_pressed():
	GlobalVars.Micah_in_case = false
	player.start_player()
	player.show()
	GlobalVars.in_interaction = ""
	case_cam.priority = 0
	main_cam.priority = 12 
	cam_anim.play("RESET")

func _input(event):
	if Input.is_action_just_pressed("Exit") and GlobalVars.in_interaction == "case": 
		#print("funk")
		UI.hide()
		GlobalVars.Micah_in_case = false
		player.start_player()
		player.show()
		GlobalVars.in_interaction = ""
		case_cam.priority = 0
		main_cam.priority = 12 
		cam_anim.play("RESET")
