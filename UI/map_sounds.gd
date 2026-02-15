extends Node

@export var buttons : Array[TextureButton]
@export var audio : Array[AudioStreamPlayer]
var cur_hov_button : TextureButton

func _ready():
	for butt in buttons:
		butt.mouse_entered.connect(location_mouse_entered.bind(butt))

func _on_map_leave_map_sound() -> void:
	audio[2].play()

func _on_map_select_level_sound() -> void:
	audio[0].play()

func _on_exit_mouse_entered() -> void:
	audio[3].play()

func location_mouse_entered(butt) -> void:
	if !butt.disabled:
		audio[1].play()
