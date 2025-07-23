extends LineEdit

@onready var place_holder = placeholder_text
@onready var wrong = $"../Wrong"


func _on_focus_entered():
	if text == "":
		placeholder_text = ""


func _on_focus_exited():
	if text == "":
		placeholder_text = place_holder


func _on_computer_ui_return_default():
	$".".editable = false
	await get_tree().create_timer(1.5).timeout
	release_focus()
	$".".editable = true
	placeholder_text = place_holder
	wrong.hide()
	
