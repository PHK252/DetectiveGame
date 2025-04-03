extends Marker2D

@onready var pos_x = 0
@onready var pos_y = 0

@export var marker: Marker2D
@export var Main_cam: Camera3D
@export var cam_var1: PhantomCamera3D
#@export var cam_var2: PhantomCamera2D
#@export var cam_var3: PhantomCamera3D

@export var body: CharacterBody3D

##postion marker
#@export var main_mult: int
#@export var main_x: int
#@export var main_y: int
#
#@export var var1_mult: int
#@export var var1_x: int
#@export var var1_y: int

#@export var var2_mult: int
#@export var var2_x: int
#@export var var2_y: int
#
#@export var var3_mult: int
#@export var var3_x: int
#@export var var3_y: int
#@onready var pos_x = 0
#@onready var pos_y = 0
#@onready var marker = $"."
#@onready var book_cam = $"../../SubViewportContainer/SubViewport/CameraSystem/CamBooks"
#@onready var cam = $"../../SubViewportContainer/SubViewport/CameraSystem/Camera3D"
#@onready var theo = $"../../Characters/Main/CharacterBody3D"


func _process(delta):
	if cam_var1.is_active() == true:
		positionMarker(6, 0, 360)
	else:
		positionMarker(6, 90, 350)

func positionMarker(mult : int, x : int, y : int):
	var pos = body.global_transform.origin
	
	var marker_pos = Main_cam.unproject_position(pos)
	marker_pos = marker_pos * mult
	marker_pos.x = marker_pos.x + x
	marker_pos.y = marker_pos.y - y
	#print(marker_pos)
	marker.position = marker_pos
