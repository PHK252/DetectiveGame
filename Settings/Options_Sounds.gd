extends Node

@export var audio : Array[AudioStreamPlayer]


func on_hover() -> void:
	audio[4].play()

func _on_exit_click() -> void:
	audio[0].play()

func _on_hover_non_exit() -> void:
	audio[6].play()

func _on_norm_click() -> void:
	audio[2].play()


func alt_select() -> void:
	audio[5].play()


func on_hover_high() -> void:
	audio[3].play()
