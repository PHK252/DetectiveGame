extends Node3D

@export var animation_tree : AnimationTree

func _on_interactable_interacted(interactor: Interactor) -> void:
	animation_tree["parameters/conditions/start"] = true
