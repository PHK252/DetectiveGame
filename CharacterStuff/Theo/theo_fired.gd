extends Node3D

@export var anim_tree : AnimationTree
@export var sound_player : AnimationPlayer
@export var getUp : AudioStreamPlayer3D
var footsteps = false
	
func _on_interactable_interacted(interactor: Interactor) -> void:
	anim_tree["parameters/conditions/idling"] = false
	await get_tree().create_timer(3.0).timeout
	anim_tree["parameters/conditions/get_up"] = true 
	getUp.play()
	await get_tree().create_timer(0.3).timeout
	sound_player.play("FootstepsGather")
	await get_tree().create_timer(1.2).timeout
	footsteps = true
	
func _physics_process(delta: float) -> void:
	if footsteps:
		sound_player.play("Footsteps")
		
func _on_idle_time_timeout() -> void:
	print("timeout")
	anim_tree["parameters/conditions/idle_time"] = true
	await get_tree().create_timer(0.5).timeout
	anim_tree["parameters/conditions/idle_time"] = false
	anim_tree["parameters/conditions/idling"] = true
