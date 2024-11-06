extends Area2D

@onready var object = $"."
@onready var look = $"../Missing Look"

func _on_input_event(viewport, event, shape_idx):
	if GlobalVars.in_look_screen == false:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed == true:
				object.hide()
				look.show()
				GlobalVars.in_look_screen = true
				GlobalVars.viewing = "missing"
				print("missing")


func _on_exit_pressed():
	GlobalVars.viewing = ""
