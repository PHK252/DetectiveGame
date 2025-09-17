extends Node2D

@onready var start_butt = $VBoxContainer/Start
@onready var continue_butt = $VBoxContainer/Continue
@onready var new_game_butt = $"VBoxContainer/New Game"

var new_game : bool
# Called when the node enters the scene tree for the first time.
func _ready():
	SaveLoad.clearSave(SaveLoad.SAVE_DIR + SaveLoad.SAVE_FILE_NAME)
	#print(GlobalVars.current_level)
	new_game = SaveLoad.check_save_file_empty(SaveLoad.SAVE_DIR + SaveLoad.SAVE_FILE_NAME)
	print("New Game: " + str(new_game))
	if new_game == true:
		start_butt.show()
		continue_butt.hide()
		new_game_butt.hide()
	else:
		SaveLoad.loadGame(SaveLoad.SAVE_DIR + SaveLoad.SAVE_FILE_NAME)
		GlobalVars.from_save_file = true
		start_butt.hide()
		continue_butt.show()
		new_game_butt.show()
		#GlobalVars.to_quit = false


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
	#GlobalVars.current_level = "quincy"
	#Loading.load_scene(self, GlobalVars.third_house_path, false, "", "")
	print(GlobalVars.dalton_pos)
	var level_to_load = GlobalVars.get_current_level_path(GlobalVars.current_level)
	Loading.load_scene(self, level_to_load, false, "", "")


func _on_new_game_pressed():
	SaveLoad.clearSave(SaveLoad.SAVE_DIR + SaveLoad.SAVE_FILE_NAME)
	SaveLoad.saveGame(SaveLoad.SAVE_DIR + SaveLoad.SAVE_FILE_NAME)
	#SaveLoad.loadGame(SaveLoad.SAVE_DIR + SaveLoad.SAVE_FILE_NAME)
	Loading.load_scene(self, GlobalVars.beginning_office, false, "", "")
