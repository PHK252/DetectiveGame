extends Node

var in_area = false


func _on_cab_mouse_entered():
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	in_area = true
	#if GlobalVars.in_look_screen == false and GlobalVars.in_dialogue == false and in_area == true:
		#GlobalVars.set_mouse_pointing()


func _on_cab_mouse_exited():
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	#print("exit cab")
	in_area = false
	#if in_area == false:
		#GlobalVars.set_mouse_default()
#
#func _input(event):
	#if event is InputEventMouseMotion:
		#if in_area == true:
			#print("pointing")
			#GlobalVars.set_mouse_pointing()
		#else:
			#print("default")
			#GlobalVars.set_mouse_default()
