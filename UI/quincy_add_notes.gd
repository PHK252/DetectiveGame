extends Control

@export var text_label : RichTextLabel
@export var title : RichTextLabel
@export var back_button : TextureButton

@export var show_coordinates : Control
@export var show_letter : Control
@export var show_journal : Control
@export var show_phone : Control
@export var show_lab_pic : Control
@export var show_proposal : Control

#All Notes
var quincy_location = "- The Mayor was not present during the break-in.\n- The security footage of the break-in was scrubbed."
var quincy_missing = "- Similar to the other break-ins, nothing of note was taken.\n -However, the intruder did make a mess."
var quincy_motive_no_skylar = "- The Mayor claims to have too many subjects with motive."
var quincy_micah = "- The Mayor does not recognize Micah Prycon."
var quincy_juniper = "- The Mayor does not recognize Juniper Hartley."
var quincy_fam_portrait_name = "- The Mayor confirmed that Skylar Aslan is his child."
var quincy_fam_portrait_no_name = "- The Mayor's wife and his child were not present during the time of the break-in."
var quincy_case_found = "- Much like the other two break-ins, a case appeared in the Mayor's Manor as well."
var quincy_case_unlocked = "- The password was found on the Mayor’s computer.\n- A hammer and note were found in the case."
var quincy_faint = "- Detective Dalton was MIA for most of this investigation :/"
var quincy_faint_skylar = "- Upon asking the Mayor about Skylar Aslan, he remembered that Skylar is his son, after much deliberation.\n- The Mayor doesn't seem to have a great relationship with his son, as Skylar took his mother's last name.\n- This fractured relationship may be a motive behind Skylar's trespassing and vandalism of the Mayor's Manor, but doesn't provide a solid motive for the other two break-ins."
var quincy_faint_no_case_asked = "- The damage done to the Mayor's Manor seems to be done by a blunt object and/or by hand.\n- Despite the mess, nothing of note was taken, but a locked case was left in the living room.\n- Although I wasn't able to open it, the case seems to contain a piece of paper and a heavy metal object in it." 
var quincy_faint_case_asked = "- The damage done to the Mayor's Manor seems to be done by a blunt object and/or by hand.\n- Although I wasn't able to open the case, it seems to contain a piece of paper and a heavy metal object in it."
var quincy_coordinates_found = "- A SET OF COORDINATES WERE FOUND IN THE LEONID FAMILY PORTRAIT.\n- TRANSCRIPT: [color=#64635f]18’5.0’’N 22’5.18’’W[/color][p][color=#566f5c][url=show_coordinates]VIEW PHOTO[/url][/color]"
var quincy_phone_found = "- A NOTE WAS FOUND ON A CRACKED PHONE.\n- TRANSCRIPT: [color=#64635f]DON'T BOTHER, I ALREADY TOOK CARE OF IT. THE PASSWORD IS ON HIS COMPUTER, OFFICER.[/color][p][color=#566f5c][url=show_phone]VIEW PHOTO[/url][/color]"
var quincy_letter_found = "- TRANSCRIPT(FRONT): [color=#64635f]HEY DAD, / WHAT A LOVELY SURPRISE! YOU HAVE A CHILD?! OH GOSH... YOU FORGOT? I KNOW. / I KNOW WHAT YOU DID TO MOM. YOU’RE A FRAUD, JUST LIKE THIS TOWN AND THE PEOPLE DESERVE TO KNOW IT. I WILL WAKE THEM UP. I’LL FINISH WHAT THEY STARTED.[/color][p]- TRANSCRIPT(BACK): [color=#64635f]OKAY! BACK TO BOARDING SCHOOL :)[/color][p][color=#566f5c][url=show_letter]VIEW PHOTO[/url][/color]"
var quincy_letter_response_fake = "- The Mayor claims that the contents of the note are fictitious."
var quincy_letter_response_skylar = "- The Mayor confirmed that Skylar Aslan is his child."
var quincy_letter_response_motive = "- The Mayor seems to believe that his child has probable motive."
var quincy_runa = "[color=#566f5c][url=show_journal]VIEW PHOTO[/url][/color]\n- ???"
var quincy_email = "- TRANSCRIPT: [color=#64635f] HEY DIR. QUINCY, / I’VE BEEN LOOKING INTO THE REPORT OF THE MOST RECENT SCAN OF THE SYSTEM, AND I FOUND AN ANOMALY THAT TRIPS A HIDDEN FAIL STATE THAT STOPS ANY SUBJECT FROM RESETTING. THOUGH THE PROBABILITY OF THIS STATE TRIGGERING IS BASICALLY 1 IN A MILLION, I THOUGHT IT WOULD BE BEST TO GET YOUR ADVICE ON HOW TO PROCEED.[/color][p]- TRANSCRIPT: [color=#64635f]HELLO DIRECTOR, / ANSWERS TO YOUR INQUIRIES:/ PLANS FOR FUTURE PROJECTS ARE GOING SMOOTHLY. WE’VE FOUND AN IDEAL LOCATION AND CAPPED OUR PARTICIPANT POOL. DEVELOPMENT IS ON TRACK. / YOUR TRANSFER REQUEST HAS BEEN FILED AND IS BEING PROCESSED. / YOUR SUBJECTS ARE SUSPENDED IN CONFINEMENT. WE ARE AWAITING FURTHER INSTRUCTIONS FROM YOU. / THANK YOU FOR YOUR HARD WORK. YOUR COOPERATION IS APPRECIATED.[/color][p]- DALTON?\n- HOW IS THIS RELATED TO THE CASE?"
var quincy_lab = "[color=#566f5c][url=show_lab_pic]VIEW PHOTO[/url][/color]\n- WHAT IS THAT??"
var quincy_pager = "- REVER, Operation NULL REV2\n- Turn off your phone when you put it away, Dalton."
var quincy_proposal = "- TRANSCRIPT: [color=#64635f]...[/color][p][color=#566f5c][url=show_proposal]VIEW PHOTO[/url][/color]\n- DALTON...\n- WHAT IS THIS?\n- WHERE ARE YOU?\n- WE HAVE TO GO THEO."

