extends Node3D

func _ready():
	GlobalVars.current_level = "Quincy"
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#var uid = ResourceUID.text_to_id("uid://b5qu46pybr7wc")
	#print(ResourceUID.get_id_path(uid))
	#print(ResourceUID.has_id(uid))

func _process(delta):
	if Input.is_action_just_pressed("Quit"):
			get_tree().quit()
