extends CanvasLayer

@export var main_menu : bool

@onready var main_menu_screen = $"Main Menu"
@onready var pause_menu = $"Pause Menu"

signal options_exit

signal set_selected #window
signal set_res(res: int)
signal set_vsync(vsync: int)
signal set_pixel_label(pixelation: int)
signal set_shadow_label(shadow: bool)

#the price of keeping them separated
signal set_selected_M #window
signal set_res_M(res: int)
signal set_vsync_M(vsync: int)
signal set_pixel_label_M(pixelation: int)
signal set_shadow_label_M(shadow: bool)
#func _ready():
	#get_tree().paused = true

func _ready() -> void:
	SaveLoad.loaded_settings.connect(_on_loaded_settings)

func _on_loaded_settings():
	print("ready to load settings")
	#handling screen and window
	
	match GlobalVars.screen_mode:
		"Full":
			if main_menu:
				emit_signal("set_selected_M", 0)
			else:
				emit_signal("set_selected", 0)
		"Window":
			if main_menu:
				emit_signal("set_selected_M", 1)
			else:
				emit_signal("set_selected", 1)
		"Borderless":
			if main_menu:
				emit_signal("set_selected_M", 2)
			else:
				emit_signal("set_selected", 2)
		_:
			if main_menu:
				emit_signal("set_selected_M", 0)
			else:
				emit_signal("set_selected", 0)

		#screen
	var loaded_size = Vector2i(GlobalVars.window_size_x, GlobalVars.window_size_y)

	match loaded_size:
		Vector2i(1280,720):
			if main_menu:
				emit_signal("set_res_M", 0)
			else:
				emit_signal("set_res", 0)
		Vector2i(1920,1080):
			if main_menu:
				emit_signal("set_res_M", 1)
			else:
				emit_signal("set_res", 1)
		Vector2i(3840,2160):
			if main_menu:
				emit_signal("set_res_M", 2)
			else:
				emit_signal("set_res", 2)
		_:
			if main_menu:
				emit_signal("set_res_M", 1)
			else:
				emit_signal("set_res", 1)

		#vsync
	match GlobalVars.vsync:
		0:
			if main_menu:
				emit_signal("set_vsync_M", 0)
			else:
				emit_signal("set_vsync", 0)
		1:
			if main_menu:
				emit_signal("set_vsync_M", 1)
			else:
				emit_signal("set_vsync", 1)
		2:
			if main_menu:
				emit_signal("set_vsync_M", 2)
			else:
				emit_signal("set_vsync", 2)
		_:
			if main_menu:
				emit_signal("set_vsync_M", 0)
			else:
				emit_signal("set_vsync", 0)

		#labels are the only issue for pixel, shadow, and brightness
	#pixelation
	match GlobalVars.stretch_factor:
		2:
			if main_menu:
				emit_signal("set_pixel_label_M", 0)
			else:
				emit_signal("set_pixel_label", 0)
		4:
			if main_menu:
				emit_signal("set_pixel_label_M", 1)
			else:
				emit_signal("set_pixel_label", 1)
		6:
			if main_menu:
				emit_signal("set_pixel_label_M", 2)
			else:
				emit_signal("set_pixel_label", 2)
		7:
			if main_menu:
				emit_signal("set_pixel_label_M", 3)
			else:
				emit_signal("set_pixel_label", 3)
		8: 
			if main_menu:
				emit_signal("set_pixel_label_M", 4)
			else:
				emit_signal("set_pixel_label", 4)
	
	#shadow
	print(GlobalVars.optional_shadow)
	if main_menu:
		emit_signal("set_shadow_label_M", GlobalVars.optional_shadow)
	else:
		emit_signal("set_shadow_label", GlobalVars.optional_shadow)

func _on_visibility_changed():
	if visible == true:
		if main_menu == true:
			main_menu_screen.visible = true
			pause_menu.visible = false
		else:
			main_menu_screen.visible = false
			pause_menu.visible = true


func _on_exit_pressed():
	SaveLoad.saveSettings(SaveLoad.SAVE_DIR + SaveLoad.SETTINGS_FILE)
	emit_signal("options_exit")
