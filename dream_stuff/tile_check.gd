extends Node
@export var main : Node
var tile_matrix = [[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0]]

var day_1_matrix = [[0,0,0,0,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,0,0,0,0]]
var day_2_matrix = [[0,0,1,1,0,0],[0,1,0,0,1,0],[1,0,0,0,0,1],[0,1,0,0,1,0],[0,0,1,1,0,0]]

@export var player : CharacterBody3D


func _on_tile_change(tile_x_num, tile_y_num, status):
	tile_matrix[tile_x_num-1][tile_y_num-1] = status
	#print(tile_matrix)
	if GlobalVars.day == 1:
		if tile_matrix == day_1_matrix:
			player.stop_player()
			Loading.load_scene(main, GlobalVars.flashback_1_1, "", "", "", false, true)
			#SceneTransitions.glitch_change_scene(GlobalVars.flashback_1_1)
			#await get_tree().create_timer(3.0).timeout
			#player.start_player()
			#await get_tree().create_timer(3.0).timeout
			#self.queue_free()
	else:
		if tile_matrix == day_2_matrix:
			player.stop_player()
			Loading.load_scene(main, GlobalVars.flashback_2, "", "", "", false, true)
			#SceneTransitions.glitch_change_scene(GlobalVars.flashback_2)
			#await get_tree().create_timer(3.0).timeout
			#player.start_player()
			#await get_tree().create_timer(3.0).timeout
			#self.queue_free()
