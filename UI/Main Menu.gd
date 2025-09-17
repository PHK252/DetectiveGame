extends Node2D

@onready var start_butt = $Start/Start
@onready var continue_new_cont = $Start/Continue
@onready var start = $Start
@onready var controls = $Controls


var new_game : bool
# Called when the node enters the scene tree for the first time.
func _ready():
	#print(GlobalVars.current_level)
	new_game = SaveLoad.check_save_file_empty(SaveLoad.SAVE_DIR + SaveLoad.SAVE_FILE_NAME)
	print("New Game: " + str(new_game))
	if new_game == true:
		start_butt.show()
		continue_new_cont.hide()
	else:
		SaveLoad.loadGame(SaveLoad.SAVE_DIR + SaveLoad.SAVE_FILE_NAME)
		GlobalVars.from_save_file = true
		start_butt.hide()
		continue_new_cont.show()
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


func _on_controls_pressed():
	start.visible = false
	controls.visible = true


func _on_controls_show_start():
	start.visible = true
