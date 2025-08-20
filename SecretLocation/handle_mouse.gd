extends Node3D


func _on_mouse_exited():
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)


func _on_mouse_entered():
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
