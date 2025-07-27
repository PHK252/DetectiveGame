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
@export var open_interact : Area2D
@export var close_interact : Area2D
@export var interact_area: Area2D
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
@onready var is_open: bool = false
#set anims
@export var animation_tree : AnimationTree
@export var extra_animation: AnimationPlayer = null

@onready var cab_anim = false

#sounds
@export var open_sound : AudioStreamPlayer3D
@export var close_sound : AudioStreamPlayer3D
signal general_interact
signal exit_interact

var kicked = false
var timed = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if extra_animation:
		extra_animation.play("RESET")
	

func _process(delta):
	var read_dialogue : bool = GlobalVars.get(dialogue)
	var viewed_item : bool = GlobalVars.get(view_item)
	#print(mouse_pos) 
	if GlobalVars.current_level == "Quincy":
		kicked = GlobalVars.quincy_kicked_out
		timed = GlobalVars.quincy_time_out
	elif GlobalVars.current_level == "Juniper":
		kicked = GlobalVars.juniper_kicked_out
		timed = GlobalVars.juniper_time_out

	mouse_pos = get_viewport().get_mouse_position()
	if GlobalVars.in_look_screen == false and GlobalVars.in_dialogue == false and GlobalVars.in_interaction == interact_type:
		if mouse_pos.y >= tilt_up_thres:
			FP_Cam.set_rotation_degrees(tilt_up_angle)
		elif mouse_pos.y < tilt_down_thres:
			FP_Cam.set_rotation_degrees(tilt_down_angle)
		else:
			FP_Cam.set_rotation_degrees(mid_angle)
				#pass
	else:
		#mouse_pos = mouse_pos
		if down_default == true:
			FP_Cam.set_rotation_degrees(tilt_up_angle)
		else:
			FP_Cam.set_rotation_degrees(mid_angle)
	
	if GlobalVars.in_look_screen == false and GlobalVars.in_dialogue == false and GlobalVars.in_interaction == interact_type:
		if Input.is_action_just_pressed("Exit") and viewed_item == true and read_dialogue == false and GlobalVars.viewing == "" and cab_anim == false and kicked == false and timed == false:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			Exit_Cam.set_tween_duration(0)
			FP_Cam.priority = 0
			Exit_Cam.priority = 30
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
			open_interact.hide()
			close_interact.hide()
			alert.hide()
		elif Input.is_action_just_pressed("Exit") and GlobalVars.viewing == "" and cab_anim == false:
			print("exit")
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			Exit_Cam.set_tween_duration(0)
			FP_Cam.priority = 0
			Exit_Cam.priority = 30
			cam_anim.play("RESET")
			player.show()
			player.start_player()
			#main_cam.set_tween_duration(1)
			GlobalVars.in_interaction = ""
			interact_area.hide()
			open_interact.hide()
			close_interact.hide()
			alert.show()
			#activate dialogue

	if GlobalVars.in_look_screen == true:
		interact_area.hide()
	elif GlobalVars.in_look_screen == false and FP_Cam.priority == 30 and is_open == true and cab_anim == false:
		interact_area.show()

func _on_interactable_interacted(interactor: Interactor) -> void:
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
		
		if is_open == false:
			open_interact.show()
			close_interact.hide()
			interact_area.hide()
			
		if is_open == true: 
			open_interact.hide()
			close_interact.show()
			interact_area.show()


func open() -> void:
	#open_sound.play()
	cab_anim = true
	animation_tree["parameters/conditions/is_opened"] = true
	animation_tree["parameters/conditions/is_closed"] = false
	is_open = true
	if extra_animation:
		extra_animation.play("Open")
		open_interact.hide()
		await extra_animation.animation_finished
		interact_area.show()
		await get_tree().create_timer(2.1).timeout
		close_interact.show()
		print(GlobalVars.viewing)
		cab_anim = false
		print("finished")
	else:
		open_interact.hide()
		await get_tree().create_timer(2.1).timeout
		interact_area.show()
		close_interact.show()
		await get_tree().create_timer(.2).timeout
		cab_anim = false
	
func close() -> void:
	#close_sound.play()
	cab_anim = true
	animation_tree["parameters/conditions/is_closed"] = true
	animation_tree["parameters/conditions/is_opened"] = false
	is_open = false
	if extra_animation:
		extra_animation.play("Close")
		close_interact.hide()
		interact_area.hide()
		await get_tree().create_timer(2.1).timeout
		open_interact.show()
		await get_tree().create_timer(.2).timeout
		cab_anim = false
	else:
		close_interact.hide()
		interact_area.hide()
		await get_tree().create_timer(2.1).timeout
		open_interact.show()
		await get_tree().create_timer(.2).timeout
		cab_anim = false
	
	

func _on_timeline_ended():
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	GlobalVars.in_dialogue = false
	player.start_player()
	alert.show()


func _on_to_open_drawer_input_event(viewport, event, shape_idx):
	if GlobalVars.in_look_screen == false:
		if event is InputEventMouseButton:
			open()


func _on_to_close_drawer_input_event(viewport, event, shape_idx):
		if GlobalVars.in_look_screen == false:
			if event is InputEventMouseButton:
				close()


func _on_quincy_caught_in_view():
	interact_area.hide()
	Exit_Cam.set_tween_duration(0)
	FP_Cam.priority = 0
	Exit_Cam.priority = 30 
	Exit_Cam.set_tween_duration(1)
	GlobalVars.in_interaction = ""
	player.show()
	emit_signal("exit_interact")
