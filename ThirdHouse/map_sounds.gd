extends Node

@export var audio : Array[AudioStreamPlayer]
@export var audio_3d : Array[AudioStreamPlayer3D]

func _on_map_leave_Quincy() -> void:
	audio[3].play()

func _on_map_select_Quincy() -> void:
	audio[2].play()

func _on_exit_hover_quincy() -> void:
	audio[1].play()

func _on_normalHover() -> void:
	audio[0].play()

func _on_car_door_close() -> void:
	audio_3d[0].play()

func _on_car_door_open() -> void:
	audio_3d[1].play()
