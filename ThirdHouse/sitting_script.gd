extends Node

@export var theo_sitting: Node3D
@export var anim_player_theo: AnimationPlayer

@export var dalton_bar: Node3D
@export var anim_player_dB: AnimationPlayer

@export var dalton_outside: Node3D
@export var anim_player_dO: AnimationPlayer

@export var theo_outside: Node3D
@export var anim_player_tO: AnimationPlayer

@export var cocktailAnim: Node3D
@export var cocktailStatic: Node3D

signal DaltonInvisible
signal DaltonVisible

func _ready() -> void:
	theo_sitting.visible = false
	theo_outside.visible = false
	dalton_bar.visible = false
	dalton_outside.visible = false
	cocktailAnim.visible = false

func _on_character_body_3d_theo_sit() -> void:
	theo_sitting.visible = true
	anim_player_theo.play("Sit_Bar")

func _on_interactable_interacted(interactor: Interactor) -> void:
	emit_signal("DaltonInvisible")
	dalton_outside.visible = true
	dalton_bar.visible = true
	#anim_player_dO.play("Sit_Outside")
	#anim_player_dB.play("SitandDrinkWine")
	#await get_tree().create_timer(4.0).timeout
	#cocktailStatic.visible = false
	#cocktailAnim.visible = true
	#await get_tree().create_timer(3.0).timeout
	#cocktailStatic.visible = true
	#cocktailAnim.visible = false
	anim_player_dB.play("SitNoDrink")
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Exit"):
		dalton_outside.visible = false
		dalton_bar.visible = false
		emit_signal("DaltonVisible")
		
		

func _on_character_body_3d_theo_stand() -> void:
	theo_sitting.visible = false
	anim_player_theo.stop()
