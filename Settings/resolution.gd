extends Control

var base_window_size := Vector2(
		ProjectSettings.get_setting("display/window/size/viewport_width"),
		ProjectSettings.get_setting("display/window/size/viewport_height")
)
@export var menu : Control
@export var cl : Panel
@export var op_button : OptionButton
var full := false
var windowed := false 
var open := false

@export var screen_transition_fade : AnimationPlayer

func _ready() -> void:
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
	cl.scale = Vector2(ratio, ratio)

	# Optional: if your CanvasLayer root needs pivot adjustment
	cl.pivot_offset = cl.size / 2   # CanvasLayer doesn’t have pivot, but its children do

#func _on_option_button_item_selected(index: int) -> void:
	#op_button.release_focus()
	#match index:
		#0:
			#base_window_size = Vector2i(384,216)
		#1:
			#base_window_size = Vector2(768,432)
		#2:
			#base_window_size = Vector2i(1152,648)
		#3:
			#base_window_size = Vector2i(1280,720)
		#4:
			#base_window_size = Vector2i(1512,982)
		#5:
			#base_window_size = Vector2i(1920,1080)
			#
	##DisplayServer.window_set_size(base_window_size)
	#if windowed:
		#get_window().set_size(base_window_size)
		#get_viewport().content_scale_size = base_window_size
	#elif full:
		#get_viewport().content_scale_size = base_window_size
	#
	#center_window()

func center_window():
	var center = DisplayServer.screen_get_position() + DisplayServer.screen_get_size() / 2
	var window_size = get_window().get_size_with_decorations()
	get_window().set_position(center - window_size / 2)

func _on_screen_full_screen() -> void:
	full = true
	windowed = false
	center_window()
	await get_tree().create_timer(.5).timeout
	screen_transition_fade.play("fade_in")
	#get_window().set_size(Vector2i(1920,1080)) think this was an issue

func _on_screen_windowed() -> void:
	windowed = true
	full = false
	center_window()
	screen_transition_fade.play("fade_in_out")

func _on_reset_graphics_pressed() -> void:
	pass
	#screen already handled
	#get_window().set_size(Vector2i(1920,1080))
	#get_viewport().content_scale_size = Vector2i(1920,1080)
	#center_window()
	#full = true
	#windowed = false
	#op_button.selected = 5


func _on_menu_on_select_option(index):
	match index:
		0:
			base_window_size = Vector2i(384,216)
		1:
			base_window_size = Vector2(768,432)
		2:
			base_window_size = Vector2i(1152,648)
		3:
			base_window_size = Vector2i(1280,720)
		4:
			base_window_size = Vector2i(1512,982)
		5:
			base_window_size = Vector2i(1920,1080)
			
	#DisplayServer.window_set_size(base_window_size)
	if windowed:
		get_window().set_size(base_window_size)
		get_viewport().content_scale_size = base_window_size
	elif full:
		get_viewport().content_scale_size = base_window_size
	
	center_window()
	print(base_window_size)


func _on_other_menu_clicked(event):
	print(menu.open)
	if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		print(menu.open)
		if menu.open == true:
			print(menu.open)
			menu._close_menu()
