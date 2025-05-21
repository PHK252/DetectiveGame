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

@export var alert : Sprite3D
signal DaltonInvisible
signal DaltonVisible
signal theo_out

var out_sit = false

func _ready() -> void:
	theo_sitting.visible = false
	theo_outside.visible = false
	dalton_bar.visible = false
	dalton_outside.visible = false
	cocktailAnim.visible = false

func _on_character_body_3d_theo_sit() -> void:
	theo_sitting.visible = true
	anim_player_theo.play("Sit_Bar")
	theo_outside.visible = true
	anim_player_tO.play("SitOutside_001")

func _on_interactable_interacted(interactor: Interactor) -> void:
	alert.hide()
	emit_signal("DaltonInvisible")
	dalton_outside.visible = true
	dalton_bar.visible = true
	
	if out_sit:
		print("signaling")
		emit_signal("theo_out")
	
	#anim_player_dO.play("Sit_Outside")
	#anim_player_dB.play("SitandDrinkWine")
	#await get_tree().create_timer(4.0).timeout
	#cocktailStatic.visible = false
	#cocktailAnim.visible = true
	#await get_tree().create_timer(3.0).timeout
	#cocktailStatic.visible = true
	#cocktailAnim.visible = false
	anim_player_dB.play("SitNoDrink")
	anim_player_dO.play("Sit_Outside")
	
func _process(delta: float) -> void:
	var bar_convo = Dialogic.VAR.get_variable("Quincy.in_bar_convo")
	if Input.is_action_just_pressed("Exit") and GlobalVars.in_dialogue == false and bar_convo == true:
		dalton_outside.visible = false
		dalton_bar.visible = false
		alert.show()
		emit_signal("DaltonVisible")
		
		

func _on_character_body_3d_theo_stand() -> void:
	theo_sitting.visible = false
	theo_outside.visible = false
	anim_player_theo.stop()
	anim_player_tO.stop()

func _on_theo_out_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		out_sit = true

func _on_theo_out_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		out_sit = false
