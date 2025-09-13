extends Node3D

signal _show_tut(tut_type : String)

func _ready():
	GlobalVars.current_level = "Beginning"
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if GlobalVars.movement_tut == false:
		emit_signal("_show_tut", "movement")
		GlobalVars.movement_tut = true

func _process(delta):
	if Input.is_action_just_pressed("Quit"):
			get_tree().quit()
