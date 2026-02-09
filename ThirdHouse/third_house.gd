extends Node3D

@export var interactables : Array[Interactable] = []
@export var distract_interactables : Array[Interactable] = []
@export var player : CharacterBody3D
@export var alert : Sprite3D
@export var timed_out_dialogue_file : String
@export var death : Node2D
@export var load_Dalton_dialogue : String
@export var load_Theo_dialogue : String
@export var load_char_dialogue : String

@export var dalton_marker : Marker2D
@export var theo_marker : Marker2D
@export var character_marker : Marker2D
@export var timer : Timer
@export var distract_time : Timer
@export var music : AudioStreamPlayer

@export var door : Interactable
@onready var pause = $Pause
@export var bathroom_door : Node3D
var time_out = false
var in_time_out_dialogue = false
var in_secret = false
var locked = false
signal time_out_drop_distract
signal phone_time_start
signal open_main_door

signal bar_timed
signal theo_leave
signal quincy_leave

signal load_bath
@export var phone_overlay : CanvasLayer
signal level_end
@export var world_env : WorldEnvironment
@export var sub_v_container : SubViewportContainer

@export var hide_tween : AnimationPlayer
var mouse_pos
func _ready():
	MusicFades.fade_in_audio() #for reset
	print(Dialogic.VAR.get_variable("Asked Questions.Micah_viewed_bookmark"), "Micahbookmark")
	GlobalVars.current_level = "quincy"
	if Dialogic.VAR.get_variable("Global.went_to_Quincy") == false:
		Dialogic.VAR.set_variable("Global.went_to_Quincy", true)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	emit_signal("phone_time_start")
	#player.start_player()
	death.hide()
	print(GlobalVars.time_left)
	#MusicFades.fade_out_audio()
	if GlobalVars.in_level:
		hide_tween.play("fade_in_hide_tween")
		#await hide_tween.animation_finished

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

		if GlobalVars.quincy_time_out == true:
			disable_interaction(interactables)
			Dialogic.clear(1)
			await get_tree().process_frame
			await get_tree().process_frame
			player.stop_player()
			alert.hide()
			in_time_out_dialogue = true
			await hide_tween.animation_finished
			var time_out_dialogue = Dialogic.start(timed_out_dialogue_file)
			Dialogic.timeline_ended.connect(_on_timeline_ended_timed)
			return
		if GlobalVars.quincy_kicked_out == true:
			disable_interaction(interactables)
			Dialogic.clear(1)
			await get_tree().process_frame
			await get_tree().process_frame
			player.start_player()
			alert.hide()
			await hide_tween.animation_finished
			emit_signal("theo_leave")
			emit_signal("quincy_leave")
			emit_signal("open_main_door")
			return
		timer.wait_time = GlobalVars.time_left
		timer.start()
	await get_tree().process_frame
	await get_tree().process_frame
	print(Dialogic.VAR.get_variable("Quincy.is_distracted"), " distracted")
	print(Dialogic.VAR.get_variable("Quincy.caught"), " caught")
	if interactables[0].monitorable == false:
		interactables[0].set_deferred("monitorable", true)
	await hide_tween.animation_finished

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
	if GlobalVars.in_interaction != "":
		mouse_pos = get_viewport().get_mouse_position()
	if Dialogic.VAR.get_variable("Quincy.kicked_out") == true and GlobalVars.quincy_kicked_out == false:
		Dialogic.clear(1)
		Dialogic.VAR.set_variable("Quincy.has_choco", false)
		SaveLoad.saveGame(SaveLoad.SAVE_DIR + SaveLoad.SAVE_FILE_NAME)
		GlobalVars.quincy_kicked_out = true
		disable_interaction(interactables)
		door.set_deferred("monitorable", false)
		emit_signal("theo_leave")
		emit_signal("quincy_leave")
		emit_signal("open_main_door")
		
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
		if in_time_out_dialogue == false and GlobalVars.in_interaction == "" and Dialogic.VAR.get_variable("Quincy.timed_out") == false and GlobalVars.quincy_kicked_out == false and bathroom_door.player_in_bathroom == false:
			player.stop_player()
			alert.hide()
			Dialogic.clear(1)
			SaveLoad.saveGame(SaveLoad.SAVE_DIR + SaveLoad.SAVE_FILE_NAME)
			disable_interaction(interactables)
			alert.hide()
			in_time_out_dialogue = true
			var time_out_dialogue = Dialogic.start(timed_out_dialogue_file)
			Dialogic.timeline_ended.connect(_on_timeline_ended_timed)
			await get_tree().process_frame
			if alert.visible == true:
				alert.hide()
	
	
	if Dialogic.VAR.get_variable("Quincy.is_distracted") == true and locked == false:
		disable_distraction_interaction(distract_interactables)
		locked = true
	elif Dialogic.VAR.get_variable("Quincy.is_distracted") == false and locked == true:
		enable_distraction_interaction(distract_interactables)
		locked = false
	else:
		return
		
#timeout set to 10 minutes right now
func _on_timer_timeout():
	if GlobalVars.quincy_kicked_out == false:
		GlobalVars.quincy_time_out = true
		if Dialogic.VAR.get_variable("Quincy.is_distracted") == true:
			Dialogic.VAR.set_variable("Quincy.is_distracted", false)
		emit_signal("time_out_drop_distract")
		time_out = true
		print("LEVEL TIMEOUT")
		#emit_signal("theo_leave")
		#emit_signal("quincy_leave")
		if GlobalVars.in_interaction == "" and Dialogic.VAR.get_variable("Quincy.dalton_in_bath") == false:
			player.stop_player()
			alert.hide()
			Dialogic.clear(1)
			SaveLoad.saveGame(SaveLoad.SAVE_DIR + SaveLoad.SAVE_FILE_NAME)
			disable_interaction(interactables)
			in_time_out_dialogue = true
			var time_out_dialogue = Dialogic.start(timed_out_dialogue_file)
			Dialogic.timeline_ended.connect(_on_timeline_ended_timed)
		 

func _on_timeline_ended_timed():
	emit_signal("theo_leave")
	emit_signal("quincy_leave")
	emit_signal("bar_timed")
	Dialogic.timeline_ended.disconnect(_on_timeline_ended_timed)
	emit_signal("open_main_door")
	GlobalVars.in_dialogue = false
	player.start_player()
	alert.hide()
	

func _on_timeline_ended_kicked():
	emit_signal("theo_leave")
	emit_signal("quincy_leave")
	Dialogic.timeline_ended.disconnect(_on_timeline_ended_kicked)
	GlobalVars.in_dialogue = false
	player.start_player()
	alert.hide()

func disable_interaction(arr: Array):
	for i in arr:
		if i:
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
func _leave_level():
	disable_interaction(interactables)

func _on_cutscene_cams_faint_disable():
	disable_interaction(interactables)
	door.set_deferred("monitorable", false)
	GlobalVars.quincy_fainted = true


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
	GlobalVars.in_level = true
	music.play()
	#MusicFades.fade_in_audio() sound better if u just play
	


func _on_exit_level():
	print("level exit!")
	emit_signal("level_end")
	GlobalVars.in_level = false
	Dialogic.VAR.set_variable("Quincy.left_quincy", true)
	SaveLoad.saveGame(SaveLoad.SAVE_DIR + SaveLoad.SAVE_FILE_NAME)
	MusicFades.fade_out_audio()
	await get_tree().create_timer(5.0).timeout
	music.stop()
	MusicFades.fade_in_audio()
