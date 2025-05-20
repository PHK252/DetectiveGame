extends Node

@export var rock_sound : AudioStreamPlayer3D

func _on_rocks_area_body_entered(body: Node3D) -> void:
	rock_sound.play()
