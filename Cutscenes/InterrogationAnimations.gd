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

@onready var dialogic_file : String
@export var dalton_marker : Marker2D
@export var theo_marker : Marker2D
@export var skylar_maker : Marker2D

func _ready() -> void:
	if Dialogic.VAR.get_variable("Interogation.Case_Intero", true):
		dialogic_file = "Day_3_intero_case"
	elif Dialogic.VAR.get_variable("Interogation.Case_Rever_Quincy_intero", true):
		dialogic_file = "Day_3_intero_case_rever_quincy"
	elif Dialogic.VAR.get_variable("Interogation.Secret_intero", true):
		dialogic_file = "Secret_intero"

	cam_anims.play("IntroAnimation_revised")
	await get_tree().create_timer(3).timeout
	decision_cam.current = true
	var intero_dialogue = Dialogic.start(dialogic_file)
	Dialogic.timeline_ended.connect(_on_timeline_ended)
	if dialogic_file == "Secret_intero":
		Dialogic.signal_event.connect(_walk_out_skylar)
		Dialogic.signal_event.connect(_show_da_choco)
	GlobalVars.in_dialogue = true
	intero_dialogue.register_character(load("res://Dialogic Characters/Dalton.dch"), dalton_marker)
	intero_dialogue.register_character(load("res://Dialogic Characters/Theo.dch"), theo_marker)
	intero_dialogue.register_character(load("res://Dialogic Characters/Skylar.dch"), skylar_maker)
	


func _on_timeline_ended():
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	GlobalVars.in_dialogue = false

func _walk_out_skylar(arg : String):
	if arg == "Skylar_walk_out":
		Dialogic.signal_event.disconnect(_walk_out_skylar)
		soundplayer.play("SoundsKey")
		cuffs_closed.visible = false
		cuffs_open.visible = true
		KeyAnim.play("Key")
		DoorAnim.play("DoorOpen")
		D_anim["parameters/conditions/release_skylar"] = true
		S_anim["parameters/conditions/release_skylar"] = true
		T_anim["parameters/conditions/release_skylar"] = true
		cam_anims.play("OutroAnimation")
	else:
		Dialogic.signal_event.disconnect(_walk_out_skylar)

func _show_da_choco(arg : String):
	if arg == "show_choco":
		Dialogic.signal_event.disconnect(_show_da_choco)
		cam_anims.play("ChocoCam")
	else:
		Dialogic.signal_event.disconnect(_show_da_choco)
