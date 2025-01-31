extends Node

@export var cameras: Array[Node3D]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func activate_camera(cam_index: int) -> void:
		for i in range(cameras.size()):
			if i == cam_index:
				cameras[i].set_priority(12)  # Highest priority for the active camera
			else:
				cameras[i].set_priority(11 - i)  # Set decreasing priority for other cameras


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
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


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
		activate_camera(9)  # Fourth camera


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
