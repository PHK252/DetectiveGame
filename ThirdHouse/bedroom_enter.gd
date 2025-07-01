extends Area3D

@export var player : CharacterBody3D
@export var dalton_marker : Marker2D
@export var quincy_marker : Marker2D
@onready var entered_room = false

func _on_body_entered(body):
	if body.is_in_group("player"):
		if entered_room == false:
			entered_room = true
			await get_tree().create_timer(1.2)
			player.stop_player()
			GlobalVars.in_dialogue = true
			var bed_enter = Dialogic.start("Quincy_bedroom_enter")
			Dialogic.timeline_ended.connect(_on_timeline_ended)
			bed_enter.register_character(load("res://Dialogic Characters/Dalton.dch"), dalton_marker)
			bed_enter.register_character(load("res://Dialogic Characters/Quincy.dch"), quincy_marker)

func _on_timeline_ended():
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	GlobalVars.in_dialogue = false
	player.start_player()
