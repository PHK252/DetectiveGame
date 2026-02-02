extends Control

@export var back : TextureRect
@export var front : TextureRect
#notes
@export var text_label : RichTextLabel
@export var title : RichTextLabel
@export var back_button : TextureButton

@export var back_label: RichTextLabel
@export var front_label: RichTextLabel

signal vis_sound
signal flip_sound

@export var front_only : bool = false
func _on_object_front_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed == true:
			if !front_only:
				emit_signal("flip_sound")
				back.show()
				back_label.show()
				front.hide()
				front_label.hide()

func _on_object_back_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed == true:
			if !front_only:
				emit_signal("flip_sound")
				back.hide()
				back_label.hide()
				front.show()
				front_label.show()


func _on_visibility_changed():
	if visible == true:
		emit_signal("vis_sound")
		front.show()
		back.hide()
		front_label.show()
		back_label.hide()
#
#
#
func _on_exit_pressed():
	hide()
	show_notes()

func show_notes():
	text_label.show()
	title.show()
	back_button.show()
