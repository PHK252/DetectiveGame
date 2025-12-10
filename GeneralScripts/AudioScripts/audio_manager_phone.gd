extends Node

@export var level : String
@export var audio : Array[AudioStreamPlayer3D]
@export var audio_master : Array[AudioStreamPlayer]

func _on_home_pressed() -> void:
	audio_master[0].play()

func _on_phone_select() -> void:
	audio_master[4].play()

func _on_phone_hover() -> void:
	audio_master[1].play()

func _on_altClick_phone() -> void:
	audio_master[11].play()

func _on_alt_hover_phone() -> void:
	audio_master[12].play()

func _on_phone_hiss() -> void:
	audio_master[10].play()

func _on_arrow_click() -> void:
	audio_master[13].play()

func _on_back_pressed_phone() -> void:
	audio_master[14].play()

func _on_num_01_pressed() -> void:
	audio_master[7].play()

func _on_num_two_pressed() -> void:
	audio_master[8].play()

func _on_num_three_pressed() -> void:
	audio_master[9].play()

func _on_accept_pressed() -> void:
	audio_master[4].play()

func _on_decline_pressed() -> void:
	audio_master[5].play()

func _on_phone_buzz() -> void:
	audio_master[15].play()

func _on_stop_buzz() -> void:
	audio_master[15].stop()

func _on_delete_pressed() -> void:
	audio_master[16].play()

func _on_view_sound() -> void:
	audio_master[18].play()

func _on_flip_sound() -> void:
	audio_master[17].play()
