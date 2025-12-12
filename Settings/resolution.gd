extends Control

var base_window_size := Vector2(
		ProjectSettings.get_setting("display/window/size/viewport_width"),
		ProjectSettings.get_setting("display/window/size/viewport_height")
)
@export var dropdown: TextureButton
@export var dropdown_label : RichTextLabel 
@export var window_mode : Control
@export var cl : Panel
@export var op_button : OptionButton
var full := false
var windowed := false 
var open := false
var native_monitor_size : Vector2
var force_window_size : Vector2
@export var screen_transition_fade : AnimationPlayer

func _ready() -> void:
	get_viewport().size_changed.connect(_on_new_window_size)
	_on_new_window_size()
	if window_mode.selected == 0:
		dropdown.disabled = true
		dropdown_label.add_theme_color_override("default_color", Color(0.992, 0.835, 0.478))
		return
	await get_tree().process_frame


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
	native_monitor_size = DisplayServer.screen_get_size()
	if native_monitor_size.x >= 1280 and native_monitor_size.x < 1920:
		force_window_size = Vector2i(1280,720)
	elif native_monitor_size.x >= 1920 and native_monitor_size.x < 3840:
		force_window_size = Vector2i(1920,1080)
	else:
		force_window_size = Vector2i(3840,2160)

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
	print("full")
	full = true
	windowed = false
	center_window()
	await get_tree().create_timer(.5).timeout
	screen_transition_fade.play("fade_in")
	dropdown.disabled = true
	dropdown_label.add_theme_color_override("default_color", Color(0.992, 0.835, 0.478))
	#get_window().set_size(Vector2i(1920,1080)) think this was an issue

func _on_screen_windowed() -> void:
	windowed = true
	full = false
	center_window()
	screen_transition_fade.play("fade_in_out")
	if dropdown.disabled:
		dropdown.disabled = false
		dropdown_label.add_theme_color_override("default_color", Color(0.898, 0.678, 0.18))

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
			base_window_size = Vector2i(1280,720)
		1:
			base_window_size = Vector2i(1920,1080)
		2:
			base_window_size = Vector2i(3840,2160)
			
	#DisplayServer.window_set_size(base_window_size)
	if windowed:
		if native_monitor_size < base_window_size:
			#get_viewport().content_scale_size = native_monitor_size
			get_window().set_size(force_window_size)
		else:
			get_window().set_size(base_window_size)
			#get_viewport().content_scale_size = base_window_size
	#I don't know how full screen will work on 4k monitors, disabling res change for now
	#elif full:
		#get_viewport().content_scale_size = base_window_size
	
	center_window()
