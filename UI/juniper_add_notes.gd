extends Control

@export var text_label : RichTextLabel
@export var title : RichTextLabel
@export var back_button : TextureButton

#@export var show_tool_notes : Control
#@export var show_ID_card : Control
#@export var show_picture : Control
@export var show_bookmark : Control
#@export var show_letter : Control

#All Notes
var juniper_location_low = "- The victim was not present during the break-in.\n- She left at noon of the previous day to work at her cafe."
var juniper_location_high = "- The victim was not present during the break-in.\n- She left at noon of the previous day to go to work and returned around the time she reported the break-in."
var juniper_missing_low = "- Besides a damaged window, no other damages were reported. Nothing was stolen, but a locked case was left behind."
var juniper_missing_high = "- Besides a damaged window, no other damages were reported, and none of the victim’s belongings were taken."
var juniper_motive_low = "- The victim reported no subjects with motive."
var juniper_motive_high = "- While the victim reported no definitive subjects with motive, she mentioned someone in her past who caused her some distress."
var juniper_quincy_low = "- The victim seems to have a negative impression of Mayor Quincy Leonid, but has no personal ties with him."
var juniper_quincy_high = "- The victim doesn't seem to be quite fond of Mayor Quincy Leonid, but has no personal ties to the Mayor."
var juniper_micah_recognized = "- Despite Mr. Procyon recognition of her, the victim claims to not recognize Mr. Procyon." 
var juniper_micah_not_recognized = "- Despite Mr. Procyon vague recognition of her, the victim claims to have no prior recollection of Mr. Procyon."
var juniper_micah_first = "- The victim does not recognize Mr. Procyon."
var juniper_bookmark_found = "- A NOTE WAS FOUND ON A BOOKMARK IN ONE OF THE VICTIM'S BOOKS.[p]- TRANSCRIPT: [color=#64635f]THE KEY TO UNLOCKING EVERYTHING IS HIS PROUDEST ACHIEVEMENT. / HE WON’T LET US WAKE UP. / PROJECT 1805220518
[/color][p][color=#566f5c][url=show_bookmark]VIEW PHOTO[/url][/color]"
var juniper_bookmark_response_low = "- The victim refused to answer questions about the note."
var juniper_bookmark_response_high = "- The victim did not write the note, nor does she know the meaning of it.\n- The book it was found in was given to the victim by one of her employees."
var juniper_window = "- The window seems to have been broken with blunt force.\n- No blood or fur were left on the shards."
var juniper_cafe_low = "- The victim owns a cafe with her mother.\n- Her mother is out of town."
var juniper_cafe_neutral = "- The victim owns a cafe with her mother.\n- Her mother was not present during the break-in."
var juniper_cafe_high = "- The victim owns a cafe that she started with her mother."
var juniper_case_low = "- The victim claims that the intruder left a locked case in her living room."
var juniper_case_high = "- The victim reports that a locked case appeared after she came back.\n- The victim presumes that the intruder left it."

func _ready():
	_add_note(juniper_bookmark_found)

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
	#elif meta == "show_ID":
		#_show_photo(show_ID_card)
	#elif meta == "show_picture":
		#_show_photo(show_picture)
	if meta == "show_bookmark":
		_show_photo(show_bookmark)
	#elif meta == "show_letter":
		#_show_photo(show_letter)

#Handling Buttons and Screens
#func _on_exit_photo_tool_pressed():
	#_hide_photo(show_tool_notes)
#
#func _on_exit_ID_pressed():
	#_hide_photo(show_ID_card)
#
#func _on_exit_picture_pressed():
	#_hide_photo(show_picture)

func _on_exit_bookmark_pressed():
	_hide_photo(show_bookmark)

#func _on_exit_letter_pressed():
	#_hide_photo(show_letter)

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
	if GlobalVars.note_event == "location":
		if GlobalVars.note_condition == "low":
			_add_note(juniper_location_low.to_upper())
		elif GlobalVars.note_condition == "high":
			_add_note(juniper_location_high.to_upper())
		else:
			print_debug("Juniper Location error")
	elif GlobalVars.note_event == "missing":
		if GlobalVars.note_condition == "low":
			_add_note(juniper_missing_low.to_upper())
		elif GlobalVars.note_condition == "high":
			_add_note(juniper_missing_high.to_upper())
		else:
			print_debug("Juniper Missing error")
	elif GlobalVars.note_event == "motive":
		if GlobalVars.note_condition == "low":
			_add_note(juniper_motive_low.to_upper())
		elif GlobalVars.note_condition == "high":
			_add_note(juniper_motive_high.to_upper())
		else:
			print_debug("Juniper Motive error")
	elif GlobalVars.note_event == "quincy":
		if GlobalVars.note_condition == "low":
			_add_note(juniper_quincy_low.to_upper())
		elif GlobalVars.note_condition == "high":
			_add_note(juniper_quincy_high.to_upper())
		else:
			print_debug("Juniper Quincy error")
	elif GlobalVars.note_event == "micah":
		if GlobalVars.note_condition == "recognized":
			_add_note(juniper_micah_recognized.to_upper())
		elif GlobalVars.note_condition == "not_recognized":
			_add_note(juniper_micah_not_recognized.to_upper())
		elif GlobalVars.note_condition == "first":
			_add_note(juniper_micah_first.to_upper())
		else:
			print_debug("Juniper Micah error")
	elif GlobalVars.note_event == "bookmark":
		if GlobalVars.note_condition == "found":
			_add_note(juniper_bookmark_found)
		elif GlobalVars.note_condition == "low":
			_add_note(juniper_bookmark_response_low.to_upper())
		elif GlobalVars.note_condition == "high":
			_add_note(juniper_bookmark_response_high.to_upper())
		else:
			print_debug("Juniper Bookmark error")
	elif GlobalVars.note_event == "window":
		_add_note(juniper_window.to_upper())
	elif GlobalVars.note_event == "cafe":
		if GlobalVars.note_condition == "low":
			_add_note(juniper_cafe_low.to_upper())
		elif GlobalVars.note_condition == "neutral":
			_add_note(juniper_cafe_neutral.to_upper())
		elif GlobalVars.note_condition == "high":
			_add_note(juniper_cafe_high.to_upper())
		else:
			print_debug("Juniper Cafe error")
	elif GlobalVars.note_event == "case":
		if GlobalVars.note_condition == "low":
			_add_note(juniper_case_low.to_upper())
		elif GlobalVars.note_condition == "high":
			_add_note(juniper_case_high.to_upper())
		else:
			print_debug("Juniper Case error") 
		
