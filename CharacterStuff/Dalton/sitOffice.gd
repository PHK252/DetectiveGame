extends Node3D

@export var armature: Node3D
@export var anim_player: AnimationPlayer
var is_sitting = false

signal DaltonInvisible
signal DaltonVisible

func _ready() -> void:
	armature.visible = false
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Exit") and is_sitting:
		armature.visible = false
		emit_signal("DaltonVisible")
		is_sitting = false

func _on_interactable_interacted(interactor: Interactor) -> void:
	is_sitting = true
	emit_signal("DaltonInvisible")
	armature.visible = true
	anim_player.play("Sit_Office")
	
