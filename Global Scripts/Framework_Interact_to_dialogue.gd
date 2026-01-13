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

signal _show_tut(tut_type : String)
signal gen_interact
signal dalton_disactivateLook

func _on_interactable_interacted(interactor):
	if GlobalVars.in_interaction == "" and GlobalVars.in_dialogue == false:
		emit_signal("gen_interact")
		GlobalVars.in_dialogue = true
		var game_dialogue = Dialogic.start(dialogue_file)
		Dialogic.timeline_ended.connect(_on_timeline_ended)
		game_dialogue.register_character(load(load_Dalton_dialogue), dalton_marker)
		game_dialogue.register_character(load(load_Isaac_dialogue), isaac_marker)
		alert.hide()
		GlobalVars.in_interaction = interact_type
		if GlobalVars.dialogue_tut == false:
			emit_signal("_show_tut", "dialogue")
			GlobalVars.dialogue_tut = true
			if GlobalVars.interact_tut == false:
				GlobalVars.interact_tut = true
		player.stop_player()



func _on_timeline_ended():
	emit_signal("dalton_disactivateLook")
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	GlobalVars.in_dialogue = false
	player.start_player()
	alert.show()
	GlobalVars.in_interaction = ""



func _on_interactable_body_entered(body):
	if body.is_in_group("player"):
		if GlobalVars.interact_tut == false: 
			emit_signal("_show_tut", "interact")
