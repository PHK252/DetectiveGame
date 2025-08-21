extends Node3D

@export var player : CharacterBody3D
@export var alert : Sprite3D
@export var dalton_marker : Marker2D
@export var theo_marker : Marker2D
@export var skylar_marker : Marker2D


func _ready():
	GlobalVars.current_level = "secret"
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#await walk in
	if GlobalVars.in_interaction == "" and GlobalVars.in_dialogue == false:
		GlobalVars.in_dialogue = true
		var arrived_dialogue = Dialogic.start("Secret_arrived")
		Dialogic.timeline_ended.connect(_on_timeline_ended)
		arrived_dialogue.register_character(load("res://Dialogic Characters/Dalton.dch"), dalton_marker)
		arrived_dialogue.register_character(load("res://Dialogic Characters/Theo.dch"), theo_marker)
		player.stop_player()

func _process(delta):
	if Input.is_action_just_pressed("Quit"):
			get_tree().quit()

func _on_timeline_ended():
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	GlobalVars.in_dialogue = false
	player.start_player()
	GlobalVars.in_interaction = ""


func _on_enter_skylar(body):
	if GlobalVars.in_interaction == "" and GlobalVars.in_dialogue == false and Dialogic.VAR.get_variable("Secret Location.finish_case") == true:
		GlobalVars.in_dialogue = true
		var exit_dialogue = Dialogic.start("Secret_Skylar_meet")
		Dialogic.timeline_ended.connect(_exit_scene)
		Dialogic.signal_event.connect(_enter_skylar)
		exit_dialogue.register_character(load("res://Dialogic Characters/Dalton.dch"), dalton_marker)
		exit_dialogue.register_character(load("res://Dialogic Characters/Theo.dch"), theo_marker)
		exit_dialogue.register_character(load("res://Dialogic Characters/Skylar.dch"), skylar_marker)
		player.stop_player()
		pass

func _enter_skylar(arg : String):
	if arg == "skylar_enter":
		#ENTER SKYLAR CODE GOES HERE
		pass

func _exit_scene():
	Dialogic.timeline_ended.disconnect(_exit_scene)
	GlobalVars.in_dialogue = false
	#player.start_player()
	GlobalVars.in_interaction = ""
	#fade to load
