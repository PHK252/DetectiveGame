extends MeshInstance3D

@export var pie_input : Area2D
@export var light : SpotLight3D
@export var letter_input : Area2D
@export var letter : MeshInstance3D

func _ready():
	if Dialogic.VAR.get_variable("Juniper.has_pie") == false or Dialogic.VAR.get_variable("Juniper.has_letter") == false:
		Dialogic.signal_event.connect(_hide_pie)
	if Dialogic.VAR.get_variable("Juniper.has_pie") == false:
		show()
	else:
		pie_input.input_pickable = false
		light.hide()
		hide()

func _hide_pie(arg : String):
	#print("arg ",  arg)
	if arg == "got pie":
		pie_input.input_pickable = false
		light.hide()
		hide()
	elif arg == "has_letter":
		letter_input.input_pickable = false
		letter.hide()
	if Dialogic.VAR.get_variable("Juniper.has_pie") == true and Dialogic.VAR.get_variable("Juniper.has_letter") == true:
		Dialogic.signal_event.disconnect(_hide_pie)
