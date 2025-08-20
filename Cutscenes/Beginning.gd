extends Node3D

func _ready():
	GlobalVars.current_level = "Beginning"
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta):
	if Input.is_action_just_pressed("Quit"):
			get_tree().quit()
