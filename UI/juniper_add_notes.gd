extends Control

@export var text_label : RichTextLabel
@export var title : RichTextLabel
@export var back_button : TextureButton

#@export var show_tool_notes : Control
@export var show_name_tag : Control
@export var show_letter : Control
@export var show_bookmark : Control
@export var show_info : Control

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
var juniper_case_opened = "- The code to the case was the employee code of Aslan, S. (8008569420)\n- A letter, a name tag, an apron, and a 50 dollar bill were found inside the case."
var juniper_info_low = "- THE VICTIM'S LAST EMPLOYEE (ASLAN, S.) IS REPORTED TO BE 'MISSING'.\n- THE VICTIM REFUSED TO ELABORATE.\n- TRANSCRIPT (RELEVANT FRONT): [color=#64635f]SKYLAR ASLAN / 8008569420 / BARISTA / PART-TIME (20HR/WEEK)/ MISSING?
[/color][p]- TRANSCRIPT (BACK): [color=#64635f]0315131621200518 16011919: NOVA1805220518 / C   A   T / 03 01  20[/color][p][color=#566f5c][url=show_info]VIEW PHOTO[/url][/color]"
var juniper_info_high = "- THE VICTIM'S LAST EMPLOYEE (ASLAN, S.) IS REPORTED TO BE 'MISSING'.\n- ACCORDING TO THE VICTIM, ASLAN SUDDENLY STOPPED SHOWING UP TO WORK AND NEVER REPLIED TO HER ATTEMPTS AT CONTACTING THEM.\n- TRANSCRIPT (RELEVANT FRONT): [color=#64635f]SKYLAR ASLAN / 8008569420 / BARISTA / PART-TIME (20HR/WEEK)/ MISSING?
[/color][p]- TRANSCRIPT (BACK): [color=#64635f]0315131621200518 16011919: NOVA1805220518 / C   A   T / 03 01  20[/color][p][color=#566f5c][url=show_info]VIEW PHOTO[/url][/color]"
var juniper_med = "The victim's mother passed away due to an unknown mental illness."
var juniper_pastry_low = "- A half-eaten pastry was found in her toaster oven.\n- Despite what the teeth marks suggest, the victim claims that she ate it."
var juniper_pastry_high = "- A half-eaten pastry was found in her toaster oven.\n- The teeth marks suggest that the suspected perpetrator ate it."
var juniper_case_letter = "- LETTER TRANSCRIPT (FRONT): [color=#64635f]HEY BOSS, I GUESS THIS IS ME PUTTING IN MY OFFICIAL 2-WEEK NOTICE, BUT I GUESS YOU WOULD’VE FIGURED BY NOW THAT I QUIT. SORRY ABOUT THE SHORT NOTICE. SOMETHING URGENT CAME UP. I HOPE YOU HAVE IT IN YOUR HEART TO FORGIVE ME FOR ALL THE TROUBLE I'VE SURELY CAUSED YOU. THANKS FOR ALL THE FREE FOOD AND BEING THE BEST BOSS I COULD EVER ASK FOR!! BEST, / YOUR MOST VALUABLE EMPLOYEE[/color][p]- LETTER TRANSCRIPT (BACK): [color=#64635f]I’M SORRY ABOUT YOUR WINDOW. I LEFT 50 DOLLARS FOR REPAIRS. IF THAT’S NOT ENOUGH, YOU COULD DOCK FROM MY LAST PAYCHECK ;)[/color][p][color=#566f5c][url=show_letter]VIEW PHOTO[/url][/color]"
var juniper_case_name_tag_found = "- NAME TAG TRANSCRIPT: [color=#64635f]SKYLAR A.[/color][p][color=#566f5c][url=show_name_tag]VIEW PHOTO[/url][/color]"
var juniper_case_name_tag_response = "- The full name of the missing employee is Skylar Aslan.\n- They left their name tag and apron in the case.\n- Skylar Aslan is now the primary suspect of this break-in."

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
	GlobalVars.juniper_notes = text_label.text

#handling photos
func _on_RichTextLabel_meta_clicked(meta):
	#if meta == "show_tool_note":
		#_show_photo(show_tool_notes)
	
	if meta == "show_bookmark":
		_show_photo(show_bookmark)
	elif meta == "show_info":
		_show_photo(show_info)
	elif meta == "show_letter":
		_show_photo(show_letter)
	elif meta == "show_name_tag":
		_show_photo(show_name_tag)

func _show_photo(photo : Control):
	if photo.visible == false:
		photo.show()
		hide_notes()
	else:
		return

func hide_notes():
	text_label.hide()
	title.hide()
	back_button.hide()


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
		elif GlobalVars.note_condition == "open":
			_add_note(juniper_case_opened.to_upper())
		else:
			print_debug("Juniper Case error") 
	elif GlobalVars.note_event == "info":
		if GlobalVars.note_condition == "low":
			_add_note(juniper_info_low)
		elif GlobalVars.note_condition == "high":
			_add_note(juniper_info_high)
		else:
			print_debug("Juniper info error")
	elif GlobalVars.note_event == "med":
		_add_note(juniper_med.to_upper())
	elif GlobalVars.note_event == "pastry":
		if GlobalVars.note_condition == "low":
			_add_note(juniper_pastry_low.to_upper())
		elif GlobalVars.note_condition == "high":
			_add_note(juniper_pastry_high.to_upper())
		else:
			print_debug("Juniper pastry error")
	elif GlobalVars.note_event == "letter":
		if GlobalVars.note_condition == "found":
			_add_note(juniper_case_letter)
	elif GlobalVars.note_event == "nametag":
		if GlobalVars.note_condition == "found":
			_add_note(juniper_case_name_tag_found)
		elif GlobalVars.note_condition == "response":
			_add_note(juniper_case_name_tag_response)
		else:
			print_debug("Juniper name tag error")
	else:
		print_debug("Juniper add notes error")
