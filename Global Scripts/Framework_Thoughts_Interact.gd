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

#Assign player body
@export var player: CharacterBody3D
@export var alert: Sprite3D

#Assign character markers (up to 3)
@export var dalton_marker: Marker2D
@export var theo_marker: Marker2D
@export var character_marker: Marker2D

#Interaction Variables
@export var dialogue_after = false
@export var thought_dialogue_file : String
@export var dialogue_file: String
@export var load_Dalton_dialogue: String
@export var load_Theo_dialogue: String
@export var load_char_dialogue: String

@export var is_player_visible : bool = false

#Load Global Variables
@export var interact_type: String
@export var dialogue: String
@export var view_item: String

#set defaults
@onready var mouse_pos = Vector2(0,0) 
@onready var thoughts = false

#sound
signal general_interact
signal general_quit
signal juniper_wander

#lookat
signal enable_look
signal disable_look

var kicked = false
var timed = false

func _ready():
	if GlobalVars.get(dialogue) == true:
		dialogue_after = false
	if GlobalVars.get(view_item) == true:
		thoughts = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var read_dialogue : bool = GlobalVars.get(dialogue)
	var viewed_item : bool = GlobalVars.get(view_item)
	
	
	#set kicked and timed out vars
	if GlobalVars.current_level == "Quincy":
		kicked = GlobalVars.quincy_kicked_out
		timed = GlobalVars.quincy_time_out
	elif GlobalVars.current_level == "Juniper":
		kicked = GlobalVars.juniper_kicked_out
		timed = GlobalVars.juniper_time_out
	elif GlobalVars.current_level == "Micah":
		kicked = GlobalVars.micah_kicked_out
		timed = GlobalVars.micah_time_out
		
	if GlobalVars.in_look_screen == false and GlobalVars.in_dialogue == false and GlobalVars.in_interaction == interact_type:
		if main:
			mouse_pos = main.mouse_pos
		else:
			mouse_pos = get_viewport().get_mouse_position()
		if mouse_pos.y >= tilt_up_thres:
			FP_Cam.set_rotation_degrees(tilt_up_angle)
		elif mouse_pos.y < tilt_down_thres:
			FP_Cam.set_rotation_degrees(tilt_down_angle)
		else:
			FP_Cam.set_rotation_degrees(mid_angle)
				#pass
	else:
		FP_Cam.set_rotation_degrees(mid_angle)
	
	if GlobalVars.in_look_screen == false and GlobalVars.in_dialogue == false and GlobalVars.in_interaction == interact_type:
		if dialogue_after == true and Input.is_action_just_pressed("Exit") and viewed_item == true and read_dialogue == false and kicked == false and timed == false:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			Exit_Cam.set_tween_duration(0)
			FP_Cam.priority = 0
			Exit_Cam.priority = 30
			emit_signal("general_quit")
			emit_signal("enable_look")
			await get_tree().create_timer(.03).timeout
			cam_anim.play("RESET")
			player.show()
			GlobalVars.in_dialogue = true
			var game_dialogue = Dialogic.start(dialogue_file)
			Dialogic.timeline_ended.connect(_on_timeline_ended)
			game_dialogue.register_character(load(load_Dalton_dialogue), dalton_marker)
			game_dialogue.register_character(load(load_Theo_dialogue), theo_marker)
			game_dialogue.register_character(load(load_char_dialogue), character_marker)
			GlobalVars.in_interaction = ""
			GlobalVars.set(dialogue, true)
			alert.hide()
			#thoughts = false
			dialogue_after = false
		elif dialogue_after == false and Input.is_action_just_pressed("Exit"):
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			Exit_Cam.set_tween_duration(0)
			FP_Cam.priority = 0
			Exit_Cam.priority = 30
			emit_signal("general_quit")
			emit_signal("juniper_wander")
			await get_tree().create_timer(.03).timeout
			cam_anim.play("RESET")
			player.show()
			player.start_player()
			#main_cam.set_tween_duration(1)
			GlobalVars.in_dialogue = false #never gets set back to false after interacting if u don't do it here, this is where 2nd interact issues come from
			GlobalVars.in_interaction = ""
			alert.show()
			#thoughts = false
			#activate dialogue


func _on_timeline_ended():
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	GlobalVars.in_dialogue = false
	emit_signal("juniper_wander")
	emit_signal("disable_look")
	player.start_player()
	alert.show()
	
func _on_thoughts_ended():
	Dialogic.timeline_ended.disconnect(_on_thoughts_ended)
	GlobalVars.in_dialogue = false
	#await get_tree().create_timer(.5).timeout

func _on_interactable_interacted(interactor):
	emit_signal("general_interact")
	if GlobalVars.in_dialogue == false and GlobalVars.in_interaction == "":
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		alert.hide()
		GlobalVars.in_interaction = interact_type
		FP_Cam.priority = 30
		Exit_Cam.priority = 0 
		cam_anim.play("Cam_Idle")
		if is_player_visible == false:
			player.hide()
		player.stop_player()
		if thoughts == false:
			thoughts = true
			GlobalVars.in_dialogue = true #always set to true even if dialogue not needed
			Dialogic.timeline_ended.connect(_on_thoughts_ended)
			Dialogic.start(thought_dialogue_file)
			GlobalVars.set(view_item, true)
