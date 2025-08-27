extends Node3D

@export var day_1_notes: Node3D
@export var day_2_notes: Node3D

func _ready():
	GlobalVars.current_level = "Transition"
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if GlobalVars.day == "Day 1":
		day_1_notes.show()
		day_2_notes.hide()
	else:
		day_2_notes.show()
		day_1_notes.hide()

func _process(delta):
	if Input.is_action_just_pressed("Quit"):
			get_tree().quit()
