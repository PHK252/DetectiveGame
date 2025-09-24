extends Node3D

@onready var pause = $Pause


func _ready():
	GlobalVars.current_level = "Flashback_day_2"
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if Input.is_action_just_pressed("Quit"):
		if pause.visible == false:
			pause.visible = true
