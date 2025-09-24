extends Node3D

signal _show_tut(tut_type : String)

@onready var pause = $Pause

func _ready():
	GlobalVars.current_level = "Beginning"
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if GlobalVars.movement_tut == false:
		emit_signal("_show_tut", "movement")

func _process(delta):
	if Input.is_action_just_pressed("Quit"):
		if pause.visible == false:
			pause.visible = true
