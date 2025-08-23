extends Node

@export var anim_I : AnimationTree
@export var anim_r : AnimationTree
@export var anim_c : AnimationPlayer

@export var isaac_marker : Marker2D
@export var runa_marker : Marker2D

func _ready() -> void:
	anim_c.play("CamAnim")
	await anim_c.animation_finished
	#anim_r["parameters/conditions/look_around"] = true
	GlobalVars.in_dialogue = true
	var office_dialogue = Dialogic.start("Day_1_Office")
	Dialogic.timeline_ended.connect(_on_timeline_ended)
	Dialogic.signal_event.connect(_isaac_movement)
	office_dialogue.register_character(load("res://Dialogic Characters/Runa.dch"), runa_marker)
	office_dialogue.register_character(load("res://Dialogic Characters/Isaac.dch"), isaac_marker)
	#await get_tree().create_timer(1.5).timeout
	#anim_I["parameters/conditions/nod"] = true

func _on_timeline_ended():
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	Dialogic.signal_event.disconnect(_isaac_movement)
	GlobalVars.in_dialogue = false
	#transtion to Day 2

func _isaac_movement(arg : String):
	if arg == "nod":
		anim_I["parameters/conditions/nod"] = true
	else:
		anim_I["parameters/conditions/snapOut"] = true
		
