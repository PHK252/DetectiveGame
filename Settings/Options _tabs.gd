extends MarginContainer

@export var sound_tab : MarginContainer
@export var graphics_tab : MarginContainer
@export var audio_button : TextureButton
@export var audio_reset : TextureButton
@export var graphic_reset : TextureButton

func _ready():
	audio_button.button_pressed = true


func _on_graphics_toggled(toggled_on):
	if toggled_on:
		sound_tab.visible = false
		graphics_tab.visible = true
		audio_reset.visible = false
		graphic_reset.visible = true


func _on_audio_toggled(toggled_on):
	if toggled_on:
		sound_tab.visible = true
		graphics_tab.visible = false
		audio_reset.visible = true
		graphic_reset.visible = false
