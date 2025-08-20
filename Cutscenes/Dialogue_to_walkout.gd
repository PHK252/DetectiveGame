extends Node3D

#Assign player body
@export var player: CharacterBody3D
@export var alert: Sprite3D

#Dialogue Stuff
@export var dalton_marker: Marker2D
@export var isaac_marker: Marker2D
@export var dialogue_file: String
@export var interact_type: String
@export var load_Dalton_dialogue: String
@export var load_Isaac_dialogue: String

signal to_walk_out

func _on_interactable_interacted(interactor):
	if GlobalVars.in_interaction == "" and GlobalVars.in_dialogue == false:
		var game_dialogue = Dialogic.start(dialogue_file)
		Dialogic.timeline_ended.connect(_on_timeline_ended)
		Dialogic.signal_event.connect(_walk_out)
		game_dialogue.register_character(load(load_Dalton_dialogue), dalton_marker)
		game_dialogue.register_character(load(load_Isaac_dialogue), isaac_marker)
		alert.hide()
		GlobalVars.in_interaction = interact_type
		player.stop_player()

func _walk_out(arg : String):
	if arg == "walk_out":
		Dialogic.signal_event.disconnect(_walk_out)
		emit_signal("to_walk_out")
	else:
		Dialogic.signal_event.disconnect(_walk_out)

func _on_timeline_ended():
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	GlobalVars.in_dialogue = false
	player.start_player()
	#alert.show()
	GlobalVars.in_interaction = ""
