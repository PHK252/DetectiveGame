extends HBoxContainer

#send signal to world env change brightness based on slide
# 0.7 min - 1.2 max
#1.0 default

signal brightness_shift
@export var slider : HSlider

func _on_h_slider_value_changed(value: float) -> void:
	GlobalVars.brightness = value
	emit_signal("brightness_shift")

func _on_reset_graphics_pressed() -> void:
	GlobalVars.brightness = 1.0
	slider.value = 1.0
	emit_signal("brightness_shift")

func _on_brightness_slider_clicked(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			slider.add_theme_icon_override("grabber_highlight", load("res://UI/Assets/Options/Graphics/Brightness Slider Grabber Pressed.png"))
		else:
			slider.add_theme_icon_override("grabber_highlight", load("res://UI/Assets/Options/Graphics/Brightness Slider Grabber normal.png"))
