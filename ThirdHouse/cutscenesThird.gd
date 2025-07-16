extends Node

@export var anim_player : AnimationPlayer
@export var test_cutscene : bool

@export var player : CharacterBody3D
@export var sitting_Dalton : Node3D
@export var quincy_norm_body : CharacterBody3D 
@export var dalton_marker : Marker2D
@export var theo_marker : Marker2D
@export var character_marker : Marker2D

signal faint_disable
signal continue_bar
signal open_door
signal after_faint
signal theo_follow
signal reposition_dalton
#func _process(delta: float) -> void:
	#if Input.is_action_just_pressed("interact") and test_cutscene:
		#pass
		#
	#if Input.is_action_just_pressed("meeting_done") and test_cutscene:	
		#anim_player.play("fainting_cutscene")
	


func _on_bar_make_drinks():
	print("making drinks")
	#quincy_norm_body.hide()
	anim_player.play("cocktail_cutscene")
	await anim_player.animation_finished
	#quincy_norm_body.show()
	emit_signal("continue_bar")


func _on_bar_faint_time():
	print("fainting")
	sitting_Dalton.hide()
	#player.hide()
	emit_signal("faint_disable")
	anim_player.play("fainting_cutscene")
	await anim_player.animation_finished
	var faint_dialogue = Dialogic.start("Quincy_faint")
	GlobalVars.in_dialogue = true
	Dialogic.timeline_ended.connect(_on_timeline_ended)
	faint_dialogue.register_character(load("res://Dialogic Characters/Dalton.dch"), dalton_marker)
	faint_dialogue.register_character(load("res://Dialogic Characters/Theo.dch"), theo_marker)
	faint_dialogue.register_character(load("res://Dialogic Characters/Quincy.dch"), character_marker)

func _on_timeline_ended():
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	GlobalVars.in_interaction = ""
	GlobalVars.in_dialogue = false
	emit_signal("open_door")
	player.start_player()
	emit_signal("theo_follow")
