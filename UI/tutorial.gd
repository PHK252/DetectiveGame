extends CanvasLayer

class_name Tutorial
#@export var tut_type : String
@export var animationplayer : AnimationPlayer
@export var movement_tut : Node
@export var run_tut : Node
@export var interact_tut : Node
@export var exit_tut : Node
@export var phone_tut : Node
@export var flip_tut : Node
@export var dialogue_tut : Node

@onready var timer = $Timer
@onready var current_tut : Node
@onready var current_anim : String

var interact = false

func _ready():
	set_process(false)
	#await get_tree().create_timer(1).timeout
	#_show_tut("flip")

func _show_tut(tut_type : String):
	if current_tut:
		current_tut.visible = false
	if tut_type == "movement":
		current_tut = movement_tut
		current_anim = "Blink Move"
	elif tut_type == "run":
		current_tut = run_tut
		current_anim = "Blink Run"
	elif tut_type == "interact":
		current_tut = interact_tut
		current_anim = "Blink Interact"
	elif tut_type == "exit":
		current_tut = exit_tut
		current_anim = "Blink Exit"
	elif tut_type == "phone":
		current_tut = phone_tut
		current_anim = "Blink Phone"
	elif tut_type == "flip":
		current_tut = flip_tut
		current_anim = "Blink Click"
	elif tut_type == "dialogue":
		current_tut = dialogue_tut
		current_anim = "Blink Pause"
	else:
		print_debug("Tutorial Loading Failed")
		return
	_handle_tut()

func _handle_tut():
	visible = true
	current_tut.visible = true
	animationplayer.play(current_anim)
	timer.start()
	if current_tut == flip_tut:
		await get_tree().create_timer(.1).timeout
	set_process(true)

func _process(delta):
	if timer.time_left > 0:
		if current_tut == flip_tut:
			#print(current_tut.visible)
			await get_tree().create_timer(.1).timeout
			if Input.is_action_just_pressed("mouse_click"):
				GlobalVars.flip_tut = true
				_hide_tut()
			if Input.is_action_just_pressed("Exit"):
				_hide_tut()
				#print(GlobalVars.flip_tut)
		if current_tut == movement_tut:
			if Input.is_action_just_pressed("Up") or Input.is_action_just_pressed("Down") or Input.is_action_just_pressed("Left") or Input.is_action_just_pressed("Right"):
				GlobalVars.movement_tut = true 
				_hide_tut()
		if current_tut == run_tut:
			if Input.is_action_just_pressed("jog"):
				GlobalVars.run_tut = true 
				_hide_tut()
		if current_tut == interact_tut:
			if Input.is_action_just_pressed("interact"):
				GlobalVars.interact_tut = true 
				_hide_tut()
		if current_tut == exit_tut:
			if Input.is_action_just_pressed("Exit"):
				GlobalVars.exit_tut = true 
				_hide_tut()
		if current_tut == phone_tut:
			if Input.is_action_just_pressed("Phone"):
				GlobalVars.phone_tut = true 
				_hide_tut()
		if current_tut == dialogue_tut:
			if Input.is_action_just_pressed("dialogic_default_action"):
				GlobalVars.dialogue_tut = true
				_hide_tut()
	else:
		if current_tut != flip_tut:
			_hide_tut()
	


func _hide_tut():
	visible = false
	current_tut.visible = false
	timer.stop()
	animationplayer.play("RESET")
	set_process(false)
	return



func _on_interactable_body_exited(body):
	_hide_tut()


func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed == true:
			if current_tut == exit_tut:
				_hide_tut()
