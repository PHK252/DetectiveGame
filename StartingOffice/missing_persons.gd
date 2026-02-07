extends Area2D

@onready var object = $"."
@onready var look = $"../Missing Look"
@export var click : AudioStreamPlayer

signal _show_tut(tut_type : String)

func _on_input_event(viewport, event, shape_idx):
	if GlobalVars.in_look_screen == false:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed == true:
				click.play()
				object.hide()
				look.show()
				GlobalVars.in_look_screen = true
				GlobalVars.clicked_missing += 1
				GlobalVars.viewing = "missing"


func _on_timeline_ended():
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	GlobalVars.in_dialogue = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if GlobalVars.exit_tut == false:
		emit_signal("_show_tut", "exit")

func _on_exit_pressed():
	if GlobalVars.viewed_missing == false and GlobalVars.clicked_missing == 1:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		GlobalVars.in_dialogue = true
		Dialogic.timeline_ended.connect(_on_timeline_ended)
		Dialogic.start("Office_Missing")
		GlobalVars.viewed_missing == true
		GlobalVars.viewing = ""
	else:
		if GlobalVars.exit_tut == false:
			emit_signal("_show_tut", "exit")

func _process(delta):
	if Input.is_action_just_pressed("Exit") and GlobalVars.viewing == "missing":
		if GlobalVars.viewed_missing == false and GlobalVars.clicked_missing == 1:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			GlobalVars.in_dialogue = true
			Dialogic.timeline_ended.connect(_on_timeline_ended)
			Dialogic.start("Office_Missing")
			GlobalVars.viewed_missing == true
			GlobalVars.viewing = ""
		else:
			if GlobalVars.exit_tut == false:
				emit_signal("_show_tut", "exit")
