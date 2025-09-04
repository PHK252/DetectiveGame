extends Marker2D

@export var marker : Marker2D
@export var cam : Camera3D
@export var body_marker : Marker3D
@export var rect : ColorRect
@export var edge_cam: PhantomCamera3D

#Micah Edges
@onready var sit = false
@export var sit_marker : Marker3D
@export var sit_body : Node3D

#Quincy Edges
@export var sit_dalton_quincy_bar : Marker3D
@export var sit_theo_quincy_bar : Marker3D
var bar_nudge = false
var dalton_bar_sit = false
var theo_bar_sit = false
@onready var pos


func _process(delta):
	if Loading.in_loading == false:
		positionMarker(6)
	else:
		return

func positionMarker(mult : int):
	if is_instance_valid(body_marker):
		if sit_marker:
			if sit == true:
				#print("SITTING MARKER")
				pos = sit_marker.global_position
			else:
				pos = body_marker.global_position
		else:
			pos = body_marker.global_position
		
		if sit_dalton_quincy_bar:
			if dalton_bar_sit == true:
				print("sitting_dalton")
				pos = sit_dalton_quincy_bar.global_position
			else:
				pos = body_marker.global_position

		if sit_theo_quincy_bar:
			if theo_bar_sit == true:
				pos = sit_theo_quincy_bar.global_position
			else:
				pos = body_marker.global_position
	
	var marker_pos = cam.unproject_position(pos)
	marker_pos = marker_pos * mult
	marker.position = marker_pos
	#print(marker_pos)
	#rect.position = marker_pos
	
	if edge_cam:
		if edge_cam.is_active():
			if GlobalVars.forward == true:
				if marker_pos.x > 1920:
					marker_pos.x = 1920
				if marker_pos.x < 0:
					marker_pos.x = 0
				if marker_pos.y > 900:
					marker_pos.y = 900
				if marker_pos.y < 180:
					marker_pos.y = 180
			else:
				if marker_pos.x >= 1920:
					marker_pos.x = 0
				if marker_pos.x <= 0:
					marker_pos.x = 1920
				if marker_pos.y >= 900:
					marker_pos.y = 180
				if marker_pos.y <= 180:
					marker_pos.y = 900
	
	if bar_nudge == true:
		marker_pos.x += 50
	#print(marker_pos)
	marker.position = marker_pos
	#rect.position = marker_pos

	
func _on_body_sit_visibility_changed():
	if sit_marker:
		if sit_body.visible == true:
			sit = true
		else:
			sit = false


#func _on_body_stand_visibility_changed():
	#sit = false


func _on_bar_nudge_quincy_marker():
	bar_nudge = true


func _on_bar_switch_dalton_marker():
	dalton_bar_sit = true



func _on_bar_switch_theo_marker():
	theo_bar_sit = true


func _on_bar_return_norm_markers():
	bar_nudge = false
	dalton_bar_sit = false
	theo_bar_sit = false
	
