extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
func _on_save_pressed():
	SaveLoad.saveGame(SaveLoad.SAVE_DIR + SaveLoad.SAVE_FILE_NAME)
	SceneTransitions.fade_change_scene(GlobalVars.main_menu)

func _on_resume_pressed():
	get_tree().paused = false
	visible = false
	#$".".hide()
	#GlobalVars.forward = true
	#GlobalVars.day = 2
	#GlobalVars.time = "morning"
	#GlobalVars.current_level = "micah"
	#GlobalVars.first_house = "juniper"
	#print(GlobalVars._load_global_arr())
	#await get_tree().process_frame
	#print(GlobalVars.load_global_arr)
	pass # Replace with function body.


func _on_options_pressed():
	print("options")


func _on_controls_pressed():
	print("controls")

func _on_visibility_changed():
	#debug
	if visible == true:
		get_tree().paused = true
	pass # Replace with function body.
