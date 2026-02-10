extends Node3D
@export var main : Node3D
@export var player : CharacterBody3D
@export var alert : Sprite3D
@export var dalton_marker : Marker2D
@export var theo_marker : Marker2D
@export var skylar_marker : Marker2D
signal dalton_rotate
signal  walk_skylar
@onready var pause = $Pause

@export var world_env : WorldEnvironment
@export var sub_v_container : SubViewportContainer

@export var case_anim : AnimationPlayer
@export var case : Node3D


func _ready():
	case.visible = false
	case_anim.play("closed")
	emit_signal("dalton_rotate")
	GlobalVars.current_level = "secret"
	Dialogic.VAR.set_variable("Global.went_to_secret", true)
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	GlobalVars.in_dialogue = true
	await get_tree().create_timer(4).timeout
	if GlobalVars.in_interaction == "":
		var arrived_dialogue = Dialogic.start("Secret_arrived")
		Dialogic.timeline_ended.connect(_on_timeline_ended)
		arrived_dialogue.register_character(load("res://Dialogic Characters/Dalton.dch"), dalton_marker)
		arrived_dialogue.register_character(load("res://Dialogic Characters/Theo.dch"), theo_marker)
		player.stop_player()
		
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



func _on_timeline_ended():
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	GlobalVars.in_dialogue = false
	player.start_player()
	GlobalVars.in_interaction = ""


func _on_enter_skylar(body):
	if GlobalVars.in_interaction == "" and GlobalVars.in_dialogue == false and Dialogic.VAR.get_variable("Secret Location.finish_case") == true:
		GlobalVars.in_dialogue = true
		var exit_dialogue = Dialogic.start("Secret_Skylar_meet")
		Dialogic.timeline_ended.connect(_exit_scene)
		Dialogic.signal_event.connect(_enter_skylar)
		exit_dialogue.register_character(load("res://Dialogic Characters/Dalton.dch"), dalton_marker)
		exit_dialogue.register_character(load("res://Dialogic Characters/Theo.dch"), theo_marker)
		exit_dialogue.register_character(load("res://Dialogic Characters/Skylar.dch"), skylar_marker)
		player.stop_player()
		pass

func _enter_skylar(arg : String):
	if arg == "skylar_enter":
		emit_signal("walk_skylar")
		pass

func _exit_scene():
	Dialogic.timeline_ended.disconnect(_exit_scene)
	GlobalVars.in_dialogue = false
	player.start_player()
	GlobalVars.in_interaction = ""
	Loading.load_scene(main, GlobalVars.interrogation, "driving", "afternoon", "")
