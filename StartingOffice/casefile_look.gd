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


func _on_input_event(viewport, event, shape_idx):
	if GlobalVars.in_look_screen == false:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed == true:
				object_in_scene.hide()
				object_interact.hide()
				UI_look.show()
				GlobalVars.viewing = viewing
				GlobalVars.in_look_screen = true
				clicked_count += 1
				GlobalVars.set(clicked_object, clicked_count)
				

func _on_exit_pressed():
	#print("exit")
	if viewed_object == false and clicked_count == 1:
		#print("set")
		GlobalVars.set(view_object, true)
	else:
		GlobalVars.set(view_object, true)

func _input(event):
	if Input.is_action_just_pressed("Exit") and GlobalVars.viewing == viewing:
		if viewed_object == false and clicked_count == 1:
			GlobalVars.set(view_object, true)
		else:
			GlobalVars.set(view_object, true)
