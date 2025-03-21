extends Area2D

@onready var object = $"."
@onready var look = $"../Missing Look"
@onready var alert = $"../MissingHover"

func _on_input_event(viewport, event, shape_idx):
	if GlobalVars.in_look_screen == false:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed == true:
				object.hide()
				look.show()
				alert.hide()
				GlobalVars.in_look_screen = true
				GlobalVars.viewing = "missing"
				print("missing")


func _on_exit_pressed():
	GlobalVars.viewing = ""

func _process(delta):
	if Input.is_action_just_pressed("Exit") and GlobalVars.viewing == "missing":
		GlobalVars.viewing = ""



func _on_mouse_entered():
	if GlobalVars.in_look_screen == false and GlobalVars.in_dialogue == false:
		alert.show()


func _on_mouse_exited():
	alert.hide()
