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
signal DaltonFaint



var out_sit = false

@export var patio_sit : AudioStreamPlayer3D
@export var patio_getup : AudioStreamPlayer3D

@export var stool_sit : AudioStreamPlayer3D
@export var stool_getup: AudioStreamPlayer3D

signal theo_armature_visible

func _ready() -> void:
	theo_sitting.visible = false
	theo_outside.visible = false
	dalton_bar.visible = false
	dalton_outside.visible = false
	cocktailAnim.visible = false
	cocktailStatic.visible = false

func _on_character_body_3d_theo_sit() -> void:
	if dalton_bar.visible == true or dalton_outside.visible == true:
		theo_sitting.visible = true
		anim_player_theo.play("Sit_Bar")
		theo_outside.visible = true
		anim_player_tO.play("SitOutside_001")
	else:
		#print("enteringalternatestate")
		emit_signal("theo_armature_visible")
		

func _on_interactable_interacted(interactor: Interactor) -> void:
	alert.hide()
	if dalton_bar.visible == false:
		if out_sit:
			print("signaling")
			emit_signal("theo_out")
			patio_sit.play()
		else:
			stool_sit.play()
	
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
	anim_player_dO.play("Sit_Outside")
	
func _process(delta: float) -> void:
	var bar_convo = Dialogic.VAR.get_variable("Quincy.in_bar_convo")
	if Input.is_action_just_pressed("Exit") and GlobalVars.in_dialogue == false and bar_convo == true:
		pass
		##emit_signal("DaltonVisible")
	elif Input.is_action_just_pressed("Exit") and GlobalVars.in_dialogue == false:
		if out_sit:
			patio_getup.play()
		elif bar_convo:
			stool_getup.play()
		elif dalton_bar.visible == true:
			stool_getup.play()
		dalton_outside.visible = false
		dalton_bar.visible = false
		alert.show()
		emit_signal("DaltonVisible")
		if theo_outside.visible == true:
			patio_getup.play()
			theo_sitting.visible = false
			theo_outside.visible = false
			anim_player_theo.stop()
			anim_player_tO.stop()
			
		
		

func _on_character_body_3d_theo_stand() -> void:
	patio_getup.play()
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

func _on_cutscene_cams_after_faint() -> void:
	dalton_outside.visible = false
	dalton_bar.visible = false
	alert.hide()
	emit_signal("DaltonFaint")


func _on_handle_sitting_while_timeout() -> void:
	dalton_outside.visible = false
