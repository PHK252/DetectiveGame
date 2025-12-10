extends Node

@export var audio : Array[AudioStreamPlayer]


func _on_buzz() -> void:
	audio[0].play()


func _on_stop_buzz() -> void:
	audio[0].stop()
