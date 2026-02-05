extends StaticBody3D

@export var coll_shape : CollisionShape3D

func _ready() -> void:
	if GlobalVars.in_level == false and Dialogic.VAR.get_variable("Global.went_to_Quincy") == false:
		coll_shape.disabled = false
	else:
		coll_shape.disabled = true

func _on_quincy_interact_finish_greeting() -> void:
	coll_shape.disabled = true
