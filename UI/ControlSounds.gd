extends Node

@export var audio : Array[AudioStreamPlayer]


func _on_exit_hover() -> void:
	audio[4].play()


func _on_exit_pressed() -> void:
	audio[0].play()
