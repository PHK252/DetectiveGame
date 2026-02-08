extends Node3D

@export var main : Node3D
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
@export var interact_area_1: Area2D
@export var interact_area_2 : Area2D
@export var dialogue_file_1: String
@export var dialogue_file_2: String
@export var choice: String
@export var load_Dalton_dialogue: String
@export var load_Theo_dialogue: String
@export var load_char_dialogue: String

#Load Global Variables
@export var interact_type: String
@export var dialogue_1: String
@export var view_item_1: String

@export var dialogue_2: String
@export var view_item_2: String

@export var tilt_hide = false
#set defaults
@onready var mouse_pos = Vector2(0,0) 
@onready var tilt = ""

var kicked = false
var timed = false

signal general_interact
signal general_quit
signal juniper_wander

#lookat
signal enable_look
signal disable_look

signal theo_reposition_start
signal theo_reposition_end

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var read_dialogue_1 : bool = GlobalVars.get(dialogue_1)
	var viewed_item_1 : bool = GlobalVars.get(view_item_1)
	var read_dialogue_2 : bool = GlobalVars.get(dialogue_2)
	var viewed_item_2 : bool = GlobalVars.get(view_item_2)
	
	if GlobalVars.current_level == "Quincy":
		kicked = GlobalVars.quincy_kicked_out
		timed = GlobalVars.quincy_time_out
	elif GlobalVars.current_level == "Juniper":
		kicked = GlobalVars.juniper_kicked_out
		timed = GlobalVars.juniper_time_out
	
	if GlobalVars.in_look_screen == false and GlobalVars.in_dialogue == false and GlobalVars.in_interaction == interact_type:
		if main:
			mouse_pos = main.mouse_pos
		else:
			mouse_pos = get_viewport().get_mouse_position()
		if FP_Cam.priority == 30:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

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
		if tilt_hide == true and tilt == "down":
			FP_Cam.set_rotation_degrees(tilt_up_angle)
			interact_area_2.show()
			interact_area_1.hide()
		elif tilt_hide == true and tilt == "up":
			interact_area_2.hide()
	if Input.is_action_just_pressed("Exit") and GlobalVars.in_look_screen == false and GlobalVars.in_dialogue == false and GlobalVars.in_interaction == interact_type:
		emit_signal("theo_reposition_end")
		if kicked == false and timed == false:
			if viewed_item_1 == true and viewed_item_2 == true and read_dialogue_1 == false and read_dialogue_2 == false and GlobalVars.viewing == "":
				print("cab exit_1")
				print("V1 :" +  str(viewed_item_1))
				print("V2 :" +  str(viewed_item_2))
				print("D1 :" +  str(read_dialogue_1))
				print("D2 :" +  str(read_dialogue_2))
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
				Exit_Cam.set_tween_duration(0)
				FP_Cam.priority = 0
				Exit_Cam.priority = 30
				GlobalVars.in_dialogue = true
				cam_anim.play("RESET")
				player.show()
				emit_signal("enable_look")
				var game_dialogue = Dialogic.start(choice)
				Dialogic.timeline_ended.connect(_on_timeline_ended)
				game_dialogue.register_character(load(load_Dalton_dialogue), dalton_marker)
				game_dialogue.register_character(load(load_Theo_dialogue), theo_marker)
				game_dialogue.register_character(load(load_char_dialogue), character_marker)
				GlobalVars.in_interaction = ""
				print("clear")
				GlobalVars.set(dialogue_1, true)
				GlobalVars.set(dialogue_2, true)
				interact_area_1.hide()
				interact_area_2.hide()
				alert.hide()
			elif read_dialogue_1 == false and GlobalVars.viewing == "" and ((viewed_item_1 == true and viewed_item_2 == false) or (viewed_item_1 == true and viewed_item_2 == true)):
				print("cab exit_2")
				print("V1 :" +  str(viewed_item_1))
				print("V2 :" +  str(viewed_item_2))
				print("D1 :" +  str(read_dialogue_1))
				print("D2 :" +  str(read_dialogue_2))
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
				Exit_Cam.set_tween_duration(0)
				FP_Cam.priority = 0
				Exit_Cam.priority = 30
				emit_signal("general_quit")
				emit_signal("enable_look")
				GlobalVars.in_dialogue = true
				cam_anim.play("RESET")
				player.show()
				var game_dialogue = Dialogic.start(dialogue_file_1)
				Dialogic.timeline_ended.connect(_on_timeline_ended)
				game_dialogue.register_character(load(load_Dalton_dialogue), dalton_marker)
				game_dialogue.register_character(load(load_Theo_dialogue), theo_marker)
				game_dialogue.register_character(load(load_char_dialogue), character_marker)
				GlobalVars.in_interaction = ""
				print("clear")
				GlobalVars.set(dialogue_1, true)
				interact_area_1.hide()
				interact_area_2.hide()
				alert.hide()
			elif read_dialogue_2 == false and GlobalVars.viewing == "" and ((viewed_item_1 == false and viewed_item_2 == true) or (viewed_item_1 == true and viewed_item_2 == true)):
				print("cab exit_3")
				print("V1 :" +  str(viewed_item_1))
				print("V2 :" +  str(viewed_item_2))
				print("D1 :" +  str(read_dialogue_1))
				print("D2 :" +  str(read_dialogue_2))
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
				Exit_Cam.set_tween_duration(0)
				FP_Cam.priority = 0
				Exit_Cam.priority = 30
				emit_signal("general_quit")
				emit_signal("enable_look")
				#await get_tree().create_timer(.03).timeout
				cam_anim.play("RESET")
				player.show()
				var game_dialogue = Dialogic.start(dialogue_file_2)
				Dialogic.timeline_ended.connect(_on_timeline_ended)
				game_dialogue.register_character(load(load_Dalton_dialogue), dalton_marker)
				game_dialogue.register_character(load(load_Theo_dialogue), theo_marker)
				game_dialogue.register_character(load(load_char_dialogue), character_marker)
				GlobalVars.in_dialogue = true
				GlobalVars.in_interaction = ""
				print("clear")
				GlobalVars.set(dialogue_2, true)
				interact_area_1.hide()
				interact_area_2.hide()
				alert.hide()
			elif GlobalVars.viewing == "":
				print("cab exit_4")
				print("V1 :" +  str(viewed_item_1))
				print("V2 :" +  str(viewed_item_2))
				print("D1 :" +  str(read_dialogue_1))
				print("D2 :" +  str(read_dialogue_2))
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
				Exit_Cam.set_tween_duration(0)
				FP_Cam.priority = 0
				Exit_Cam.priority = 30
				emit_signal("juniper_wander")
				emit_signal("general_quit")
				cam_anim.play("RESET")
				player.show()
				player.start_player()
				#main_cam.set_tween_duration(1)
				GlobalVars.in_interaction = ""
				interact_area_1.hide()
				interact_area_2.hide()
				alert.show()
		elif GlobalVars.viewing == "":
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			Exit_Cam.set_tween_duration(0)
			FP_Cam.priority = 0
			Exit_Cam.priority = 30
			emit_signal("juniper_wander")
			emit_signal("general_quit")
			cam_anim.play("RESET")
			player.show()
			player.start_player()
			GlobalVars.in_interaction = ""
			interact_area_1.hide()
			interact_area_2.hide()
			alert.show()
			
	if GlobalVars.in_look_screen == true:
		interact_area_1.hide()
		interact_area_2.hide()
	elif GlobalVars.in_look_screen == false and FP_Cam.priority == 30:
		interact_area_1.show()
		interact_area_2.show()


func _on_timeline_ended():
	emit_signal("disable_look")
	emit_signal("theo_reposition_end")
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	GlobalVars.in_dialogue = false
	emit_signal("juniper_wander")
	player.start_player()
	alert.show()

func _on_interactable_interacted(interactor):
	if GlobalVars.in_dialogue == false and GlobalVars.in_interaction == "":
		emit_signal("general_interact")
		emit_signal("theo_reposition_start")
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		alert.hide()
		GlobalVars.in_interaction = interact_type
		FP_Cam.priority = 30
		Exit_Cam.priority = 0 
		cam_anim.play("Cam_Idle")
		player.hide()
		player.stop_player()
		interact_area_1.show()
		interact_area_2.show()
		if GlobalVars.in_interaction == "Resume" and Dialogic.VAR.get_variable("Juniper.reenter_resumes") == true:
			GlobalVars.set(dialogue_1, false)
			GlobalVars.set(view_item_1, false)
			if GlobalVars.get(view_item_2) == true and GlobalVars.get(dialogue_2) == false:
				GlobalVars.set(view_item_2, false)
