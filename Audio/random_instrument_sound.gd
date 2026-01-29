extends Node3D

@export var player : AudioStreamPlayer3D
@export var stream_array : Array[String]
var playing := false

func _on_guitar_interact_interacted(interactor):
	if !playing:
		var arr_size = stream_array.size()
		if arr_size != 0:
			playing = true
			var stream_num = randi_range(0, arr_size-1)
			var curr_stream = load(stream_array[stream_num])
			player.stream = curr_stream
			player.play()
		else:
			print_debug("no streams :(")
			return


func _on_guitar_sounds_finished():
	playing = false
