extends Node3D

@export var dalton : CharacterBody3D
@export var player : AudioStreamPlayer
@export var sounds_folder : String
@export var alert : Sprite3D
var stream_array : Array[String]
var playing := false
var bus_ind = AudioServer.get_bus_index("Music")
var starting_db = AudioServer.get_bus_volume_db(bus_ind)

func _ready():
	if sounds_folder:
		get_sounds_from_folder(sounds_folder)
		print(stream_array)

func _on_guitar_interact_interacted(interactor):
	if !playing and !GlobalVars.in_dialogue:
		var arr_size = stream_array.size()
		if arr_size != 0:
			playing = true
			var stream_num = randi_range(0, arr_size-1)
			var curr_stream = load(stream_array[stream_num])
			side_chain("Music", -15, .5)
			await get_tree().create_timer(.5).timeout
			player.stream = curr_stream
			alert.hide()
			dalton.stop_player()
			player.play()
		else:
			print_debug("no streams :(")
			return

func side_chain(bus_name : String, target_db : float, duration : float):
	var cur_db = AudioServer.get_bus_volume_db(bus_ind)
	var tween = create_tween()
	tween.tween_method(func(volume): AudioServer.set_bus_volume_db(bus_ind, volume),
	cur_db,
	target_db,
	duration
	)
	
func _on_guitar_sounds_finished():
	if !GlobalVars.in_dialogue:
		alert.show()
		dalton.start_player()
	playing = false
	side_chain("Music", starting_db, .25)
	await get_tree().create_timer(.5).timeout

func get_sounds_from_folder(folder : String):
	var dir_access := DirAccess.open(folder)
	if dir_access:
		for file in dir_access.get_files():
			if file.get_extension().to_lower() == "wav":
				stream_array.append(folder.path_join(file))
	else:
		print_debug("Can not open folder : ", folder)
