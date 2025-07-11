extends Area3D

@export var player: CharacterBody3D

#Assign character markers (up to 3)
@export var dalton_marker: Marker2D
@export var character_marker: Marker2D

signal play_anim

func _on_quincy_play_caught():
	Dialogic.VAR.set_variable("Quincy.caught", true)
	GlobalVars.in_dialogue = true
	player.stop_player()
	var caught_dialogue = Dialogic.start("Quincy_caught")
	Dialogic.timeline_ended.connect(_on_timeline_ended)
	caught_dialogue.register_character("res://Dialogic Characters/Dalton.dch", dalton_marker)
	caught_dialogue.register_character("res://Dialogic Characters/Quincy.dch", character_marker)
	pass

func _on_timeline_ended():
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	GlobalVars.in_dialogue = false
	emit_signal("play_anim")
	#reset all vars expect caught
