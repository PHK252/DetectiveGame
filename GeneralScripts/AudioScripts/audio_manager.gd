extends Node

@export var level : String
@export var audio : Array[AudioStreamPlayer3D]
@export var audio_master : Array[AudioStreamPlayer]

func _on_doughnut_001_time_to_eat() -> void:
	audio[3].play()
	await get_tree().create_timer(2.0).timeout
	audio[9].play()
	await get_tree().create_timer(1.0).timeout
	audio[2].play()

func _on_detective_anims_dalton_invisible() -> void:
	audio[0].play()

func _on_detective_anims_dalton_visible() -> void:
	audio[1].play()

func _on_forward_pressed() -> void:
	audio_master[0]["parameters/switch_to_clip"] = "Paper 7"
	audio_master[0].play() 

func _on_back_pressed() -> void:
	audio_master[0]["parameters/switch_to_clip"] = "Paper 8"
	audio_master[0].play() 

func _on_interactable_interacted(interactor: Interactor) -> void:
	audio_master[0]["parameters/switch_to_clip"] = "Paper 3"
	audio_master[0].play() 

func _on_paper_sound() -> void:
	audio_master[0]["parameters/switch_to_clip"] = "Paper 11"
	audio_master[0].play() 

func _on_general_interacted(interactor: Interactor) -> void:
	audio[3].play()
	
func _on_team_pic_mouse_entered() -> void:
	audio[4].play()
	
func exit_hiss_mouse_entered() -> void:
	audio[6].play()

func _on_exit_pressed() -> void:
	audio[5].play()

func _on_arrow_pressed() -> void:
	audio[7].play()

func _on_back_arrow_pressed() -> void:
	audio[8].play()


func _on_plastic_crunch_body_entered(body: Node3D) -> void:
	audio[0].play()


func _on_exit_mouse_entered() -> void:
	audio[2].play()


func _on_up_mouse_entered() -> void:
	audio[6].play()

func _on_down_mouse_entered() -> void:
	audio[7].play()


func _on_closet_general_interact() -> void:
	#for all micah
	audio[3].play()


func _on_cafe_interact_general_interact() -> void:
	#for all juniper
	audio[3].play()


func _on_cafe_interact_general_quit() -> void:
	audio_master[0].play()

func _on_recipe_paper_sound() -> void:
	audio_master[1].play()

func _on_back_mouse_entered_Juniper() -> void:
	audio[4].play()

func _on_back_pressed_juniper() -> void:
	audio[0].play()

func _on_forward_pressed_juniper() -> void:
	audio[1].play()

func _on_caseButtonJuniper_pressed() -> void:
	audio_master[0].play()

func _on_x_pressed() -> void:
	audio[8].play()

func _on_enter_pressed() -> void:
	pass # Replace with function body.

func _on_caseHoverJuniper_entered() -> void:
	audio_master[2].play()


func _on_case_ui_locked_sound() -> void:
	audio_master[3].play()


func _on_case_ui_unlocked_sound() -> void:
	audio_master[4].play()
	await get_tree().create_timer(0.2).timeout
	audio[7].play()

func _on_case_picking_up() -> void:
	audio[6].play()

func _on_character_body_3d_knocking() -> void:
	await get_tree().create_timer(2).timeout
	audio[13].play()

func _on_door_general_interact() -> void:
	print("trytoPlay")
	audio[3].play()

func _on_interact_general_quit() -> void:
	audio_master[1].play()

func _on_closet_general_quit() -> void:
	audio_master[1].play()

func _on_window_general_quit() -> void:
	audio_master[1].play()

func _on_bookshelf_interact_general_quit() -> void:
	audio_master[1].play()

func _on_cab_interact_general_quit() -> void:
	audio_master[1].play()

func _on_character_body_3d_knocking_juniper() -> void:
	audio[9].play()
