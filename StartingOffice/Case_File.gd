extends MeshInstance3D

@onready var object = $"."
@onready var look = $"../../../../UI/Case Look"
@onready var player = $"../../../../Dalton/CharacterBody3D"

func _on_interactable_interacted(interactor):
	object.hide()
	look.show()
	GlobalVars.in_look_screen = true
	print("case file")



func _on_exit_pressed():
	await get_tree().create_timer(.5).timeout
	Dialogic.timeline_ended.connect(_on_timeline_ended)
	player.stop_player()
	var layout = Dialogic.start("Day 1 Office timeline")
	layout.register_character(load("res://Dialogic Characters/Dalton.dch"), $"../../../../Dalton/CharacterBody3D/Marker2D")

func _on_timeline_ended():
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	player.start_player()
	GlobalVars.in_dialogue = false
	print("dialogic timeline ended")
