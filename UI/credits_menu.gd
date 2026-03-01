extends CanvasLayer

@export var main_menu : CanvasLayer 

func _on_exit_pressed():
	main_menu.show()
	hide()
