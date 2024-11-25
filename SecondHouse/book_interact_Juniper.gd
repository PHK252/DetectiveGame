extends Node3D

@onready var book_cam = $"../../BookCam"
@onready var main_cam = $"../../CamBooks"
@onready var player = $"../../../../../Characters/Dalton/CharacterBody3D"
@onready var cam_anim = $"../../BookCam/AnimationPlayer"
@onready var mouse_pos = Vector2(0,0) 
@onready var bookmark_interact = $"../../../../../UI/Bookmark"

@onready var dalton_maker = $"../../../../../UI/Dalton Marker"
@onready var juniper_marker = $"../../../../../UI/Juniper Marker"
@onready var theo_marker = $"../../../../../UI/Theo Marker"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	mouse_pos = get_viewport().get_mouse_position()
	#print(mouse_pos) 
	if GlobalVars.in_look_screen == false and GlobalVars.in_dialogue == false:
		if mouse_pos.y >= 130:
			book_cam.set_rotation_degrees(Vector3(-20, -90, 0))
		elif mouse_pos.y < 65:
			book_cam.set_rotation_degrees(Vector3(8, -90, 0))
		else:
			book_cam.set_rotation_degrees(Vector3(0, -90, 0))
	else:
		book_cam.set_rotation_degrees(Vector3(-20, -90, 0))
	
	if GlobalVars.in_look_screen == false and GlobalVars.in_dialogue == false and GlobalVars.in_interaction == "book":
		if Input.is_action_just_pressed("Exit") and GlobalVars.viewed_Micah_bookmark == true and GlobalVars.book_dialogue == false and GlobalVars.viewing == "":
			#print("enter dialogue")
			book_cam.priority = 0
			main_cam.priority = 12
			await get_tree().create_timer(.03).timeout
			cam_anim.play("RESET")
			player.show()
			var book_dialogue = Dialogic.start("Juniper_Book")
			Dialogic.timeline_ended.connect(_on_timeline_ended)
			book_dialogue.register_character(load("res://Dialogic Characters/Dalton.dch"), dalton_maker)
			book_dialogue.register_character(load("res://Dialogic Characters/Micah.dch"), juniper_marker)
			book_dialogue.register_character(load("res://Dialogic Characters/Theo.dch"), theo_marker)
			GlobalVars.in_interaction = ""
			GlobalVars.book_dialogue = true
			bookmark_interact.hide()
			#main_cam.set_tween_duration(1)
		elif Input.is_action_just_pressed("Exit") and GlobalVars.viewing == "":
			print("enter")
			book_cam.priority = 0
			main_cam.priority = 12
			await get_tree().create_timer(.03).timeout
			cam_anim.play("RESET")
			player.show()
			player.start_player()
			#main_cam.set_tween_duration(1)
			GlobalVars.in_interaction = ""
			bookmark_interact.hide()
			
			#activate dialogue

	if GlobalVars.in_look_screen == true:
		bookmark_interact.hide()
	elif GlobalVars.in_look_screen == false and book_cam.priority == 15:
		bookmark_interact.show()


func _on_timeline_ended():
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	GlobalVars.in_dialogue = false
	player.start_player()



func _on_bookshelf_interacted(interactor):
	GlobalVars.in_interaction = "book"
	book_cam.priority = 15
	main_cam.priority = 0 
	bookmark_interact.show()
	cam_anim.play("Cam_Idle")
	player.hide()
	player.stop_player()
