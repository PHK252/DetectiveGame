extends Node3D

@onready var resume_cam = $"../../ResumeCam"
@onready var main_cam = $"../../CamWindows"
@onready var player = $"../../../../../Characters/Dalton/CharacterBody3D"
@onready var cam_anim = $"../../ResumeCam/AnimationPlayer"
@onready var mouse_pos = Vector2(0,0) 
@onready var resume_interact = $"../../../../../UI/Resume"

@onready var dalton_maker = $"../../../../../UI/Dalton Marker"
@onready var juniper_marker = $"../../../../../UI/Juniper Marker"
#@onready var theo_marker = $"../../../../../UI/Theo Marker"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	mouse_pos = get_viewport().get_mouse_position()
	#print(mouse_pos) 
	if GlobalVars.in_look_screen == false and GlobalVars.in_dialogue == false:
		if mouse_pos.y >= 130:
			resume_cam.set_rotation_degrees(Vector3(-60, 0, 0))
		elif mouse_pos.y < 65:
			resume_cam.set_rotation_degrees(Vector3(-40, 0, 0))
		else:
			resume_cam.set_rotation_degrees(Vector3(-50, 0, 0))
	else:
		resume_cam.set_rotation_degrees(Vector3(-50, 0, 0))
	
	if GlobalVars.in_look_screen == false and GlobalVars.in_dialogue == false and GlobalVars.in_interaction == "resume":
		if Input.is_action_just_pressed("Exit") and GlobalVars.viewed_Juniper_resume == true and GlobalVars.resume_dialogue_Juniper == false and GlobalVars.viewing == "":
			GlobalVars.in_dialogue = true
			resume_cam.priority = 0
			main_cam.priority = 12
			await get_tree().create_timer(.03).timeout
			cam_anim.play("RESET")
			player.show()
			var case_dialogue = Dialogic.start("Juniper_Resumes")
			Dialogic.timeline_ended.connect(_on_timeline_ended)
			case_dialogue.register_character(load("res://Dialogic Characters/Dalton.dch"), dalton_maker)
			case_dialogue.register_character(load("res://Dialogic Characters/Juniper.dch"), juniper_marker)
			GlobalVars.in_interaction = ""
			GlobalVars.case_dialogue_Juniper = true
			resume_interact.hide()
		elif Input.is_action_just_pressed("Exit") and GlobalVars.viewing == "":
			#print("enter")
			resume_cam.priority = 0
			main_cam.priority = 12
			await get_tree().create_timer(.03).timeout
			cam_anim.play("RESET")
			player.show()
			player.start_player()
			GlobalVars.in_interaction = ""
			resume_interact.hide()
			
			#activate dialogue

	if GlobalVars.in_look_screen == true:
		resume_interact.hide()
	elif GlobalVars.in_look_screen == false and resume_cam.priority == 15:
		resume_interact.show()


func _on_timeline_ended():
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	GlobalVars.in_dialogue = false
	player.start_player()



func _on_bookshelf_interacted(interactor):
	if GlobalVars.in_look_screen == false:
		GlobalVars.in_interaction = "resume"
		resume_cam.priority = 15
		main_cam.priority = 0 
		resume_interact.show()
		cam_anim.play("Cam_Idle")
		player.hide()
		player.stop_player()
