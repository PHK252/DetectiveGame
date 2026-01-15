extends VBoxContainer

signal full_screen
signal windowed

@export var op_button : OptionButton
@export var screen_transition_fade : AnimationPlayer

var base_window_size := Vector2i(
		ProjectSettings.get_setting("display/window/size/viewport_width"),
		ProjectSettings.get_setting("display/window/size/viewport_height")
)
var native_monitor_size : Vector2

var open := false
var maxed := false

func _ready() -> void:
	pass
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
			#print("FADE")
			maxed = false
			screen_transition_fade.play("fade_out")
			await get_tree().create_timer(.5).timeout
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			emit_signal("full_screen")
		1: #window
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
			emit_signal("windowed")
		2: #borderless window
			maxed = false
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
			emit_signal("windowed")
