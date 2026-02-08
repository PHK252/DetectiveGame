extends Node3D

#Assign first person cam and exit cam + idle animation
@export var FP_Cam: PhantomCamera3D
@export var Exit_Cam: PhantomCamera3D

#First Person cam anim + movement
@export var cam_anim: AnimationPlayer
@export var tilt_up_thres: int
@export var tilt_down_thres: int
@export var tilt_up_angle: Vector3
@export var tilt_down_angle: Vector3
@export var mid_angle: Vector3

#Assign player body
@export var player: CharacterBody3D
@export var alert: Sprite3D

#Assign character markers (up to 3)
@export var dalton_marker: Marker2D
@export var theo_marker: Marker2D
@export var character_marker: Marker2D

#Interaction Variables
@export var interact_area_fall: Area2D
@export var interact_area_look : Area2D
@export var dialogue_file: String
@export var load_Dalton_dialogue: String
@export var load_Theo_dialogue: String
@export var load_char_dialogue: String

#Load Global Variables
@export var interact_type: String
@export var dialogue: String
@export var pic_status : String

#set defaults
@onready var mouse_pos = Vector2(0,0) 

#sound
signal general_interact
signal general_quit

signal enable_look
signal disable_look


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var pic_fell : bool = GlobalVars.get(pic_status)
	var read_dialogue : bool = GlobalVars.get(dialogue)
	mouse_pos = get_viewport().get_mouse_position()
	#print(mouse_pos) 
	if GlobalVars.in_look_screen == false and GlobalVars.in_dialogue == false and FP_Cam.priority == 30:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		if mouse_pos.y >= tilt_up_thres:
			FP_Cam.set_rotation_degrees(tilt_up_angle)
		elif mouse_pos.y < tilt_down_thres:
			FP_Cam.set_rotation_degrees(tilt_down_angle)
		else:
			FP_Cam.set_rotation_degrees(mid_angle)
				#pass
	else:
		FP_Cam.set_rotation_degrees(tilt_up_angle)
	
	if GlobalVars.in_look_screen == false and GlobalVars.in_dialogue == false and GlobalVars.in_interaction == interact_type:
		if Input.is_action_just_pressed("Exit") and GlobalVars.viewed_Micah_pic == true and pic_fell == true and read_dialogue == false and GlobalVars.viewing == "" and GlobalVars.micah_kicked_out == false and GlobalVars.micah_time_out == false:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			Exit_Cam.set_tween_duration(0)
			FP_Cam.priority = 0
			Exit_Cam.priority = 30
			emit_signal("general_quit")
			await get_tree().create_timer(.03).timeout
			cam_anim.play("RESET")
			player.show()
			emit_signal("enable_look")
			var book_dialogue = Dialogic.start(dialogue_file)
			Dialogic.timeline_ended.connect(_on_timeline_ended)
			GlobalVars.in_interaction = ""
			GlobalVars.set(dialogue, true)
			interact_area_fall.hide()
			interact_area_look.hide()
			alert.hide()
		elif Input.is_action_just_pressed("Exit") and GlobalVars.viewing == "":
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			Exit_Cam.set_tween_duration(0)
			FP_Cam.priority = 0
			Exit_Cam.priority = 30
			emit_signal("general_quit")
			await get_tree().create_timer(.03).timeout
			cam_anim.play("RESET")
			player.show()
			player.start_player()
			#main_cam.set_tween_duration(1)
			GlobalVars.in_interaction = ""
			interact_area_fall.hide()
			interact_area_look.hide()
			alert.show()
			#activate dialogue

	if GlobalVars.in_look_screen == true and pic_fell == true: #add global var pic fell
		interact_area_look.hide()
	elif GlobalVars.in_look_screen == false and FP_Cam.priority == 30 and pic_fell == true: #add global var pic fell
		interact_area_look.show()


func _on_timeline_ended():
	emit_signal("disable_look")
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	GlobalVars.in_dialogue = false
	player.start_player()
	alert.show()

func _on_interactable_interacted(interactor):
	if GlobalVars.in_dialogue == false and GlobalVars.in_interaction == "":
		emit_signal("general_interact")
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		alert.hide()
		GlobalVars.in_interaction = interact_type
		FP_Cam.priority = 30
		Exit_Cam.priority = 0 
		cam_anim.play("Cam_Idle")
		player.hide()
		player.stop_player()
		if GlobalVars.get(pic_status) == false:
			interact_area_fall.show()
		else:
			interact_area_look.show()
