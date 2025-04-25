extends MeshInstance3D

@onready var player = $"../../SubViewportContainer/SubViewport/Characters/Dalton/CharacterBody3D"
@onready var dalton_marker = $"../../../../UI/Dalton's Marker"

func _on_interactable_interacted(interactor):
	if GlobalVars.in_dialogue == false:
		GlobalVars.in_dialogue = true
		player.stop_player()
		Dialogic.timeline_ended.connect(_on_timeline_ended)
		var layout = Dialogic.start("Office_Donuts")
		layout.register_character(load("res://Dialogic Characters/Dalton.dch"), dalton_marker)

func _on_timeline_ended():
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	player.start_player()
	GlobalVars.in_dialogue = false
	#print("dialogic timeline ended")
