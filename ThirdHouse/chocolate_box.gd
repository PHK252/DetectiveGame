extends Node3D

@export var anim_player: AnimationPlayer
var is_open = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	anim_player.play("ChocolateDefault")

func _on_interactable_interacted(interactor: Interactor) -> void:
	if is_open == false:
		is_open = true
		anim_player.play("ChocolateOpen")
		return
		
	if is_open == true:
		is_open = false
		anim_player.play("ChocolateClosed")
		return
		
