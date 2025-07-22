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

func _ready():
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
