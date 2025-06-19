extends Node

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

func _ready() -> void:
	CIA_01.visible = false
	CIA_02.visible = false
	anim_phone.play("Phone")
	await get_tree().create_timer(14).timeout
	blend = true
	
func _process(delta: float) -> void:
	if blend:
		watching_dalton["parameters/BlendSpace1D/blend_position"] = lerp(watching_dalton["parameters/BlendSpace1D/blend_position"], 1.0, delta * 2.0) 
	
	if Input.is_action_just_pressed("interact"):
		anim_case.play("CasePickup")
		isaac_anim["parameters/conditions/handover"] = true
		CIA_anim["parameters/conditions/handover"] = true
		CIA_02_anim["parameters/conditions/handover"] = true
		watching_dalton["parameters/conditions/handover"] = true
		whistleblower_anim["parameters/conditions/handover"] = true
		await get_tree().create_timer(0.2).timeout
		CIA_01.visible = true
		CIA_02.visible = true
		
	
