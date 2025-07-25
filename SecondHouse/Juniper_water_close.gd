extends Area3D

@export var dalton_marker: Marker2D
@export var theo_marker: Marker2D

@export var player: CharacterBody3D

@export var timer : Timer

func _on_body_entered(body):
	if GlobalVars.in_look_screen == false and GlobalVars.in_dialogue == false and Dialogic.VAR.get_variable("Juniper.waterfall_talk") == false:
			timer.start()
			await timer.timeout
			
			

func _on_timeline_ended():
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	GlobalVars.in_interaction = ""
	GlobalVars.in_dialogue = false
	player.start_player()


func _on_body_exited(body):
	if timer.time_left > 0:
		timer.stop()
	elif Dialogic.VAR.get_variable("Juniper.waterfall_talk") == false:
		GlobalVars.in_dialogue = true
		player.stop_player()
		var waterfall = Dialogic.start("Juniper_waterfall")
		Dialogic.timeline_ended.connect(_on_timeline_ended)
		waterfall.register_character(load("res://Dialogic Characters/Dalton.dch"), dalton_marker)
		waterfall.register_character(load("res://Dialogic Characters/Theo.dch"), theo_marker)
