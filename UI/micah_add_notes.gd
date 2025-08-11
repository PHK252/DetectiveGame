extends Control

var text = "[color=#566f5c][url=show_node]View Photo[/url][/color]"
var text2 = "hwllooo"

#@onready var pressed_color = Color(0.541, 0.537, 0.484)
#@onready var norm_color = Color(0.337, 0.435, 0.361)

@export var text_label : RichTextLabel

var hovered_text = "[color = #566f5c]" + text + "[/color]"
var norm_text = "[color = #959487]" + text + "[/color]"


func _ready():
	_add_note(text)
	_add_note(text2)

func _add_note(text : String):
	if text_label.text == "ADD NOTES HERE":
		text_label.text = ""
	
	if text_label.text == "":
		text_label.text = text
	else:
		text_label.text += "\n" + text
	pass

func _on_RichTextLabel_meta_clicked(meta):
	if meta == "show_node":
		if $test.visible == false:
			$test.visible = true
		else:
			$test.visible = false

#func _on_rich_text_label_meta_hover_started(meta):
	#if meta == "show_node":
		#print("change color")
		#text = ""
		#text = hovered_text
#
#func _on_rich_text_label_meta_hover_ended(meta):
	#if meta == "show_node":
		#text = ""
		#text = norm_text
