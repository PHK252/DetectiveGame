extends Node

@export var anim_q : AnimationPlayer
@export var anim_s : AnimationPlayer
@export var anim_d : AnimationPlayer
@export var quincy_arrest : bool = false

func _ready() -> void:
	anim_d.play("WalkDetectiveOut")
	if quincy_arrest == false:
		anim_s.play("PrisonSkylar")
	else:
		anim_q.play("QuincyPrison")
		
		
