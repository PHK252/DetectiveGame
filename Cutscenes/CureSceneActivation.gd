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
@export var zoom_cam : Camera3D
@export var door_sound : AudioStreamPlayer3D
@export var general_sound : AnimationPlayer
@onready var player = $Dalton/CharacterBody3D
@onready var alert = $Dalton/CharacterBody3D/PlayerInteractor/CollisionShape3D/Alert
@onready var pause = $"../../../Pause"

@export var marker_place_dalton : Marker3D
@export var marker_rotate_dalton : Marker3D

@export var norm_dalton : CharacterBody3D
@export var armature_d : Node3D

signal walkoutdalton

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	GlobalVars.current_level = "Give Cure"
	cam_anims.play("IntroAnimation")


func _on_interactable_interacted(interactor: Interactor) -> void:
	player.stop_player()
	alert.hide()
	
func hand_cure(arg : String):
	if arg == "give_vial":
		brother_anims["parameters/conditions/take_cure"] = true
		await get_tree().create_timer(0.7).timeout
		dalton_controller.visible = false
		dalton_cutscene.visible = true
		zoom_cam.current = true
		dalton_anims["parameters/conditions/start_anim"] = true
		general_sound.play("gen_sounds")
		await get_tree().create_timer(1).timeout
		cure_dalton_hand.visible = true
		await get_tree().create_timer(2.3).timeout
		cure_dalton_hand.visible = false
		cure_brother_hand.visible = true
		await get_tree().create_timer(2).timeout
		dialogue_cam.current = true
		dalton_controller.visible = true
		dalton_cutscene.visible = false
		cure_brother_hand.visible = false
		brother_anims["parameters/conditions/take_cure"] = false
	Dialogic.signal_event.disconnect(hand_cure)

func _on_timeline_ended():
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	cam_anims.play("OutroAnimation")
	emit_signal("walkoutdalton")
	#TO ENDING

func _on_knock_open_door_brother():
	norm_dalton.global_position = marker_place_dalton.global_position
	var dir = (armature_d.global_position - marker_rotate_dalton.global_position).normalized()
	armature_d.rotation.y = atan2(-dir.x, -dir.z)
	door_sound.play()
	door.play("doorOpen")
	brother_anims["parameters/conditions/door_open"] = true
	dialogue_cam.current = true
	await get_tree().create_timer(3.0).timeout
	Dialogic.timeline_ended.connect(_on_timeline_ended)
	Dialogic.signal_event.connect(hand_cure)
	Dialogic.start("Give_kale_cure")
