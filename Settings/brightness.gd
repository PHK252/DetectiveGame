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
