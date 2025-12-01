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

var master_default : float
var music_default : float
var sfx_default : float
var amb_default : float

func _ready() -> void:
	master.value = db_to_linear(AudioServer.get_bus_volume_db(master_index))
	master_default = master.value
	master_label.text = str(int(round(master.value * 10)))
	#
	music.value = db_to_linear(AudioServer.get_bus_volume_db(master_index))
	music_default = music.value
	music_label.text = str(int(round(music.value * 10)))
	#
	sfx.value = db_to_linear(AudioServer.get_bus_volume_db(master_index))
	sfx_default = sfx.value
	sfx_label.text = str(int(round(sfx.value * 10)))
	#
	ambience.value = db_to_linear(AudioServer.get_bus_volume_db(master_index))
	amb_default = ambience.value
	amb_label.text = str(int(round(ambience.value * 10)))
	#

func _on_master_slider_value_changed(value: float) -> void:
	master_label.text = str(int(round(master.value * 10)))
	AudioServer.set_bus_volume_db(master_index, linear_to_db(value))

func _on_music_slider_value_changed(value: float) -> void:
	music_label.text = str(int(round(music.value * 10)))
	AudioServer.set_bus_volume_db(music_index, linear_to_db(value))

func _on_sfx_slider_value_changed(value: float) -> void:
	sfx_label.text = str(int(round(sfx.value * 10)))
	AudioServer.set_bus_volume_db(sfx_index, linear_to_db(value))

func _on_ambience_slider_value_changed(value: float) -> void:
	amb_label.text = str(int(round(ambience.value * 10)))
	AudioServer.set_bus_volume_db(amb_index, linear_to_db(value))



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
	master.value = master_default
	music.value = music_default
	sfx.value = sfx_default
	ambience.value = amb_default
