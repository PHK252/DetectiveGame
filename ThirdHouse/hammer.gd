extends MeshInstance3D

@export var hammer_input : Area2D

func _ready():
	if Dialogic.VAR.get_variable("Quincy.has_hammer") == false:
		show()
		Dialogic.signal_event.connect(_hide_hammer)
	else:
		hammer_input.input_pickable = false
		hide()

func _hide_hammer(arg : String):
	if arg == "has note":
		Dialogic.signal_event.disconnect(_hide_hammer)
		hammer_input.input_pickable = false
		hide()
	else:
		Dialogic.signal_event.disconnect(_hide_hammer)
