extends Node

@export var audio : Array[AudioStreamPlayer]


func _on_view_photo_flip_sound() -> void:
	audio[0].play()


func _on_view_photo_vis_sound() -> void:
	audio[1].play()


func _on_exit_pressed() -> void:
	audio[2].play()


func _on_exit_mouse_entered() -> void:
	audio[3].play()
