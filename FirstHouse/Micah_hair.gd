extends MeshInstance3D

@export var hair_interact : Area2D

func _on_input_event(viewport, event, shape_idx):
	if GlobalVars.in_look_screen == false:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed == true:
				Dialogic.signal_event.connect(_take_hair)
				
func _take_hair(argument : String):
	if argument == "take hair":
		Dialogic.signal_event.disconnect(_take_hair)
		hide()
	else:
		Dialogic.signal_event.disconnect(_take_hair)
