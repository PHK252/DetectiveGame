extends VBoxContainer

signal full_screen
signal windowed
signal set_selected
var selected : int
@export var op_button : Node
@export var screen_transition_fade : AnimationPlayer
@export var pause_screen : Panel
@export var pause_menu : Node
#var base_window_size := Vector2i(
		#ProjectSettings.get_setting("display/window/size/viewport_width"),
		#ProjectSettings.get_setting("display/window/size/viewport_height")
#)
#var native_monitor_size : Vector2

var open := false

func _ready() -> void:
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	
	match GlobalVars.screen_mode:
		"Full":
			op_button.selected = 0
			selected = 0
			emit_signal("set_selected", 0)
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			emit_signal("full_screen")
		"Window":
			op_button.selected = 1
			selected = 1
			emit_signal("set_selected", 1)
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
			emit_signal("windowed")
		"Borderless":
			op_button.selected = 2
			selected = 2
			emit_signal("set_selected", 2)
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
			emit_signal("windowed")
		_:
			op_button.selected = 0
			selected = 0
			emit_signal("set_selected", 0)
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			emit_signal("full_screen")
	#default window option

func _on_reset_graphics_pressed() -> void:
	pass
	#op_button.selected = 0
	#DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	#emit_signal("full_screen")

func _on_option_panel_clicked(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			op_button.release_focus()


func _on_option_button_clicked(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			if open == true:
				op_button.release_focus()

func _on_option_button_toggled(toggled_on):
	open = toggled_on

func _on_menu_on_select_option(index):
	match index:
		0: #full
			GlobalVars.screen_mode = "Full"
			selected = 0
			#screen_transition_fade.play("fade_out")
			#await get_tree().create_timer(.5).timeout
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			emit_signal("full_screen")
		1: #window
			GlobalVars.screen_mode = "Window"
			selected = 1
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
			emit_signal("windowed")
		2: #borderless window
			GlobalVars.screen_mode = "Borderless"
			selected = 2
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
			emit_signal("windowed")

func _on_pause_menu_visibility_changed():
	if pause_screen.visible == true:
		pause_menu.op_array[selected].set_pressed_no_signal(true)
