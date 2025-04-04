extends Node3D
@export var coll_2: CollisionShape3D


func _on_door_second_j_door_closed() -> void:
	coll_2.disabled = true

func _on_door_second_j_door_open() -> void:
	coll_2.disabled = false
