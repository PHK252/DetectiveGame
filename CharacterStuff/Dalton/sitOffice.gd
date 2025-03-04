extends Node3D

@export var armature: Node3D
@export var anim_player: AnimationPlayer

signal DaltonInvisible
signal DaltonVisible

func _ready() -> void:
	armature.visible = false
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Exit"):
		armature.visible = false
		emit_signal("DaltonVisible")

func _on_interactable_interacted(interactor: Interactor) -> void:
	emit_signal("DaltonInvisible")
	armature.visible = true
	anim_player.play("Sit_Office")
	
