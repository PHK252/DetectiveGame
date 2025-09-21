extends HBoxContainer

signal set_pixelation
@export var op_button : OptionButton

func _on_option_button_item_selected(index: int) -> void:
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

func _on_reset_graphics_pressed() -> void:
	op_button.selected = 2
	GlobalVars.stretch_factor = 6
	emit_signal("set_pixelation")
