extends MeshInstance3D

@onready var player = $"../../../../Dalton/CharacterBody3D"

func _on_interactable_interacted(interactor):
	if GlobalVars.in_dialogue == false:
		GlobalVars.in_dialogue = true
		player.stop_player()
		Dialogic.timeline_ended.connect(_on_timeline_ended)
		var layout = Dialogic.start("Office_Donuts")
		layout.register_character(load("res://Dialogic Characters/Dalton.dch"), $"../../../../Dalton/CharacterBody3D/Marker2D")

func _on_timeline_ended():
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	player.start_player()
	GlobalVars.in_dialogue = false
	print("dialogic timeline ended")
