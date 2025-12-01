extends Control

@export var menu : VBoxContainer
@export var main_button : TextureButton
@export var main_label : RichTextLabel
@export var selected : int = -1
@export var op_array : Array[TextureButton]
@export var label_array : Array[RichTextLabel]

signal on_select_option(index : int)

func _ready():
	menu.hide()
	if selected == -1:
		return
	if selected > op_array.size() -1:
		return
	op_array[selected].button_pressed = true
	main_label.text = label_array[selected].text
	label_array[selected].add_theme_color_override("default_color", Color(0.992,0.835,0.478,1.0))

func _on_texture_button_toggled(toggled_on):
	if toggled_on:
		menu.show()
	else:
		menu.hide()
	


func _on_option_select(label, index):
	emit_signal("on_select_option", index)
	main_label.text = label
	main_button.button_pressed = false
	label_array[selected].add_theme_color_override("default_color", Color(0.898,0.678,0.18,1.0))
	menu.hide()
	selected = index
	label_array[selected].add_theme_color_override("default_color", Color(0.992,0.835,0.478,1.0))
