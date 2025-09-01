extends Node

@export var anim_drink : AnimationPlayer

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("meeting_done"):
		anim_drink.play("dalton_drink")
