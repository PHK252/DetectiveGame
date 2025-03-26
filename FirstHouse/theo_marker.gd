extends Marker2D

@onready var pos_x = 0
@onready var pos_y = 0
@onready var marker = $"."
@onready var cam = $"../../SubViewportContainer/SubViewport/CameraSystem/Camera3D"
@onready var theo = $"../../Characters/Main/CharacterBody3D"
@onready var kitchen = $"../../SubViewportContainer/SubViewport/CameraSystem/Kitchen"
@onready var live_cam = $"../../SubViewportContainer/SubViewport/CameraSystem/livingroom"
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.

	if live_cam.is_active() == true:
		positionMarker(6, 60, 400)
	elif kitchen.is_active() == true:
		positionMarker(6, 60, 400)
	else:
		positionMarker(6, 90, 550)

func positionMarker(mult : int, x : int, y : int):
	var pos = theo.global_transform.origin
	
	var marker_pos = cam.unproject_position(pos)
	marker_pos = marker_pos * mult
	marker_pos.x = marker_pos.x + x
	marker_pos.y = marker_pos.y - y
	#print(marker_pos)
	marker.position = marker_pos
