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
@export var viewed_dialogue_file: String
@export var regular_dialogue_file: String
@export var cue_distract_dialogue :String
@export var load_Dalton_dialogue: String
@export var load_Theo_dialogue: String
@export var load_char_dialogue: String

#Load Global Variables
@export var interact_type: String
@export var dialogue: String
@export var view_item: String

#set defaults
@onready var mouse_pos = Vector2(0,0) 
@onready var distracted : bool
@onready var need_distraction : bool
@onready var try_viewed = 0

var kicked = false
var timed = false
var in_thoughts = false
signal thoughts_finished
signal exit_interact

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	distracted = Dialogic.VAR.get_variable("Quincy.is_distracted") 
	need_distraction = Dialogic.VAR.get_variable("Quincy.needs_distraction")
	if try_viewed == 2:
		Dialogic.VAR.set_variable("Quincy.needs_distraction", true)
	var read_dialogue : bool = GlobalVars.get(dialogue)
	var viewed_item : bool = GlobalVars.get(view_item)
	mouse_pos = get_viewport().get_mouse_position()
	
	if GlobalVars.current_level == "Quincy":
		kicked = GlobalVars.quincy_kicked_out
		timed = GlobalVars.quincy_time_out
	elif GlobalVars.current_level == "Juniper":
		kicked = GlobalVars.juniper_kicked_out
		timed = GlobalVars.juniper_time_out
	
	if GlobalVars.in_look_screen == false and GlobalVars.in_dialogue == false and GlobalVars.in_interaction == interact_type:
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
		if Input.is_action_just_pressed("Exit") and viewed_item == true and read_dialogue == false and GlobalVars.viewing == "" and kicked == false and timed == false:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			Exit_Cam.set_tween_duration(0)
			FP_Cam.priority = 0
			Exit_Cam.priority = 30
			await get_tree().create_timer(.03).timeout
			cam_anim.play("RESET")
			player.show()
			var game_dialogue = Dialogic.start(viewed_dialogue_file)
			Dialogic.timeline_ended.connect(_on_timeline_ended)
			game_dialogue.register_character(load(load_Dalton_dialogue), dalton_marker)
			game_dialogue.register_character(load(load_Theo_dialogue), theo_marker)
			game_dialogue.register_character(load(load_char_dialogue), character_marker)
			GlobalVars.in_interaction = ""
			GlobalVars.set(dialogue, true)
			interact_area.hide()
			alert.hide()
		elif Input.is_action_just_pressed("Exit") and GlobalVars.viewing == "":
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			Exit_Cam.set_tween_duration(0)
			FP_Cam.priority = 0
			Exit_Cam.priority = 30
			await get_tree().create_timer(.03).timeout
			cam_anim.play("RESET")
			player.show()
			player.start_player()
			#main_cam.set_tween_duration(1)
			GlobalVars.in_interaction = ""
			interact_area.hide()
			alert.show()
			#activate dialogue

	if GlobalVars.in_look_screen == true:
		interact_area.hide()
	elif GlobalVars.in_look_screen == false and FP_Cam.priority == 30:
		interact_area.show()


func _on_timeline_ended():
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	GlobalVars.in_interaction = ""
	GlobalVars.in_dialogue = false
	player.start_player()
	alert.show()
	
func _on_thoughts_ended():
	Dialogic.timeline_ended.disconnect(_on_thoughts_ended)
	in_thoughts = false
	GlobalVars.in_dialogue = false
	emit_signal("thoughts_finished") 
	print(in_thoughts)


func _on_interactable_interacted(interactor):
	if GlobalVars.in_interaction == "" and GlobalVars.in_dialogue == false:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		alert.hide()
		GlobalVars.in_interaction = interact_type
		FP_Cam.priority = 30
		Exit_Cam.priority = 0 
		interact_area.show()
		cam_anim.play("Cam_Idle")
		player.hide()
		player.stop_player()
		


func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed == true:
			if GlobalVars.in_look_screen == false and GlobalVars.in_dialogue == false and GlobalVars.in_interaction == interact_type and GlobalVars.quincy_kicked_out == false and GlobalVars.quincy_time_out == false:
				if Dialogic.VAR.get_variable("Quincy.is_distracted") == false:
					Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
					interact_area.hide()
					choose_quincy_cycle_dialogue()
					if need_distraction == true:
						GlobalVars.in_dialogue = true
						choose_distract_thought_dialogue()
						in_thoughts = true
						Dialogic.start(cue_distract_dialogue)
						Dialogic.timeline_ended.connect(_on_thoughts_ended)
					else:
						try_viewed += 1
					if in_thoughts == false:
						Exit_Cam.set_tween_duration(0)
						FP_Cam.priority = 0
						Exit_Cam.priority = 30 
						Exit_Cam.set_tween_duration(1)
						player.show()
						GlobalVars.in_dialogue = true
						var game_dialogue = Dialogic.start(regular_dialogue_file)
						Dialogic.timeline_ended.connect(_on_timeline_ended)
						game_dialogue.register_character(load(load_Dalton_dialogue), dalton_marker)
						game_dialogue.register_character(load(load_Theo_dialogue), theo_marker)
						game_dialogue.register_character(load(load_char_dialogue), character_marker)
						player.stop_player()
						alert.hide()


func choose_distract_thought_dialogue():
	if Dialogic.VAR.get_variable("Quincy.first_cue") == true:
		var rng = RandomNumberGenerator.new()
		var random = rng.randi_range(1, 3)
		Dialogic.VAR.set_variable("Quincy.cue_cycle", random)
		print("cue cycle " + str(random))
	else:
		Dialogic.VAR.set_variable("Quincy.first_cue", true)
		Dialogic.VAR.set_variable("Quincy.cue_cycle", 1)
		
func choose_quincy_cycle_dialogue():
	var rng = RandomNumberGenerator.new()
	var random = rng.randi_range(1, 3)
	Dialogic.VAR.set_variable("Quincy.bedroom_cycle", random)
#Set try viewed --> needs distraction after 2 looks
#set up cycling dialogue for cue thoughts and quincy dialogue for this and bookshelf



func _on_thoughts_finished():
	if in_thoughts == false and GlobalVars.in_dialogue== false:
		interact_area.hide()
		Exit_Cam.set_tween_duration(0)
		FP_Cam.priority = 0
		Exit_Cam.priority = 30 
		Exit_Cam.set_tween_duration(1)
		player.show()
		GlobalVars.in_dialogue = true
		var game_dialogue = Dialogic.start(regular_dialogue_file)
		Dialogic.timeline_ended.connect(_on_timeline_ended)
		game_dialogue.register_character(load(load_Dalton_dialogue), dalton_marker)
		game_dialogue.register_character(load(load_Theo_dialogue), theo_marker)
		game_dialogue.register_character(load(load_char_dialogue), character_marker)
		player.stop_player()
		alert.hide()



func _on_quincy_caught_in_view():
	interact_area.hide()
	Exit_Cam.set_tween_duration(0)
	FP_Cam.priority = 0
	Exit_Cam.priority = 30 
	Exit_Cam.set_tween_duration(1)
	GlobalVars.in_interaction = ""
	player.show()
	emit_signal("exit_interact")
