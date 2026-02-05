extends Node

@export var audio : Array[AudioStreamPlayer]

func _on_map_leave_map_sound() -> void:
	audio[2].play()

func _on_map_select_level_sound() -> void:
	audio[0].play()

func _on_exit_mouse_entered() -> void:
	audio[3].play()

func location_mouse_entered() -> void:
	audio[1].play()
