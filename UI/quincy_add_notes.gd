extends Control

@export var text_label : RichTextLabel
@export var title : RichTextLabel
@export var back_button : TextureButton

#@export var show_name_tag : Control
@export var show_letter : Control
#@export var show_bookmark : Control
#@export var show_info : Control

func _ready():
	#_add_note(juniper_case_letter)
	#_add_note(juniper_case_name_tag_found)
	#_add_note(juniper_bookmark_found)
	pass

#Handling Notes
func _add_note(text : String):
	if text_label.text == "ADD NOTES HERE":
		text_label.text = ""
	
	if text_label.text == "":
		text_label.text = text
	else:
		text_label.text += "\n" + text
	pass

#handling photos
func _on_RichTextLabel_meta_clicked(meta):
	#if meta == "show_tool_note":
		#_show_photo(show_tool_notes)
	
	#if meta == "show_bookmark":
		#_show_photo(show_bookmark)
	#elif meta == "show_info":
		#_show_photo(show_info)
	if meta == "show_letter":
		_show_photo(show_letter)
	#elif meta == "show_name_tag":
		#_show_photo(show_name_tag)
#Handling Buttons and Screens
#func _on_exit_photo_tool_pressed():
	#_hide_photo(show_tool_notes)
#
#func _on_exit_name_tag_pressed():
	#_hide_photo(show_name_tag)
#
func _on_exit_letter_pressed():
	_hide_photo(show_letter)

#func _on_exit_bookmark_pressed():
	#_hide_photo(show_bookmark)

#func _on_exit_info_pressed():
	#_hide_photo(show_info)

func _show_photo(photo : Control):
	if photo.visible == false:
		photo.show()
		hide_notes()
	else:
		return

func _hide_photo(photo : Control):
	show_notes()
	photo.hide()

func hide_notes():
	text_label.hide()
	title.hide()
	back_button.hide()

func show_notes():
	text_label.show()
	title.show()
	back_button.show()

func _on_case_add_quincy_note():
	pass # Replace with function body.
