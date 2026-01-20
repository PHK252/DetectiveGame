extends Node

@export var cameras: Array[Node3D]
signal camera_changed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#pass
	if GlobalVars.in_level:
		activate_camera(GlobalVars.cam_index)

func activate_camera(cam_index: int) -> void:
		GlobalVars.cam_index = cam_index #will update last index whenever func activates
		emit_signal("camera_changed")
		for i in range(cameras.size()):
			if i == cam_index:
				cameras[i].set_priority(23)  # Highest priority for the active camera
			else:
				cameras[i].set_priority(22 - i)  # Set decreasing priority for other cameras

func _on_hall_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		activate_camera(0)  # First camera

func _on_main_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		activate_camera(1)  # Second camera

func _on_poster_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		activate_camera(2)  # Third camera

func _on_window_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		activate_camera(3)  # Fourth camera

func _on_kitchen_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		activate_camera(4)  # Fifth camera
	


func _on_door_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		activate_camera(0)  # First camera


func _on_book_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		activate_camera(1)  # Second camera


func _on_wurli_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		activate_camera(2)  # Third camera


func _on_door_a_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		activate_camera(0)  # First camera


func _on_living_a_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		activate_camera(1)  # Second camera


func _on_fam_paint_a_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		activate_camera(2)  # Third camera


func _on_outside_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		activate_camera(3)  # Fourth camera


func _on_upstairs_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		activate_camera(4)  # Fourth camera


func _on_u_1a_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		activate_camera(5)  # Fourth camera


func _on_u_2a_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		activate_camera(6)  # Fourth camera


func _on_secret_hall_a_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		activate_camera(7)  # Fourth camera


func _on_secret_a_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		activate_camera(8)  # Fourth camera


func _on_office_a_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		activate_camera(13)  # Fourth camera


func _on_downstairs_a_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		activate_camera(10)  # Fourth camera


func _on_outside_sc_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		activate_camera(0)  # First camera


func _on_inside_sc_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		activate_camera(1)  # First camera


func _on_doorcamarea_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		activate_camera(5)  # First camera


func _on_exitcamarea_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		activate_camera(6)  # First camera


func _on_forest_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		activate_camera(4)


func _on_open_door_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		activate_camera(5)


func _on_waterfall_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		activate_camera(6)


func _on_kitchen_area_jun_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		activate_camera(7)


func _on_outside_snow_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		activate_camera(11)


func _on_living_b_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		activate_camera(18)


func _on_office_area_q_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		activate_camera(9)


func _on_bathroom_q_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		activate_camera(14)


func _on_main_master_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		activate_camera(15)


func _on_master_closet_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		activate_camera(16)


func _on_master_notebook_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		activate_camera(17)


func _on_ski_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		activate_camera(12)


func _on_patio_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		activate_camera(19)


func _on_kitchen_door_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		activate_camera(8)


func _on_wine_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		pass
		#activate_camera(20)


func _on_interactable_interacted(interactor: Interactor) -> void:
		activate_camera(9)


func _on_leaves_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		activate_camera(10)


func _on_porch_juniper_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		activate_camera(11)


func _on_door_second_cam_greeting() -> void:
	activate_camera(12)


func _on_water_close_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		activate_camera(13)


func _on_water_close_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		activate_camera(6)

func _on_hall_close_cam_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		activate_camera(21)

func _on_area_01_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		activate_camera(0)


func _on_area_02_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		activate_camera(1)

func _on_character_body_3d_activate_hall() -> void:
	activate_camera(1)

func _on_character_body_3d_cam_bed() -> void:
	activate_camera(2)

func _on_quincy_interact_greet_cam() -> void:
	activate_camera(22)

func _on_quincy_interact_finish_greeting() -> void:
	activate_camera(23)


func _on_door_door_open() -> void:
	activate_camera(7)

func _on_door_greeting() -> void:
	activate_camera(8)


func _on_sitting_ppl_dalton_faint() -> void:
	activate_camera(20)


func _on_main_area_flashback_01(body: Node3D) -> void:
	activate_camera(0)
