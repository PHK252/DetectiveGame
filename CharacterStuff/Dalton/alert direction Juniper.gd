extends Node3D


@onready var alert = $CharacterBody3D/PlayerInteractor/CollisionShape3D/Alert
@onready var cam = $"../../SubViewportContainer/SubViewport/CameraSystem/Camera3D"


func _process(delta):
	alert.rotation_degrees.y = cam.rotation_degrees.y