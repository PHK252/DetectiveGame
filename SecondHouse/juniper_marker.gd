extends Marker2D

@onready var pos_x = 0
@onready var pos_y = 0
@onready var marker = $"."
@onready var cam = $"../../SubViewportContainer/SubViewport/CameraSystem/Camera3D"
@onready var juniper = $"../../Characters/Juniper/CharacterBody3D"
@onready var book_cam = $"../../SubViewportContainer/SubViewport/CameraSystem/CamBooks"


func _process(delta):
	if book_cam.is_active() == true:
		positionMarker(6, 0, 360)
	else:
		positionMarker(6, 90, 550)

func positionMarker(mult : int, x : int, y : int):
	pass
	#var pos = juniper.global_transform.origin
	
	#var marker_pos = cam.unproject_position(pos)
	#marker_pos = marker_pos * mult
	#marker_pos.x = marker_pos.x + x
	#marker_pos.y = marker_pos.y - y
	#print(marker_pos)
	#marker.position = marker_pos
