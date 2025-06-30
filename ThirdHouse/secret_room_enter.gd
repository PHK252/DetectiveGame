extends Area3D

@export var player : CharacterBody3D
@export var dalton_marker : Marker2D
@onready var entered_room = false

func _on_body_entered(body):
	if body.is_in_group("player"):
		if entered_room == false:
			entered_room = true
			player.stop_player()
			GlobalVars.in_dialogue = true
			var secret_enter = Dialogic.start("Quincy_Secret_room")
			Dialogic.timeline_ended.connect(_on_timeline_ended)
			secret_enter.register_character(load("res://Dialogic Characters/Dalton.dch"), dalton_marker)

func _on_timeline_ended():
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	GlobalVars.in_dialogue = false
	player.start_player()
