extends Node3D

@export var alert : Sprite3D
@export var cam : Camera3D

## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	alert.rotation_degrees.y = cam.rotation_degrees.y
	pass
