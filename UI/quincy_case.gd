extends CanvasLayer

@onready var label = $Label

@onready var password = "afdahlsjds"
@onready var input = ""

@onready var abc_pos = 0
@onready var abc_array = ["2", "a", "b", "c"]

func _ready():
	label.text = ""


func loop_press(arr : Array, pos : int):
	if pos == len(arr) - 1:
		label.text = input + arr[pos]
		pos = 0
	else:
		print("entered")
		label.text = input + arr[pos]
		pos += 1
		
	


func _on_abc_pressed():
	#loop_press(abc_array, abc_pos)
	#print(abc_pos)
	if abc_pos == len(abc_array) - 1:
		label.text = input + abc_array[abc_pos]
		abc_pos = 0
	else:
		label.text = input + abc_array[abc_pos]
		abc_pos += 1
		#
	#await get_tree().create_timer(1.0).timeout



func _on_next_pressed():
	input = input + abc_array[abc_pos]
	print(input)
