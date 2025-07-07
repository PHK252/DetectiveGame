extends Node3D

@onready var debug_label = $"../../../../../../UI/debug label"
@export var player : CharacterBody3D
@export var player_interactor : Interactor
@export var dalton_marker : Marker2D
@export var micah_marker : Marker2D
@export var theo_marker : Marker2D
@export var alert : Sprite3D
@export var stand_interaction : Interactable
@export var sit_interaction : Interactable
signal Dquestion
signal Dstopped
signal Tstop
signal Tstart
@onready var sit_micah = false
@export var sit_body : Node3D

@onready var asked = false
@onready var asked_dad = false
@onready var asked_skylar = false
@onready var time_out = false

func _on_interactable_interacted(interactor):
	emit_signal("Dquestion")
	if GlobalVars.in_dialogue == false and GlobalVars.micah_time_out == false and GlobalVars.micah_kicked_out == false:
		emit_signal("Tstop")
		GlobalVars.in_dialogue = true
		player.stop_player()
		alert.hide()
		var ask_victims = Dialogic.start("Micah_Ask_Victims")
		Dialogic.timeline_ended.connect(_on_timeline_ended)
		ask_victims.register_character(load("res://Dialogic Characters/Dalton.dch"), dalton_marker)
		ask_victims.register_character(load("res://Dialogic Characters/Micah.dch"), micah_marker)
		ask_victims.register_character(load("res://Dialogic Characters/Theo.dch"), theo_marker)

func _on_timeline_ended():
	emit_signal("Dstopped")
	emit_signal("Tstart")
	player.start_player()
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	GlobalVars.in_dialogue = false
	asked = true

func _process(delta):
	debug_label.text = str(sit_micah)
	asked = Dialogic.VAR.get_variable("Asked Questions.Micah_asked_all")
	asked_dad =  Dialogic.VAR.get_variable("Asked Questions.Micah_Asked_Clyde")
	asked_skylar = Dialogic.VAR.get_variable("Asked Questions.Micah_Asked_Skylar")
	if Dialogic.VAR.get_variable("Asked Questions.Micah_Solved_Case") == false:
		if asked == true:
			if Dialogic.VAR.get_variable("Juniper.found_skylar") == true and asked_skylar == false and time_out == false:
				if sit_body.visible == true:
					sit_interaction.set_monitorable(true)
				else:
					stand_interaction.set_monitorable(true)
			elif Dialogic.VAR.get_variable("Asked Questions.Micah_viewed_ID") == true and asked_dad == false and time_out == false:
				if sit_body.visible == true:
					sit_interaction.set_monitorable(true)
				else:
					stand_interaction.set_monitorable(true)
			else:
				if sit_body.visible == true:
					sit_interaction.set_monitorable(false)
				else:
					stand_interaction.set_monitorable(false)
	else:
		stand_interaction.set_monitorable(false)
		sit_interaction.set_monitorable(false)
		
		

#func _on_character_body_3d_d_inside() -> void:
	#if asked == false:
		#print("asking")
		#emit_signal("Tstop")
		#GlobalVars.in_dialogue = true
		#player.stop_player()
		#var ask_victims = Dialogic.start("Micah_Ask_Victims")
		#Dialogic.timeline_ended.connect(_on_timeline_ended)
		#ask_victims.register_character(load("res://Dialogic Characters/Dalton.dch"), dalton_marker)
		#ask_victims.register_character(load("res://Dialogic Characters/Micah.dch"), micah_marker)


func _on_timer_timeout():
	time_out = true

func _on_micah_sit():
	if sit_body.visible == true:
		sit_micah = true
		stand_interaction.set_monitorable(false)
		sit_interaction.set_monitorable(true)
		player_interactor.set_monitoring(false)
		await get_tree().create_timer(.03)
		player_interactor.set_monitoring(true)
	else:
		sit_micah = false
		stand_interaction.set_monitorable(true)
		sit_interaction.set_monitorable(false)
		player_interactor.set_monitoring(false)
		await get_tree().create_timer(.03)
		player_interactor.set_monitoring(true)
