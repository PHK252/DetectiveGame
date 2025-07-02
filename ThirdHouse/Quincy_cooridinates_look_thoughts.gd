extends Area2D

#Assign object in 2D and 3D
@export var object_interact: Area2D
@export var  object_in_scene: MeshInstance3D

#UI Overlay
@export var UI_look: CanvasLayer

#Globals
@export var viewing : String
@export var clicked_object : String
@export var view_object: String

#Access Globals
@onready var clicked_count = GlobalVars.get(clicked_object)
@onready var viewed_object = GlobalVars.get(view_object)

#Bools to check 
@export var is_there_thoughts: bool = false


#Dialogue if there is a single thought behind those eyes
@export var dialogue_file : String

#bookmark swipe
@export var note_swipe : AudioStreamPlayer3D
@export var paper : AudioStreamPlayer

func _on_input_event(viewport, event, shape_idx):
	if GlobalVars.in_look_screen == false:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed == true:
				#if clicked_object == "clicked_Micah_pic" or "clicked_tool_note" or "clicked_coor_Quincy":
						#paper.play()
				object_in_scene.hide()
				object_interact.hide()
				UI_look.show()
				GlobalVars.viewing = viewing
				GlobalVars.in_look_screen = true
				clicked_count += 1
				GlobalVars.set(clicked_object, clicked_count)
				

func _on_exit_pressed():
	if Dialogic.VAR.get_variable("Quincy.has_secret_coor") == false:
		object_interact.show()
		object_in_scene.show()
		GlobalVars.in_dialogue = true
		Dialogic.timeline_ended.connect(_on_timeline_ended)
		Dialogic.start(dialogue_file)
		if viewed_object == false: 
			GlobalVars.set(view_object, true)
	else:
		object_interact.hide()
		object_in_scene.hide()


func _on_timeline_ended():
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	GlobalVars.in_dialogue = false
	object_interact.show()

func _input(event):
	if Input.is_action_just_pressed("Exit") and GlobalVars.viewing == viewing:
		if Dialogic.VAR.get_variable("Quincy.has_secret_coor") == false:
			object_interact.show()
			object_in_scene.show()
			GlobalVars.in_dialogue = true
			Dialogic.timeline_ended.connect(_on_timeline_ended)
			Dialogic.start(dialogue_file)
			if viewed_object == false: 
				GlobalVars.set(view_object, true)
		else:
			object_interact.hide()
			object_in_scene.hide()
