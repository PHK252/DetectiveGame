extends Node3D

@export var dialogue_file: String
@export var player: CharacterBody3D
@export var alert : Sprite3D
@export var interactable : Interactable

func _on_interactable_interacted(interactor):
	Dialogic.start(dialogue_file)
	Dialogic.timeline_ended.connect(_on_timeline_ended)
	player.stop_player()
	alert.hide()

func _on_timeline_ended():
	player.start_player()
	interactable.set_deferred("monitorable", false)
