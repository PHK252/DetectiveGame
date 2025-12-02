extends VBoxContainer

signal set_pixelation
signal set_selected
@export var op_button : Control
var open := false
func _on_option_button_item_selected(index: int) -> void:
	op_button.release_focus()


func _on_reset_graphics_pressed() -> void:
	emit_signal("set_selected", "Normal", 2, true)
	GlobalVars.stretch_factor = 6
	emit_signal("set_pixelation")

func _on_menu_on_select_option(index):
	match index:
		0:
			GlobalVars.stretch_factor = 2
		1:
			GlobalVars.stretch_factor = 4
		2:
			GlobalVars.stretch_factor = 6
		3:
			GlobalVars.stretch_factor = 7
		4: 
			GlobalVars.stretch_factor = 8
	emit_signal("set_pixelation")
