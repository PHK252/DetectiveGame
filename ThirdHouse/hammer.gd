extends MeshInstance3D

@export var hammer_input : Area2D
@export var letter_input : Area2D

@export var hammer : MeshInstance3D
#@export var choco : MeshInstance3D
@export var letter : MeshInstance3D

func _ready():
	if Dialogic.VAR.get_variable("Quincy.has_letter") == false or Dialogic.VAR.get_variable("Quincy.has_hammer") == false:
		#print("connect")
		Dialogic.signal_event.connect(_hide_takables)
	if Dialogic.VAR.get_variable("Quincy.has_hammer") == false:
		show()
	else:
		hammer_input.input_pickable = false
		hide()

func _hide_takables(arg : String):
	print("enter signal", arg)
	if arg == "has hammer":
		hammer_input.input_pickable = false
		print("take hammer")
		hammer.hide()
		return
	if arg == "has note":
		print("take note")
		letter_input.input_pickable = false
		letter.hide()
		return
	if Dialogic.VAR.get_variable("Quincy.has_letter") == false or Dialogic.VAR.get_variable("Quincy.has_hammer") == false:
		Dialogic.signal_event.disconnect(_hide_takables)
		
