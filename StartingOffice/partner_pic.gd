extends Area2D

@onready var object = $"."
@onready var look = $"../Partner Look"
@onready var alert = $"../PartnerHover"

func _on_input_event(viewport, event, shape_idx):
	if GlobalVars.in_look_screen == false:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed == true:
				object.hide()
				look.show()
				alert.hide()
				GlobalVars.viewing = "partner"
				GlobalVars.in_look_screen = true
				GlobalVars.clicked_partner = GlobalVars.clicked_partner + 1
				
				
func _on_timeline_ended():
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	GlobalVars.in_dialogue = false


func _on_exit_pressed():
	if GlobalVars.viewed_partner == false and GlobalVars.clicked_partner == 1:
		GlobalVars.in_dialogue = true
		Dialogic.timeline_ended.connect(_on_timeline_ended)
		Dialogic.start("Office_Partner_Picture")
		GlobalVars.viewed_partner == true
		GlobalVars.viewing = ""

func _process(delta):
	if Input.is_action_just_pressed("Exit") and GlobalVars.viewing == "partner":
		if GlobalVars.viewed_partner == false and GlobalVars.clicked_partner == 1:
			GlobalVars.in_dialogue = true
			Dialogic.timeline_ended.connect(_on_timeline_ended)
			Dialogic.start("Office_Partner_Picture")
			GlobalVars.viewed_partner == true
			GlobalVars.viewing = ""

func _on_mouse_entered():
	if GlobalVars.in_look_screen == false and GlobalVars.in_dialogue == false:
		alert.show()

func _on_mouse_exited():
	alert.hide()
