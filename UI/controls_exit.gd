extends CanvasLayer

signal show_start
signal show_pause

@export var main_menu : bool 
@export var pause : bool 

@onready var main_menu_screen = $"Main Menu"
@onready var pause_menu_screen = $"Pause _menu"


func _on_exit_button_pressed():
	visible = false
	pause_menu_screen.visible = false
	emit_signal("show_pause")

func _on_main_exit_button_pressed():
	visible = false
	main_menu_screen.visible = false
	emit_signal("show_start")


func _on_visibility_changed():
	print(pause)
	await get_tree().process_frame
	if visible == true:
		if main_menu == true:
			main_menu_screen.visible = true
			pause_menu_screen.visible = false
			return
		if pause == true:
			#print("enter")
			main_menu_screen.visible = false
			pause_menu_screen.visible = true
			return
		print_debug("Select option plz")
