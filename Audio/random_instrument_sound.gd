extends Node3D

@export var player : AudioStreamPlayer
@export var sounds_folder : String
@export var alert : Sprite3D
var stream_array : Array[String]
var playing := false

func _ready():
	if sounds_folder:
		get_sounds_from_folder(sounds_folder)
		print(stream_array)

func _on_guitar_interact_interacted(interactor):
	if !playing:
		var arr_size = stream_array.size()
		if arr_size != 0:
			playing = true
			var stream_num = randi_range(0, arr_size-1)
			var curr_stream = load(stream_array[stream_num])
			player.stream = curr_stream
			alert.hide()
			player.play()
		else:
			print_debug("no streams :(")
			return


func _on_guitar_sounds_finished():
	alert.show()
	playing = false

func get_sounds_from_folder(folder : String):
	var dir_access := DirAccess.open(folder)
	if dir_access:
		for file in dir_access.get_files():
			if file.get_extension().to_lower() == "wav":
				stream_array.append(folder.path_join(file))
	else:
		print_debug("Can not open folder : ", folder)
