extends RayCast2D

var collider_mem = null
func _input(event):
	global_position = get_global_mouse_position()
	if is_colliding():
		var collider = get_collider()
		if collider != collider_mem:
			if collider.visible == true:
				if collider.name == "RightHover" or collider.name == "LeftHover":
					return
				collider_mem = collider
				print("Hovering over: ", collider.name, "/Look Screen: ", GlobalVars.in_look_screen, "/Interaction: ", GlobalVars.in_interaction)
