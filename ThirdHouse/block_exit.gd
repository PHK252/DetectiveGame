extends MeshInstance3D

@export var coll_shape : CollisionShape3D

func _ready():
	coll_shape.disabled = true

func _on_wine_time_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		await get_tree().process_frame
		coll_shape.disabled = false

func _on_character_body_3d_allow_stairs() -> void:
	coll_shape.disabled = true
