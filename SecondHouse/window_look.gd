extends Node3D

@onready var window_cam = $"../../WindowCam"
@onready var main_cam = $"../../CamWindows"
@onready var player = $"../../../../../Characters/Dalton/CharacterBody3D"
@onready var cam_anim = $"../../WindowCam/AnimationPlayer"
@onready var mouse_pos = Vector2(0,0) 
@onready var dalton_maker = $"../../../../../UI/Dalton Marker"
@onready var juniper_marker = $"../../../../../UI/Juniper Marker"
@onready var theo_marker = $"../../../../../UI/Theo Marker"


func _process(delta):
	mouse_pos = get_viewport().get_mouse_position()
	if GlobalVars.in_look_screen == false and GlobalVars.in_dialogue == false:
		if mouse_pos.y >= 150:
			window_cam.set_rotation_degrees(Vector3(-10, 0, 0))
		elif mouse_pos.y < 50:
			window_cam.set_rotation_degrees(Vector3(10, 0, 0))
		else:
			window_cam.set_rotation_degrees(Vector3(0, 0, 0))
				#pass
	else:
		window_cam.set_rotation_degrees(Vector3(0, 0, 0))

	if GlobalVars.in_look_screen == false and GlobalVars.in_dialogue == false and GlobalVars.in_interaction == "window":
		if Input.is_action_just_pressed("Exit"):
			window_cam.priority = 0
			main_cam.priority = 12
			await get_tree().create_timer(.03).timeout
			cam_anim.play("RESET")
			player.show()
			GlobalVars.in_interaction = ""
			player.start_player()
		
		
func _on_timeline_ended():
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	GlobalVars.viewed_Juniper_window = true
	GlobalVars.in_dialogue = false
	#player.start_player()



func _on_interactable_interacted(interactor):
	if GlobalVars.in_dialogue == false:
		GlobalVars.in_interaction = "window"
		window_cam.priority = 15
		main_cam.priority = 0 
		cam_anim.play("Cam_Idle")
		player.hide()
		player.stop_player()
		if GlobalVars.viewed_Juniper_window == false:
			GlobalVars.in_dialogue = true
			Dialogic.start("Juniper_Window_Thoughts")
			Dialogic.timeline_ended.connect(_on_timeline_ended)
