extends CanvasLayer

@onready var prev_mouse_mode : int
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
func _on_save_pressed():
	print("save_pressed")
	get_tree().paused = false
	await get_tree().process_frame
	SaveLoad.saveGame(SaveLoad.SAVE_DIR + SaveLoad.SAVE_FILE_NAME)
	GlobalVars.to_quit = true
	SceneTransitions.fade_change_scene(GlobalVars.main_menu)

func _on_resume_pressed():
	print("resume_pressed")
	get_tree().paused = false
	visible = false
	#print(prev_mouse_mode)
	Input.set_mouse_mode(prev_mouse_mode)
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
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			prev_mouse_mode = 2
		elif Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			prev_mouse_mode = 0
		print(prev_mouse_mode)
		get_tree().paused = true
		await get_tree().process_frame
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	pass # Replace with function body.
