extends CanvasLayer

@export var view_container : SubViewportContainer
@export var intro : CanvasLayer
@export var intro_anim : AnimationPlayer
@export var bottom : Control
@export var battery_anim : AnimationPlayer

@export var home : Control
@export var menu : Control
@export var messages : Control
@export var contact : Control
@export var error : Control

var up = InputMap.action_get_events("ui_up")
var down = InputMap.action_get_events("ui_down")
var exit = InputMap.action_get_events("Exit")
var disabled = false

func _ready():
	#hide()
	#await get_tree().create_timer(1).timeout
	#show()
	home.visible = false
	menu.visible = false
	messages.visible = false
	contact.visible = false
	error.visible = false
	bottom.visible = false
	
func _on_visibility_changed():
	if visible == true:
		print("disable")
		view_container.process_mode = Node.PROCESS_MODE_INHERIT
		InputMap.action_erase_events("ui_up")
		InputMap.action_erase_events("ui_down")
		InputMap.action_erase_events("Exit")
		disabled = true
		#start animation
		intro.show()
		intro_anim.play("Intro")
		await intro_anim.animation_finished
		intro.hide()
		home.visible = true
		bottom.visible = true
		battery_anim.play("Flashing Battery")
	else:
		if disabled == true:
			view_container.process_mode = Node.PROCESS_MODE_DISABLED
			print("enable")
			InputMap.action_add_event("ui_up", up[0])
			InputMap.action_add_event("ui_down", down[0])
			InputMap.action_add_event("Exit", exit[0])


func _on_exit_pressed():
	visible = false
	GlobalVars.viewing = ""
	GlobalVars.in_look_screen = false
	home.visible = false
	menu.visible = false
	messages.visible = false
	contact.visible = false
	error.visible = false
	bottom.visible = false
	intro.visible = false
	intro_anim.stop()

#func _input(event):
	#if event is InputEventKey and event.is_pressed():
		#if event.keycode == KEY_P:
			#show()
		#if event.keycode == KEY_CAPSLOCK:
			#hide()
