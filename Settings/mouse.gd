extends Node2D

# need to wrap in boolean logic if controller state activated in 
# input manager + integrate with existing mouse logic
# 
# for this to work rn globalvars mouse stuff needs to be disengaged

const cursor_speed = 1500.0
#const deadzone: float = 0.2
var new_pos 

func _input(event: InputEvent) -> void:
	pass

func _physics_process(delta: float) -> void:
	var move_vec = Input.get_vector("Left", "Right", "Forward", "Back")

	if move_vec != Vector2.ZERO:
		new_pos = get_window().get_mouse_position() + move_vec * cursor_speed * delta
		Input.warp_mouse(new_pos)
	
	if Input.is_action_just_pressed("controller_left_click"):
		var click: InputEventMouseButton = InputEventMouseButton.new()
		click.button_index = MOUSE_BUTTON_LEFT
		click.pressed = true 
		click.position = new_pos
		Input.parse_input_event(click)
		print("clicked")
		
	if Input.is_action_just_released("controller_left_click"):
		var click: InputEventMouseButton = InputEventMouseButton.new()
		click.button_index = MOUSE_BUTTON_LEFT
		click.pressed = false
		click.position = new_pos
		Input.parse_input_event(click)
		print("released")
	
	if Input.is_action_just_pressed("Quit"):
		get_tree().quit()

	
