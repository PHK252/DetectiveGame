extends Node3D


@export var player : CharacterBody3D
@export var alert : Sprite3D
@export var dalton_marker : Marker2D
@export var theo_marker : Marker2D
@export var quincy_marker : Marker2D
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
		alert.hide()
		var ask_victims = Dialogic.start("Quincy_asked_questions")
		Dialogic.timeline_ended.connect(_on_timeline_ended)
		ask_victims.register_character(load("res://Dialogic Characters/Dalton.dch"), dalton_marker)
		ask_victims.register_character(load("res://Dialogic Characters/Theo.dch"), theo_marker)
		ask_victims.register_character(load("res://Dialogic Characters/Quincy.dch"), quincy_marker)

func _on_timeline_ended():
	#emit_signal("Dstopped")
	#emit_signal("Tstart")
	player.start_player()
	alert.show()
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	GlobalVars.in_dialogue = false
	#asked = true

func _on_greeting_ended():
	#emit_signal("Dstopped")
	#emit_signal("Tstart")
	player.start_player()
	alert.show()
	Dialogic.timeline_ended.disconnect(_on_greeting_ended)
	GlobalVars.in_dialogue = false
	emit_signal("finish_greeting")

func _process(delta):
	asked = Dialogic.VAR.get_variable("Quincy.asked_all")
	if Dialogic.VAR.get_variable("Quincy.solved_case") == false:
		if asked == true and GlobalVars.quincy_kicked_out == false and GlobalVars.quincy_time_out == false:
			#print("hide")
			alert.hide()
			$Interactable.set_monitorable(false)
	else:
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

func _on_greeting_third_q_dialogue() -> void: # Quincy is greeted outside, Player can't enter until Quincv is greeted
	print("recieved")
	if GlobalVars.in_dialogue == false and asked == false:
		#emit_signal("Tstop")
		alert.hide()
		print("tryingtogrree")
		GlobalVars.in_dialogue = true
		player.stop_player()
		var greeting = Dialogic.start("Quincy_greeting")
		Dialogic.timeline_ended.connect(_on_greeting_ended)
		greeting.register_character(load("res://Dialogic Characters/Dalton.dch"), dalton_marker)
		greeting.register_character(load("res://Dialogic Characters/Theo.dch"), theo_marker)
		greeting.register_character(load("res://Dialogic Characters/Quincy.dch"), quincy_marker)
