extends Node

@export var audio : Array[AudioStreamPlayer]

func _on_button_pressed() -> void:
	audio[0].play()


func _on_hover_label() -> void:
	audio[1].play()
