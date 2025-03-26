extends Node

@export var micah: Node3D

func _on_micah_body_sit_visible() -> void:
	micah.visible = true


func _on_micah_body_sit_invisible() -> void:
	micah.visible = false
