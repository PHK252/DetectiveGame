extends Node

@export var collision: CollisionShape3D
@export var area: Area3D

func _on_character_body_3d_stop_coll() -> void:
	print("stoppedCollision")
	area.monitoring = false
	collision.disabled = true
