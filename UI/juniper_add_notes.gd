extends Control

@export var text_label : RichTextLabel
@export var title : RichTextLabel
@export var back_button : TextureButton

@export var show_tool_notes : Control
@export var show_ID_card : Control
@export var show_picture : Control
@export var show_bookmark : Control
@export var show_letter : Control

#All Notes
var juniper_location_low = "- The victim was not present during the break-in.\n- She left at noon of the previous day to work at her cafe."
var juniper_location_high = "- The victim was not present during the break-in.\n- She left at noon of the previous day to go to work and returned around the time she reported the break-in."
var juniper_missing_low = "- Besides a damaged window, no other damages were reported. Nothing was stolen, but a case was left behind."
var juniper_missing_high = "- Besides a damaged window, no other damages were reported, and none of the victim’s belongings were taken."
var juniper_motive_low = "- The victim reported no subjects with motive."
var juniper_motive_high = "- While the victim reported no definitive subjects with motive, she mentioned someone in her past who caused her some distress."
var juniper_quincy_low = "- The victim seems to have a negative impression of Mayor Quincy Leonid, but has no personal ties with him."
var juniper_quincy_high = "- The victim doesn't seem to be quite fond of Mayor Quincy Leonid, but has no personal ties to the Mayor."
var juniper_micah_recognized = "- Despite Mr. Procyon recognition of her, the victim claims to not recognize Mr. Procyon." 
var juniper_micah_not_recognized = "- Despite Mr. Procyon vague recognition of her, the victim claims to have no prior recollection of Mr. Procyon."
var juniper_micah_first = "- The victim does not recognize Mr. Procyon."

#func _ready():
	#_add_note(text)

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
	if meta == "show_tool_note":
		_show_photo(show_tool_notes)
	elif meta == "show_ID":
		_show_photo(show_ID_card)
	elif meta == "show_picture":
		_show_photo(show_picture)
	elif meta == "show_bookmark":
		_show_photo(show_bookmark)
	elif meta == "show_letter":
		_show_photo(show_letter)

#Handling Buttons and Screens
func _on_exit_photo_tool_pressed():
	_hide_photo(show_tool_notes)

func _on_exit_ID_pressed():
	_hide_photo(show_ID_card)

func _on_exit_picture_pressed():
	_hide_photo(show_picture)

func _on_exit_bookmark_pressed():
	_hide_photo(show_bookmark)

func _on_exit_letter_pressed():
	_hide_photo(show_letter)

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

#Handling Adding Notes Signals
func _on_case_add_juniper_note():
	#if GlobalVars.note_event == "waterfall":
		#_add_note(text)
		pass
