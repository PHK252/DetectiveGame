extends VBoxContainer

signal set_pixelation
@export var op_button : OptionButton
var open := false
func _on_option_button_item_selected(index: int) -> void:
	op_button.release_focus()
	match index:
		0:
			GlobalVars.stretch_factor = 2
		1:
			GlobalVars.stretch_factor = 4
		2:
			GlobalVars.stretch_factor = 7
		3:
			GlobalVars.stretch_factor = 8
		4: 
			GlobalVars.stretch_factor = 6
	emit_signal("set_pixelation")

func _on_reset_graphics_pressed() -> void:
	op_button.selected = 4
	GlobalVars.stretch_factor = 6
	emit_signal("set_pixelation")

func _on_option_panel_clicked(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			op_button.release_focus()


func _on_option_button_clicked(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			if open == true:
				op_button.release_focus()

func _on_option_button_toggled(toggled_on):
	open = toggled_on
