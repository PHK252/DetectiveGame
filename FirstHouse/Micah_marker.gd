extends Marker2D

@onready var pos_x = 0
@onready var pos_y = 0
@onready var marker = $"."
@onready var cam = $"../../SubViewportContainer/SubViewport/CameraSystem/Camera3D"
@onready var micah = $"../../Characters/MicahPath/MicahPath3D/PathFollow3D/Micah/MicahBody"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var pos = micah.global_transform.origin
	
	var marker_pos = cam.unproject_position(pos)
	marker_pos = marker_pos * 6
	marker_pos.x = marker_pos.x + 90
	marker_pos.y = marker_pos.y - 550
	#print(marker_pos)
	marker.position = marker_pos
