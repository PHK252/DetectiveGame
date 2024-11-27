extends Area2D

@onready var object = $"."
@onready var resume = $"../../SubViewportContainer/SubViewport/SecondHouseUpdate/Interactable2"
@onready var look = $"../MultiPage"

func _on_input_event(viewport, event, shape_idx):
	if GlobalVars.in_look_screen == false:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed == true:
				resume.hide()
				object.hide()
				look.show()
				GlobalVars.viewing = "resume"
				GlobalVars.in_look_screen = true
				GlobalVars.clicked_resume_Juniper = GlobalVars.clicked_resume_Juniper + 1

	

func _on_exit_pressed():
	if GlobalVars.viewed_Juniper_resume == false and GlobalVars.clicked_resume_Juniper == 1:
		resume.show()
		object.show()
		GlobalVars.viewed_Juniper_resume = true
		GlobalVars.viewing = ""
	else:
		resume.show()
		GlobalVars.viewing = ""


func _input(event):
	if Input.is_action_just_pressed("Exit") and GlobalVars.viewing == "resume":
		if GlobalVars.viewed_Juniper_resume == false and GlobalVars.clicked_resume_Juniper == 1:
			resume.show()
			await get_tree().create_timer(.3).timeout
			GlobalVars.viewed_Juniper_resume = true
			GlobalVars.viewing = "" 
		else:
			resume.show()
			await get_tree().create_timer(.3).timeout
			GlobalVars.viewing = ""
	
	
