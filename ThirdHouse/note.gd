extends MeshInstance3D

@export var letter_input : Area2D

func _ready():
	if Dialogic.VAR.get_variable("Quincy.has_letter") == false:
		show()
	else:
		letter_input.input_pickable = false
		hide()

#func _hide_letter(arg : String):
	#print(arg, "letter")
	#if arg == "has note":
		#Dialogic.signal_event.disconnect(_hide_letter)
		#print("take note")
		#letter_input.input_pickable = false
		#hide()
	#else:
		#print("leave note")
		#Dialogic.signal_event.disconnect(_hide_letter)
