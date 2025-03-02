extends Node

@export var theo_sitting: Node3D
@export var anim_player_theo: AnimationPlayer

func _ready() -> void:
	theo_sitting.visible = false


func _on_character_body_3d_theo_sit() -> void:
	theo_sitting.visible = true
	anim_player_theo.play("Sit_Bar")
