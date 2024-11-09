extends Area2D

@onready var object = $"."
@onready var look = $"../Partner Look"

func _on_input_event(viewport, event, shape_idx):
	if GlobalVars.in_look_screen == false:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed == true:
				object.hide()
				look.show()
				GlobalVars.in_look_screen = true
				GlobalVars.viewing = "news"
				


func _on_exit_pressed():
	GlobalVars.viewing = ""

func _process(delta):
	if Input.is_action_just_pressed("Exit") and GlobalVars.viewing == "news":
		GlobalVars.viewing = ""
