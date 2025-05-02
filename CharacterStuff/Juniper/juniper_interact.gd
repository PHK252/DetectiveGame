extends Node3D

@export var player : CharacterBody3D
@export var alert : Sprite3D
@export var dalton_marker : Marker2D
@export var theo_marker : Marker2D
@export var juniper_marker : Marker2D
#signal Dquestion
#signal Dstopped
#signal Tstop
#signal Tstart

@onready var asked = false

signal finish_greeting

func _on_interactable_interacted(interactor):
	#print(asked)
	#emit_signal("Dquestion")
	if GlobalVars.in_dialogue == false and asked == false:
		#emit_signal("Tstop")
		GlobalVars.in_dialogue = true
		player.stop_player()
		var ask_victims = Dialogic.start("Juniper_questions")
		Dialogic.timeline_ended.connect(_on_timeline_ended)
		ask_victims.register_character(load("res://Dialogic Characters/Dalton.dch"), dalton_marker)
		ask_victims.register_character(load("res://Dialogic Characters/Theo.dch"), theo_marker)
		ask_victims.register_character(load("res://Dialogic Characters/Juniper.dch"), juniper_marker)

func _on_timeline_ended():
	#emit_signal("Dstopped")
	#emit_signal("Tstart")
	player.start_player()
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	GlobalVars.in_dialogue = false
	emit_signal("finish_greeting")
	#asked = true

func _process(delta):
	asked = Dialogic.VAR.get_variable("Juniper.asked_all")
	if asked == true:
		#print("hide")
		$Interactable.set_monitorable(false)

#func _on_character_body_3d_d_inside() -> void:
	#if asked == false:
		#print("asking")
		#emit_signal("Tstop")
		#GlobalVars.in_dialogue = true
		#player.stop_player()
		#var ask_victims = Dialogic.start("Micah_Ask_Victims")
		#Dialogic.timeline_ended.connect(_on_timeline_ended)
		#ask_victims.register_character(load("res://Dialogic Characters/Dalton.dch"), dalton_marker)
		#ask_victims.register_character(load("res://Dialogic Characters/Micah.dch"), theo_marker)
		#ask_victims.register_character(load("res://Dialogic Characters/Micah.dch"), juniper_marker)

func _on_door_second_j_dialogue() -> void:
	print("recieved")
	if GlobalVars.in_dialogue == false and asked == false:
		#emit_signal("Tstop")
		print("tryingtogrree")
		GlobalVars.in_dialogue = true
		player.stop_player()
		var ask_victims = Dialogic.start("Juniper_questions")
		Dialogic.timeline_ended.connect(_on_timeline_ended)
		ask_victims.register_character(load("res://Dialogic Characters/Dalton.dch"), dalton_marker)
		ask_victims.register_character(load("res://Dialogic Characters/Theo.dch"), theo_marker)
		ask_victims.register_character(load("res://Dialogic Characters/Juniper.dch"), juniper_marker)
