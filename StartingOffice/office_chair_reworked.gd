extends Node3D

func _ready() -> void:
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	
	match GlobalVars.day:
		1:
			global_position = Vector3(-0.021,-0.011,0.77)
			set_global_rotation_degrees(Vector3(0.0,0.0,0.0))
		2:
			global_position = Vector3(-0.049,-0.011,0.70)
			set_global_rotation_degrees(Vector3(0.0,-5.1,0.0))
		3:
			global_position = Vector3(-0.019,-0.011,0.75)
			set_global_rotation_degrees(Vector3(0.0,4.2,0.0))
