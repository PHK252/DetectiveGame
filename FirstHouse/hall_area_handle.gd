extends Area3D

func _ready() -> void:
	monitoring = false
	await get_tree().create_timer(1.0).timeout
	monitoring = true
