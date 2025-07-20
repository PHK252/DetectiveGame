extends CanvasLayer

@onready var pass_enter = $Label
@onready var input_array = ["", "a", "A", "b", "B", "c", "C", "d", "D", "e", "E", "f", "F", "g", "G", "h", "H", "i", "I", 
"j", "J", "k", "K", "l", "L", "m", "M", "n", "N", "o", "O", "p", "P", "q", "Q", "r", "R", "s", "S", "t", "T", "u", "U", 
"v", "V", "w", "W", "x", "X", "y", "Y", "z", "Z", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]
@onready var password = "REVER"

@onready var input = ""
@onready var array_pos = 0
@onready var incorrect_times = 3

@onready var is_open: bool = false
@export var animation_tree : AnimationTree
@onready var safe_anim = false
@export var open_interact : Area2D
@export var close_interact : Area2D

@onready var blinker = $blinker
@onready var blinker_x_pos_intial = 506
@onready var blinker_x_pos = blinker_x_pos_intial
@onready var blinker_anim = $AnimationPlayer
@onready var position = 0

@export var interior_interact_area_1 : Area2D
@export var interior_interact_area_2 : Area2D
@export var interior_interact_area_3 : Area2D
@export var interior_interact_area_4 : Area2D

signal alarm

@export var safe_click : AudioStreamPlayer3D
@export var safe_open : AudioStreamPlayer3D
@export var safe_close : AudioStreamPlayer3D
@export var safe_error : AudioStreamPlayer3D

func _ready():
	pass_enter.text = ""
	blinker_anim.play("Blink")

func _on_down_pressed():
	if array_pos == 0:
		array_pos = len(input_array) - 1
		pass_enter.text = input + input_array[array_pos]
	else:
		array_pos -= 1
		pass_enter.text = input + input_array[array_pos]


func _on_up_pressed():
	if array_pos == len(input_array) - 1:
		array_pos = 0
		pass_enter.text = input + input_array[array_pos]
	else:
		array_pos += 1
		pass_enter.text = input + input_array[array_pos]
		

func _on_next_pressed():
	input = input + input_array[array_pos]
	if len(input) == position + 1:
		position += 1
		position_blinker_forward(position - 1)
	array_pos = 0
	print(input)

func _on_backspace_pressed():
	if len(input) > 0:
		position_blinker_backwards(position-1)
		pass_enter.text = pass_enter.text.erase(len(pass_enter.text)-1, 1)
		input = pass_enter.text
		position -= 1
		print(position)
		array_pos = 0

func position_blinker_forward(pos : int):
	var offset = pass_enter.get_character_bounds(pos)
	blinker_x_pos = offset.size.x + blinker_x_pos
	blinker.position.x = blinker_x_pos


func position_blinker_backwards(pos : int):
	var offset = pass_enter.get_character_bounds(pos)
	blinker_x_pos =  blinker_x_pos - offset.size.x
	blinker.position.x = blinker_x_pos

func _on_enter_pressed():
	blinker_anim.play("RESET")
	blinker.position.x = blinker_x_pos_intial
	input = input + input_array[array_pos]
	if password == input:
		$".".hide()
		GlobalVars.in_look_screen = false
		GlobalVars.Quincy_Safe_UI = false
		#print("correct")
		pass_enter.text = "Opening..."
		await get_tree().create_timer(1.5).timeout
		open()
		array_pos = 0
		input = ""
		pass_enter.text = input
		
	elif incorrect_times > 0:
		#print("wrong")
		safe_error.play()
		array_pos = 0
		pass_enter.text = "Incorrect. " + str(incorrect_times) + " tries remaining."
		incorrect_times -= 1
		await get_tree().create_timer(1.5).timeout
		blinker_anim.play("Blink")
		input = ""
		pass_enter.text = input
	else:
		#print("very wrong")
		array_pos = 0
		pass_enter.text = "Exceeded amount of incorrect tries."
		await get_tree().create_timer(1.5).timeout
		pass_enter.text = "Sending alarm..."
		emit_signal("alarm")
		await get_tree().create_timer(1.5).timeout
		$".".hide()
		#exit to third cam
		input = ""
		pass_enter.text = input
		
func open() -> void:
	safe_open.play()
	safe_anim = true
	animation_tree["parameters/conditions/is_opened"] = true
	animation_tree["parameters/conditions/is_closed"] = false
	is_open = true
	open_interact.hide()
	interior_interact_area_1.show()
	interior_interact_area_2.show()
	interior_interact_area_3.show()
	interior_interact_area_4.show()
	await get_tree().create_timer(2.1).timeout
	close_interact.show()
	await get_tree().create_timer(.2).timeout
	safe_anim = false
	
func close() -> void:
	safe_close.play()
	safe_anim = true
	animation_tree["parameters/conditions/is_closed"] = true
	animation_tree["parameters/conditions/is_opened"] = false
	is_open = false
	close_interact.hide()
	interior_interact_area_1.hide()
	interior_interact_area_2.hide()
	interior_interact_area_3.hide()
	interior_interact_area_4.hide()
	await get_tree().create_timer(2.1).timeout
	open_interact.show()
	await get_tree().create_timer(.2).timeout
	safe_anim = false



func _on_to_close_safe_input_event(viewport, event, shape_idx):
		if GlobalVars.in_look_screen == false:
			if event is InputEventMouseButton:
				close()

func _on_input_event(viewport, event, shape_idx):
	if GlobalVars.in_look_screen == false:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed == true:
				$".".show()
				interior_interact_area_1.hide()
				interior_interact_area_2.hide()
				interior_interact_area_3.hide()
				interior_interact_area_4.hide()
				open_interact.hide()
				GlobalVars.Quincy_Safe_UI = true
				GlobalVars.viewing = "safe"
				GlobalVars.in_look_screen = true
				blinker_anim.play("Blink")


func _on_exit_pressed():
	$".".hide()
	GlobalVars.Quincy_Safe_UI = false
	GlobalVars.viewing = ""
	GlobalVars.in_look_screen = false
	open_interact.show()

func _input(event):
	if Input.is_action_just_pressed("Exit") and GlobalVars.viewing == "safe":
		$".".hide()
		GlobalVars.Quincy_Safe_UI = false
		GlobalVars.in_look_screen = false
		await get_tree().create_timer(.3).timeout
		GlobalVars.viewing = ""
		open_interact.show()
	if Input.is_action_just_pressed("Exit") and GlobalVars.viewing == "proposal" or GlobalVars.viewing == "newspaper" or  GlobalVars.viewing == "pager":
		open_interact.hide()
		close_interact.show()
		interior_interact_area_1.show()
		interior_interact_area_2.show()
		interior_interact_area_3.show()
		interior_interact_area_4.show()



func _on_safe_interact_interacted(interactor):
	if is_open == false:
		open_interact.show()
		close_interact.hide()
		interior_interact_area_1.hide()
		interior_interact_area_2.hide()
		interior_interact_area_3.hide()
		interior_interact_area_4.hide()
		
	if is_open == true: 
		open_interact.hide()
		close_interact.show()
		interior_interact_area_1.show()
		interior_interact_area_2.show()
		interior_interact_area_3.show()
		interior_interact_area_4.show()


func _on_object_exit_pressed():
	open_interact.hide()
	close_interact.show()
	interior_interact_area_1.show()
	interior_interact_area_2.show()
	interior_interact_area_3.show()
	interior_interact_area_4.show()
