extends Node2D

@export var anim : AnimationPlayer
@export var restart: AnimationPlayer
@export var phone_pause : CanvasLayer

@onready var anim_frames = $AnimFrames
@onready var text = $Text
@onready var quincy_detection_restart = $QuincyDetectionRestart
@onready var quincy_caught = $"."

@onready var anim_finished = false

func _ready():
	quincy_caught.hide()


func _on_dalton_caught_play_anim():
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
			#restart level
			print("restarting...")
			pass
