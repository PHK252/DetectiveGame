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
				GlobalVars.clicked_team = GlobalVars.clicked_team + 1

				
func _on_timeline_ended():
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	GlobalVars.in_dialogue = false

func _on_exit_pressed():
	if GlobalVars.viewed_team == false and GlobalVars.clicked_team == 1:
		GlobalVars.in_dialogue = true
		Dialogic.timeline_ended.connect(_on_timeline_ended)
		Dialogic.start("Office_Team_Picture")
		GlobalVars.viewed_team == true



func _on_mouse_entered():
	$"../../SubViewportContainer/SubViewport/StartingOffice/Sprite3D".show()

func _on_mouse_exited():
	$"../../SubViewportContainer/SubViewport/StartingOffice/Sprite3D".hide()