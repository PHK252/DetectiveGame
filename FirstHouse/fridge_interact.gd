extends Node3D

@onready var fridge_cam =  $"../../SubViewport/CameraSystem/Fridge"
@onready var main_cam = $"../../SubViewport/CameraSystem/livingroom"
@onready var player = $"../../../Characters/Dalton/CharacterBody3D"
@onready var cam_anim = $"../../SubViewport/CameraSystem/Fridge/AnimationPlayer"
@onready var mouse_pos = Vector2(0,0) 
@onready var fridge_open = false
@onready var fridge_anim = $"../AnimationPlayer"
@onready var fridge_open_area = $Fridge_open
@onready var fridge_close_area = $Fridge_close
@onready var in_anim = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	mouse_pos = get_viewport().get_mouse_position()
	#print(mouse_pos) 
	if GlobalVars.in_look_screen == false and GlobalVars.in_dialogue == false:
		if mouse_pos.y >= 550:
			fridge_cam.set_rotation_degrees(Vector3(-33.5, -87.1, -1.3))
		else:
			fridge_cam.set_rotation_degrees(Vector3(-20.1, -87.1, -1.3))
	else:
		fridge_cam.set_rotation_degrees(Vector3(-33.5, -87.1, -1.3))
	
	if GlobalVars.in_look_screen == false and GlobalVars.in_dialogue == false and GlobalVars.in_interaction == "fridge":
		if Input.is_action_just_pressed("Exit") and in_anim == false:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			fridge_open_area.hide()
			fridge_close_area.hide()
			fridge_cam.priority = 0
			main_cam.priority = 24
			await get_tree().create_timer(.03).timeout
			cam_anim.play("RESET")
			player.show()
			player.start_player()
			GlobalVars.in_interaction = ""


func _on_interactable_interacted(interactor):
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	GlobalVars.in_interaction = "fridge"
	fridge_cam.priority = 24
	main_cam.priority = 0 
	cam_anim.play("Cam_Idle")
	player.hide()
	player.stop_player()
	if fridge_open == false:
		fridge_open_area.show()
	elif fridge_open == true:
		fridge_close_area.show()



func _on_fridge_open_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed == true:
			GlobalVars.in_look_screen = true
			in_anim = true
			fridge_open_area.hide()
			fridge_open = true
			fridge_anim.play("NEWfridgeopen")
			await fridge_anim.animation_finished
			in_anim = false
			if GlobalVars.viewed_Micah_fridge == false:
				GlobalVars.in_dialogue = true
				Dialogic.timeline_ended.connect(_on_timeline_ended)
				Dialogic.start("Micah_Fridge_thoughts")
			else:
				GlobalVars.in_look_screen = false
				fridge_close_area.show()

func _on_fridge_close_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed == true:
			GlobalVars.in_look_screen = true
			in_anim = true
			fridge_open = false
			fridge_close_area.hide()
			fridge_anim.play_backwards("NEWfridgeopen")
			await fridge_anim.animation_finished
			GlobalVars.in_look_screen = false
			fridge_open_area.show()
			in_anim = false

func _on_timeline_ended():
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	GlobalVars.in_dialogue = false
	GlobalVars.in_look_screen = false
	fridge_close_area.show()
	GlobalVars.viewed_Micah_fridge = true
