extends Node3D
@export var coll_2: CollisionShape3D
@export var doorJ_open : AudioStreamPlayer3D
@export var doorJ_close : AudioStreamPlayer3D

func _on_door_second_j_door_closed() -> void:
	print("coll22")
	coll_2.disabled = true
	await get_tree().create_timer(1.8).timeout
	doorJ_close.play()

func _on_door_second_j_door_open() -> void:
	print("coll2")
	doorJ_open.play()
	coll_2.disabled = false
