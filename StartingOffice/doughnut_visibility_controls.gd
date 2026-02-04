extends MeshInstance3D

#box rotation and location
@export var box_under : MeshInstance3D
@export var box_over : MeshInstance3D

#doughnuts reduced + vis number
@export var doughnuts : Array[Node3D]
var doughnuts_eaten := 0

var rng = RandomNumberGenerator.new()

signal no_more_doughnuts

func _ready() -> void:
	box_under.visible = false
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	
	var random_doughnut_number = rng.randi_range(6, 8)
	doughnuts_eaten = random_doughnut_number - 1
	match GlobalVars.day:
		1:
			box_over.global_position = Vector3(0.091,0.001,0.042)
			box_over.set_global_rotation_degrees(Vector3(0.0,0.0,0.0))
			for i in range(0, random_doughnut_number):
				doughnuts[i].visible = true
		2:
			box_over.global_position = Vector3(0.15,0.001,0.042)
			box_over.set_global_rotation_degrees(Vector3(0.0,-2.9,0.0))
			for i in range(0, random_doughnut_number):
				doughnuts[i].visible = true
		3:
			box_over.visible = false
			for i in range(doughnuts.size()):
				doughnuts[i].visible = false

func _on_doughnut_001_doughnut_gone() -> void:
	if doughnuts_eaten >= 0:
		doughnuts[doughnuts_eaten].visible = false
		doughnuts_eaten -= 1
		if doughnuts_eaten == -1:
			emit_signal("no_more_doughnuts")
