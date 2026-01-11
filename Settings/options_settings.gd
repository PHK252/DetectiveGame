extends CanvasLayer

@export var main_menu : bool

@onready var main_menu_screen = $"Main Menu"
@onready var pause_menu = $"Pause Menu"

signal options_exit
#func _ready():
	#get_tree().paused = true

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
