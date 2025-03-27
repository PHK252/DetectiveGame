extends Node

@export var micah: Node3D
@export var coll_micah: CollisionShape3D

func _on_micah_body_sit_visible() -> void:
	micah.visible = true
	coll_micah.disabled = true


func _on_micah_body_sit_invisible() -> void:
	micah.visible = false
	coll_micah.disabled = false
