extends Node

var tile_matrix = [[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0]]

var day_1_matrix = [[0,0,0,0,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,1,1,0,0],[0,0,0,0,0,0]]
var day_2_matrix = [[0,0,1,1,0,0],[0,1,0,0,1,0],[1,0,0,0,0,1],[0,1,0,0,1,0],[0,0,1,1,0,0]]

#func _ready():
	#print(tile_matrix[4][4])


func _on_tile_change(tile_x_num, tile_y_num, status):
	tile_matrix[tile_x_num-1][tile_y_num-1] = status
	print(tile_matrix)
	if GlobalVars.day == "first":
		if tile_matrix == day_1_matrix:
			print("Yippee")
	else:
		if tile_matrix == day_2_matrix:
			print("Yippee too")
