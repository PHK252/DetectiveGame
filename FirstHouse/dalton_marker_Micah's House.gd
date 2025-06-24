extends Marker2D

@onready var pos_x = 0
@onready var pos_y = 0
@onready var marker = $"."
@onready var cam = $"../../SubViewportContainer/SubViewport/CameraSystem/Camera3D"
@export var player : Marker3D
@onready var live_cam = $"../../SubViewportContainer/SubViewport/CameraSystem/livingroom"
@onready var kitchen = $"../../SubViewportContainer/SubViewport/CameraSystem/Kitchen"
@export var door : PhantomCamera3D
@export var exit : PhantomCamera3D
@export var rect : ColorRect
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	##print(get_viewport().get_mouse_position())
	#if live_cam.is_active() == true or kitchen.is_active() == true:
		#positionMarker(6, 60, 400)
	#elif door.is_active() == true or exit.is_active():
		#positionMarker(6, 100, 300)
	#else:
	positionMarker(6)

func positionMarker(mult : int):
	var pos = player.global_position
	
	var marker_pos = cam.unproject_position(pos)
	marker_pos = marker_pos * mult
	marker.position = marker_pos
	rect.position = marker_pos
	
	if marker_pos.x > 1920:
		marker_pos.x = 1920
	
	if marker_pos.y > 1080:
		marker_pos.y = 1080
	
	if marker_pos.x < 0:
		marker_pos.x = 0
	
	if marker_pos.y < 0:
		marker_pos.y = 0
	
	marker.position = marker_pos
	rect.position = marker_pos

	
