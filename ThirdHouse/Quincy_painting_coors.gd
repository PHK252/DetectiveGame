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
@export var down_default: bool = false
#Assign player body
@export var player: CharacterBody3D
@export var alert: Sprite3D

#Assign character markers (up to 3)
@export var dalton_marker: Marker2D
@export var theo_marker: Marker2D
@export var character_marker: Marker2D

#Interaction Variables
@export var interact_area: Area2D
@export var interact_area_2: Area2D
@export var dialogue_file: String
@export var load_Dalton_dialogue: String
@export var load_Theo_dialogue: String
@export var load_char_dialogue: String

#Load Global Variables
@export var interact_type: String
@export var dialogue: String
@export var view_item: String

#set defaults
@onready var mouse_pos = Vector2(0,0) 

var read_dialogue : bool
var kicked = false
var timed = false

signal general_interact
signal general_quit
signal juniper_wander

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (Dialogic.VAR.get_variable("Quincy.talked_at_port_know_skylar") == true or Dialogic.VAR.get_variable("Quincy.talked_at_port_not_know_Skylar")) and Dialogic.VAR.get_variable("Quincy.asked_painting") == true:
		if Dialogic.VAR.get_variable("Quincy.has_secret_coor") == true:
			if Dialogic.VAR.get_variable("Quincy.show_coors_note") == true:
				read_dialogue = true
			else:
				read_dialogue = false
		else:
			read_dialogue = true
	else:
		read_dialogue = false
	var viewed_item : bool = GlobalVars.get(view_item)
	mouse_pos = get_viewport().get_mouse_position()
	kicked = GlobalVars.quincy_kicked_out
	timed = GlobalVars.quincy_time_out
	if GlobalVars.in_look_screen == false and GlobalVars.in_dialogue == false:
		if mouse_pos.y >= tilt_up_thres:
			FP_Cam.set_rotation_degrees(tilt_up_angle)
		elif mouse_pos.y < tilt_down_thres:
			FP_Cam.set_rotation_degrees(tilt_down_angle)
		else:
			FP_Cam.set_rotation_degrees(mid_angle)
				#pass
	else:
		if GlobalVars.viewing == "coordinates" or Dialogic.VAR.get_variable("Quincy.in_coor_thoughts") == true:
			FP_Cam.set_rotation_degrees(tilt_up_angle)
		else:
			FP_Cam.set_rotation_degrees(mid_angle)
	
	if GlobalVars.in_look_screen == false and GlobalVars.in_dialogue == false and GlobalVars.in_interaction == interact_type:
		if Input.is_action_just_pressed("Exit") and viewed_item == true and read_dialogue == false and GlobalVars.viewing == "" and kicked == false and timed == false:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			Exit_Cam.set_tween_duration(0)
			FP_Cam.priority = 0
			Exit_Cam.priority = 30
			emit_signal("general_quit")
			await get_tree().create_timer(.03).timeout
			cam_anim.play("RESET")
			player.show()
			var game_dialogue = Dialogic.start(dialogue_file)
			Dialogic.timeline_ended.connect(_on_timeline_ended)
			game_dialogue.register_character(load(load_Dalton_dialogue), dalton_marker)
			game_dialogue.register_character(load(load_Theo_dialogue), theo_marker)
			game_dialogue.register_character(load(load_char_dialogue), character_marker)
			GlobalVars.in_interaction = ""
			GlobalVars.set(dialogue, true)
			interact_area.hide()
			interact_area_2.hide()
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
			interact_area.hide()
			interact_area_2.hide()
			alert.show()
			#activate dialogue

	if GlobalVars.in_look_screen == true:
		interact_area.hide()
		interact_area_2.hide()
	elif GlobalVars.in_look_screen == false and FP_Cam.priority == 30:
		interact_area.show()
		if Dialogic.VAR.get_variable("Quincy.has_secret_coor") == false:
			interact_area_2.show()


func _on_timeline_ended():
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	GlobalVars.in_dialogue = false
	player.start_player()
	alert.show()

func _on_interactable_interacted(interactor):
	if GlobalVars.in_interaction == "":
		emit_signal("general_interact")
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		alert.hide()
		GlobalVars.in_interaction = interact_type
		FP_Cam.priority = 30
		Exit_Cam.priority = 0 
		interact_area.show()
		if Dialogic.VAR.get_variable("Quincy.has_secret_coor") == false:
			interact_area_2.show()
		cam_anim.play("Cam_Idle")
		player.hide()
		player.stop_player()
