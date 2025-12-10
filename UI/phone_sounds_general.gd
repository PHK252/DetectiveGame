extends Node

@export var audio : Array[AudioStreamPlayer]


func _on_home_pressed() -> void:
	audio[0].play()

func _on_phone_select() -> void:
	audio[4].play()

func _on_phone_hover() -> void:
	audio[1].play()

func _on_altClick_phone() -> void:
	audio[11].play()

func _on_alt_hover_phone() -> void:
	audio[12].play()

func _on_phone_hiss() -> void:
	audio[10].play()

func _on_arrow_click() -> void:
	audio[13].play()

func _on_back_pressed_phone() -> void:
	audio[14].play()

func _on_num_01_pressed() -> void:
	audio[7].play()

func _on_num_two_pressed() -> void:
	audio[8].play()

func _on_num_three_pressed() -> void:
	audio[9].play()

func _on_accept_pressed() -> void:
	audio[4].play()

func _on_decline_pressed() -> void:
	audio[5].play()

func _on_phone_buzz() -> void:
	audio[15].play()

func _on_stop_buzz() -> void:
	audio[15].stop()

func _on_delete_pressed() -> void:
	audio[16].play()
