extends Control

signal add_micah_note
signal add_juniper_note
signal add_quincy_note
signal added_notes_overlay

#func _ready():
	#await get_tree().process_frame
	#emit_signal("added_notes_overlay")

func _process(delta):
	if GlobalVars.note_char == "micah":
		emit_signal("add_micah_note")
		emit_signal("added_notes_overlay")
		GlobalVars.note_char = ""
	elif GlobalVars.note_char == "juniper":
		GlobalVars.note_char = ""
		emit_signal("add_juniper_note")
		emit_signal("added_notes_overlay")
	elif GlobalVars.note_char == "quincy":
		emit_signal("add_quincy_note")
		emit_signal("added_notes_overlay")
		GlobalVars.note_char = ""
	else:
		return
