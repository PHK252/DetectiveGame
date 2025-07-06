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
@export var player_interactor: Interactor
@export var alert: Sprite3D

#Interaction Variables
@export var interact_area: Area2D
@export var dialogue_file: String
@export var interactable: Interactable
#Load Global Variables
@export var interact_type: String
@export var dialogue: String
@export var view_item: String
@export var chocolate : Node3D
#set defaults
@onready var mouse_pos = Vector2(0,0) 

var kicked = false
var timed = false
var set_monitor = false
@export var anim_player: AnimationPlayer
var is_open = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	anim_player.play("ChocolateDefault")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var read_dialogue : bool = GlobalVars.get(dialogue)
	var viewed_item : bool = GlobalVars.get(view_item)
	mouse_pos = get_viewport().get_mouse_position()
	
	if GlobalVars.current_level == "Quincy":
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
		if down_default == true:
			FP_Cam.set_rotation_degrees(tilt_up_angle)
		else:
			FP_Cam.set_rotation_degrees(mid_angle)
	
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
			player.start_player()
			#main_cam.set_tween_duration(1)
			GlobalVars.in_interaction = ""
			interact_area.hide()
			if Dialogic.VAR.get_variable("Quincy.has_choco") == true:
				alert.hide()
			else:
				alert.show()

	if GlobalVars.in_look_screen == true:
		interact_area.hide()

	
	if Dialogic.VAR.get_variable("Quincy.is_distracted") == true and Dialogic.VAR.get_variable("Quincy.has_choco") == false:
		#print("monitorable")
		interactable.set_monitorable(true)
	else:
		#print("unmonitorable")
		
		if Dialogic.VAR.get_variable("Quincy.has_choco") == true and set_monitor == false:
			print("unmonitorable")
			set_monitor = true
			interactable.set_monitorable(false)
			player_interactor.process_mode = player_interactor.PROCESS_MODE_DISABLED 
			await get_tree().create_timer(.03).timeout
			player_interactor.process_mode = player_interactor.PROCESS_MODE_INHERIT
		else:
			interactable.set_monitorable(false)

	
func _on_timeline_ended():
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	GlobalVars.in_dialogue = false
	player.start_player()
	alert.show()
	if GlobalVars.get(dialogue) == false:
		GlobalVars.set(dialogue, true)

func _on_interactable_interacted(interactor):
	if GlobalVars.in_interaction == "":
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		alert.hide()
		GlobalVars.in_interaction = interact_type
		FP_Cam.priority = 30
		Exit_Cam.priority = 0 
		if Dialogic.VAR.get_variable("Quincy.has_choco") == false:
			interact_area.show()
		else:
			interact_area.hide()
		cam_anim.play("Cam_Idle")
		player.hide()
		player.stop_player()

func _on_chocolate_input_event(viewport, event, shape_idx):
	if GlobalVars.in_look_screen == false and GlobalVars.in_dialogue == false:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed == true:
				if is_open == false:
					if Dialogic.VAR.get_variable("Quincy.has_choco") == false:
						interact_area.hide()
						Dialogic.signal_event.connect(_open_choco)
						Dialogic.signal_event.connect(_take_choco)
						Dialogic.timeline_ended.connect(_on_timeline_ended)
						GlobalVars.in_dialogue = true
						Dialogic.start(dialogue_file)
						if GlobalVars.get(view_item) == false:
							GlobalVars.set(view_item, true)
				else:
					is_open = false
					anim_player.play("ChocolateClosed")

func _open_choco(argument: String):
	if argument == "open_choco":
		Dialogic.signal_event.disconnect(_open_choco)
		is_open = true
		anim_player.play("ChocolateOpen")
	elif argument == "end":
		Dialogic.signal_event.disconnect(_open_choco)

func _take_choco(argument: String):
	if argument == "take_choco":
		Dialogic.signal_event.disconnect(_take_choco)
		chocolate.hide()
		interact_area.hide()
		#interactable.set_monitorable(false)
	elif argument == "end":
		Dialogic.signal_event.disconnect(_open_choco)
