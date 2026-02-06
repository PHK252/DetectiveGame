extends Node
@export var main : Node
var tile_matrix = [[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0]]

var day_1_matrix = [[0,0,0,0,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,0,0,0,0]]
var day_2_matrix = [[0,0,1,1,0,0],[0,1,0,0,1,0],[1,0,0,0,0,1],[0,1,0,0,1,0],[0,0,1,1,0,0]]

@export var clue : MeshInstance3D
@export var text_day_1 : String
@export var text_day_2 : String
@export var player : CharacterBody3D

func _ready():
	if GlobalVars.day == 2: #u increment after they come back to office
		clue.get_active_material(0).albedo_texture = load(text_day_1)
	else:
		clue.get_active_material(0).albedo_texture = load(text_day_2)
	#get_active_material(0).set_shader_parameter("texture_albedo", load(texture))

func _on_tile_change(tile_x_num, tile_y_num, status):
	tile_matrix[tile_x_num-1][tile_y_num-1] = status
	#print(tile_matrix)
	if GlobalVars.day == 2:
		if tile_matrix == day_1_matrix:
			player.stop_player()
			Loading.load_scene(main, GlobalVars.flashback_1_1, "", "", "", true, false)
			#SceneTransitions.glitch_change_scene(GlobalVars.flashback_1_1)
			#await get_tree().create_timer(3.0).timeout
			#player.start_player()
			#await get_tree().create_timer(3.0).timeout
			#self.queue_free()
	else:
		if tile_matrix == day_2_matrix:
			player.stop_player()
			Loading.load_scene(main, GlobalVars.flashback_2, "", "", "", true, false)
			#SceneTransitions.glitch_change_scene(GlobalVars.flashback_2)
			#await get_tree().create_timer(3.0).timeout
			#player.start_player()
			#await get_tree().create_timer(3.0).timeout
			#self.queue_free()
