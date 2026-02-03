extends MeshInstance3D

func _ready() -> void:
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	
	match GlobalVars.day:
		1:
			global_position = Vector3(-0.011,0.005,0.076)
			set_global_rotation_degrees(Vector3(0.0,-2.0,0.0))
		2:
			global_position = Vector3(0.032,0.005,-0.063)
			set_global_rotation_degrees(Vector3(0.0,0.0,0.0))
		3:
			visible = false
