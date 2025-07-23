extends LineEdit

@onready var place_holder = placeholder_text

func _on_focus_entered():
	if text == "":
		placeholder_text = ""


func _on_focus_exited():
	if text == "":
		placeholder_text = place_holder
