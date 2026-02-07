extends Node3D

@export var day_1_notes: Node3D
@export var day_2_notes: Node3D

@onready var pause = $Pause

@export var world_env : WorldEnvironment
@export var sub_v_container : SubViewportContainer

func _ready():
	GlobalVars.current_level = "Transition"
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if GlobalVars.day == 2:
		day_1_notes.show()
		day_2_notes.hide()
	else:
		day_2_notes.show()
		day_1_notes.hide()
		
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
