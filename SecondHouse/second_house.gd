extends Node3D

@export var interactables : Array[Interactable] = []
@export var tea_interactable : Interactable
@export var timed_out_dialogue_file: String
@export var kicked_out_dialogue_file: String
@export var load_Dalton_dialogue: String
@export var load_Theo_dialogue: String
@export var load_char_dialogue: String

@export var dalton_marker: Marker2D
@export var theo_marker: Marker2D
@export var character_marker: Marker2D

@export var player: CharacterBody3D
@export var alert : Sprite3D

@export var music : AudioStreamPlayer

@export var timer : Timer
@onready var time_out = false 
@onready var pause = $Pause

@onready var in_time_out_dialogue = false
@onready var in_kicked_out_dialogue = false

signal phone_time_start
signal auto_open

var mouse_pos = Vector2(0,0) 
@export var world_env : WorldEnvironment
@export var sub_v_container : SubViewportContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	if Dialogic.timeline_ended.is_connected(_on_timeline_ended_kicked):
		Dialogic.timeline_ended.disconnect(_on_timeline_ended_kicked)
	if Dialogic.timeline_ended.is_connected(_on_timeline_ended_timed):
		Dialogic.timeline_ended.disconnect(_on_timeline_ended_timed)
	#player.start_player()
	if GlobalVars.in_level == false:
		disable_interaction_beginning(interactables)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	GlobalVars.current_level = "juniper"
	if Dialogic.VAR.get_variable("Global.went_to_Micah") == false and Dialogic.VAR.get_variable("Global.went_to_Juniper") == false:
		Dialogic.VAR.set_variable("Global.first_house", "Juniper")
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
	if GlobalVars.from_save_file == true and GlobalVars.in_level == true:
		music.play()
		if GlobalVars.juniper_time_out == true:
			Dialogic.clear(1)
			disable_interaction(interactables)
			await get_tree().process_frame
			await get_tree().process_frame
			alert.hide()
			player.stop_player()
			#in_time_out_dialogue = true
			GlobalVars.in_dialogue = true
			var time_out_dialogue = Dialogic.start(timed_out_dialogue_file)
			Dialogic.timeline_ended.connect(_on_timeline_ended_timed)
			return
		if GlobalVars.juniper_kicked_out == true:
			Dialogic.clear(1)
			disable_interaction(interactables)
			await get_tree().process_frame
			await get_tree().process_frame
			alert.hide()
			player.stop_player()
			GlobalVars.in_dialogue = true
			var kicked_out_dialogue = Dialogic.start(kicked_out_dialogue_file)
			Dialogic.timeline_ended.connect(_on_timeline_ended_kicked)
			return
		timer.wait_time = GlobalVars.time_left
		timer.start()

func _set_pixelation(stretch) -> void:
	sub_v_container.stretch_shrink = stretch

func _set_shadow(shadow) -> void:
	world_env.environment.ssao_enabled = shadow
	#optional lights for other levels
	#for light in lights:
		#light.shadow_enabled = GlobalVars.optional_shadow
func _on_brightness_brightness_shift(brightness) -> void:
	world_env.environment.adjustment_brightness = brightness

