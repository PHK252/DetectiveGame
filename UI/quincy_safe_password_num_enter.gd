extends CanvasLayer

@onready var pass_enter = $Label
@onready var input_array = ["-", "a", "A", "b", "B", "c", "C", "d", "D", "e", "E", "f", "F", "g", "G", "h", "H", "i", "I", 
"j", "J", "k", "K", "l", "L", "m", "M", "n", "N", "o", "O", "p", "P", "q", "Q", "r", "R", "s", "S", "t", "T", "u", "U", 
"v", "V", "w", "W", "x", "X", "y", "Y", "z", "Z", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]
@onready var password = "REVER"

@onready var input = ""
@onready var array_pos = 0
@onready var incorrect_times = 2

@onready var is_open: bool = false
@export var animation_tree : AnimationTree
@onready var safe_anim = false
@export var open_interact : Area2D
@export var close_interact : Area2D

@export var interior_interact_area_1 : Area2D
@export var interior_interact_area_2 : Area2D
@export var interior_interact_area_3 : Area2D
@export var interior_interact_area_4 : Area2D

func _ready():
	pass_enter.text = ""

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
	array_pos = 0
	print(input)

func _on_backspace_pressed():
	if len(input) > 0:
		pass_enter.text = pass_enter.text.erase(len(pass_enter.text)-1, 1)
		input = pass_enter.text
		print(input)
		array_pos = 0

func _on_enter_pressed():
	input = input + input_array[array_pos]
	if password == input:
		$".".hide()
		GlobalVars.in_look_screen = false
		GlobalVars.Quincy_Safe_UI = false
		#print("correct")
		pass_enter.text = "Opening..."
		await get_tree().create_timer(1.5).timeout
		open()
		
	elif incorrect_times > 0:
		#print("wrong")
		pass_enter.text = "Incorrect. " + str(incorrect_times) + " tries remaining."
		incorrect_times -= 1
		await get_tree().create_timer(1.5).timeout
		input = ""
		pass_enter.text = input
	else:
		#print("very wrong")
		pass_enter.text = "Exceeded amount of incorrect tries."
		await get_tree().create_timer(1.5).timeout
		pass_enter.text = "Sending alarm..."
		await get_tree().create_timer(1.5).timeout
		input = ""
		pass_enter.text = input
		
func open() -> void:
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
	$".".show()
	GlobalVars.Quincy_Safe_UI = true
	GlobalVars.viewing = "safe"
	GlobalVars.in_look_screen = true


func _on_exit_pressed():
	$".".show()
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
