extends Node3D

func _ready():
	GlobalVars.current_level = "Beginning"
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
