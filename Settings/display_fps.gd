extends HBoxContainer

@onready var menu_fps = $MarginContainer/Fps
@onready var pause_fps = $"../../../../../../Pause Menu/AspectRatioContainer/Graphics/VBoxContainer/FpS_Shadows/display fps/MarginContainer/Fps"

@export var checkbox : TextureButton

func _ready() -> void:
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	menu_fps.button_pressed = GlobalVars.fps_toggle
	pause_fps.button_pressed = GlobalVars.fps_toggle

func _on_check_box_toggled(toggled_on: bool) -> void:
	GlobalVars.fps_toggle = toggled_on


func _on_reset_graphics_pressed() -> void:
	GlobalVars.fps_toggle = false
	checkbox.button_pressed = false

func _on_disable_overlap(toggled):
	if toggled:
		checkbox.mouse_filter = Control.MOUSE_FILTER_IGNORE
	else:
		checkbox.mouse_filter = Control.MOUSE_FILTER_STOP


func _on_fps_toggled(toggled_on):
	pause_fps.set_pressed_no_signal(GlobalVars.fps_toggle)


func _on_pause_fps_toggled(toggled_on):
	menu_fps.set_pressed_no_signal(GlobalVars.fps_toggle)
