extends Node

@export var door_anim : AnimationPlayer
@export var dalton_look : AnimationTree
@export var dalton_room : AnimationTree
@export var brother_anims : AnimationTree
signal check_on_isaac
var stop_repeat := false

@export var doorSound : AudioStreamPlayer3D
@export var seizure_sound : AnimationPlayer

func _on_enter_room_body_entered(body: Node3D) -> void:
	if stop_repeat == false:
		door_anim.play("DoorOpen")
		doorSound.play()
		dalton_look["parameters/conditions/go_in"] = true
		dalton_room["parameters/conditions/seizure"] = true
		seizure_sound.play("tweak")
		brother_anims["parameters/conditions/start_anim"] = true
		emit_signal("check_on_isaac")
		stop_repeat = true
