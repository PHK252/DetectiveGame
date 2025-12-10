extends CanvasLayer

signal show_start
signal show_pause

@export var main_menu : bool 
@export var pause : bool 
@export var cl_main : Panel
@export var cl_pause : Panel
@export var main_menu_screen : CanvasLayer
@export var pause_menu_screen : CanvasLayer

func _ready():
	get_viewport().size_changed.connect(_on_new_window_size)
	_on_new_window_size()

func _on_new_window_size():
	var viewport_size = get_viewport().get_visible_rect().size
	
	# Pick the smaller ratio so the UI never stretches unevenly
	var ratio = min(
		viewport_size.x / ProjectSettings.get_setting("display/window/size/viewport_width"),
		viewport_size.y / ProjectSettings.get_setting("display/window/size/viewport_height")
	)
	
	# Scale the whole CanvasLayer (so all children Controls scale uniformly)
	cl_main.scale = Vector2(ratio, ratio)
	cl_pause.scale = Vector2(ratio, ratio)

	# Optional: if your CanvasLayer root needs pivot adjustment
	cl_main.pivot_offset = cl_main.size / 2   # CanvasLayer doesn’t have pivot, but its children do
	
func _on_exit_button_pressed():
	#visible = false
	pause_menu_screen.visible = false
	emit_signal("show_pause")

func _on_main_exit_button_pressed():
	#visible = false
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
