extends Control

@export var menu : VBoxContainer
@export var main_button : TextureButton
@export var main_label : RichTextLabel
@export var selected : int = -1
@export var op_array : Array[TextureButton]
@export var label_array : Array[RichTextLabel]
@export var sub_menu : bool = false
signal on_select_option(index : int)
signal disable_overlap (toggled : bool)
@export var main_box_container : VBoxContainer
var open = false

signal select_sound

func _ready():
	menu.hide()
	if selected == -1:
		return
	if selected > op_array.size() -1:
		return
	#_set_selected(selected)

func _set_selected(selected : int):
	print("setting_selection")
	op_array[selected].button_pressed = true
	main_label.text = op_array[selected].label
	label_array[selected].add_theme_color_override("default_color", Color(0.992,0.835,0.478,1.0))

func _on_texture_button_toggled(toggled_on):
	menu.visible = toggled_on
	open = toggled_on
	emit_signal("disable_overlap", toggled_on)
	
func _on_option_select(label, index, reset):
	if reset == false:
		emit_signal("on_select_option", index)
		emit_signal("select_sound")
	main_label.text = label
	main_button.button_pressed = false
	print(selected)
	label_array[selected].add_theme_color_override("default_color", Color(0.898,0.678,0.18,1.0))
	menu.hide()
	selected = index
	op_array[selected].button_pressed = true
	label_array[selected].add_theme_color_override("default_color", Color(0.992,0.835,0.478,1.0))

func _close_menu():
	main_button.button_pressed = false
	menu.hide()
	

func _on_main_menu_click(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			_close_menu()

#func _on_main_toggled(toggled_on):
	#if toggled_on == true and sub_menu == true:
		#main_button.mouse_filter = Control.MOUSE_FILTER_IGNORE
		#mouse_filter = Control.MOUSE_FILTER_IGNORE
		#main_box_container.mouse_filter = Control.MOUSE_FILTER_IGNORE
	#else:
		#main_button.mouse_filter = Control.MOUSE_FILTER_STOP
		#mouse_filter = Control.MOUSE_FILTER_STOP
		#main_box_container.mouse_filter = Control.MOUSE_FILTER_STOP


func _on_disable_overlap(toggled):
	if toggled == true and sub_menu == true:
		main_button.mouse_filter = Control.MOUSE_FILTER_IGNORE
		mouse_filter = Control.MOUSE_FILTER_IGNORE
		main_box_container.mouse_filter = Control.MOUSE_FILTER_IGNORE
	else:
		main_button.mouse_filter = Control.MOUSE_FILTER_STOP
		mouse_filter = Control.MOUSE_FILTER_STOP
		main_box_container.mouse_filter = Control.MOUSE_FILTER_STOP
