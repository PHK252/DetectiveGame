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

#twilight
@export var t_01 : SpotLight3D
@export var t_02 : SpotLight3D

#alt day just 1 spot
@export var spot_alt : SpotLight3D

func _ready() -> void:
	pass
	##daylighting
	#toggle_nightlight(false)
	#toggle_twilight(false)
	#toggle_daylight(true)
#
	##nightlighting (end_day or ending)
	#toggle_daylight(false)
	#toggle_twilight(false)
	#toggle_nightlight(true)
#
	##twilight lighting (end_day or ending)
	#toggle_daylight(false)
	#toggle_nightlight(false)
	#toggle_twilight(true)
	
	#daylighting day 2

#func _process(delta: float) -> void:
	##toggles for testing
	#if Input.is_action_just_pressed("call"):
		#toggle_daylight_alternate(false)
		#toggle_nightlight(false)
		#toggle_twilight(false)
		#toggle_daylight(true)
	#
	#if Input.is_action_just_pressed("meeting_done"):
		#toggle_daylight_alternate(false)
		#toggle_daylight(false)
		#toggle_twilight(false)
		#toggle_nightlight(true)
		#
	#if Input.is_action_just_pressed("interact"):
		##toggle_daylight_alternate(false) 
		##toggle_daylight(false)
		##toggle_nightlight(false)
		##toggle_twilight(true)
		#
		#toggle_daylight(false)
		#toggle_nightlight(false)
		#toggle_twilight(false)
		#toggle_daylight_alternate(true)

	
func toggle_daylight(toggle : bool):
	if toggle:
		world_env.environment.set_bg_energy_multiplier(2.07)
		world_env.environment.sky.sky_material.set_sky_top_color(Color(0.385, 0.454, 0.55, 1))
	lamp_light.visible = toggle
	spot_01.visible = toggle
	spot_02.visible = toggle
	directional.visible = toggle
	
func toggle_daylight_alternate(toggle : bool):
	if toggle:
		world_env.environment.set_bg_energy_multiplier(2.07)
		world_env.environment.sky.sky_material.set_sky_top_color(Color(0.385, 0.454, 0.55, 1))
	lamp_light.visible = toggle
	directional.visible = toggle
	spot_alt.visible = toggle

func toggle_nightlight(toggle : bool):
	if toggle:
		world_env.environment.set_bg_energy_multiplier(0.0)
		world_env.environment.sky.sky_material.set_sky_top_color(Color(0.385, 0.454, 0.55, 1))
	night_spot_01.visible = toggle
	night_spot_02.visible = toggle
	night_spot_03.visible = toggle
	night_spot_04.visible = toggle
	
func toggle_twilight(toggle : bool):
	if toggle:
		world_env.environment.set_bg_energy_multiplier(1.88)
		world_env.environment.sky.sky_material.set_sky_top_color(Color(0.468, 0.458, 0.458, 1))
	lamp_light.visible = toggle
	t_01.visible = toggle
	t_02.visible = toggle
	

func _on_night_lighting() -> void:
	toggle_daylight_alternate(false)
	toggle_daylight(false)
	toggle_twilight(false)
	toggle_nightlight(true)


func _on_day_lighting_alternate() -> void:
	toggle_daylight(false)
	toggle_nightlight(false)
	toggle_twilight(false)
	toggle_daylight_alternate(true)


func _on_twilight_lighting() -> void:
	toggle_daylight_alternate(false) 
	toggle_daylight(false)
	toggle_nightlight(false)
	toggle_twilight(true)
