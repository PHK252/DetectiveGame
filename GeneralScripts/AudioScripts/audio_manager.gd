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

func _on_menuHover() -> void:
	audio_master[3].play()

func _on_menuClick() -> void:
	audio_master[2].play()

func _on_start_click() -> void:
	audio_master[1].play()

func _on_menu_exit() -> void:
	audio_master[0].play()

func _on_hover_exit() -> void:
	audio_master[4].play()

func _on_map_select_level_sound() -> void:
	audio_master[2].play()

func _on_secret_focus_entered() -> void:
	var secret_coor = Dialogic.VAR.get_variable("Quincy.has_secret_coor")
	if secret_coor == true and GlobalVars.day == 3:
		audio[4].play()


func _on_non_interact_general_interaction() -> void:
	audio[3].play()


func _on_home_pressed() -> void:
	audio_master[0].play()

func _on_phone_select() -> void:
	audio_master[4].play()

func _on_phone_hover() -> void:
	audio_master[1].play()

func _on_altClick_phone() -> void:
	audio_master[11].play()

func _on_alt_hover_phone() -> void:
	audio_master[12].play()

func _on_phone_hiss() -> void:
	audio_master[10].play()

func _on_arrow_click() -> void:
	audio_master[13].play()

func _on_back_pressed_phone() -> void:
	audio_master[14].play()

func _on_num_01_pressed() -> void:
	audio_master[7].play()

func _on_num_two_pressed() -> void:
	audio_master[8].play()

func _on_num_three_pressed() -> void:
	audio_master[9].play()


func _on_accept_pressed() -> void:
	audio_master[4].play()


func _on_decline_pressed() -> void:
	audio_master[5].play()

func _on_phone_buzz() -> void:
	audio_master[15].play()

func _on_stop_buzz() -> void:
	audio_master[15].stop()


func _on_delete_pressed() -> void:
	audio_master[16].play()


func _on_view_sound() -> void:
	audio_master[18].play()


func _on_flip_sound() -> void:
	audio_master[17].play()

func _on_map_leave_second() -> void:
	audio[5].play()

func _on_map_select_second() -> void:
	audio_master[5].play()

func _on_exit_hover_second() -> void:
	audio[2].play()

func _on_map_hover_second() -> void:
	audio[4].play()
