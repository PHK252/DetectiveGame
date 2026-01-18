extends Area3D

@export var player : CharacterBody3D
@export var dalton_marker : Marker2D
@export var quincy_marker : Marker2D
@onready var entered_room = false
@export var phantom_camera_masterbed : PhantomCamera3D
@export var phantom_camera_hallway : PhantomCamera3D
var to_hall := false
var to_notes := false


func _on_timeline_ended():
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	GlobalVars.in_dialogue = false
	player.start_player()


func _on_bedroom_closet_cam_tween_completed():
	if entered_room == false:
		entered_room = true
		player.stop_player()
		GlobalVars.in_dialogue = true
		var bed_enter = Dialogic.start("Quincy_bedroom_enter")
		Dialogic.timeline_ended.connect(_on_timeline_ended)
		bed_enter.register_character(load("res://Dialogic Characters/Dalton.dch"), dalton_marker)
		bed_enter.register_character(load("res://Dialogic Characters/Quincy.dch"), quincy_marker)


func _on_body_entered(body: Node3D) -> void:
	if to_notes:
		#if come back from notes then tween
		phantom_camera_masterbed.tween_duration= 0.5
	else:
		phantom_camera_masterbed.tween_duration= 0.0
	
	phantom_camera_hallway.tween_duration = 0.0

func _on_master_notebook_body_entered(body: Node3D) -> void:
	to_notes = true
	to_hall = false

func _on_hall_close_cam_area_body_entered(body: Node3D) -> void:
	to_hall = true
	to_notes = false

func _on_body_exited(body: Node3D) -> void:
	if to_hall:
		phantom_camera_masterbed.tween_duration = 0.0 # not that it matters
		phantom_camera_hallway.tween_duration = 0.0


func _on_door_a_body_entered(body: Node3D) -> void:
	phantom_camera_hallway.tween_duration = 1.0
