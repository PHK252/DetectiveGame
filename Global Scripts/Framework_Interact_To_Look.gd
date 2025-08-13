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
@export var is_there_anim: bool = false
@export var is_there_thoughts: bool = false
@export var add_note: bool = false

#Animation if there is one
@export var anim: AnimationPlayer
@export var anim_track: String


#Dialogue if there is a single thought behind those eyes
@export var dialogue_file : String

#bookmark swipe
@export var note_swipe : AudioStreamPlayer3D
@export var paper : AudioStreamPlayer

func _on_input_event(viewport, event, shape_idx):
	if GlobalVars.in_look_screen == false:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed == true:
				if is_there_anim == true:
					if clicked_object == "clicked_book_note" or "clicked_bookmark_Juniper":
						note_swipe.play()
					anim.play(anim_track)
					await anim.animation_finished
					await get_tree().create_timer(.5).timeout
					anim.play("RESET")
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
	if viewed_object == false and clicked_count == 1:
		if is_there_thoughts == true:
			object_interact.show()
			object_in_scene.show()
			GlobalVars.in_dialogue = true
			Dialogic.timeline_ended.connect(_on_timeline_ended)
			Dialogic.start(dialogue_file)
			GlobalVars.set(view_object, true)
		else:
			GlobalVars.set(view_object, true)
			object_in_scene.show()
			object_interact.show() # might not need?
	else:
		GlobalVars.set(view_object, true)
		object_in_scene.show()
		object_interact.show() # might not need?


func _on_timeline_ended():
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	GlobalVars.in_dialogue = false
	object_interact.show()

func _input(event):
	if Input.is_action_just_pressed("Exit") and GlobalVars.viewing == viewing:
		if viewed_object == false and clicked_count == 1:
			if is_there_thoughts == true:
				object_interact.show()
				object_in_scene.show()
				GlobalVars.in_dialogue = true
				Dialogic.timeline_ended.connect(_on_timeline_ended)
				Dialogic.start(dialogue_file)
				GlobalVars.set(view_object, true)
			else:
				object_in_scene.show()
				object_interact.show() # might not need?
				GlobalVars.set(view_object, true)
			if add_note == true:
				GlobalVars.emit_add_note(GlobalVars.current_level, viewing, "found")
		else:
			object_in_scene.show()
			object_interact.show() # might not need?

			GlobalVars.set(view_object, true)
