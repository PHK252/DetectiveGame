extends Control

var text = "REVER: The town is a quarantine site for an experiment to combine human DNA with animal DNA."
var text2 = "hwllooo"

@export var text_label : RichTextLabel
#
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
