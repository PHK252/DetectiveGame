extends Node

@export var audio : Array[AudioStreamPlayer]


func _on_menu_press() -> void:
	audio[0].play()


func _on_menu_hover() -> void:
	audio[1].play()


func _on_start_pressed() -> void:
	audio[1].play()
