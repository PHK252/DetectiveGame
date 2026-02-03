extends StaticBody3D

@export var coll_shape : CollisionShape3D


func _on_character_body_3d_block_stairs() -> void:
	coll_shape.disabled = false
