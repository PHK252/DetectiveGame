extends Control

#sliders
@export var ambience : HSlider
@export var amb_label : Label

@export var master : HSlider
@export var master_label : Label

@export var sfx : HSlider
@export var sfx_label : Label

@export var music : HSlider
@export var music_label : Label

#indices
var amb_index = AudioServer.get_bus_index("Ambience")
var sfx_index = AudioServer.get_bus_index("SFX")
var music_index = AudioServer.get_bus_index("Music")
var master_index = AudioServer.get_bus_index("Master")

const MASTER_DEFAULT : float = 0.8
var MUSIC_DEFAULT : float = .6
var SFX_DEFAULT : float = .75
var AMB_DEFAULT : float = .55

func _ready() -> void:
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	#set master
	if !GlobalVars.master:
		AudioServer.set_bus_volume_db(master_index, linear_to_db(MASTER_DEFAULT))
		master.value = db_to_linear(AudioServer.get_bus_volume_db(master_index))
	else:
		AudioServer.set_bus_volume_db(master_index, linear_to_db(GlobalVars.master))
		master.value = db_to_linear(AudioServer.get_bus_volume_db(master_index))
		
	#set music
	if !GlobalVars.music:
		AudioServer.set_bus_volume_db(music_index, linear_to_db(MUSIC_DEFAULT))
		music.value = db_to_linear(AudioServer.get_bus_volume_db(music_index))
	else:
		AudioServer.set_bus_volume_db(music_index, linear_to_db(GlobalVars.music))
		music.value = db_to_linear(AudioServer.get_bus_volume_db(music_index))
	#set sfx
	if !GlobalVars.sfx:
		AudioServer.set_bus_volume_db(sfx_index, linear_to_db(SFX_DEFAULT))
		sfx.value = db_to_linear(AudioServer.get_bus_volume_db(sfx_index))
	else:
		AudioServer.set_bus_volume_db(sfx_index, linear_to_db(GlobalVars.sfx))
		sfx.value = db_to_linear(AudioServer.get_bus_volume_db(sfx_index))
	#set amb
	if !GlobalVars.ambience:
		AudioServer.set_bus_volume_db(amb_index, linear_to_db(AMB_DEFAULT))
		ambience.value = db_to_linear(AudioServer.get_bus_volume_db(amb_index))
	else:
		AudioServer.set_bus_volume_db(amb_index, linear_to_db(GlobalVars.ambience))
		ambience.value = db_to_linear(AudioServer.get_bus_volume_db(amb_index))

func _on_master_slider_value_changed(value: float) -> void:
	master_label.text = str(int(round(master.value * 10)))
	AudioServer.set_bus_volume_db(master_index, linear_to_db(value))
	GlobalVars.master = value

func _on_music_slider_value_changed(value: float) -> void:
	music_label.text = str(int(round(music.value * 10)))
	AudioServer.set_bus_volume_db(music_index, linear_to_db(value))
	GlobalVars.music = value

func _on_sfx_slider_value_changed(value: float) -> void:
	sfx_label.text = str(int(round(sfx.value * 10)))
	AudioServer.set_bus_volume_db(sfx_index, linear_to_db(value))
	GlobalVars.sfx = value

func _on_ambience_slider_value_changed(value: float) -> void:
	amb_label.text = str(int(round(ambience.value * 10)))
	AudioServer.set_bus_volume_db(amb_index, linear_to_db(value))
	GlobalVars.ambience = value

	

func _on_master_slider_clicked(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			master.add_theme_icon_override("grabber_highlight", load("res://UI/Assets/Options/Graphics/Brightness Slider Grabber Pressed.png"))
		else:
			master.add_theme_icon_override("grabber_highlight", load("res://UI/Assets/Options/Graphics/Brightness Slider Grabber normal.png"))



func _on_music_slider_clicked(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			music.add_theme_icon_override("grabber_highlight", load("res://UI/Assets/Options/Graphics/Brightness Slider Grabber Pressed.png"))
		else:
			music.add_theme_icon_override("grabber_highlight", load("res://UI/Assets/Options/Graphics/Brightness Slider Grabber normal.png"))


func _on_sfx_slider_clicked(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			sfx.add_theme_icon_override("grabber_highlight", load("res://UI/Assets/Options/Graphics/Brightness Slider Grabber Pressed.png"))
		else:
			sfx.add_theme_icon_override("grabber_highlight", load("res://UI/Assets/Options/Graphics/Brightness Slider Grabber normal.png"))


func _on_ambience_slider_clicked(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			ambience.add_theme_icon_override("grabber_highlight", load("res://UI/Assets/Options/Graphics/Brightness Slider Grabber Pressed.png"))
		else:
			ambience.add_theme_icon_override("grabber_highlight", load("res://UI/Assets/Options/Graphics/Brightness Slider Grabber normal.png"))


func _on_audio_reset_pressed():
	master.value = MASTER_DEFAULT
	music.value = MUSIC_DEFAULT
	sfx.value = SFX_DEFAULT
	ambience.value = AMB_DEFAULT
