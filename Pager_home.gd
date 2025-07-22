extends Control

@export var continue_anim : AnimationPlayer
@export var home : Control
@export var menu : Control

signal menu_default

func _ready():
	continue_anim.play("Flash Continue")



func _on_enter_pressed():
	if home.visible == true:
		home.visible = false
		await get_tree().process_frame
		menu.visible = true
		continue_anim.stop()
		emit_signal("menu_default")
		


func _on_home_default():
	continue_anim.play("Flash Continue")
