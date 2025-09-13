extends Node2D

@onready var start_butt = $Start
@onready var continue_butt = $Continue

var new_game : bool
# Called when the node enters the scene tree for the first time.
func _ready():
	new_game = SaveLoad.check_save_file_empty(SaveLoad.SAVE_DIR + SaveLoad.SAVE_FILE_NAME)
	print("New Game: " + str(new_game))
	if new_game == true:
		start_butt.show()
		continue_butt.hide()
	else:
		SaveLoad.loadGame(SaveLoad.SAVE_DIR + SaveLoad.SAVE_FILE_NAME)
		start_butt.hide()
		continue_butt.show()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_quit_pressed():
	get_tree().quit()


func _on_start_pressed():
	#SceneTransitions.glitch_change_scene("res://StartingOffice/starting_office.tscn")
	#LoadManager.load_scene(GlobalVars.first_house_path)
	#Loading.load_scene(self, GlobalVars.first_house_path, true, "morning", "yes_diner")
	Loading.load_scene(self, GlobalVars.beginning_office, false, "", "")


func _on_continue_pressed():
	Loading.load_scene(self, GlobalVars.beginning_office, false, "", "")
