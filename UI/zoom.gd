extends Camera2D

var in_zoom := false
var normal = 1.0
var max_zoom = 2.0

var dragging = false
var drag_start = Vector2.ZERO
var cam_pos = Vector2.ZERO

func _input(event):
	if event.is_action_pressed("zoom_in"):
		in_zoom = true
		zoom = Vector2(max_zoom, max_zoom)
	if event.is_action_pressed("zoom_out"):
		in_zoom = false
		zoom = Vector2(normal, normal)
		position = Vector2(960,540)

func _unhandled_input(event):
	if event.is_action_pressed("Drag"):
		dragging = true
		drag_start = event.position
		cam_pos = position
	if event.is_action_released("Drag"):
		dragging = false
			
	if event is InputEventMouseMotion and dragging and in_zoom:
		var move_diff = (event.position - drag_start)/zoom
		position = cam_pos - move_diff
