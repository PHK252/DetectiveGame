extends HBoxContainer

#set globalvars.graphics_optimization = true/false
# perfect (lowkey unnecessary) = 
# AO + IIL (average)
# Atlas size (4096)

#regular  =
# AO + IIL (average)

# optimized
#AO + IIL (lowest)
# shadows (soft very low (positional + directional)
# atlas size (2048) + less cones
#

signal graphics_switch

func _on_option_button_item_selected(index: int) -> void:
	match index:
		0:
			GlobalVars.optimized_graphics = "average"
		1:
			GlobalVars.optimized_graphics = "ultra"
		2:
			GlobalVars.optimized_graphics = "optimized"
	
	emit_signal("graphics_switch")
