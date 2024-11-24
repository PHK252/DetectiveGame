extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalVars.current_level = "Juniper"


func _process(delta):
	if Input.is_action_just_pressed("Quit"):
			get_tree().quit()
