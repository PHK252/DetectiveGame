extends Node3D

@onready var house_cam = $"../../HouseCam"
@onready var main_cam = $"../../CamFurnace"
@onready var player = $"../../../../../Characters/Dalton/CharacterBody3D"
@onready var cam_anim = $"../../HouseCam/AnimationPlayer"

@onready var mouse_pos = Vector2(0,0) 
@onready var is_looking = false


@onready var dalton_maker = $"../../../../../UI/Dalton Marker"
@onready var juniper_marker = $"../../../../../UI/Juniper Marker"


func _process(delta):
	mouse_pos = get_viewport().get_mouse_position()
	if GlobalVars.in_look_screen == false and GlobalVars.in_dialogue == false:
		if mouse_pos.y >= 700:
			house_cam.set_rotation_degrees(Vector3(-25, -180, 0))
		elif mouse_pos.y < 120:
			house_cam.set_rotation_degrees(Vector3(0, -180, 0))
		else:
			house_cam.set_rotation_degrees(Vector3(-9, -180, 0))
				#pass
	else:
		house_cam.set_rotation_degrees(Vector3(-9, -180, 0))
	
	#var dialogue_pick = Dialogic.VAR.get_variable("Asked Questions.Micah_cab")
	if GlobalVars.in_look_screen == false and GlobalVars.in_dialogue == false and GlobalVars.in_interaction == "house":
		#print("whjat")
		if Input.is_action_just_pressed("Exit") and GlobalVars.viewed_Juniper_house_pic == false:
			GlobalVars.viewed_Juniper_house_pic = true
			GlobalVars.in_dialogue = true
			house_cam.priority = 0
			main_cam.priority = 12
			await get_tree().create_timer(.03).timeout
			cam_anim.play("RESET")
			player.show()
			GlobalVars.in_interaction = ""
			var house_dialogue = Dialogic.start("Juniper_Old_House_Pics")
			Dialogic.timeline_ended.connect(_on_timeline_ended)
			house_dialogue.register_character(load("res://Dialogic Characters/Dalton.dch"), dalton_maker)
			house_dialogue.register_character(load("res://Dialogic Characters/Juniper.dch"), juniper_marker)
		elif Input.is_action_just_pressed("Exit") and GlobalVars.viewed_Juniper_house_pic == true:
			#print("no click")
			house_cam.priority = 0
			main_cam.priority = 12
			await get_tree().create_timer(.03).timeout
			cam_anim.play("RESET")
			player.show()
			player.start_player()
			main_cam.set_tween_duration(1)
			GlobalVars.in_interaction = ""
		
		
func _on_timeline_ended():
	#print("end")
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	GlobalVars.in_dialogue = false
	player.start_player()


func _on_house_pic_interacted(interactor):
	if GlobalVars.in_dialogue == false:
		GlobalVars.in_interaction = "house"
		house_cam.priority = 15
		main_cam.priority = 0 
		cam_anim.play("Cam_Idle")
		player.hide()
		player.stop_player()
