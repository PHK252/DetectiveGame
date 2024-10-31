extends Area2D

@onready var object = $"."
@onready var look = $"../TeamPic Look"

func _on_input_event(viewport, event, shape_idx):
	if GlobalVars.in_look_screen == false:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed == true:
				object.hide()
				$"../../SubViewportContainer/SubViewport/StartingOffice/Sprite3D".hide()
				look.show()
				GlobalVars.in_look_screen = true
				print("team")



func _on_mouse_entered():
	$"../../SubViewportContainer/SubViewport/StartingOffice/Sprite3D".show()

func _on_mouse_exited():
	$"../../SubViewportContainer/SubViewport/StartingOffice/Sprite3D".hide()
