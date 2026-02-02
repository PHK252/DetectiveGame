extends Node

@export var world_env : WorldEnvironment
@export var lamp_light : OmniLight3D

#daylights
@export var spot_01 : SpotLight3D
@export var spot_02 : SpotLight3D

#take away for twilight
@export var directional : DirectionalLight3D

#nightlights
@export var night_spot_01 : SpotLight3D
@export var night_spot_02 : SpotLight3D
@export var night_spot_03 : SpotLight3D
@export var night_spot_04 : SpotLight3D

func _ready() -> void:
	#daylighting
	world_env.environment.set_bg_energy_multiplier(2.07)
	toggle_nightlight(false)
	toggle_daylight(true)
	#
	#nightlighting
	#world_env.environment.set_bg_energy_multiplier(0.0)
	#toggle_daylight(false)
	#toggle_nightlight(true)
	#
	#twilight lighting
	
	#alternate daylight
	
func toggle_daylight(toggle : bool):
	lamp_light.visible = toggle
	spot_01.visible = toggle
	spot_02.visible = toggle
	directional.visible = toggle

func toggle_nightlight(toggle : bool):
	night_spot_01 .visible = toggle
	night_spot_02 .visible = toggle
	night_spot_03 .visible = toggle
	night_spot_04 .visible = toggle
	
