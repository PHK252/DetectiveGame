extends Node

@export var cam_1 : Camera3D
@export var cam_2 : Camera3D
@export var cam_anims : AnimationPlayer

func _ready():
	cam_anims.play("CamAnims")
	cam_1.current = true
	cam_2.current = false
	await get_tree().create_timer(3).timeout
	cam_1.current = false
	cam_2.current = true
