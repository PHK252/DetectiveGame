extends Node3D

@export var anim_tree = AnimationTree
@export var spill = Node3D
signal distraction

func _ready() -> void:
	spill.visible = false
	

func _on_interactable_interacted(interactor: Interactor) -> void:
	emit_signal("distraction")
	print("trying to make bottle fall")
	anim_tree["parameters/conditions/wine_fall"] = true
	await get_tree().create_timer(1).timeout
	spill.visible = true
	#anim_player.play("BottleBreak")
	#anim_player_2.play("BottleBreak_001")
	#anim_player_3.play("BottleBreak_002")
	#await get_tree().create_timer(2).timeout
	#anim_player.play("wineappears")
	