func _process(delta):
	GlobalVars.time_left = timer.time_left
	#print(get_viewport().get_mouse_position())
	#Kicked out 
	#if Input.is_action_just_pressed("call"):
		#print("Juniper_bookmark" + str(Dialogic.VAR.Juniper.viewed_bookmark))
		#print("Micah_bookmark:" + str(Dialogic.VAR["Asked Questions"]["Micah_viewed_bookmark"]))
		#print("MicahClyde" + str(Dialogic.VAR["Asked Questions"]["Micah_Asked_Clyde"]))
		#print("MicahPoints" + str(Dialogic.VAR["Character Aff Points"]["Micah"]))
		#print("JuniperPoints" + str(Dialogic.VAR["Character Aff Points"]["Juniper"]))
		#print("JuniperMomRever" + str(Dialogic.VAR.Juniper.ask_mom_rever))
		
	if GlobalVars.in_interaction != "":
		mouse_pos = get_viewport().get_mouse_position()
	if Dialogic.VAR.get_variable("Character Aff Points.Juniper") <= -4:
		if GlobalVars.juniper_kicked_out == false and GlobalVars.in_interaction == "":
			GlobalVars.juniper_kicked_out = true
			disable_interaction(interactables)
			alert.hide()
			player.stop_player()
			Dialogic.clear(1)
			SaveLoad.saveGame(SaveLoad.SAVE_DIR + SaveLoad.SAVE_FILE_NAME)
			GlobalVars.in_dialogue = true
			var kicked_out_dialogue = Dialogic.start(kicked_out_dialogue_file)
			Dialogic.timeline_ended.connect(_on_timeline_ended_kicked)
	
	#timed out
	if time_out == true:
		if in_time_out_dialogue == false and GlobalVars.in_interaction == "" and Dialogic.VAR.get_variable("Juniper.timed_out") == false and GlobalVars.juniper_kicked_out == false:
			alert.hide()
			player.stop_player()
			Dialogic.clear(1)
			in_time_out_dialogue = true
			SaveLoad.saveGame(SaveLoad.SAVE_DIR + SaveLoad.SAVE_FILE_NAME)
			GlobalVars.in_dialogue = true
			var time_out_dialogue = Dialogic.start(timed_out_dialogue_file)
			Dialogic.timeline_ended.connect(_on_timeline_ended_timed)
			
	#print($SubViewportContainer/SubViewport/CameraSystem/Camera3D.rotation_degrees.y)

#timeout set to 10 minutes right now
func _on_timer_timeout():
	if GlobalVars.juniper_kicked_out == false:
		GlobalVars.juniper_time_out = true
		disable_interaction(interactables)
		time_out = true
		print("LEVEL TIMEOUT")
		player.stop_player()
		alert.hide()
		if GlobalVars.in_interaction == "":
			#await get_tree().process_frame
			SaveLoad.saveGame(SaveLoad.SAVE_DIR + SaveLoad.SAVE_FILE_NAME)
			Dialogic.clear(1)
			in_time_out_dialogue = true
			GlobalVars.in_dialogue = true
			print("timeout_dialogue_entered")
			var time_out_dialogue = Dialogic.start(timed_out_dialogue_file)
			Dialogic.timeline_ended.connect(_on_timeline_ended_timed)
		else:
			pass
		 

func _on_timeline_ended_timed():
	Dialogic.timeline_ended.disconnect(_on_timeline_ended_timed)
	GlobalVars.in_dialogue = false
	player.start_player()
	alert.hide()
	emit_signal("auto_open")
	

func _on_timeline_ended_kicked():
	Dialogic.timeline_ended.disconnect(_on_timeline_ended_kicked)
	GlobalVars.in_dialogue = false
	player.start_player()
	alert.hide()
	emit_signal("auto_open")
	

func disable_interaction(arr: Array):
	for i in arr:
		if i:
			i.set_monitorable(false)
			i.queue_free()

func disable_interaction_beginning(arr: Array):
	for i in arr:
		i.set_monitorable(false)

func enable_interaction(arr: Array):
	for i in arr:
		i.set_monitorable(true)

func can_interact():
	enable_interaction(interactables)

func _on_entered_juniper():
	timer.start()
	GlobalVars.in_level = true
	emit_signal("phone_time_start")
	music.play()
	print("level start!")

func _leave_level():
	disable_interaction(interactables)
	if tea_interactable.monitorable:
		tea_interactable.set_deferred("monitorable", false)

func _on_level_exit():
	print("level exited!")
	GlobalVars.in_level = false
	Dialogic.VAR.set_variable("Juniper.left_juniper", true)
	SaveLoad.saveGame(SaveLoad.SAVE_DIR + SaveLoad.SAVE_FILE_NAME)
	MusicFades.fade_out_audio()
	await get_tree().create_timer(5.0).timeout
	music.stop()
	MusicFades.fade_in_audio()
