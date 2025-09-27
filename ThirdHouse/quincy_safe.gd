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
#@export var down_default: bool = false
#Assign player body
@export var player: CharacterBody3D
@export var alert: Sprite3D

#Assign character markers (up to 3)
@export var dalton_marker: Marker2D
#@export var theo_marker: Marker2D
#@export var character_marker: Marker2D

@export var dialogue_file: String
#@export var in_case_thought_1 : String #News dialogue
#@export var in_case_thought_2 : String #proposal dialogue
#@export var in_case_thought_3 : String #Usb dialogue
#@export var in_case_thought_4 : String #pager dialogue

#Interaction Variables
@export var interior_interact_area_1 : Area2D
@export var interior_interact_area_2 : Area2D
@export var interior_interact_area_3 : Area2D
@export var interior_interact_area_4 : Area2D
@export var open_interact : Area2D
@export var close_interact : Area2D
@export var load_Dalton_dialogue: String 
#Load Global Variables
@export var interact_type: String
@export var dialogue_read: String
@export var view_item_1: String
@export var view_item_2: String
@export var view_item_3: String
@export var view_item_4: String

@export var tilt_hide = false
#set defaults
@onready var mouse_pos = Vector2(0,0) 
@onready var tilt = ""

signal exit_interact
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var viewed_item_1 : bool = GlobalVars.get(view_item_1)
	var viewed_item_2 : bool = GlobalVars.get(view_item_2)
	var viewed_item_3 : bool = GlobalVars.get(view_item_3)
	var viewed_item_4 : bool = GlobalVars.get(view_item_4)
	var read_dialogue : bool = GlobalVars.get(dialogue_read)
	mouse_pos = get_viewport().get_mouse_position()
	#print(mouse_pos) 
	if GlobalVars.in_look_screen == false and GlobalVars.in_dialogue == false:
		mouse_pos = get_viewport().get_mouse_position()
		if mouse_pos.y >= tilt_up_thres:
			FP_Cam.set_rotation_degrees(tilt_up_angle)
			tilt = "down"
		elif mouse_pos.y < tilt_down_thres:
			FP_Cam.set_rotation_degrees(tilt_down_angle)
			tilt = "up"
		else:
			FP_Cam.set_rotation_degrees(mid_angle)
			tilt = "mid"
		#mouse_pos = mouse_pos
		#if tilt_hide == true and tilt == "down":
			#FP_Cam.set_rotation_degrees(tilt_up_angle)
			#interior_interact_area_2.show()
			#interior_interact_area_1.hide()
		#elif tilt_hide == true and tilt == "up":
			#interior_interact_area_2.hide()
	if GlobalVars.in_look_screen == false and GlobalVars.in_dialogue == false and GlobalVars.in_interaction == interact_type:
		if Input.is_action_just_pressed("Exit") and read_dialogue == false and viewed_item_1 == true and viewed_item_2 == true and  viewed_item_3 == true and viewed_item_4 == true and GlobalVars.viewing == "" and GlobalVars.quincy_kicked_out == false and GlobalVars.quincy_time_out == false:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			Exit_Cam.set_tween_duration(0)
			FP_Cam.priority = 0
			Exit_Cam.priority = 30
			cam_anim.play("RESET")
			player.show()
			var game_dialogue = Dialogic.start(dialogue_file)
			Dialogic.timeline_ended.connect(_on_timeline_ended)
			game_dialogue.register_character(load(load_Dalton_dialogue), dalton_marker)
			GlobalVars.set(dialogue_read, true)
			GlobalVars.in_interaction = ""
			interior_interact_area_1.hide()
			interior_interact_area_2.hide()
			interior_interact_area_3.hide()
			interior_interact_area_4.hide()
			open_interact.hide()
			close_interact.hide()
			alert.hide()
		elif Input.is_action_just_pressed("Exit") and GlobalVars.viewing == "":
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			Exit_Cam.set_tween_duration(0)
			FP_Cam.priority = 0
			Exit_Cam.priority = 30
			cam_anim.play("RESET")
			player.show()
			player.start_player()
			#main_cam.set_tween_duration(1)
			GlobalVars.in_interaction = ""
			interior_interact_area_1.hide()
			interior_interact_area_2.hide()
			interior_interact_area_3.hide()
			interior_interact_area_4.hide()
			open_interact.hide()
			close_interact.hide()
			alert.show()
			
	if GlobalVars.in_look_screen == true:
		interior_interact_area_1.hide()
		interior_interact_area_2.hide()
		interior_interact_area_3.hide()
		interior_interact_area_4.hide()
	#elif GlobalVars.in_look_screen == false and FP_Cam.priority == 30:
		#interior_interact_area_1.show()
		#interior_interact_area_2.show()
		#interior_interact_area_3.show()
		#interior_interact_area_4.show()


func _on_timeline_ended():
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	GlobalVars.in_dialogue = false
	player.start_player()
	alert.show()

func _on_interactable_interacted(interactor):
	if GlobalVars.in_interaction == "":
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		alert.hide()
		GlobalVars.in_interaction = interact_type
		FP_Cam.priority = 30
		Exit_Cam.priority = 0 
		open_interact.show()
		cam_anim.play("Cam_Idle")
		player.hide()
		player.stop_player()


func _on_quincy_caught_in_view():
	interior_interact_area_1.hide()
	interior_interact_area_2.hide()
	interior_interact_area_3.hide()
	interior_interact_area_4.hide()
	open_interact.hide()
	close_interact.hide()
	Exit_Cam.set_tween_duration(0)
	FP_Cam.priority = 0
	Exit_Cam.priority = 30 
	Exit_Cam.set_tween_duration(1)
	GlobalVars.in_interaction = ""
	player.show()
	emit_signal("exit_interact")


func _on_safe_ui_alarm():
	interior_interact_area_1.hide()
	interior_interact_area_2.hide()
	interior_interact_area_3.hide()
	interior_interact_area_4.hide()
	open_interact.hide()
	close_interact.hide()
	Exit_Cam.set_tween_duration(0)
	FP_Cam.priority = 0
	Exit_Cam.priority = 30 
	Exit_Cam.set_tween_duration(1)
	GlobalVars.in_interaction = ""
	player.show()
	emit_signal("exit_interact")
