extends Node

@export var phantom_cam_tweening : PhantomCamera3D

func _ready() -> void:
	phantom_cam_tweening.tween_duration = 0.0
	await get_tree().create_timer(2.0).timeout
	phantom_cam_tweening.tween_duration = 0.5
