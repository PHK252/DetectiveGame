extends VBoxContainer

signal set_pixelation
signal set_reset
signal set_selected
signal set_mirror
var selected : int
@export var op_button : Control
var open := false

@export var pause_menu : Control
@export var menu_menu : Control
@export var pause_screen : Panel

func _ready():
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	print(GlobalVars.stretch_factor)
	match GlobalVars.stretch_factor:
		2:
			op_button.selected = 0
			selected = 0
			emit_signal("set_selected", 0)
		4:
			op_button.selected = 1
			selected = 1
			emit_signal("set_selected", 1)
		6:
			op_button.selected = 2
			selected = 2
			emit_signal("set_selected", 2)
		7:
			op_button.selected = 3
			selected = 3
			emit_signal("set_selected", 3)
		8:
			op_button.selected = 4
			selected = 4
			emit_signal("set_selected", 4)
		_:
			op_button.selected = 2
			selected = 2
			emit_signal("set_selected", 2)
		

func _on_option_button_item_selected(index: int) -> void:
	op_button.release_focus()


func _on_reset_graphics_pressed() -> void:
	emit_signal("set_reset", "Normal", 2, true)
	GlobalVars.stretch_factor = 6
	emit_signal("set_pixelation")

func _on_menu_on_select_option(index):
	match index:
		0:
			GlobalVars.stretch_factor = 2
			selected = 0
		1:
			GlobalVars.stretch_factor = 4
			selected = 1
		2:
			GlobalVars.stretch_factor = 6
			selected = 2
		3:
			GlobalVars.stretch_factor = 7
			selected = 3
		4: 
			GlobalVars.stretch_factor = 8
			selected = 4
	emit_signal("set_pixelation")

#
#func _on_pixelation_pause_selected_changed():
	#menu_menu.op_array[selected].set_pressed_no_signal(true)
#
#
#func _on_pixelation_main_selected_changed():
	#


func _on_pause_menu_visibility_changed():
	if pause_screen.visible == true:
		pause_menu.op_array[selected].set_pressed_no_signal(true)
