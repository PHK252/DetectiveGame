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
@export var alert : Sprite3D

#Assign character markers (up to 3)
@export var dalton_marker: Marker2D
@export var theo_marker: Marker2D
@export var character_marker: Marker2D

#Interaction Variables
@export var interact_area: Area2D
@export var start_dialogue_file: String
@export var end_dialogue_file: String
@export var load_Dalton_dialogue: String
@export var load_Theo_dialogue: String
@export var load_char_dialogue: String

#Load Global Variables
@export var interact_type: String
@export var dialogue: String
@export var view_item: String


#set defaults
@onready var mouse_pos = Vector2(0,0) 

#Closet Anim things
@export var closet_anim : AnimationPlayer
@onready var closet_open = false
@export var open_closet_door_1 : CollisionShape3D
@export var open_closet_door_2 : CollisionShape3D
signal stepback
@export var open_closet_sound : AudioStreamPlayer3D
@export var close_closet_sound : AudioStreamPlayer3D
signal general_interact
signal general_quit

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var read_dialogue : bool = GlobalVars.get(dialogue)
	var viewed_item : bool = GlobalVars.get(view_item)
	mouse_pos = get_viewport().get_mouse_position()
	#print(mouse_pos) 
	if GlobalVars.in_look_screen == false and GlobalVars.in_dialogue == false:
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
		if Input.is_action_just_pressed("Exit") and viewed_item == true and read_dialogue == false and GlobalVars.viewing == "":
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			Exit_Cam.set_tween_duration(0)
			FP_Cam.priority = 0
			Exit_Cam.priority = 25
			await get_tree().create_timer(.03).timeout
			cam_anim.play("RESET")
			player.show()
			var closet_dialogue = Dialogic.start(end_dialogue_file)
			Dialogic.timeline_ended.connect(_on_timeline_ended)
			closet_dialogue.register_character(load(load_Dalton_dialogue), dalton_marker)
			closet_dialogue.register_character(load(load_Theo_dialogue), theo_marker)
			closet_dialogue.register_character(load(load_char_dialogue), character_marker)
			GlobalVars.in_interaction = ""
			GlobalVars.set(dialogue, true)
			interact_area.hide()
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
			GlobalVars.in_interaction = ""
			interact_area.hide()
			alert.show()
			#main_cam.set_tween_duration(1)
	
	if GlobalVars.in_look_screen == true:
		interact_area.hide()
	elif GlobalVars.in_look_screen == false and FP_Cam.priority == 25:
		interact_area.show()

func _on_interactable_interacted(interactor):
	open_closet_door_1.disabled = false
	open_closet_door_2.disabled = false
	Exit_Cam.priority = 30
	alert.hide()
	if closet_open == false: 
		emit_signal("general_interact")
		emit_signal("stepback")
		await get_tree().create_timer(2).timeout
		open_closet_sound.play()
	
	var tool_asked = Dialogic.VAR.get_variable("Asked Questions.Micah_Closet_Asked")
	if GlobalVars.in_dialogue == false:
		if closet_open == false and tool_asked == false:
			GlobalVars.in_dialogue = true
			player.stop_player()
			closet_anim.play("NewClosetOpen")
			await closet_anim.animation_finished
			closet_open = true
			#Dialogue start
			var closet_dialogue = Dialogic.start(start_dialogue_file)
			Dialogic.timeline_ended.connect(_on_timeline_ended)
			Dialogic.signal_event.connect(closetLook)
			closet_dialogue.register_character(load(load_Dalton_dialogue), dalton_marker)
			closet_dialogue.register_character(load(load_Theo_dialogue), theo_marker)
			closet_dialogue.register_character(load(load_char_dialogue), character_marker)
			#await get_tree().create_timer(3).timeout
		elif closet_open == true and tool_asked == false:
			GlobalVars.in_dialogue = true
			player.stop_player()
			var closet_dialogue = Dialogic.start("Micah_closet_ask", "choices")
			Dialogic.timeline_ended.connect(_on_timeline_ended)
			Dialogic.signal_event.connect(closetLook)
			closet_dialogue.register_character(load(load_Dalton_dialogue), dalton_marker)
			closet_dialogue.register_character(load(load_Theo_dialogue), theo_marker)
			closet_dialogue.register_character(load(load_char_dialogue), character_marker)
		elif closet_open == true and tool_asked == true:
			GlobalVars.in_dialogue = true
			player.stop_player()
			var closet_dialogue = Dialogic.start("Micah_closet_ask", "tool choices")
			Dialogic.timeline_ended.connect(_on_timeline_ended)
			Dialogic.signal_event.connect(closetLook)
			closet_dialogue.register_character(load(load_Dalton_dialogue), dalton_marker)
			closet_dialogue.register_character(load(load_Theo_dialogue), theo_marker)
			closet_dialogue.register_character(load(load_char_dialogue), character_marker)

func _on_timeline_ended():
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	GlobalVars.in_dialogue = false
	player.start_player()
	alert.show()
	#print("enter")
#
func closetLook(argument: String):
	if argument == "look":
		# connect signal to switch cams
		GlobalVars.in_interaction = interact_type
		FP_Cam.priority = 30
		Exit_Cam.priority = 0 
		interact_area.show()
		cam_anim.play("Cam_Idle")
		player.hide()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
