extends MeshInstance3D

func _ready() -> void:
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame

	match GlobalVars.day:
		1:
			global_position = Vector3(0,0,0)
		2:
			global_position = Vector3(-0.06,0,-0.26)
		3:
			global_position = Vector3(1.583,-0.597,0.0)
