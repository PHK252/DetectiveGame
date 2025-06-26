extends Node

@export var anim_player : AnimationPlayer
@export var test_cutscene : bool
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") and test_cutscene:
		anim_player.play("cocktail_cutscene")
		
	if Input.is_action_just_pressed("meeting_done") and test_cutscene:	
		anim_player.play("fainting_cutscene")
	
