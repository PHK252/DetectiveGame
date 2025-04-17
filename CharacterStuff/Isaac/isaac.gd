extends Node3D

@export var anim_tree = AnimationTree

func _on_interactable_interacted(interactor: Interactor) -> void:
	anim_tree["parameters/conditions/at_end"] = false
	anim_tree["parameters/conditions/leave_isaac"] = true

func _on_isaac_idle_timeout() -> void:
	anim_tree["parameters/conditions/time_elapsed"] = true
