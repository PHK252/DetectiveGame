extends MeshInstance3D

@export var pie_input : Area2D

func _ready():
	if Dialogic.VAR.get_variable("Juniper.has_pie") == false:
		show()
		Dialogic.signal_event.connect(_hide_pie)
	else:
		pie_input.input_pickable = false
		hide()

func _hide_pie(arg : String):
	if arg == "got pie":
		Dialogic.signal_event.disconnect(_hide_pie)
		pie_input.input_pickable = false
		hide()
	else:
		Dialogic.signal_event.disconnect(_hide_pie)
