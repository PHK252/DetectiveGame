
extends Marker3D

@export var marker : Marker3D
@export var body : CharacterBody3D
@export var cam_face_back: Array[PhantomCamera3D] = []
@export var cam_face_front: Array[PhantomCamera3D] = []
@export var x_pos: float
var forward 

var place_pos
func place_marker():
	check_cam_orenination(cam_face_front, cam_face_back)
	if forward == true:
		place_pos = -x_pos
		#print("facing front label still on right? " + str(place_pos))
		marker.position.x = place_pos
	else:
		#print("facing back  label still on right? " + str(place_pos))
		place_pos = x_pos
		marker.position.x = place_pos

func check_cam_orenination(frontArr: Array, backArr: Array):
		for i in frontArr:
			if i.is_active():
				forward = true
		
		for j in backArr:
			if j.is_active():
				forward = false

func _process(delta):
	place_marker()
