extends CharacterBody3D

@export var speed = 5.0
@export var jump_velocity = 3
@onready var pivot = $CamOrigin
@onready var sens = 0.5
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var _model = $Detective


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func _input(event):
	if event is InputEventMouseMotion:
		pivot.rotate_y(deg_to_rad(-event.relative.x * sens))
		pivot.rotation.x -= deg_to_rad(event.relative.y * sens)
		pivot.rotation.x = clamp(pivot.rotation.x, deg_to_rad(-90), deg_to_rad(45))
		
		_model.rotate_y(deg_to_rad(-event.relative.x * sens))
		#pivot.rotation.y = clamp(pivot.rotation.y, deg_to_rad(-90), deg_to_rad(45))

func _physics_process(delta):
	#Gravity
	if not is_on_floor():
		velocity.y -= gravity * delta
	#Handle Jump
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = jump_velocity
	
	if Input.is_action_just_pressed("Quit"):
		get_tree().quit()
		
	var input_dir = Input.get_vector("Left", "Right", "Forward", "Back")
	var direction = (pivot.transform.basis * Vector3(input_dir.x, 0, input_dir.y)). normalized()
	#if direction:
		#velocity.x = direction.x * speed
		#velocity.z = direction.z * speed
	#else:
		#velocity.x = move_toward(velocity.x, 0, speed)
		#velocity.z = move_toward(velocity.z, 0, speed)
		
	if is_on_floor():
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
			#particles.emitting = true
		else:
			velocity.x = lerp(velocity.x, direction.x * speed, delta *7.0)
			velocity.z = lerp(velocity.z, direction.z * speed, delta *7.0)
			#particles.emitting = false
	else:
		velocity.x = lerp(velocity.x, direction.x * speed, delta *3.0)
		velocity.z = lerp(velocity.z, direction.z * speed, delta *3.0)
	
	move_and_slide()
