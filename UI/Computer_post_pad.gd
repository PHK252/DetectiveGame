extends TextureButton

@onready var panel = $"../Panel"
@onready var close_post = $"../ComputerHomePostIt"



func _on_pressed():
	close_post.show()
	panel.show()

func _on_panel_gui_input(event):
	if close_post.visible == true:
		if event is InputEventMouseButton:
				if event.button_index == MOUSE_BUTTON_LEFT and event.pressed == true:
					close_post.hide()
					panel.hide()

func _on_exit_pressed():
	close_post.hide()
	panel.hide()
