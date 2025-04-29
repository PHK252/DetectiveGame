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
@export var load_Dalton_dialogue: String
@export var load_Theo_dialogue: String
@export var load_char_dialogue: String

#Interaction Variables
@export var interact_area_1: Area2D
@export var interact_area_2: Area2D
@export var distraction_dialogue_file: String
@export var regular_dialogue_file: String
@export var thought_dialogue_file: String

#@export var flood_anim : AnimationPlayer
#@export var anim_track : String
#Load Global Variables
@export var interact_type: String
@export var view_item: String


#set defaults
@onready var mouse_pos = Vector2(0,0)
@onready var need_distraction : bool
@onready var distracted : bool


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	mouse_pos = get_viewport().get_mouse_position()
	need_distraction = Dialogic.VAR.get_variable("Quincy.needs_distraction")
	distracted = Dialogic.VAR.get_variable("Quincy.out_of_bathroom") 
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
		if Input.is_action_just_pressed("Exit"):
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			Exit_Cam.set_tween_duration(0)
			FP_Cam.priority = 0
			Exit_Cam.priority = 30
			await get_tree().create_timer(.03).timeout
			cam_anim.play("RESET")
			player.show()
			player.start_player()
			GlobalVars.in_interaction = ""
			interact_area_1.hide()
			interact_area_2.hide()
			alert.show()
			#activate dialogue
		if GlobalVars.get(view_item) == true:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			Exit_Cam.set_tween_duration(0)
			FP_Cam.priority = 0
			Exit_Cam.priority = 30
			await get_tree().create_timer(.03).timeout
			cam_anim.play("RESET")
			player.show()
			player.start_player()
			GlobalVars.in_interaction = ""
			interact_area_1.hide()
			interact_area_2.hide()
			alert.show()
			#flood_anim.play(anim_track)
			
	if GlobalVars.in_look_screen == true:
		interact_area_1.hide()
		interact_area_2.hide()

	elif GlobalVars.in_look_screen == false and FP_Cam.priority == 30:
		interact_area_1.hide()
		interact_area_2.hide()


func _on_thoughts_ended():
	Dialogic.timeline_ended.disconnect(_on_thoughts_ended)
	GlobalVars.in_dialogue = false
	interact_area_1.show()
	interact_area_2.show()

func _on_timeline_ended():
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	GlobalVars.in_dialogue = false
	player.start_player()
	alert.show()

func _on_interactable_interacted(interactor):
	if distracted == true:
		GlobalVars.in_dialogue = true
		Dialogic.timeline_ended.connect(_on_thoughts_ended)
		Dialogic.start(thought_dialogue_file)
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		alert.hide()
		GlobalVars.in_interaction = interact_type
		FP_Cam.priority = 30
		Exit_Cam.priority = 0 
		cam_anim.play("Cam_Idle")
		player.hide()
		player.stop_player()
	elif need_distraction == true: 
		GlobalVars.in_dialogue = true
		Dialogic.timeline_ended.connect(_on_timeline_ended)
		var game_dialogue = Dialogic.start(distraction_dialogue_file)
		game_dialogue.register_character(load(load_Dalton_dialogue), dalton_marker)
		game_dialogue.register_character(load(load_Theo_dialogue), theo_marker)
		game_dialogue.register_character(load(load_char_dialogue), character_marker)
		player.stop_player()
		alert.hide()
	else:
		GlobalVars.in_dialogue = true
		Dialogic.timeline_ended.connect(_on_timeline_ended)
		var game_dialogue = Dialogic.start(regular_dialogue_file)
		game_dialogue.register_character(load(load_Dalton_dialogue), dalton_marker)
		game_dialogue.register_character(load(load_Theo_dialogue), theo_marker)
		game_dialogue.register_character(load(load_char_dialogue), character_marker)
		player.stop_player()
		alert.hide()
