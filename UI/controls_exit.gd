extends CanvasLayer

signal show_start

func _on_exit_button_pressed():
	visible = false
	emit_signal("show_start")
