extends Node

@export var level : String
@export var audio : Array[AudioStreamPlayer3D]
@export var audio_master : Array[AudioStreamPlayer]

func _on_doughnut_001_time_to_eat() -> void:
	await get_tree().create_timer(3.0).timeout
	audio[2].play()

func _on_detective_anims_dalton_invisible() -> void:
	audio[0].play()

func _on_detective_anims_dalton_visible() -> void:
	print("VISIBILITY")
	audio[1].play()

func _on_forward_pressed() -> void:
	audio_master[0]["parameters/switch_to_clip"] = "Paper 7"
	audio_master[0].play() 

func _on_back_pressed() -> void:
	audio_master[0]["parameters/switch_to_clip"] = "Paper 8"
	audio_master[0].play() 

func _on_interactable_interacted(interactor: Interactor) -> void:
	audio_master[0]["parameters/switch_to_clip"] = "Paper 3"
	audio_master[0].play() 

func _on_paper_sound() -> void:
	audio_master[0]["parameters/switch_to_clip"] = "Clip 10"
	audio_master[0].play() 
