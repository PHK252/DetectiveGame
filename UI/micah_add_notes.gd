extends Control

var text = "[color=#566f5c][url=show_node]View Photo[/url][/color]"
var text2 = "hwllooo"

@export var text_label : RichTextLabel
@export var title : RichTextLabel
@export var back_button : TextureButton

@export var show_tool_notes : Control

var micah_location = "- The victim was at work during the alleged break-in."
var micah_time_return = "- The victim was at work during the alleged break-in."
var micah_sus_low = "- The victim cited no suspicious activity during his shift."
var micah_sus_high = "- He cited no additional suspicious activity during his shift."
var micah_theo_asked_dinner = "- Aye! He’s a fellow Timber Groove fan!"
var micah_damage = "- The victim did not notice any damages or changes to his property."
var micah_motive = "- The victim presented no subjects with motive."
var micah_theo_answer = "- Upon presenting the case to the victim, he seemed concerned that the perpetrator entered his property through the window.\n- The victim was working during the time of the alleged break-in.\n- A case appeared in his apartment overnight."
var micah_tool_note_found = "- A NOTE WAS FOUND IN THE VICTIM'S TOOLBOX[p]- TRANSCRIPT (FRONT): [color=#a9a89b]SORRY, I GOTTA BORROW YOUR HAMMER :/[/color][p]- TRANSCRIPT (BACK): [color=#a9a89b] IF PA GETS MAD, TELL HIM TO USE ONE OF THE THOUSAND HAMMERS HE GOT FROM WORK ;)
[/color][p][color=#566f5c][url=show_tool_note]VIEW PHOTO[/url][/color]"


func _ready():
	_add_note(micah_tool_note_found)
	#_add_note(text)
	#_add_note(text2)
	pass

func _add_note(text : String):
	if text_label.text == "ADD NOTES HERE":
		text_label.text = ""
	
	if text_label.text == "":
		text_label.text = text
	else:
		text_label.text += "\n" + text
	pass

func _on_RichTextLabel_meta_clicked(meta):
	if meta == "show_tool_note":
		if show_tool_notes.visible == false:
			show_tool_notes.show()
			hide_notes()

func hide_notes():
	text_label.hide()
	title.hide()
	back_button.hide()

func show_notes():
	text_label.show()
	title.show()
	back_button.show()


func _on_exit_photo_tool_pressed():
	show_notes()
	show_tool_notes.hide()

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
		_add_note(micah_theo_answer.to_upper())
