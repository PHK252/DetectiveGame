extends Node3D
@export var coll_2: CollisionShape3D

func _on_door_second_j_door_closed() -> void:
	print("coll22")
	coll_2.disabled = true

func _on_door_second_j_door_open() -> void:
	print("coll2")
	coll_2.disabled = false
