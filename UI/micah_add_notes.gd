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
var micah_location = "- The victim was at work during the alleged break-in."
var micah_time_return = "- The victim was at work during the alleged break-in."
var micah_sus_low = "- The victim cited no suspicious activity during his shift."
var micah_sus_high = "- He cited no additional suspicious activity during his shift."
var micah_theo_asked_dinner = "- Aye! He’s a fellow Timber Groove fan!"
var micah_damage = "- The victim did not notice any damages or changes to his property."
var micah_motive = "- The victim presented no subjects with motive."
var micah_theo_answer = "- Upon presenting the case to the victim, he seemed concerned that the perpetrator entered his property through the window.\n- The victim was working during the time of the alleged break-in.\n- A case appeared in his apartment overnight."
var micah_tool_note_found = "- A NOTE WAS FOUND IN THE VICTIM'S TOOLBOX.[p]- TRANSCRIPT (FRONT): [color=#64635f]SORRY, I GOTTA BORROW YOUR HAMMER :/[/color][p]- TRANSCRIPT (BACK): [color=#64635f]IF PA GETS MAD, TELL HIM TO USE ONE OF THE THOUSAND HAMMERS HE GOT FROM WORK ;)
[/color][p][color=#566f5c][url=show_tool_note]VIEW PHOTO[/url][/color]"
var micah_tool_note_low = "- The victim claims that the note was written by his father, though there is mention of a 'Pa' figure written on the note."
var micah_tool_note_high = "- Upon presenting the note to the victim, he seemed indifferent to the notion that the perpetrator entered his property and took an item of his."
var micah_tool_note_theo = "- Upon presenting the note to the victim, he seemed a bit puzzled, asking for some time to think."
var micah_ID_card_found = "- AN ID CARD WAS FOUND IN THE CLOSET.[p]- BASED ON THE SHARED SURNAME, IT IS PRESUMED TO BE HIS FATHER’S.[p]- TRANSCRIPT: [color=#64635f]ARCADIA WATER PLANT/CLYDE PROCYON, LEAD PLANT OPERATOR/ ID: E11909323160005/ CONTACT: 093-316[/color][p][color=#566f5c][url=show_ID]VIEW PHOTO[/url][/color]"
var micah_pic_fell = "- Detective Reynard broke the victim's picture frame :/"
var micah_pic_low_found = "- A PICTURE OF THE VICTIM AND A FRIEND WAS FOUND ON THE TV STAND.[p]- BOTH OF THEM ARE CHILDREN IN THE PICTURE.[p]- TRANSCRIPT: [color=#64635f]CAN’T BELIEVE OUR CUTIES ARE ALREADY FIVE I GUESS THEY WEREN’T LYING WHEN THEY SAY THEY GROW UP SO FAST...[/color][p]- THE PICTURE IS DATED 10/04/XX04.[p][color=#566f5c][url=show_picture]VIEW PHOTO[/url][/color]"
var micah_pic_high_found = "- A PICTURE OF THE VICTIM AND A CHILDHOOD FRIEND WAS FOUND ON THE TV STAND.[p]- BOTH OF THEM ARE CHILDREN IN THE PICTURE.[p]- THE VICTIM MENTIONED THAT THEY HAVE NOT TALKED IN A WHILE.[p]- TRANSCRIPT: [color=#64635f]CAN’T BELIEVE OUR CUTIES ARE ALREADY FIVE I GUESS THEY WEREN’T LYING WHEN THEY SAY THEY GROW UP SO FAST...[/color][p]- THE PICTURE IS DATED 10/04/XX04.[p][color=#566f5c][url=show_picture]VIEW PHOTO[/url][/color]"
var micah_bookmark_found = "- A NOTE WAS FOUND ON A BOOKMARK IN ONE OF THE VICTIM’S BOOKS.[p]TRANSCRIPT: [color=#64635f]THINGS AREN’T WHAT THEY SEEM. WE ARE TOYS TO A POWER THEY DON’T WANT US TO SEE.[/color][p][color=#566f5c][url=show_bookmark]VIEW PHOTO[/url][/color]"
var micah_bookmark_wrote_low = "- The victim claims to not have written the note, nor does he know the author of the note."
var micah_bookmark_wrote_high = "- The victim claims to not have any recollection of writing the note, nor does he know the author of the note."
var micah_bookmark_meaning_low = "- The victim seems oblivious to the meaning and existence of the note."
var micah_bookmark_meaning_high = "- The victim claims not to know the meaning of the note."
var micah_case_low = "- There is a locked case of unknown origins in the victim’s living room.\n- When questioned, the victim gave vague, non-committal answers."
var micah_case_high = "- A locked case appeared in the victim's living room this morning.\n- The victim claims not to know its origins or how to open it."
var micah_case_theo = "- The victim claims not to know how to open the case."
var micah_case_unlock = "- The password to the case was 100404, the date on the victim’s childhood picture.\n- A letter, a key and a strand of fur were found inside."
var micah_case_key_low = "- The victim claims that the key may be his, but failed to give a solid confirmation."
var micah_case_key_high = "- The victim claims that the key is not his."
var micah_case_letter = "- TRANSCRIPT (FRONT): [color=#64635f]HEY, I'M SORRY FOR LEAVING WITHOUT TELLING YOU. I HAVE TO SKIP TOWN FOR A WHILE. I’LL BE BACK SOME DAY, HOPEFULLY BUT DON'T HOLD YOUR BREATH. DON'T TRY TO FIND ME. TAKE CARE OF MA AND PA FOR ME, ALRIGHT?[/color][p]- TRANSCRIPT (BACK): [color=#64635f]YOU WERE RIGHT ABOUT IO AND FELICE BTW/ DENIAL IS ONE HELL OF A DRUG :([/color][p][color=#566f5c][url=show_letter]VIEW PHOTO[/url][/color]"
var micah_case_letter_low = "- The victim claims not to know the author of the letter.".to_upper() + "\n" + micah_case_letter
var micah_case_letter_high = "- The victim may know the author of the letter, but declined to give a specific name.".to_upper() + "\n" + micah_case_letter
var micah_case_letter_skylar = "- It is speculated that the author of the letter is Skylar Aslan.".to_upper() + "\n" + micah_case_letter
var micah_window = "- The victim's window was open during the time of the crime, which aligns with what is stated in the report."
var micah_juniper_connection_low = "- The victim claims to recognize Ms. Hartley, but doesn't know where he has seen her."
var micah_juniper_connection_high = "- The victim recognizes Ms. Hartley, and claims to have gone to her Cafe on occasion."
var micah_juniper_connection_high_repeated = "- A friend of the victim worked at Ms. Hartley's Cafe/"
#var micah_juniper_motive = "- The victim does not have a close enough connection to Ms. Hartley to know any subjects with motive against her."
var micah_quincy_connection = "- The victim claims to have no connection to the Mayor."
#var micah_quincy_motive = "- The victim does not have a close enough connection to the Mayor to know any subjects with motive against him."
var micah_dad = "- The victim's father may have connections to the Mayor."
var micah_skylar_low = "- The victim claims not to know Skylar Aslan."
var micah_skylar_high = "- Skylar Aslan and the victim are friends, but the victim claims not to know of their whereabouts.\n- Skylar Aslan is the other child in the picture."
var micah_leave_missing = "- The victim mentioned that his friend by the name of Skylar Aslan has gone missing for the past few weeks."

func _ready():
	#_add_note(micah_case_letter_skylar)
	#_add_note(micah_pic_high_found)
	#_add_note(micah_tool_note_found)
	pass

#handling notes
func _add_note(text : String):
	if text_label.text == "ADD NOTES HERE":
		text_label.text = ""
	
	if text_label.text == "":
		text_label.text = text
	else:
		text_label.text += "\n" + text
	GlobalVars.micah_notes = text_label.text
	#print(GlobalVars.micah_notes)
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
func _on_case_add_micah_note():
	if GlobalVars.note_event == "location":
		_add_note(micah_location.to_upper())
	elif GlobalVars.note_event == "time_return":
		_add_note(micah_time_return.to_upper())
	elif GlobalVars.note_event == "suspicious":
		if GlobalVars.note_condition == "high":
			_add_note(micah_sus_high.to_upper())
		elif GlobalVars.note_condition == "low":
			_add_note(micah_sus_low.to_upper())
		else:
			print_debug("micah sus went wrong somewhere")
	elif GlobalVars.note_event == "theo_asked_dinner":
		_add_note(micah_theo_asked_dinner.to_upper())
	elif GlobalVars.note_event == "damage":
		_add_note(micah_damage.to_upper())
	elif GlobalVars.note_event == "motive":
		_add_note(micah_motive.to_upper())
	elif GlobalVars.note_event == "theo_answer":
		_add_note(micah_theo_answer.to_upper())
	elif GlobalVars.note_event == "tool_note":
		if GlobalVars.note_condition == "found":
			_add_note(micah_tool_note_found)
		elif GlobalVars.note_condition == "low":
			_add_note(micah_tool_note_low.to_upper())
		elif GlobalVars.note_condition == "high":
			_add_note(micah_tool_note_high.to_upper())
		elif GlobalVars.note_condition == "theo":
			_add_note(micah_tool_note_theo.to_upper())
	elif GlobalVars.note_event == "ID":
		if GlobalVars.note_condition == "found":
			_add_note(micah_ID_card_found)
	elif GlobalVars.note_event == "picture":
		if GlobalVars.note_condition == "fell":
			_add_note(micah_pic_fell.to_upper())
		elif GlobalVars.note_condition == "low_found":
			_add_note(micah_pic_low_found)
		elif GlobalVars.note_condition == "high_found":
			_add_note(micah_pic_high_found)
	elif GlobalVars.note_event == "bookmark":
		if GlobalVars.note_condition == "found":
			_add_note(micah_bookmark_found)
		elif GlobalVars.note_condition == "wrote_low":
			_add_note(micah_bookmark_wrote_low.to_upper())
		elif GlobalVars.note_condition == "wrote_high":
			_add_note(micah_bookmark_wrote_high.to_upper())
		elif GlobalVars.note_condition == "meaning_low":
			_add_note(micah_bookmark_meaning_low.to_upper())
		elif GlobalVars.note_condition == "meaning_high":
			_add_note(micah_bookmark_meaning_high.to_upper())
	elif GlobalVars.note_event == "case":
		if GlobalVars.note_condition == "low":
			_add_note(micah_case_low.to_upper())
		elif GlobalVars.note_condition == "high":
			_add_note(micah_case_high.to_upper())
		elif GlobalVars.note_condition == "theo":
			_add_note(micah_case_theo.to_upper())
		elif GlobalVars.note_condition == "unlock":
			_add_note(micah_case_unlock.to_upper())
	elif GlobalVars.note_event == "case_key":
		if GlobalVars.note_condition == "low":
			_add_note(micah_case_key_low.to_upper())
		elif GlobalVars.note_condition == "high":
			_add_note(micah_case_key_high.to_upper())
	elif GlobalVars.note_event == "case_letter":
		if GlobalVars.note_condition == "low":
			_add_note(micah_case_letter_low)
		elif GlobalVars.note_condition == "high":
			_add_note(micah_case_letter_high)
		elif GlobalVars.note_condition == "skylar":
			_add_note(micah_case_letter_skylar)
	elif GlobalVars.note_event == "window":
		_add_note(micah_window.to_upper())
	elif GlobalVars.note_event == "juniper":
		if GlobalVars.note_condition == "connection_low":
			_add_note(micah_juniper_connection_low.to_upper())
		elif GlobalVars.note_condition == "connection_high":
			_add_note(micah_juniper_connection_high.to_upper())
		elif GlobalVars.note_condition == "connection_high_repeated":
			_add_note(micah_juniper_connection_high_repeated.to_upper())
		#elif GlobalVars.note_condition == "motive":
			#_add_note(micah_juniper_motive.to_upper())
	elif GlobalVars.note_event == "quincy":
		if GlobalVars.note_condition == "connection":
			_add_note(micah_quincy_connection.to_upper())
		#elif GlobalVars.note_condition == "motive":
			#_add_note(micah_quincy_motive.to_upper())
	elif GlobalVars.note_event == "clyde":
		_add_note(micah_dad.to_upper())
	elif GlobalVars.note_event == "skylar":
		if GlobalVars.note_condition == "low":
			_add_note(micah_skylar_low.to_upper())
		elif GlobalVars.note_condition == "high":
			_add_note(micah_skylar_high.to_upper())
	elif GlobalVars.note_event == "leave_missing":
		_add_note(micah_leave_missing.to_upper())
