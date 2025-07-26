extends Panel

@onready var dropdown = $".."
@onready var Home_icon = $"../../Icon"


func _on_gui_input(event):
	if dropdown.visible == true:
		if event is InputEventMouseButton:
				if event.button_index == MOUSE_BUTTON_LEFT and event.pressed == true:
					print("click")
					dropdown.hide()
					Home_icon.set_pressed(false)
	pass # Replace with function body.
