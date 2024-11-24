extends Node3D

@onready var cafe_cam = $"../../CafeCam"
@onready var main_cam = $"../../CamBooks"
@onready var player = $"../../../../../Characters/Dalton/CharacterBody3D"
@onready var cam_anim = $"../../CafeCam/AnimationPlayer"
@onready var mouse_pos = Vector2(0,0) 
@onready var dalton_maker = $"../../../../../UI/Dalton Marker"
@onready var juniper_marker = $"../../../../../UI/Juniper Marker"
@onready var theo_marker = $"../../../../../UI/Theo Marker"


func _process(delta):
	mouse_pos = get_viewport().get_mouse_position()
	if GlobalVars.in_look_screen == false and GlobalVars.in_dialogue == false:
		if mouse_pos.y >= 150:
			cafe_cam.set_rotation_degrees(Vector3(-8, 90, 0))
		elif mouse_pos.y < 50:
			cafe_cam.set_rotation_degrees(Vector3(8, 90, 0))
		else:
			cafe_cam.set_rotation_degrees(Vector3(0, 90, 0))
				#pass
	else:
		cafe_cam.set_rotation_degrees(Vector3(0, 90, 0))

	if GlobalVars.in_look_screen == false and GlobalVars.in_dialogue == false and GlobalVars.in_interaction == "cafe":
		if Input.is_action_just_pressed("Exit") and GlobalVars.viewed_Juniper_cafe_pic == false:
			GlobalVars.viewed_Juniper_cafe_pic = true
			GlobalVars.in_dialogue = true
			cafe_cam.priority = 0
			main_cam.priority = 12
			await get_tree().create_timer(.03).timeout
			cam_anim.play("RESET")
			player.show()
			GlobalVars.in_interaction = ""
			var house_dialogue = Dialogic.start("Juniper_Cafe_Pic")
			Dialogic.timeline_ended.connect(_on_timeline_ended)
			house_dialogue.register_character(load("res://Dialogic Characters/Dalton.dch"), dalton_maker)
			house_dialogue.register_character(load("res://Dialogic Characters/Juniper.dch"), juniper_marker)
			house_dialogue.register_character(load("res://Dialogic Characters/Theo.dch"), theo_marker)
		elif Input.is_action_just_pressed("Exit") and GlobalVars.viewed_Juniper_cafe_pic == true:
			cafe_cam.priority = 0
			main_cam.priority = 12
			await get_tree().create_timer(.03).timeout
			cam_anim.play("RESET")
			player.show()
			player.start_player()
			GlobalVars.in_interaction = ""
		
		
func _on_timeline_ended():
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	GlobalVars.in_dialogue = false
	player.start_player()


func _on_cafe_pic_interacted(interactor):
	if GlobalVars.in_dialogue == false:
		GlobalVars.in_interaction = "cafe"
		cafe_cam.priority = 15
		main_cam.priority = 0 
		cam_anim.play("Cam_Idle")
		player.hide()
		player.stop_player()
