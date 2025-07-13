extends Marker3D

@export var marker : Marker3D
@export var body : CharacterBody3D
@export var cam_face_back: Array[PhantomCamera3D] = []
@export var cam_face_front: Array[PhantomCamera3D] = []
@export var flip_cam : PhantomCamera3D
@export var x_pos: float

var place_pos
var flip = false


func place_marker():
	check_cam_orenination(cam_face_front, cam_face_back)
	if GlobalVars.forward == true:
		place_pos = -x_pos
		
		marker.position.x = place_pos
	else:
		#print("facing back  label still on right? " + str(place_pos))
		place_pos = x_pos
		marker.position.x = place_pos

func check_cam_orenination(frontArr: Array, backArr: Array):
	for i in frontArr:
		if i.is_active():
			GlobalVars.forward = true
	for j in backArr:
		if j.is_active():
			GlobalVars.forward = false
	
	if flip == true:
		if flip_cam.is_active(): 
			GlobalVars.forward = true
		else:
			GlobalVars.forward = false
		
		
func _process(delta):
	place_marker()


func _on_flip_marker_closet_body_entered(body):
	if body.is_in_group("player"):
		flip = true


func _on_flip_marker_closet_body_exited(body):
	if body.is_in_group("player"):
		flip = false
