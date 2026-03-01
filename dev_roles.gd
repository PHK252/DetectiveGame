extends TextureButton

@export var menu : TextureRect
@export var panel : Panel

func _on_toggled(toggled_on):
	menu.visible = toggled_on
	panel.visible = toggled_on


func _on_panel_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			_close_menu()

func _close_menu():
	button_pressed = false
	menu.visible = false
