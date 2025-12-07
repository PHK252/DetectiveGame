extends HBoxContainer

signal set_shadow
@export var checkbox : TextureButton

func _ready():
	checkbox.button_pressed = true
	GlobalVars.optional_shadow = true
	emit_signal("set_shadow")

func _on_check_box_toggled(toggled_on: bool) -> void:
	GlobalVars.optional_shadow = toggled_on
	emit_signal("set_shadow")

#set globalvars shadows = true/false
# set AO on and off
# set optional lights on and off for each scene

#implementation:
# settings script in scene
# export- world env, lights array, subviewport
# upon signal from op menu check 
#

func _on_reset_graphics_pressed() -> void:
	checkbox.button_pressed = true
	GlobalVars.optional_shadow = true
	emit_signal("set_shadow")



func _on_disable_overlap(toggled):
	if toggled:
		checkbox.mouse_filter = Control.MOUSE_FILTER_IGNORE
	else:
		checkbox.mouse_filter = Control.MOUSE_FILTER_STOP
