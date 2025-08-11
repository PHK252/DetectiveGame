extends Control

var text = "Waterfall smell funkky"
var text2 = "hwllooo"

@export var text_label : RichTextLabel

#func _ready():
	#_add_note(text)

func _add_note(text : String):
	if text_label.text == "ADD NOTES HERE":
		text_label.text = ""
	
	if text_label.text == "":
		text_label.text = text
	else:
		text_label.text += "\n" + text
	pass



func _on_case_add_juniper_note():
	if GlobalVars.note_event == "waterfall":
		_add_note(text)
