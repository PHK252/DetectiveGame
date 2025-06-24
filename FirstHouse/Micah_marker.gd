extends Marker2D
@onready var debug_label = $"../debug label"
@onready var pos_x = 0
@onready var pos_y = 0
@onready var marker = $"."
@onready var cam = $"../../SubViewportContainer/SubViewport/CameraSystem/Camera3D"
@onready var micah = $"../../SubViewportContainer/Characters/Micah/Micah/MicahBody"
@onready var micah_sit = $"../../SitMicah/Micah/MicahBody"
@onready var kitchen = $"../../SubViewportContainer/SubViewport/CameraSystem/Kitchen"
@onready var live_cam = $"../../SubViewportContainer/SubViewport/CameraSystem/livingroom"
@onready var sit_micah = false
@onready var pos
@export var door : PhantomCamera3D
@export var exit : PhantomCamera3D
@export var rect : ColorRect

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	debug_label.text = str(sit_micah)
	if live_cam.is_active() == true or kitchen.is_active() == true:
		if sit_micah == true:
			positionMarker(6, 75, 350)
		else:
			positionMarker(6, 60, 400)
	elif door.is_active() == true or exit.is_active(): #exit might need tweak
		positionMarker(6, 100, 300)
	else:
		
		positionMarker(6, 90, 550)

func positionMarker(mult : int, x : int, y : int):
	if sit_micah == false:
		pos = micah.global_transform.origin
	else:
		pos = micah_sit.global_transform.origin
		
	var marker_pos = cam.unproject_position(pos)
	marker_pos = marker_pos * mult
	if marker_pos.x > 1920 and marker_pos.y > 1080:
		marker_pos.x = 1920
		marker_pos.y = 1080
	elif marker_pos.x < 0 and marker_pos.y < 0:
		marker_pos.x = 0
		marker_pos.y = 0
	else:
		marker_pos.x = marker_pos.x + x
		marker_pos.y = marker_pos.y - y
		marker.position = marker_pos
		rect.position = marker_pos


func _on_micah_visibility_changed():
	sit_micah = true


func _on_micah_stand_visibility_changed():
	sit_micah = false
