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
@onready var asked_entered = false

signal finish_greeting
signal tea_time
signal reactivate_door
signal enable_interaction

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

func _on_greeting_ended():
	#emit_signal("Dstopped")
	#emit_signal("Tstart")
	player.start_player()
	Dialogic.timeline_ended.disconnect(_on_greeting_ended)
	GlobalVars.in_dialogue = false
	emit_signal("finish_greeting")
	#asked = true
func _on_timeline_ended():
	#emit_signal("Dstopped")
	#emit_signal("Tstart")
	player.start_player()
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	GlobalVars.in_dialogue = false

func _on_tea_ended():
	#emit_signal("Dstopped")
	#emit_signal("Tstart")
	player.start_player()
	Dialogic.timeline_ended.disconnect(_on_tea_ended)
	GlobalVars.in_dialogue = false
	if GlobalVars.in_tea_time == false:
		emit_signal("enable_interaction")

func _process(delta):
	asked = Dialogic.VAR.get_variable("Juniper.asked_all")
	if asked == true:
		#print("hide")
		$Interactable.set_monitorable(false)

func _on_door_second_j_dialogue() -> void:
	if GlobalVars.in_dialogue == false and asked == false:
		#emit_signal("Tstop")
		print("tryingtogrree")
		GlobalVars.in_dialogue = true
		player.stop_player()
		alert.hide()
		var greeting = Dialogic.start("Juniper_Greeting", "continue")
		Dialogic.timeline_ended.connect(_on_greeting_ended)
		greeting.register_character(load("res://Dialogic Characters/Dalton.dch"), dalton_marker)
		greeting.register_character(load("res://Dialogic Characters/Theo.dch"), theo_marker)
		greeting.register_character(load("res://Dialogic Characters/Juniper.dch"), juniper_marker)


func _on_entered_juniper_house():
	if GlobalVars.in_dialogue == false and asked_entered == false:
		GlobalVars.in_dialogue = true
		asked_entered = true
		player.stop_player()
		emit_signal("reactivate_door")
		var in_house = Dialogic.start("Juniper_Enter_House")
		Dialogic.signal_event.connect(_activate_tea)
		Dialogic.timeline_ended.connect(_on_tea_ended)
		in_house.register_character(load("res://Dialogic Characters/Dalton.dch"), dalton_marker)
		in_house.register_character(load("res://Dialogic Characters/Theo.dch"), theo_marker)
		in_house.register_character(load("res://Dialogic Characters/Juniper.dch"), juniper_marker)

func _activate_tea(argument : String):
	if argument == "tea_time":
		Dialogic.signal_event.disconnect(_activate_tea)
		GlobalVars.in_tea_time = true
		emit_signal("tea_time")
	else:
		Dialogic.signal_event.disconnect(_activate_tea)
