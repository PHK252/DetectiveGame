extends Node
@export var main : Node3D
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

@onready var pause = $"../../../Pause"

signal look_at_activate_skylar

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	GlobalVars.current_level = "interrogation"
	if Dialogic.VAR.get_variable("Interogation.Case_Intero") == true:
		dialogic_file = "Day_3_intero_case"
	elif Dialogic.VAR.get_variable("Interogation.Case_Rever_Quincy_intero") == true:
		dialogic_file = "Day_3_intero_case_rever_quincy"
	elif Dialogic.VAR.get_variable("Interogation.Secret_intero") == true:
		dialogic_file = "Secret_intero"
	else:
		dialogic_file = "Day_3_intero_case"
		print_debug("How you get here?")
		return

	cam_anims.play("IntroAnimation_revised")
	await get_tree().create_timer(4).timeout
	emit_signal("look_at_activate_skylar")
	decision_cam.current = true
	var intero_dialogue = Dialogic.start(dialogic_file)
	Dialogic.timeline_ended.connect(_on_timeline_ended)
	if dialogic_file == "Secret_intero":
		Dialogic.signal_event.connect(_walk_out_skylar)
		Dialogic.signal_event.connect(_show_da_choco)
	GlobalVars.in_dialogue = true


func _on_timeline_ended():
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	GlobalVars.in_dialogue = false
	match Dialogic.VAR.get_variable("Endings.Ending_type"):
		"Arrested Skylar":
			Loading.load_scene(main, GlobalVars.office_path, "", "", "")
		"Keep Confidential":
			Loading.load_scene(main, GlobalVars.office_path, "date", "14 APR XX21", "")
		"Give Skylar Cure":
			Loading.load_scene(main, GlobalVars.office_path, "date", "15 FEB XX21", "")
		"Give Skylar Cure And Choco":
			Loading.load_scene(main, GlobalVars.office_path, "date", "26 NOV XX21", "")
		"Give Kale Cure":
			Loading.load_scene(main, GlobalVars.isaac_house, "", "", "")
		"Give Kale Cure And Choco":
			Loading.load_scene(main, GlobalVars.isaac_house, "", "", "")
		_:
			print_debug("No Ending Uh Oh")

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
