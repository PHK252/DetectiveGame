extends Area2D

#Assign object in 2D and 3D
@export var object_interact: Area2D
@export var  object_in_scene: Resource

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
@export var is_there_anim: bool = false
@export var is_there_thoughts: bool = false

#Animation if there is one
@export var anim: AnimationPlayer
@export var anim_track: String


#Dialogue if there is a single thought behind those eyes
@export var dialogue_file : String


func _on_input_event(viewport, event, shape_idx):
	if GlobalVars.in_look_screen == false:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed == true:
				if is_there_anim == true:
					anim.play(anim_track)
					await anim.animation_finished
					await get_tree().create_timer(.5).timeout
					anim.play("RESET")
				object_in_scene.hide()
				object_interact.hide()
				UI_look.show()
				GlobalVars.viewing = viewing
				GlobalVars.in_look_screen = true
				clicked_count += 1

func _on_exit_pressed():
	if viewed_object == false and clicked_count == 1:
		if is_there_thoughts == true:
			object_in_scene.show()
			GlobalVars.in_dialogue = true
			Dialogic.timeline_ended.connect(_on_timeline_ended)
			Dialogic.start(dialogue_file)
			viewed_object = true
			GlobalVars.viewing = ""
		else:
			object_in_scene.show()
			object_interact.show() # might not need?
	else:
		object_in_scene.show()
		object_interact.show() # might not need?
		GlobalVars.viewing = ""


func _on_timeline_ended():
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	GlobalVars.in_dialogue = false
	object_interact.show()

func _input(event):
	if Input.is_action_just_pressed("Exit") and GlobalVars.viewing == viewing:
		if viewed_object == false and clicked_count == 1:
			if is_there_thoughts == true:
				object_in_scene.show()
				GlobalVars.in_dialogue = true
				Dialogic.timeline_ended.connect(_on_timeline_ended)
				Dialogic.start(dialogue_file)
				viewed_object = true
				GlobalVars.viewing = ""
			else:
				object_in_scene.show()
				object_interact.show() # might not need?
		else:
			object_in_scene.show()
			object_interact.show() # might not need?
			GlobalVars.viewing = ""
