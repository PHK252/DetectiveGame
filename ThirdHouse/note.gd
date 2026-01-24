extends MeshInstance3D

@export var letter_input : Area2D

func _ready():
	if Dialogic.VAR.get_variable("Quincy.has_letter") == false:
		show()
		Dialogic.signal_event.connect(_hide_letter)
	else:
		letter_input.input_pickable = false
		hide()

func _hide_letter(arg : String):
	if arg == "has note":
		Dialogic.signal_event.disconnect(_hide_letter)
		letter_input.input_pickable = false
		hide()
	else:
		Dialogic.signal_event.disconnect(_hide_letter)
