extends CharacterBody3D

signal set_movement_state(_movement_state: MovementState)
signal set_movement_direction(_movement_direction : Vector3)

@export var movement_states : Dictionary

var movement_direction : Vector3

func _input(event):
	if event.is_action("movement"):
		movement_direction.x = Input.get_action_strength("Left") - Input.get_action_strength("Right")
		movement_direction.x = Input.get_action_strength("Forward") - Input.get_action_strength("Back")

		if is_movement_ongoing():
			if Input.is_action_pressed("movement"):
				set_movement_state.emit(movement_states["walk"])
			else:
				set_movement_state.emit(movement_states["Idle"])
				
		

func _ready():
	set_movement_state.emit(movement_states["Idle"])


func _physics_process(_delta):
	if is_movement_ongoing():
		set_movement_direction.emit(movement_direction)
	

func is_movement_ongoing() -> bool:
		return abs(movement_direction.x) > 0 or abs(movement_direction.z) > 0
