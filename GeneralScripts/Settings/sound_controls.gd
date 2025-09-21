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

func _ready() -> void:
	master.value = db_to_linear(AudioServer.get_bus_volume_db(master_index))
	master_label.text = str(int(round(master.value * 10)))
	#
	music.value = db_to_linear(AudioServer.get_bus_volume_db(master_index))
	music_label.text = str(int(round(music.value * 10)))
	#
	sfx.value = db_to_linear(AudioServer.get_bus_volume_db(master_index))
	sfx_label.text = str(int(round(sfx.value * 10)))
	#
	ambience.value = db_to_linear(AudioServer.get_bus_volume_db(master_index))
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
