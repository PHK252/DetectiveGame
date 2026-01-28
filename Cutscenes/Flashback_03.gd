extends Node

@export var main : Node
@export var anim_case : AnimationPlayer
@export var anim_phone : AnimationPlayer

@export var isaac_anim : AnimationTree
@export var whistleblower_anim : AnimationTree

@export var CIA_anim : AnimationTree
@export var CIA_02_anim : AnimationTree

@export var watching_dalton : AnimationTree

#visibility
@export var CIA_01 : Node3D
@export var CIA_02 : Node3D

var blend := false

@export var isaac_marker : Marker2D
@export var marcus_marker : Marker2D
@export var man1_marker : Marker2D
@export var man2_marker : Marker2D
#sounds
@export var isaac_sounds : AnimationPlayer
@export var wb_sounds : AnimationPlayer
@export var CIA2_sounds : AnimationPlayer
@export var CIA1_sounds : AnimationPlayer
@export var rustle : AudioStreamPlayer3D

#headbob signals
signal activate_look_general
signal activate_look_isaac
signal deactivate_look

func _ready() -> void:
	emit_signal("activate_look_general")
	isaac_sounds.play("IsaacStart")
	CIA_01.visible = false
	CIA_02.visible = false
	anim_phone.play("Phone")
	await anim_phone.animation_finished
	emit_signal("activate_look_isaac")
	GlobalVars.in_dialogue = true
	var end_dialogue = Dialogic.start("Day_2_Secret")
	Dialogic.timeline_ended.connect(_on_timeline_ended)
	Dialogic.signal_event.connect(_end_movement)
	
	await get_tree().create_timer(14).timeout
	blend = true
	
func _process(delta: float) -> void:
	if blend:
		watching_dalton["parameters/BlendSpace1D/blend_position"] = lerp(watching_dalton["parameters/BlendSpace1D/blend_position"], 1.0, delta * 2.0) 

func _end_movement(arg : String):
	if arg == "marc_walk_in":
		whistleblower_anim["parameters/conditions/enter"] = true
		wb_sounds.play("WalkIn")
	if arg == "rustle":
		rustle.play()
	elif arg == "marc_give_and_runs":
		emit_signal("deactivate_look")
		isaac_sounds.play("IsaacHandover")
		isaac_anim["parameters/conditions/handover"] = true
		whistleblower_anim["parameters/conditions/handover"] = true
		anim_case.play("CasePickup")
		wb_sounds.play("RunOut")
	elif arg == "mm_enter":
		isaac_sounds.play("IsaacFight")
		isaac_anim["parameters/conditions/fight"] = true
		CIA_anim["parameters/conditions/fight"] = true
		CIA_02_anim["parameters/conditions/fight"] = true
		watching_dalton["parameters/conditions/handover"] = true
		CIA1_sounds.play("WalkCIA1")
		CIA2_sounds.play("WalkCIA2")
		await get_tree().create_timer(0.2).timeout
		CIA_01.visible = true
		CIA_02.visible = true

func _on_timeline_ended():
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	Dialogic.signal_event.disconnect(_end_movement)
	GlobalVars.in_dialogue = false
	GlobalVars.day = 3
	Loading.load_scene(main, GlobalVars.office_path, "Sleep", "Out Dream", "", true, false)
	
