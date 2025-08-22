extends Node3D

@export var FP_cam : PhantomCamera3D
@export var Exit_cam : PhantomCamera3D
@export var cam_anim: AnimationPlayer
@export var player : CharacterBody3D


func _on_clue_interacted(interactor):
	FP_cam.priority= 30
	Exit_cam.priority = 0
	cam_anim.play("Cam_Idle")
	player.stop_player()
	player.hide()

func _input(event):
	if Input.is_action_just_pressed("Exit"):
		FP_cam.priority= 0
		Exit_cam.priority = 30
		cam_anim.play("RESET")
		player.start_player()
		player.show()
