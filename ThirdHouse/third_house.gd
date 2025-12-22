extends Node3D

@export var interactables : Array[Interactable] = []
@export var distract_interactables : Array[Interactable] = []
@export var player : CharacterBody3D
@export var alert : Sprite3D
@export var timed_out_dialogue_file : String

@export var load_Dalton_dialogue : String
@export var load_Theo_dialogue : String
@export var load_char_dialogue : String

@export var dalton_marker : Marker2D
@export var theo_marker : Marker2D
@export var character_marker : Marker2D
@export var timer : Timer
@export var music : AudioStreamPlayer
@onready var pause = $Pause

var time_out = false
var in_time_out_dialogue = false

var in_secret = false
var locked = false
signal time_out_drop_distract
signal phone_time_start

@export var world_env : WorldEnvironment
@export var sub_v_container : SubViewportContainer

func _ready():
	GlobalVars.current_level = "quincy"
	Dialogic.VAR.set_variable("Global.went_to_Quincy", true)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	emit_signal("phone_time_start")
	
	#settings
	#brightness
	GlobalVars.pixelation_changed.connect(_set_pixelation)
	_set_pixelation(GlobalVars.stretch_factor) 
	#shadow
	GlobalVars.shadow_changed.connect(_set_shadow)
	_set_shadow(GlobalVars.optional_shadow)
	#pixel
	GlobalVars.brightness_changed.connect(_on_brightness_brightness_shift)
	_on_brightness_brightness_shift(GlobalVars.brightness)
	

func _set_pixelation(stretch) -> void:
	sub_v_container.stretch_shrink = stretch

func _set_shadow(shadow) -> void:
	world_env.environment.ssao_enabled = shadow
	#optional lights for other levels
	#for light in lights:
		#light.shadow_enabled = GlobalVars.optional_shadow
func _on_brightness_brightness_shift(brightness) -> void:
	world_env.environment.adjustment_brightness = brightness

func _input(event):
	if Input.is_action_just_pressed("Quit"):
		if pause.visible == false:
			pause.visible = true

func _process(delta):
	#Kicked out 
	if Dialogic.VAR.get_variable("Quincy.kicked_out") == true:
		GlobalVars.quincy_kicked_out = true
		disable_interaction(interactables)
			#alert.hide()
			#player.stop_player()
			#in_kicked_out_dialogue = true
			#var kicked_out_dialogue = Dialogic.start(kicked_out_dialogue_file)
			#Dialogic.timeline_ended.connect(_on_timeline_ended_kicked)
			#kicked_out_dialogue.register_character(load(load_Dalton_dialogue), dalton_marker)
			#kicked_out_dialogue.register_character(load(load_Theo_dialogue), theo_marker)
			#kicked_out_dialogue.register_character(load(load_char_dialogue), character_marker)

	#timed out
	if time_out == true:
		if in_time_out_dialogue == false and GlobalVars.in_interaction == "" and Dialogic.VAR.get_variable("Quincy.timed_out") == false and GlobalVars.quincy_kicked_out == false:
			alert.hide()
			in_time_out_dialogue = true
			var time_out_dialogue = Dialogic.start(timed_out_dialogue_file)
			Dialogic.timeline_ended.connect(_on_timeline_ended_timed)
			time_out_dialogue.register_character(load(load_Dalton_dialogue), dalton_marker)
			time_out_dialogue.register_character(load(load_Theo_dialogue), theo_marker)
			time_out_dialogue.register_character(load(load_char_dialogue), character_marker)
	
	
	if Dialogic.VAR.get_variable("Quincy.is_distracted") == true and locked == false:
		disable_distraction_interaction(distract_interactables)
		locked == true
	elif Dialogic.VAR.get_variable("Quincy.is_distracted") == false and locked == true:
		enable_distraction_interaction(distract_interactables)
		locked == false
	else:
		return
		
#timeout set to 10 minutes right now
func _on_timer_timeout():
	if GlobalVars.quincy_kicked_out == false:
		GlobalVars.quincy_time_out = true
		if Dialogic.VAR.get_variable("Quincy.is_distracted") == true:
			Dialogic.VAR.set_variable("Quincy.is_distracted", false)
		emit_signal("time_out_drop_distract")
		disable_interaction(interactables)
		time_out = true
		print("LEVEL TIMEOUT")
		player.stop_player()
		alert.hide()
		if GlobalVars.in_interaction == "":
			in_time_out_dialogue = true
			var time_out_dialogue = Dialogic.start(timed_out_dialogue_file)
			Dialogic.timeline_ended.connect(_on_timeline_ended_timed)
			time_out_dialogue.register_character(load(load_Dalton_dialogue), dalton_marker)
			time_out_dialogue.register_character(load(load_Theo_dialogue), theo_marker)
			time_out_dialogue.register_character(load(load_char_dialogue), character_marker)
		else:
			pass
		 

func _on_timeline_ended_timed():
	Dialogic.timeline_ended.disconnect(_on_timeline_ended_timed)
	GlobalVars.in_dialogue = false
	player.start_player()
	alert.hide()
	

func _on_timeline_ended_kicked():
	Dialogic.timeline_ended.disconnect(_on_timeline_ended_kicked)
	GlobalVars.in_dialogue = false
	player.start_player()
	alert.hide()

func disable_interaction(arr: Array):
	for i in arr:
		i.set_monitorable(false)
		i.queue_free()

func enable_distraction_interaction(arr: Array):
	for i in arr:
		i.set_monitorable(true)

func disable_distraction_interaction(arr: Array):
	for i in arr:
		i.set_monitorable(false)
#
#func _on_secret_entered(body):
	#if body == player:
		#if in_secret == false:
			#in_secret = true
			#timer.paused = true
#
#func _on_secret_exit(body):
	#if body == player:
		#if in_secret == true:
			#in_secret = false
			#timer.paused = false


func _on_cutscene_cams_faint_disable():
	disable_interaction(interactables)
	GlobalVars.quincy_fainted = false


func _on_quincy_pause_timeout():
	print("time out paused: " + str(timer.time_left)) 
	timer.paused = true
	


func _on_quincy_time_out_resume():
	timer.paused = false
	print("time out resume: " + str(timer.time_left))


func _on_quincy_entered():
	timer.start()
	emit_signal("phone_time_start")
	print("level start!")
	music.play()
