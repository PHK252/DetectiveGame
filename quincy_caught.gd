extends Node2D

@export var anim : AnimationPlayer
@export var restart: AnimationPlayer

@onready var anim_frames = $AnimFrames
@onready var text = $Text
@onready var quincy_detection_restart = $QuincyDetectionRestart


func _ready():
	quincy_detection_restart.hide()
	anim.play("Caught_Anim")
	await  anim.animation_finished
	text.hide()
	anim_frames.hide()
	quincy_detection_restart.show()
	restart.play("Restart")
