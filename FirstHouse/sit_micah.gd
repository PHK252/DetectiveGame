extends Node

@export var micah: Node3D
@export var coll_micah: CollisionShape3D
@export var couch_sit : AudioStreamPlayer3D
@export var couch_situp : AudioStreamPlayer3D

func _on_micah_body_sit_visible() -> void:
	couch_sit.play()
	micah.visible = true
	coll_micah.disabled = true


func _on_micah_body_sit_invisible() -> void:
	couch_situp.play()
	micah.visible = false
	coll_micah.disabled = false
