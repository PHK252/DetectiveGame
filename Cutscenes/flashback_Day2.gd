extends Node3D

@onready var pause = $Pause

@export var world_env : WorldEnvironment
@export var sub_v_container : SubViewportContainer


func _ready():
	MusicFades.fade_in_audio()
	GlobalVars.current_level = "Flashback_day_2"
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
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
