extends Node

@export var cameras: Array[Node3D]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func activate_camera(cam_index: int) -> void:
		for i in range(cameras.size()):
			if i == cam_index:
				cameras[i].set_priority(4)  # Highest priority for the active camera
			else:
				cameras[i].set_priority(3 - i)  # Set decreasing priority for other cameras


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
