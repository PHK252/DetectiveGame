extends CanvasLayer

@export var main_scene : Node
@onready var resume = $VBoxContainer/Resume
@onready var controls = $Controls
@onready var prev_mouse_mode : int
@onready var pause_buttons = $VBoxContainer
@onready var options = $Options_Settings
var quit = InputMap.action_get_events("Quit")
@onready var resume_short = Shortcut.new()
@onready var key_event = InputEventKey.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_save_pressed():
	AudioServer.set_bus_mute(0, true)
	resume.shortcut = null
	await get_tree().process_frame
	InputMap.action_add_event("Quit", quit[0])
	visible = false
	Loading.load_scene(main_scene, GlobalVars.main_menu, "", "", "")
	get_tree().paused = false
	Engine.time_scale = 1
	await get_tree().create_timer(0.51).timeout
	


func _on_resume_pressed():
	print("resume_pressed")
	resume.shortcut = null
	visible = false
	GlobalVars.unpaused.emit()
	Input.set_mouse_mode(prev_mouse_mode)
	await get_tree().process_frame
	await get_tree().process_frame
	InputMap.action_add_event("Quit", quit[0])
	get_tree().paused = false
	Engine.time_scale = 1
	

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

func _input(event):
	if event.is_action_pressed("Quit"):
		if visible == false:
			visible = true

func _on_options_pressed():
	pause_buttons.visible = false
	options.visible = true


func _on_controls_pressed():
	pause_buttons.visible = false
	controls.visible = true

func _on_controls_show_pause():
	pause_buttons.visible = true

func _on_visibility_changed():
	if visible == true:
		print("pause visible")
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			prev_mouse_mode = 2
		elif Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			prev_mouse_mode = 0
		get_tree().paused = true

		await get_tree().process_frame
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		InputMap.action_erase_events("Quit")
		await get_tree().process_frame
		key_event.keycode = KEY_ESCAPE
		resume_short.events = [key_event]
		resume.shortcut = resume_short
		Engine.time_scale = 0
		
func _process(delta):
	if GlobalVars.in_dialogue == true:
		$VBoxContainer/Save.disabled = true
		$VBoxContainer/Save.mouse_default_cursor_shape = Control.CURSOR_ARROW
	else:
		$VBoxContainer/Save.disabled = false
		$VBoxContainer/Save.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
func _on_options_exit():
	pause_buttons.visible = true
	options.visible = false
