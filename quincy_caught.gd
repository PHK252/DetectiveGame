extends Node2D

@export var main : Node3D
@export var anim : AnimationPlayer
@export var restart: AnimationPlayer
@export var phone_pause : CanvasLayer

@onready var anim_frames = $AnimFrames
@onready var text = $Text
@onready var quincy_detection_restart = $QuincyDetectionRestart
@onready var quincy_caught = $"."

@onready var anim_finished = false

var pause = InputMap.action_get_events("Quit")
func _ready():
	quincy_caught.hide()


func _on_dalton_caught_play_anim():
	InputMap.action_erase_events("Quit")
	phone_pause.hide()
	quincy_caught.show()
	#pause process
	quincy_detection_restart.hide()
	anim.play("Caught_Anim")
	await  anim.animation_finished
	text.hide()
	anim_frames.hide()
	quincy_detection_restart.show()
	restart.play("Restart")
	anim_finished = true

func _input(event):
	if anim_finished == true:
		if event is InputEventKey and event.is_pressed():
			anim_finished = false
			GlobalVars._dalton_caught_clear_state()
			print("restarting...")
			Loading.load_scene(main, GlobalVars.third_house_path, "","","", true, true)
			pass


func _on_visibility_changed():
	if visible == false:
		InputMap.action_add_event("Quit", pause[0])
