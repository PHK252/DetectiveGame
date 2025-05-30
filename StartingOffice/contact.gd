extends Area2D

@onready var object = $"."
@export var intact_ad : MeshInstance3D
@export var ripped_ad : MeshInstance3D
@export var intact_look : CanvasLayer
@export var ripped_look : CanvasLayer
@export var click : AudioStreamPlayer
@onready var ad_took = false

func _on_input_event(viewport, event, shape_idx):
	if GlobalVars.in_look_screen == false:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed == true:
				ad_took = Dialogic.VAR.get_variable("Global.got_theo_ad")
				click.play()
				object.hide()
				if ad_took == false:
					intact_look.show()
				else:
					ripped_look.show()
				GlobalVars.viewing = "contact"
				GlobalVars.in_look_screen = true
				GlobalVars.clicked_contact = GlobalVars.clicked_contact + 1

func _on_timeline_ended():
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	GlobalVars.in_dialogue = false
	check_ripped()

func _on_exit_pressed():
	if ad_took == false:
		GlobalVars.in_dialogue = true
		Dialogic.timeline_ended.connect(_on_timeline_ended)
		Dialogic.start("Office_contact_ad")
		GlobalVars.viewed_contact == true
		GlobalVars.viewing = ""

func _process(delta):
	if Input.is_action_just_pressed("Exit") and GlobalVars.viewing == "contact":
		if ad_took == false:
			GlobalVars.in_dialogue = true
			Dialogic.timeline_ended.connect(_on_timeline_ended)
			Dialogic.start("Office_contact_ad")
			GlobalVars.viewed_contact == true
			GlobalVars.viewing = ""

func check_ripped():
	ad_took = Dialogic.VAR.get_variable("Global.got_theo_ad")
	if ad_took == false:
		intact_ad.show()
		ripped_ad.hide()
	else:
		ripped_ad.show()
		intact_ad.hide()
