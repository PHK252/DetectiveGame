extends Node3D

@onready var pic_cam = $"../../../../../../SubViewport/CameraSystem/Picture"
@onready var main_cam = $"../../../../../../SubViewport/CameraSystem/livingroom"
@onready var player = $"../../../../../../../Characters/Dalton/CharacterBody3D"
@onready var cam_anim = $"../../../../../../SubViewport/CameraSystem/Picture/AnimationPlayer"
@onready var pic_fall = $"../Pic fall Interact"
@onready var pic_look = $"../Picture Look"
@onready var mouse_pos = Vector2(0,0)

@onready var dalton_marker = $"../../../../../../../UI/Dalton_marker"
@onready var micah_marker = $"../../../../../../../UI/Micah_marker"
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	mouse_pos = get_viewport().get_mouse_position()
	#print(mouse_pos) 
	if GlobalVars.in_look_screen == false and GlobalVars.in_dialogue == false:
		if mouse_pos.y >= 700:
			pic_cam.set_rotation_degrees(Vector3(-45.4, 177.7, 1))
		elif mouse_pos.y < 120:
			pic_cam.set_rotation_degrees(Vector3(-5.4, 177.7, 1))
		else:
			pic_cam.set_rotation_degrees(Vector3(-25.4, 177.7, 1))
				#pass
	else:
		pic_cam.set_rotation_degrees(Vector3(-25.4, 177.7, 1))
	
	if GlobalVars.in_look_screen == false and GlobalVars.in_dialogue == false and GlobalVars.in_interaction == "picture":
		if Input.is_action_just_pressed("Exit") and GlobalVars.viewing == "" and GlobalVars.Micah_pic_dialogue == false and GlobalVars.pic_fell == true:
			GlobalVars.Micah_pic_dialogue == true
			pic_cam.priority = 0
			main_cam.priority = 12
			await get_tree().create_timer(.03).timeout
			cam_anim.play("RESET")
			player.show()
			#player.start_player()
			GlobalVars.in_dialogue = true
			#main_cam.set_tween_duration(1)
			GlobalVars.in_interaction = ""
			pic_fall.hide()
			pic_look.hide()
			Dialogic.timeline_ended.connect(_on_timeline_ended)
			var pic_Dialogue = Dialogic.start("Micah_pic_ask")
			pic_Dialogue.register_character(load("res://Dialogic Characters/Dalton.dch"), dalton_marker)
			pic_Dialogue.register_character(load("res://Dialogic Characters/Micah.dch"), micah_marker)
		elif Input.is_action_just_pressed("Exit") and GlobalVars.viewing == "": 
			pic_cam.priority = 0
			main_cam.priority = 12
			await get_tree().create_timer(.03).timeout
			cam_anim.play("RESET")
			player.show()
			player.start_player()
			GlobalVars.in_interaction = ""
			pic_fall.hide()
			pic_look.hide()
			
	if GlobalVars.in_look_screen == true and GlobalVars.pic_fell == true:
		pic_look.hide()
	elif GlobalVars.in_look_screen == false and pic_cam.priority == 15 and GlobalVars.pic_fell == true:
		pic_look.show()

func _on_interactable_interacted(interactor):
	if GlobalVars.in_dialogue == false:
		GlobalVars.in_interaction = "picture"
		pic_cam.priority = 15
		main_cam.priority = 0
		cam_anim.play("Cam_Idle")
		player.hide()
		player.stop_player()
		if GlobalVars.pic_fell == false:
			pic_fall.show()
		else:
			pic_look.show()
	
func _on_timeline_ended():
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	GlobalVars.in_dialogue = false
	player.start_player()
	
