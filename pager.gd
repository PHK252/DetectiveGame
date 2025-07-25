extends CanvasLayer

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
var disabled = false

func _ready():
	hide()
	await get_tree().create_timer(2).timeout
	show()
	home.visible = false
	menu.visible = false
	messages.visible = false
	contact.visible = false
	error.visible = false
	bottom.visible = false
	
	intro.show()
	intro_anim.play("Intro")
	await intro_anim.animation_finished
	intro.hide()
	home.visible = true
	bottom.visible = true
	battery_anim.play("Flashing Battery")



func _on_visibility_changed():
	if visible == true:
		print("disable")
		InputMap.action_erase_events("ui_up")
		InputMap.action_erase_events("ui_down")
		disabled = true
	else:
		if disabled == true:
			print("enable")
			InputMap.action_add_event("ui_up", up)
			InputMap.action_add_event("ui_down", down)
