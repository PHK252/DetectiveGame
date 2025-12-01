extends HBoxContainer

@export var fps_label : Label
var display_fps := false 

@export var checkbox : TextureButton

func _ready() -> void:
	fps_label.visible = false

func _process(delta: float) -> void:
	if display_fps:
		fps_label.text = str(Engine.get_frames_per_second())

func _on_check_box_toggled(toggled_on: bool) -> void:
	fps_label.visible = toggled_on
	display_fps = toggled_on

func _on_reset_graphics_pressed() -> void:
	fps_label.visible = false
	display_fps = false
	checkbox.button_pressed = false
