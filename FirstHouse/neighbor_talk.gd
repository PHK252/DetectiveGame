extends Node3D

@export var dialogue_file: String
@export var player: CharacterBody3D
@export var alert : Sprite3D
@export var interactable : Interactable

signal look_at_on
signal look_at_off

func _on_interactable_interacted(interactor):
	if GlobalVars.in_dialogue == false:
		print("talk")
		emit_signal("look_at_on")
		Dialogic.start(dialogue_file)
		Dialogic.timeline_ended.connect(_on_timeline_ended)
		player.stop_player()
		alert.hide()
		GlobalVars.in_dialogue = true

func _on_timeline_ended():
	emit_signal("look_at_off")
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	GlobalVars.in_dialogue = false
	player.start_player()
	interactable.set_deferred("monitorable", false)
