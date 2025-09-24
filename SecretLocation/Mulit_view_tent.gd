extends Node3D

#Assign first person cam and exit cam + idle animation
@export var FP_Cam: PhantomCamera3D
@export var Exit_Cam: PhantomCamera3D

#First Person cam anim + movement
@export var cam_anim: AnimationPlayer
@export var tilt_thres: int
@export var tilt_up_angle: Vector3
@export var tilt_down_angle: Vector3
#@export var mid_angle: Vector3
#@export var down_default: bool = false
#Assign player body
@export var player: CharacterBody3D
@export var alert: Sprite3D
@export var case_1 : MeshInstance3D
@export var case_2 : MeshInstance3D
@export var case_3 : MeshInstance3D
@export var case_letter_1 : MeshInstance3D
@export var case_letter_2 : MeshInstance3D
#@export var case_3 : MeshInstance3D
#@export var case_3 : MeshInstance3D
#Interaction Variables
@export var open_interact : Area2D
@export var interact_area_1: Area2D
@export var interact_area_2 : Area2D 
@export var interact_area_3 : Area2D 
@export var interact_area_4 : Area2D 
@export var trash_area : Area2D

@export var open_dialogue: String


#Load Global Variables
@export var interact_type: String


#set defaults
@onready var mouse_pos = Vector2(0,0) 
@onready var is_open: bool = false
#set anims
@export var animation_player : AnimationPlayer
@onready var tilt = ""

var case_show = true

#sound 
#@export var close_cab_sound : AudioStreamPlayer3D
#@export var open_cab_sound : AudioStreamPlayer3D
#signal general_interact
#signal general_quit

	

func _process(delta):
	if GlobalVars.in_look_screen == false and GlobalVars.in_dialogue == false and GlobalVars.in_interaction == interact_type:
		mouse_pos = get_viewport().get_mouse_position()
		if mouse_pos.y >= tilt_thres:
			FP_Cam.set_rotation_degrees(tilt_up_angle)
			tilt = "down"
		elif mouse_pos.y < tilt_thres:
			FP_Cam.set_rotation_degrees(tilt_down_angle)
			tilt = "up"
		#mouse_pos = mouse_pos
		#if tilt == "down":
			#FP_Cam.set_rotation_degrees(tilt_up_angle)
			#interact_area_2.show()
			#close_interact_1.hide()
			#close_interact_2.hide()
			#interact_area_1.hide()
			#open_interact.hide()
#
		#elif tilt == "up" and cab_anim == false:
			#FP_Cam.set_rotation_degrees(tilt_down_angle)
			#interact_area_2.hide()
			#if is_open == true:
				#open_interact.hide()
				#interact_area_1.show()
				#close_interact_1.show()
				#close_interact_2.show()
			#else:
				#open_interact.show()
				#interact_area_1.hide()
				#close_interact_1.hide()
				#close_interact_2.hide()

	if GlobalVars.in_look_screen == false and GlobalVars.in_dialogue == false and GlobalVars.in_interaction == interact_type:
		if Input.is_action_just_pressed("Exit") and GlobalVars.viewing == "":
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			Exit_Cam.set_tween_duration(0)
			FP_Cam.priority = 0
			Exit_Cam.priority = 30
			#emit_signal("general_quit")
			await get_tree().create_timer(.03).timeout
			cam_anim.play("RESET")
			player.show()
			GlobalVars.in_interaction = ""
			print("clear")
			interact_area_1.hide()
			interact_area_2.hide()
			interact_area_3.hide()
			interact_area_4.hide()
			open_interact.hide()
			trash_area.hide()
			alert.show()
			player.start_player()
		#else:
			#print_debug("Exit Tent case interaction went wrong")

	if GlobalVars.in_look_screen == true:
		interact_area_1.hide()
		interact_area_2.hide()
		interact_area_3.hide()
		interact_area_4.hide()
		trash_area.hide()
	
	if Dialogic.VAR.get_variable("Secret Location.took_case") == true and case_show == true:
		close()
		case_1.hide()
		case_2.hide()
		case_3.hide()
		case_letter_1.hide()
		case_letter_2.hide()
		

func _on_interactable_interacted(interactor: Interactor) -> void:
	if GlobalVars.in_dialogue == false and GlobalVars.in_interaction == "":
		#emit_signal("general_interact")
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		alert.hide()
		GlobalVars.in_interaction = interact_type
		FP_Cam.priority = 30
		Exit_Cam.priority = 0 
		cam_anim.play("Cam_idle")
		player.hide()
		player.stop_player()
		if is_open == false:
			print("entered")
			open_interact.show()
			interact_area_1.hide()
			interact_area_2.hide()
			interact_area_3.hide()
			interact_area_4.hide()
		else:
			open_interact.hide()
			interact_area_1.show()
			interact_area_2.show()
			interact_area_3.show()
			interact_area_4.show()
		
		if Dialogic.VAR.get_variable("Secret Location.viewed_trash") == false:
			trash_area.show()
		else:
			trash_area.hide()


func open() -> void:
	#open_cab_sound.play()
	#cab_anim = true
	animation_player.play("opening case")
	is_open = true
	open_interact.hide()
	interact_area_1.show()
	interact_area_2.show()
	interact_area_3.show()
	interact_area_4.show()

func close() -> void:
	#open_cab_sound.play()
	#cab_anim = true
	animation_player.play("closingcase")
	is_open = false
	open_interact.hide()
	interact_area_1.hide()
	interact_area_2.hide()
	interact_area_3.hide()
	interact_area_4.hide()


func _on_timeline_ended():
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	GlobalVars.in_dialogue = false


func _on_open_case_input_event(viewport, event, shape_idx):
	if GlobalVars.in_look_screen == false:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed == true:
				print("clicked")
				GlobalVars.in_dialogue = true
				Dialogic.timeline_ended.connect(_on_timeline_ended)
				Dialogic.signal_event.connect(_open_case)
				Dialogic.start(open_dialogue)

func _open_case(arg : String):
	if arg == "open":
		Dialogic.signal_event.disconnect(_open_case)
		open()
	else:
		Dialogic.signal_event.disconnect(_open_case)

func _on_show_other_areas():
	interact_area_1.show()
	interact_area_2.show()
	interact_area_3.show()
	interact_area_4.show()
	if Dialogic.VAR.get_variable("Secret Location.viewed_trash") == false:
		trash_area.show()
	else:
		trash_area.hide()
