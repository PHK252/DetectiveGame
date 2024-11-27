extends CanvasLayer

@onready var text_edit = $Label
@onready var password = "8008569420"

func key_press(num : int):
	if len(text_edit.text) <  10:
		text_edit.text += str(num)

func _on_zero_pressed():
	key_press(0)
	print("0")

func _on_one_pressed():
	key_press(1)
	print("1")

func _on_two_pressed():
	key_press(2)
	print("2")

func _on_three_pressed():
	key_press(3)
	print("3")

func _on_four_pressed():
	key_press(4)
	print("4")

func _on_five_pressed():
	key_press(5)
	print("5")

func _on_six_pressed():
	key_press(6)
	print("6")

func _on_seven_pressed():
	key_press(7)
	print("7")

func _on_eight_pressed():
	key_press(8)
	print("8")

func _on_nine_pressed():
	key_press(9)
	print("9")

func _on_x_pressed():
	text_edit.text = ""
	print("x")

func _on_enter_pressed():
	if text_edit.text == password:
		print("Open")
		await get_tree().create_timer(1.5).timeout
		text_edit.text = ""
	else:
		print("nu uh")
		text_edit.text = "xxxxxxxxxx"
		await get_tree().create_timer(1.5).timeout
		text_edit.text = ""
	print("enter")



func _on_exit_pressed():
	$".".hide()
	GlobalVars.in_look_screen = false

func _input(event):
	if Input.is_action_just_pressed("Exit"):
		$".".hide()
		GlobalVars.in_look_screen = false
