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
@export var in_case_thought_1 : String #News dialogue
@export var in_case_thought_2 : String #proposal dialogue
@export var in_case_thought_3 : String #Usb dialogue
@export var in_case_thought_4 : String #pager dialogue

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
		if Input.is_action_just_pressed("Exit") and read_dialogue == false and viewed_item_1 == true and viewed_item_2 == true and  viewed_item_3 == true and viewed_item_4 == true and GlobalVars.viewing == "":
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
	elif GlobalVars.in_look_screen == false and FP_Cam.priority == 30:
		interior_interact_area_1.show()
		interior_interact_area_2.show()
		interior_interact_area_3.show()
		interior_interact_area_4.show()


func _on_timeline_ended():
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	GlobalVars.in_dialogue = false
	player.start_player()
	alert.show()

func _on_interactable_interacted(interactor):
	print("enter safe")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	alert.hide()
	GlobalVars.in_interaction = interact_type
	FP_Cam.priority = 30
	Exit_Cam.priority = 0 
	open_interact.show()
	cam_anim.play("Cam_Idle")
	player.hide()
	player.stop_player()



#extends Node3D
#
#@export var safe_cam: PhantomCamera3D
#@export var main_cam: PhantomCamera3D
#@export var player: CharacterBody3D
#@export var alert: Sprite3D
#@export var cam_anim : AnimationPlayer
#@export var interact_area: Area2D
#@export var UI : CanvasLayer
#
#
#@export var interior_interact_area_1 : Area2D
#@export var interior_interact_area_2 : Area2D
#@export var interior_interact_area_3 : Area2D
#@export var interior_interact_area_4 : Area2D
#
##@export var dalton_marker: Marker2D
##@export var theo_marker: Marker2D
##@export var character_marker: Marker2D
#
##@export var dialogue_file: String
#
#@export var in_case_thought_1 : String #News dialogue
#@export var in_case_thought_2 : String #proposal dialogue
#@export var in_case_thought_3 : String #Usb dialogue
#@export var in_case_thought_4 : String #pager dialogue
#@export var in_case_dialogue_choices : String
#@export var load_Dalton_dialogue: String
#@export var load_Theo_dialogue: String
#@export var load_char_dialogue: String
#
#@export var interact_type: String
## Called when the node enters the scene tree for the first time.
#func _ready():
	#UI.hide()
	#interact_area.hide()
	#pass # Replace with function body.
#
#
#func _on_interactable_interacted(interactor):
	##var case_asked = Dialogic.VAR.get_variable("Quincy.Quincy_asked_case")
	##print(case_asked)
	#if GlobalVars.in_dialogue == false:
		#
		##if case_asked == false:
			##GlobalVars.in_dialogue = true
			##GlobalVars.in_interaction = interact_type
			##alert.hide()
			##player.stop_player()
			##var game_dialogue = Dialogic.start(dialogue_file)
			##Dialogic.signal_event.connect(caseUI)
			##Dialogic.timeline_ended.connect(_on_timeline_ended)
			##game_dialogue.register_character(load(load_Dalton_dialogue), dalton_marker)
			##game_dialogue.register_character(load(load_Theo_dialogue), theo_marker)
			##game_dialogue.register_character(load(load_char_dialogue), character_marker)
		##elif GlobalVars.opened_jun_case == true:
			##GlobalVars.in_interaction = interact_type
			###print("look " + str(GlobalVars.in_look_screen))
			##Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			##alert.hide()
			##player.stop_player()
			##safe_cam.priority = 30
			##main_cam.priority = 0 
			##cam_anim.play("Cam_Idle")
			##interior_interact_area_1.show()
			##interior_interact_area_2.show()
		##else:
			##GlobalVars.in_interaction = interact_type
			##GlobalVars.in_dialogue = true
			##alert.hide()
			##player.stop_player()
			##var game_dialogue = Dialogic.start(dialogue_file, "choices")
			##Dialogic.signal_event.connect(caseUI)
			##Dialogic.timeline_ended.connect(_on_timeline_ended)
			##game_dialogue.register_character(load(load_Dalton_dialogue), dalton_marker)
			##game_dialogue.register_character(load(load_Theo_dialogue), theo_marker)
			##game_dialogue.register_character(load(load_char_dialogue), character_marker)
#
#
#func _on_timeline_ended():
	#Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	#GlobalVars.in_dialogue = false
	#if GlobalVars.Quincy_in_case == false:
		#player.start_player()
		#alert.show()
##
#func caseUI(argument: String):
	#if argument == "look_case":
		#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		#player.hide()
		#GlobalVars.Quincy_in_case = true
		#player.stop_player()
		#GlobalVars.viewing = "case_ui"
		#interact_area.show()
		#safe_cam.priority = 30
		#main_cam.priority = 0 
		#cam_anim.play("Cam_Idle")
		#Dialogic.signal_event.disconnect(caseUI)
		#
#
#
#func _on_exit_pressed():
	##Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	#GlobalVars.Quincy_in_case = false
	#GlobalVars.in_look_screen = false
	#UI.hide()
	#interact_area.show()
	#GlobalVars.viewing = ""
