extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_save_pressed():
	SaveLoad.saveGame(SaveLoad.SAVE_DIR + SaveLoad.SAVE_FILE_NAME)
	#print(GlobalVars._load_global_arr())
	#get_tree().change_scene_to_file("res://UI/Main Menu.tscn")


func _on_exit_pressed():
	$".".hide()
	pass # Replace with function body.


func _on_resume_pressed():
	#$".".hide()
	GlobalVars.forward = true
	GlobalVars.day = 2
	GlobalVars.time = "morning"
	GlobalVars.current_level = "micah"
	GlobalVars.first_house = "juniper"
	#print(GlobalVars._load_global_arr())
	#await get_tree().process_frame
	#print(GlobalVars.load_global_arr)
	pass # Replace with function body.


func _on_options_pressed():
	SaveLoad.loadGame(SaveLoad.SAVE_DIR + SaveLoad.SAVE_FILE_NAME)
	print(GlobalVars._load_global_arr())


func _on_controls_pressed():
	GlobalVars.forward = false
	GlobalVars.day = 0
	GlobalVars.time = ""
	GlobalVars.current_level = ""
	GlobalVars.first_house = ""
