extends Node3D

@export var anim_tree : AnimationTree
	
func _on_interactable_interacted(interactor: Interactor) -> void:
	anim_tree["parameters/conditions/idling"] = false
	await get_tree().create_timer(3.0).timeout
	anim_tree["parameters/conditions/get_up"] = true 

func _on_idle_time_timeout() -> void:
	print("timeout")
	anim_tree["parameters/conditions/idle_time"] = true
	await get_tree().create_timer(0.5).timeout
	anim_tree["parameters/conditions/idle_time"] = false
	anim_tree["parameters/conditions/idling"] = true
