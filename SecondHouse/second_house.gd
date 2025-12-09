extends Node3D

@export var interactables : Array[Interactable] = []
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

@export var timer : Timer
@onready var time_out = false 
@onready var pause = $Pause

@onready var in_time_out_dialogue = false
@onready var in_kicked_out_dialogue = false

signal phone_time_start

@export var world_env : WorldEnvironment
@export var sub_v_container : SubViewportContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	disable_interaction_beginning(interactables)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	GlobalVars.current_level = "juniper"
	if Dialogic.VAR.get_variable("Global.went_to_Micah") == false and Dialogic.VAR.get_variable("Global.went_to_Juniper") == false:
		Dialogic.VAR.set_variable("Global.first_house", "Juniper")
	#await get_tree().create_timer(1.0).timeout
	#GlobalVars.emit_add_evidence("juniper", "letter")
	#await get_tree().create_timer(10.0).timeout
	#GlobalVars.emit_add_note("juniper", "letter", "found")
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
	if Dialogic.VAR.get_variable("Character Aff Points.Juniper") <= -3:
		GlobalVars.juniper_kicked_out = true
		if in_kicked_out_dialogue == false and GlobalVars.in_interaction == "":
			disable_interaction(interactables)
			alert.hide()
			player.stop_player()
			in_kicked_out_dialogue = true
			var kicked_out_dialogue = Dialogic.start(kicked_out_dialogue_file)
			Dialogic.timeline_ended.connect(_on_timeline_ended_kicked)
			kicked_out_dialogue.register_character(load(load_Dalton_dialogue), dalton_marker)
			kicked_out_dialogue.register_character(load(load_Theo_dialogue), theo_marker)
			kicked_out_dialogue.register_character(load(load_char_dialogue), character_marker)
	
	#timed out
	if time_out == true:
		if in_time_out_dialogue == false and GlobalVars.in_interaction == "" and Dialogic.VAR.get_variable("Juniper.timed_out") == false and GlobalVars.juniper_kicked_out == false:
			alert.hide()
			in_time_out_dialogue = true
			var time_out_dialogue = Dialogic.start(timed_out_dialogue_file)
			Dialogic.timeline_ended.connect(_on_timeline_ended_timed)
			time_out_dialogue.register_character(load(load_Dalton_dialogue), dalton_marker)
			time_out_dialogue.register_character(load(load_Theo_dialogue), theo_marker)
			time_out_dialogue.register_character(load(load_char_dialogue), character_marker)
			
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
			in_time_out_dialogue = true
			print("timeout_dialogue_entered")
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
	emit_signal("phone_time_start")
	print("level start!")
