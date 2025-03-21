extends Area2D

@onready var object = $"."
@onready var look = $"../../UI/Tool_note"
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_input_event(viewport, event, shape_idx):
	if GlobalVars.in_look_screen == false:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed == true:
				object.hide()
				look.show()
				GlobalVars.viewing = "tool note"
				GlobalVars.in_look_screen = true
				GlobalVars.clicked_tool_note = GlobalVars.clicked_tool_note + 1
	pass # Replace with function body.
	

func _on_exit_pressed():
	if GlobalVars.viewed_tool_note == false and GlobalVars.clicked_tool_note == 1:
		#print("hello")
		GlobalVars.in_dialogue = true
		Dialogic.timeline_ended.connect(_on_timeline_ended)
		Dialogic.start("Micah_closet_note_thoughts")
		GlobalVars.viewed_tool_note = true
		GlobalVars.viewing = ""
	else:
		GlobalVars.viewing = ""
		#GlobalVars.in_look_screen = false

func _on_timeline_ended():
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	GlobalVars.in_dialogue = false

func _input(event):
	if Input.is_action_just_pressed("Exit") and GlobalVars.viewing == "tool note":
		if GlobalVars.viewed_tool_note == false and GlobalVars.clicked_tool_note == 1:
			GlobalVars.in_dialogue = true
			Dialogic.timeline_ended.connect(_on_timeline_ended)
			Dialogic.start("Micah_closet_note_thoughts")
			GlobalVars.viewed_tool_note = true
			GlobalVars.viewing = ""
		else:
			#await get_tree().create_timer(.5).timeout
			GlobalVars.viewing = ""
			
