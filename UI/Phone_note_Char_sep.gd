extends Control

signal add_micah_note
signal add_juniper_note
signal add_quincy_note


func _process(delta):
	if GlobalVars.note_char == "micah":
		emit_signal("add_micah_note")
		GlobalVars.note_char = ""
	elif GlobalVars.note_char == "juniper":
		GlobalVars.note_char = ""
		emit_signal("add_juniper_note")
	elif GlobalVars.note_char == "quincy":
		emit_signal("add_quincy_note")
		GlobalVars.note_char = ""
	else:
		return
