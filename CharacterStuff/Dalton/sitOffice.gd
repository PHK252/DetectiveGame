extends Node3D

@export var armature: Node3D
@export var anim_player: AnimationPlayer
@export var alert : Sprite3D
var is_sitting = false

signal DaltonInvisible
signal DaltonVisible

var just_interacted = false

func _ready() -> void:
	armature.visible = false
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Exit") and is_sitting:
		just_interacted = false
		armature.visible = false
		emit_signal("DaltonVisible")
		is_sitting = false
		alert.show()

func _on_interactable_interacted(interactor: Interactor) -> void:
	if just_interacted == false:
		just_interacted = true
		is_sitting = true
		alert.hide()
		emit_signal("DaltonInvisible")
		armature.visible = true
		anim_player.play("Sit_Office")
	
