extends Area3D

@export var player: CharacterBody3D

#Assign character markers (up to 3)
@export var dalton_marker: Marker2D
@export var character_marker: Marker2D
@export var phone : CanvasLayer
@export var time_out_timer: Timer 
@export var music : AudioStreamPlayer
var caught_anim := false
signal play_anim

func _on_quincy_play_caught():
	if caught_anim == false:
		caught_anim = true
		if phone.visible == true:
			phone.hide()
		music.stop()
		#mute all buses
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		time_out_timer.stop()
		Dialogic.VAR.set_variable("Quincy.caught", true)
		GlobalVars.Quincy_Dalton_caught = true
		GlobalVars.in_dialogue = true
		player.stop_player()
		Dialogic.start("Quincy_caught")
		Dialogic.timeline_ended.connect(_on_timeline_ended)
		pass

func _on_timeline_ended():
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	GlobalVars.in_dialogue = false
	emit_signal("play_anim")
	#reset all vars expect caught
