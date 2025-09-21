extends HBoxContainer

signal full_screen
signal windowed

@export var op_button : OptionButton

func _ready() -> void:
	pass
	#default window option
	
func _on_window_mode_item_selected(index: int) -> void:
	match index:
		0: #full
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
			emit_signal("full_screen")
		1: #window
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
			emit_signal("windowed")
		2: #borderless window
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
			emit_signal("windowed")


func _on_reset_graphics_pressed() -> void:
	pass
	#op_button.selected = 0
	#DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	#emit_signal("full_screen")
