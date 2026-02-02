extends Node3D

@export var interactables : Array[Interactable] = []
@export var timed_out_dialogue_file: String
@export var kicked_out_dialogue_file: String
@export var load_Dalton_dialogue: String
@export var load_Theo_dialogue: String
@export var load_char_dialogue: String
@export var theo_body : CharacterBody3D
@export var dalton_marker: Marker2D
@export var theo_marker: Marker2D
@export var character_marker: Marker2D

@export var player: CharacterBody3D
@export var alert : Sprite3D

@onready var timer = $UI/Timer
@onready var time_out = false 
@onready var note_interaction = $closet/Note
@onready var pic_fall_interact = $"SubViewportContainer/FirstHouseUpdated/FrameFalling/Armature_001/Skeleton3D/PictureFrameFriend/Pic fall Interact"
@onready var pic_look_interact = $"SubViewportContainer/FirstHouseUpdated/FrameFalling/Armature_001/Skeleton3D/PictureFrameFriend/Picture Look"
@onready var bookmark_interact = $"SubViewportContainer/FirstHouseUpdated/Bookshelf/Bookshelf interact/Bookmark_interact"
@onready var cab_interact = $"SubViewportContainer/FirstHouseUpdated/cabinetz/Cab Interact/Cab"
@onready var tool_look = $UI/Tool_note
@onready var bookmark_look = $UI/Bookmark
@onready var tool_anim = $NewToolBoxTop/AnimationPlayer

@onready var pause = $Pause

@onready var in_time_out_dialogue = false
@onready var in_kicked_out_dialogue = false

@export var world_env : WorldEnvironment
@export var sub_v_container : SubViewportContainer
@export var music : AudioStreamPlayer

signal phone_time_start
signal auto_open
# Called when the node enters the scene tree for the first time.
func _ready():
	print(GlobalVars.phone_contacts)
	if theo_body.visible == false:
		theo_body.visible = true
	GlobalVars.current_level = "micah"
	note_interaction.hide()
	pic_fall_interact.hide()
	bookmark_interact.hide()
	tool_look.hide()
	bookmark_look.hide()
	cab_interact.hide()
	pic_look_interact.hide()
	tool_anim.play("NEWToolOpen")

	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if Dialogic.VAR.get_variable("Global.went_to_Micah") == false and Dialogic.VAR.get_variable("Global.went_to_Juniper") == false:
		Dialogic.VAR.set_variable("Global.first_house", "Micah")
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
		if GlobalVars.micah_time_out == true:
			Dialogic.clear(1)
			disable_interaction(interactables)
			await get_tree().process_frame
			await get_tree().process_frame
			alert.hide()
			player.stop_player()
			in_time_out_dialogue = true
			GlobalVars.in_dialogue = true
			print("timeout_dialogue_entered")
			var time_out_dialogue = Dialogic.start(timed_out_dialogue_file)
			Dialogic.timeline_ended.connect(_on_timeline_ended_timed)
			return
		if GlobalVars.micah_kicked_out == true:
			Dialogic.clear(1)
			disable_interaction(interactables)
			await get_tree().process_frame
			await get_tree().process_frame
			alert.hide()
			player.stop_player()
			in_kicked_out_dialogue = true
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
	#Kicked out 
	if Dialogic.VAR.get_variable("Character Aff Points.Micah") <= -3:
		GlobalVars.micah_kicked_out = true
		if in_kicked_out_dialogue == false and GlobalVars.in_interaction == "":
			Dialogic.clear(1)
			disable_interaction(interactables)
			alert.hide()
			player.stop_player()
			timer.stop()
			SaveLoad.saveGame(SaveLoad.SAVE_DIR + SaveLoad.SAVE_FILE_NAME)
			in_kicked_out_dialogue = true
			GlobalVars.in_dialogue = true
			var kicked_out_dialogue = Dialogic.start(kicked_out_dialogue_file)
			Dialogic.timeline_ended.connect(_on_timeline_ended_kicked)
	
	#timed out
	if time_out == true:
		if in_time_out_dialogue == false and GlobalVars.in_interaction == "" and Dialogic.VAR.get_variable("Asked Questions.Micah_time_out_finished") == false and GlobalVars.micah_kicked_out == false:
			Dialogic.clear(1)
			SaveLoad.saveGame(SaveLoad.SAVE_DIR + SaveLoad.SAVE_FILE_NAME)
			alert.hide()
			#disable_interaction(interactables)
			player.stop_player()
			in_time_out_dialogue = true
			GlobalVars.in_dialogue = true
			var time_out_dialogue = Dialogic.start(timed_out_dialogue_file)
			Dialogic.timeline_ended.connect(_on_timeline_ended_timed)
	
			
	#print($SubViewportContainer/SubViewport/CameraSystem/Camera3D.rotation_degrees.y)

#timeout set to 10 minutes right now
func _on_timer_timeout():
	if GlobalVars.micah_kicked_out == false:
		GlobalVars.micah_time_out = true
		disable_interaction(interactables)
		time_out = true
		print("LEVEL TIMEOUT")
		player.stop_player()
		alert.hide()
		if GlobalVars.in_interaction == "":
			Dialogic.clear(1)
			SaveLoad.saveGame(SaveLoad.SAVE_DIR + SaveLoad.SAVE_FILE_NAME)
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
		i.set_monitorable(false)
		i.queue_free()


func _on_entered_micah():
	timer.start()
	music.play()
	emit_signal("phone_time_start")
	GlobalVars.in_level = true
	print("level start!")
	#disconnect("_on_entered_micah")


func _on_door_activate_leave():
	MusicFades.fade_out_audio()
	GlobalVars.in_level = false
	Dialogic.VAR.set_variable("Asked Questions.left_Micah", true)
	SaveLoad.saveGame(SaveLoad.SAVE_DIR + SaveLoad.SAVE_FILE_NAME)
	print("level exit!")
	await get_tree().create_timer(4.0).timeout
	music.stop() #technically not necessary
	
