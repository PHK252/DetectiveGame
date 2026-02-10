extends Node

@export var audio_sfx : Array[AudioStreamPlayer]
@export var audio_world : Array[AudioStreamPlayer3D]

@export var case : Node3D #held by dalton

func _ready() -> void:
	Dialogic.signal_event.connect(_on_dialogic_signal)
	
	
func _on_dialogic_signal(argument: String):
	if argument == "open":
		audio_world[1].play()
	
	if argument == "take_case":
		case.visible = true
		audio_world[2].play()


func _on_look_paper_sound() -> void:
	audio_world[0].play()


func _on_interactable_interacted(interactor: Interactor) -> void:
	audio_sfx[0].play()


func _on_exit_pressed() -> void:
	audio_sfx[1].play()


func _on_exit_mouse_entered() -> void:
	audio_sfx[2].play()
