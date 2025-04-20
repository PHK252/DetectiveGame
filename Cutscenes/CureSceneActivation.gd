extends Node

@export var dalton_controller : Node3D
@export var dalton_cutscene : Node3D
@export var dalton_anims : AnimationTree
@export var door : AnimationPlayer
@export var brother_anims : AnimationTree
@export var cure_dalton_hand : Node3D
@export var cure_brother_hand : Node3D
@export var cam_anims : AnimationPlayer
@export var dialogue_cam : Camera3D

func _ready() -> void:
	cam_anims.play("IntroAnimation")

func _process(delta):
	if Input.is_action_just_pressed("meeting_done"):
		cam_anims.play("OutroAnimation")
		dalton_controller.visible = false
		dalton_cutscene.visible = true
		dalton_anims["parameters/conditions/start_anim"] = true 
		brother_anims["parameters/conditions/take_cure"] = true
		await get_tree().create_timer(0.7).timeout
		dalton_anims["parameters/conditions/give_cure"] = true
		cure_dalton_hand.visible = true
		await get_tree().create_timer(3).timeout
		cure_dalton_hand.visible = false
		cure_brother_hand.visible = true
		await get_tree().create_timer(2).timeout
		cure_brother_hand.visible = false

func _on_interactable_interacted(interactor: Interactor) -> void:
	door.play("doorOpen")
	brother_anims["parameters/conditions/door_open"] = true
	dialogue_cam.current = true
	
	
