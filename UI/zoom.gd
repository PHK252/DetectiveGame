extends Camera2D

@export var zoom_butt : TextureButton
var in_zoom := false
var normal = 1.0
var max_zoom = 2.0

var dragging = false
var drag_start = Vector2.ZERO
var cam_pos = Vector2.ZERO

signal zoomed(state: bool)

func _ready():
	position = Vector2(960,540)

func _input(event):
	if event.is_action_pressed("zoom_in"):
		_zoom_in()
		zoom_butt.button_pressed = true
	if event.is_action_pressed("zoom_out"):
		_zoom_out()
		zoom_butt.button_pressed = false

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
		if position.y > 1081:
			position.y = 1080
		if position.y < 0:
			position.y = 0
		if position.x > 1921:
			position.x = 1920
		if position.x < 0:
			position.x = 0

func _zoom_in():
	GlobalVars.map_tut = true
	in_zoom = true
	zoom = Vector2(max_zoom, max_zoom)
	emit_signal("zoomed", true)

func _zoom_out():
	in_zoom = false
	zoom = Vector2(normal, normal)
	position = Vector2(960,540)
	emit_signal("zoomed", false)

func _on_zoom_toggled(toggled_on):
	if toggled_on:
		_zoom_in()
	else:
		_zoom_out()
