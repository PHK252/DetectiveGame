extends Node2D

#continue and start buttons
@export var start_butt : MarginContainer 
@export var continue_new_cont : MarginContainer

#switching screens
@export var start : CanvasLayer 
@export var controls : CanvasLayer
@export var options : CanvasLayer

@export var cl : Panel
@export var bg : TextureRect

var new_game : bool

var selected : int

#handle_label_changes

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if AudioServer.is_bus_mute(0) == true:
		AudioServer.set_bus_mute(0, false)
		#GlobalVars.to_quit = false
	#get_viewport().size_changed.connect(_on_new_window_size)
	#_on_new_window_size()
	#SaveLoad.clearSave(SaveLoad.SAVE_DIR + SaveLoad.SAVE_FILE_NAME)
	await get_tree().process_frame
	#print(GlobalVars.current_level)
	
	new_game = SaveLoad.check_save_file_empty(SaveLoad.SAVE_DIR + SaveLoad.SAVE_FILE_NAME)
	print("New Game: " + str(new_game))
	SaveLoad.loadSettings(SaveLoad.SAVE_DIR + SaveLoad.SETTINGS_FILE)
	if new_game == true or SaveLoad.brand_new == true:
		start_butt.show()
		continue_new_cont.hide()
	else:
		SaveLoad.loadGame(SaveLoad.SAVE_DIR + SaveLoad.SAVE_FILE_NAME)
		GlobalVars.from_save_file = true
		start_butt.hide()
		continue_new_cont.show()
		
		
		#not needed
		#brightness technically firing twice bad practice but maybe ok
		#emit_signal("set_brightness_label", GlobalVars.brightnes)

func _on_new_window_size():
	var viewport_size = get_viewport().get_visible_rect().size
	
	# Pick the smaller ratio so the UI never stretches unevenly
	var ratio = min(
		viewport_size.x / ProjectSettings.get_setting("display/window/size/viewport_width"),
		viewport_size.y / ProjectSettings.get_setting("display/window/size/viewport_height")
	)
	
	# Scale the whole CanvasLayer (so all children Controls scale uniformly)
	cl.scale = Vector2(ratio, ratio)
	bg.scale = Vector2(ratio, ratio)

	# Optional: if your CanvasLayer root needs pivot adjustment
	cl.pivot_offset = cl.size / 2   # CanvasLayer doesn’t have pivot, but its children do


func _on_quit_pressed():
	get_tree().quit()


func _on_start_pressed():
	#SceneTransitions.glitch_change_scene("res://StartingOffice/starting_office.tscn")
	#LoadManager.load_scene(GlobalVars.first_house_path)
	#Loading.load_scene(self, GlobalVars.first_house_path, "driving", "afternoon", "Day_1_ride_to_back_to_station")
	Loading.load_scene(self, GlobalVars.beginning_office, "date", "1 OCT XX19", "")


func _on_continue_pressed():
	#GlobalVars.current_level = "quincy"
	#Loading.load_scene(self, GlobalVars.third_house_path, false, "", "")
	print(GlobalVars.dalton_pos, "menu")
	print(GlobalVars.from_save_file, " from save")
	var level_to_load = GlobalVars.get_current_level_path(GlobalVars.current_level)
	Loading.load_scene(self, level_to_load, "", "", "")


func _on_new_game_pressed():
	SaveLoad.clearSave(SaveLoad.SAVE_DIR + SaveLoad.SAVE_FILE_NAME)
	GlobalVars.reset_globals()
	SaveLoad.saveGame(SaveLoad.SAVE_DIR + SaveLoad.SAVE_FILE_NAME)
	#SaveLoad.loadGame(SaveLoad.SAVE_DIR + SaveLoad.SAVE_FILE_NAME)
	Loading.load_scene(self, GlobalVars.beginning_office, "date", "1 OCT XX19", "")


func _on_controls_pressed():
	start.visible = false
	controls.visible = true


func _on_controls_show_start():
	start.visible = true
	controls.visible = false

func _on_options_pressed():
	start.visible = false
	options.visible = true


func _on_options_exit_button_pressed():
	start.visible = true
	options.visible = false
