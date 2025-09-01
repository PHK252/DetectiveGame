extends Node3D

@export var anim_tree = AnimationTree
@export var sounds : AnimationPlayer
@export var getUp : AudioStreamPlayer3D

#func _on_interactable_interacted(interactor: Interactor) -> void:
	#anim_tree["parameters/conditions/at_end"] = false
	#anim_tree["parameters/conditions/leave_isaac"] = true
	#getUp.play()
	#await get_tree().create_timer(1).timeout
	#sounds.play("walk_gather")
	#await get_tree().create_timer(2.5).timeout
	#sounds.play("walk_wood")
	

func _on_isaac_idle_timeout() -> void:
	pass
	#anim_tree["parameters/conditions/time_elapsed"] = true


func _on_isaac_to_walk_out():
	anim_tree["parameters/conditions/at_end"] = false
	anim_tree["parameters/conditions/leave_isaac"] = true
	getUp.play()
	await get_tree().create_timer(1).timeout
	sounds.play("walk_gather")
	await get_tree().create_timer(2.5).timeout
	sounds.play("walk_wood")
