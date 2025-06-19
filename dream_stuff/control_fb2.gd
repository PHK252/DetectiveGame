extends Node

@export var anim_I : AnimationTree
@export var anim_r : AnimationTree
@export var anim_c : AnimationPlayer

func _ready() -> void:
	anim_c.play("CamAnim")

func _process(delta):
	if Input.is_action_just_pressed("interact"):
		anim_I["parameters/conditions/snapOut"] = true
		anim_r["parameters/conditions/look_around"] = true
		await get_tree().create_timer(1.5).timeout
		anim_I["parameters/conditions/nod"] = true
	
		