#
#func _input(event):
	#var finished_letter = Dialogic.VAR.get_variable("Quincy.finished_case_note")
	#var finished_hammer = Dialogic.VAR.get_variable("Quincy.finished_case_hammer")
	#if GlobalVars.in_dialogue == false:
		#if Input.is_action_just_pressed("Exit") and GlobalVars.in_interaction == interact_type and GlobalVars.viewing == "":
			#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			#safe_cam.priority = 0
			#main_cam.priority = 30
			#cam_anim.play("RESET")
			#player.show()
			#if GlobalVars.opened_jun_case == true:
				#interior_interact_area_1.hide()
				#interior_interact_area_2.hide()
				#if finished_letter == true or finished_hammer == true:
					#if finished_hammer == true:
						#GlobalVars.in_interaction = ""
						#GlobalVars.in_dialogue = true
						#alert.hide()
						#player.stop_player()
						#var game_dialogue = Dialogic.start(in_case_dialogue_1) 
						#Dialogic.timeline_ended.connect(_on_timeline_ended)
						#game_dialogue.register_character(load(load_Dalton_dialogue), dalton_marker)
						#game_dialogue.register_character(load(load_Theo_dialogue), theo_marker)
						#game_dialogue.register_character(load(load_char_dialogue), character_marker)
					#elif finished_letter == true:
						#GlobalVars.in_interaction = ""
						#GlobalVars.in_dialogue = true
						#alert.hide()
						#player.stop_player()
						#var game_dialogue = Dialogic.start(in_case_dialogue_2) 
						#Dialogic.timeline_ended.connect(_on_timeline_ended)
						#game_dialogue.register_character(load(load_Dalton_dialogue), dalton_marker)
						#game_dialogue.register_character(load(load_Theo_dialogue), theo_marker)
						#game_dialogue.register_character(load(load_char_dialogue), character_marker)
				#else:
					#if GlobalVars.viewed_Quincy_letter == true and GlobalVars.viewed_Quincy_hammer == true:
						#GlobalVars.in_interaction = ""
						#GlobalVars.in_dialogue = true
						#alert.hide()
						#player.stop_player()
						#var game_dialogue = Dialogic.start(in_case_dialogue_choices)
						#Dialogic.timeline_ended.connect(_on_timeline_ended)
						#game_dialogue.register_character(load(load_Dalton_dialogue), dalton_marker)
						#game_dialogue.register_character(load(load_Theo_dialogue), theo_marker)
						#game_dialogue.register_character(load(load_char_dialogue), character_marker)
					#elif GlobalVars.viewed_Quincy_letter == true and GlobalVars.viewed_Quincy_hammer == false:
						#print("enteredddd else")
						#GlobalVars.in_interaction = ""
						#GlobalVars.in_dialogue = true
						#alert.hide()
						#player.stop_player()
						#var game_dialogue = Dialogic.start(in_case_dialogue_1)
						#Dialogic.timeline_ended.connect(_on_timeline_ended)
						#game_dialogue.register_character(load(load_Dalton_dialogue), dalton_marker)
						#game_dialogue.register_character(load(load_Theo_dialogue), theo_marker)
						#game_dialogue.register_character(load(load_char_dialogue), character_marker)
					#elif GlobalVars.viewed_Quincy_letter == false and GlobalVars.viewed_Quincy_hammer == true:
						#print("enteredddd")
						#GlobalVars.in_interaction = ""
						#GlobalVars.in_dialogue = true
						#alert.hide()
						#player.stop_player()
						#var game_dialogue = Dialogic.start(in_case_dialogue_2)
						#Dialogic.timeline_ended.connect(_on_timeline_ended)
						#game_dialogue.register_character(load(load_Dalton_dialogue), dalton_marker)
						#game_dialogue.register_character(load(load_Theo_dialogue), theo_marker)
						#game_dialogue.register_character(load(load_char_dialogue), character_marker)
			#else:
				#GlobalVars.in_interaction = ""
				#player.start_player()
				#alert.show()
				#interact_area.hide()
		#elif Input.is_action_just_pressed("Exit") and GlobalVars.in_interaction == interact_type and GlobalVars.viewing == "case_ui": 
			#UI.hide()
			#GlobalVars.in_look_screen = false
			#GlobalVars.Quincy_in_case = false
			#await get_tree().create_timer(.03).timeout
			#GlobalVars.viewing = ""
			#interact_area.show()
#
#func _on_input_event(viewport, event, shape_idx):
	#if GlobalVars.in_look_screen == false:
		#if event is InputEventMouseButton:
			#if event.button_index == MOUSE_BUTTON_LEFT and event.pressed == true:
				#if GlobalVars.in_interaction == "":
					#GlobalVars.in_interaction = interact_type
				#UI.show()
				#GlobalVars.in_look_screen = true
				#GlobalVars.clicked_case_Quincy = GlobalVars.clicked_case_Quincy + 1
				#interact_area.hide()
