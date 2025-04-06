extends Node




func _on_bookmark_mouse_entered():
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)


func _on_bookmark_mouse_exited():
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)



func _on_case_mouse_entered():
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)


func _on_case_mouse_exited():
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)


func _on_resume_mouse_entered():
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)


func _on_resume_mouse_exited():
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
