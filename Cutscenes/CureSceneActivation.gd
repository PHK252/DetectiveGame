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
@export var door_sound : AudioStreamPlayer3D
@export var general_sound : AnimationPlayer
@onready var player = $Dalton/CharacterBody3D
@onready var alert = $Dalton/CharacterBody3D/PlayerInteractor/CollisionShape3D/Alert
@onready var pause = $"../../../Pause"

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	GlobalVars.current_level = "Give Cure"
	cam_anims.play("IntroAnimation")

func _input(event):
	if Input.is_action_just_pressed("Quit"):
		if pause.visible == false:
			pause.visible = true

func _on_interactable_interacted(interactor: Interactor) -> void:
	player.stop_player()
	alert.hide()
	
func hand_cure(arg : String):
	if arg == "give_vial":
		dalton_controller.visible = false
		dalton_cutscene.visible = true
		dalton_anims["parameters/conditions/start_anim"] = true 
		brother_anims["parameters/conditions/take_cure"] = true
		await get_tree().create_timer(0.7).timeout
		dalton_anims["parameters/conditions/give_cure"] = true
		general_sound.play("gen_sounds")
		await get_tree().create_timer(1).timeout
		cure_dalton_hand.visible = true
		await get_tree().create_timer(2).timeout
		cure_dalton_hand.visible = false
		cure_brother_hand.visible = true
		await get_tree().create_timer(2).timeout
		cure_brother_hand.visible = false
		brother_anims["parameters/conditions/take_cure"] = false
	Dialogic.signal_event.disconnect(hand_cure)

func _on_timeline_ended():
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	cam_anims.play("OutroAnimation")
	#TO ENDING


func _on_knock_open_door_brother():
	door_sound.play()
	door.play("doorOpen")
	brother_anims["parameters/conditions/door_open"] = true
	dialogue_cam.current = true
	await get_tree().create_timer(3.0).timeout
	Dialogic.timeline_ended.connect(_on_timeline_ended)
	Dialogic.signal_event.connect(hand_cure)
	Dialogic.start("Give_kale_cure")
