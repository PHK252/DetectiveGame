extends MeshInstance3D


func _ready() -> void:
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame

	match GlobalVars.day:
		1:
			global_position = Vector3(0,0,0)
		2:
			global_position = Vector3(0.27,0,0.34)
		3:
			visible = false
