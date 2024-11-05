extends Node

@export var cam1: Node3D
@export var cam2: Node3D
@export var cam3: Node3D
@export var cam4: Node3D
@export var cam5: Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func cam1_on():
	cam1.set_priority(4)
	cam2.set_priority(3)
	cam3.set_priority(2)
	cam4.set_priority(1)
	cam5.set_priority(0)
	
func cam2_on():
	cam1.set_priority(3)
	cam2.set_priority(4)
	cam3.set_priority(2)
	cam4.set_priority(1)
	cam5.set_priority(0)
	
func cam3_on():
	cam1.set_priority(3)
	cam2.set_priority(2)
	cam3.set_priority(4)
	cam4.set_priority(1)
	cam5.set_priority(0)
	
func cam4_on():
	cam1.set_priority(3)
	cam2.set_priority(2)
	cam3.set_priority(1)
	cam4.set_priority(4)
	cam5.set_priority(0)
	
func cam5_on():
	cam1.set_priority(3)
	cam2.set_priority(2)
	cam3.set_priority(1)
	cam4.set_priority(0)
	cam5.set_priority(4)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_hall_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		cam1_on()


func _on_main_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		cam2_on()


func _on_poster_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		cam3_on()


func _on_window_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		cam4_on()


func _on_kitchen_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		cam5_on()
