extends LineEdit

@onready var place_holder = $"../Subject Holder"

func _on_focus_entered():
	if text == "":
		place_holder.visible = false


func _on_focus_exited():
	if text == "":
		place_holder.visible = true




func _on_text_submitted(new_text):
	keep_editing_on_text_submit = true
