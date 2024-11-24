extends Marker2D

@onready var pos_x = 0
@onready var pos_y = 0
@onready var marker = $"."
@onready var cam = $"../../SubViewportContainer/SubViewport/CameraSystem/Camera3D"
@onready var player = $"../../Characters/Dalton/CharacterBody3D"
@onready var live_cam = $"../../SubViewportContainer/SubViewport/CameraSystem/livingroom"
@onready var kitchen = $"../../SubViewportContainer/SubViewport/CameraSystem/Kitchen"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if live_cam.is_active() == true:
		positionMarker(6, 60, 400)
	elif kitchen.is_active() == true:
		positionMarker(6, 60, 400)
	else:
		positionMarker(6, 90, 550)
	#var pos = player.global_transform.origin
	#
	#var marker_pos = cam.unproject_position(pos)
	#marker_pos = marker_pos * 6
	#marker_pos.x = marker_pos.x + 90
	#marker_pos.y = marker_pos.y - 550
	##print(marker_pos)
	#marker.position = marker_pos

func positionMarker(mult : int, x : int, y : int):
	var pos = player.global_transform.origin
	
	var marker_pos = cam.unproject_position(pos)
	marker_pos = marker_pos * mult
	marker_pos.x = marker_pos.x + x
	marker_pos.y = marker_pos.y - y
	#print(marker_pos)
	marker.position = marker_pos
