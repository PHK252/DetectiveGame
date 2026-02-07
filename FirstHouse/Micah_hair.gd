extends MeshInstance3D

@export var hair_interact : Area2D
@export var key_interact : Area2D

func _ready():
	if Dialogic.VAR.get_variable("Asked Questions.has_key") == false or Dialogic.VAR.get_variable("Asked Questions.has_hair") == false:
		Dialogic.signal_event.connect(_take_hair)

#func _hide_pie(arg : String):
	##print("arg ",  arg)
	#if arg == "got pie":
		#pie_input.input_pickable = false
		#light.hide()
		#hide()
	#elif arg == "has_letter":
		#letter_input.input_pickable = false
		#letter.hide()
	#if Dialogic.VAR.get_variable("Juniper.has_pie") == true and Dialogic.VAR.get_variable("Juniper.has_letter") == true:
		#Dialogic.signal_event.disconnect(_hide_pie)

#func _on_input_event(viewport, event, shape_idx):
	#if GlobalVars.in_look_screen == false:
		#if event is InputEventMouseButton:
			#if event.button_index == MOUSE_BUTTON_LEFT and event.pressed == true:
				#Dialogic.signal_event.connect(_take_hair)
				#
func _take_hair(argument : String):
	if argument == "take hair":
		hair_interact.hide()
	elif argument == "take_key":
		key_interact.hide()
	if Dialogic.VAR.get_variable("Asked Questions.has_key") == true and Dialogic.VAR.get_variable("Asked Questions.has_hair") == true:
		Dialogic.signal_event.disconnect(_take_hair)
