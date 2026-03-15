extends LineEdit
@onready var placeholder = $"../Placeholder"
@onready var enter = $"../Enter"
@onready var place_holder = placeholder_text
@onready var wrong = $"../Wrong"
var focused

func _on_focus_entered():
	focused = true
	if text == "":
		placeholder.visible = false


func _on_focus_exited():
	focused = false
	if text == "":
		placeholder.visible = true


func _on_computer_ui_return_default():
	$".".editable = false
	await get_tree().create_timer(1.5).timeout
	release_focus()
	$".".editable = true
	placeholder.visible = true
	wrong.hide()
	


func _on_enter_pressed():
	release_focus()
	placeholder.visible = true

func _input(event):
	if Input.is_action_just_pressed("ui_accept"):
		if !enter.disabled:
			if focused:
				release_focus()
		


func _on_text_submitted(new_text):
	if text == "":
		keep_editing_on_text_submit = true
