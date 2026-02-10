extends LineEdit

@onready var place_holder = placeholder_text
@onready var wrong = $"../Wrong"
var focused

func _on_focus_entered():
	focused = true
	if text == "":
		placeholder_text = ""


func _on_focus_exited():
	focused = false
	if text == "":
		placeholder_text = place_holder


func _on_computer_ui_return_default():
	$".".editable = false
	await get_tree().create_timer(1.5).timeout
	release_focus()
	$".".editable = true
	placeholder_text = place_holder
	wrong.hide()
	


func _on_enter_pressed():
	release_focus()
	placeholder_text = place_holder

func _input(event):
	if Input.is_action_just_pressed("ui_accept"):
		if focused:
			release_focus()
