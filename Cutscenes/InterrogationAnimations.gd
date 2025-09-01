extends Node

@export var S_anim : AnimationTree
@export var D_anim : AnimationTree
@export var T_anim : AnimationTree
@export var decision_cam : Camera3D

@export var cam_anims : AnimationPlayer
#play intro anim - choice cam - play outro anim

@export var cuffs_open : Node3D
@export var cuffs_closed : Node3D

@export var KeyAnim : AnimationPlayer
@export var DoorAnim : AnimationPlayer
@export var soundplayer : AnimationPlayer

#chocolate show
@export var chocolate_animation : AnimationPlayer

func _ready() -> void:
	cam_anims.play("IntroAnimation")
	await get_tree().create_timer(10).timeout
	decision_cam.current = true
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact"):
		soundplayer.play("SoundsKey")
		cuffs_closed.visible = false
		cuffs_open.visible = true
		KeyAnim.play("Key")
		DoorAnim.play("DoorOpen")
		D_anim["parameters/conditions/release_skylar"] = true
		S_anim["parameters/conditions/release_skylar"] = true
		T_anim["parameters/conditions/release_skylar"] = true
		cam_anims.play("OutroAnimation")
	
	if Input.is_action_just_pressed("meeting_done"):
		cam_anims.play("ChocoCam")