func _ready():
	text_label.text = GlobalVars.quincy_notes
	if text_label.text == "":
		text_label.text = "ADD NOTES HERE"

#Handling Notes
func _add_note(text : String):
	if text_label.text == "ADD NOTES HERE":
		text_label.text = ""
	
	if text_label.text == "":
		text_label.text = text
	else:
		text_label.text += "\n" + text
	GlobalVars.quincy_notes = text_label.text

#handling photos
func _on_RichTextLabel_meta_clicked(meta):
	if meta == "show_letter":
		_show_photo(show_letter)
	elif meta == "show_coordinates":
		_show_photo(show_coordinates)
	elif meta == "show_phone":
		_show_photo(show_phone)
	elif meta == "show_lab_pic":
		_show_photo(show_lab_pic)
	elif meta == "show_journal":
		_show_photo(show_journal)
	elif meta == "show_proposal":
		_show_photo(show_proposal)

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


func _on_case_add_quincy_note():
	if GlobalVars.note_event == "location":
		_add_note(quincy_location.to_upper())
	elif GlobalVars.note_event == "missing":
		_add_note(quincy_missing.to_upper())
	elif GlobalVars.note_event == "motive":
		_add_note(quincy_motive_no_skylar.to_upper())
	elif GlobalVars.note_event == "juniper":
		_add_note(quincy_juniper.to_upper())
	elif GlobalVars.note_event == "micah":
		_add_note(quincy_micah.to_upper())
	elif GlobalVars.note_event == "fam_portrait":
		if GlobalVars.note_condition == "name":
			_add_note(quincy_fam_portrait_name.to_upper())
		elif GlobalVars.note_condition == "no_name":
			_add_note(quincy_fam_portrait_no_name.to_upper())
		else:
			print_debug("Quincy portrait add notes error")
	elif GlobalVars.note_event == "case":
		if GlobalVars.note_condition == "found":
			_add_note(quincy_case_found.to_upper())
		elif GlobalVars.note_condition == "unlocked":
			_add_note(quincy_case_unlocked.to_upper())
		else:
			print_debug("Quincy case add notes error")
	elif GlobalVars.note_event == "faint":
		if GlobalVars.note_condition == "skylar":
			_add_note((quincy_faint + "\n" + quincy_faint_skylar).to_upper())
		if GlobalVars.note_condition == "asked_case":
			_add_note((quincy_faint + "\n" + quincy_faint_case_asked).to_upper())
		if GlobalVars.note_condition == "no_asked_case":
			_add_note((quincy_faint + "\n" + quincy_faint_no_case_asked).to_upper())
		else:
			print_debug("Quincy faint add notes error")
	elif GlobalVars.note_event == "coordinates":
		if GlobalVars.note_condition == "found":
			_add_note(quincy_coordinates_found)
		else:
			print_debug("Quincy coordinates add notes error")
	elif GlobalVars.note_event == "letter":
		if GlobalVars.note_condition == "found":
			_add_note(quincy_letter_found)
		elif GlobalVars.note_condition == "name_portrait":
			_add_note(quincy_letter_response_fake.to_upper())
		elif GlobalVars.note_condition == "name_no_portrait":
			_add_note((quincy_letter_response_fake + "\n" + quincy_letter_response_skylar).to_upper())
		elif GlobalVars.note_condition == "no_name_no_portrait":
			_add_note((quincy_letter_response_fake + "\n" + quincy_letter_response_skylar + "\n" + quincy_letter_response_motive).to_upper())
		else:
			print_debug("Quincy letter add notes error")
	elif GlobalVars.note_event == "runa":
		_add_note(quincy_runa)
	elif GlobalVars.note_event == "email":
		_add_note(quincy_email)
	elif GlobalVars.note_event == "lab":
		_add_note(quincy_lab)
	elif GlobalVars.note_event == "pager":
		_add_note(quincy_pager.to_upper())
	elif GlobalVars.note_event == "proposal":
		if GlobalVars.note_condition == "found":
			_add_note(quincy_proposal)
		else:
			print_debug("Quincy proposal add notes error")
	else:
		print(GlobalVars.note_event, "event")
		print(GlobalVars.note_condition, "condition")
		print_debug("Quincy add notes error")
