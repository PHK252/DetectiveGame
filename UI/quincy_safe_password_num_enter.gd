extends CanvasLayer

@onready var pass_enter = $Label
@onready var input_array = ["-", "a", "A", "b", "B", "c", "C", "d", "D", "e", "E", "f", "F", "g", "G", "h", "H", "i", "I", 
"j", "J", "k", "K", "l", "L", "m", "M", "n", "N", "o", "O", "p", "P", "q", "Q", "r", "R", "s", "S", "t", "T", "u", "U", 
"v", "V", "w", "W", "x", "X", "y", "Y", "z", "Z", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]
@onready var password = "REVER"

@onready var input = ""
@onready var array_pos = 0
@onready var incorrect_times = 2

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
		print("correct")
		pass_enter.text = "Opening..."
	elif incorrect_times > 0:
		print("wrong")
		pass_enter.text = "Incorrect. " + str(incorrect_times) + " tries remaining."
		incorrect_times -= 1
		await get_tree().create_timer(1.5).timeout
		input = ""
		pass_enter.text = input
	else:
		print("very wrong")
		pass_enter.text = "Exceeded amount of incorrect tries."
		await get_tree().create_timer(1.5).timeout
		pass_enter.text = "Sending alarm..."
		await get_tree().create_timer(1.5).timeout
		input = ""
		pass_enter.text = input
		
