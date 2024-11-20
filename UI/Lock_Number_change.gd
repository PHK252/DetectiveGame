extends Node2D

@onready var num0 = $"0"
@onready var num1 = $"1"
@onready var num2 = $"2"
@onready var num3 = $"3"
@onready var num4 = $"4"
@onready var num5 = $"5"
@onready var num6 = $"6"
@onready var num7 = $"7"
@onready var num8 = $"8"
@onready var num9 = $"9"

@onready var numClick = 0



func _ready():
	#$".".hide()
	numChange()

func _on_up_pressed():
	#if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
	if numClick < 9:
		numClick = numClick + 1 
	else:
		numClick = 0
	numChange()

func _on_down_pressed():
	#if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if numClick > 0:
			numClick = numClick - 1
		else:
			numClick = 9
		numChange()


func hideArrows():
	$Up.disabled = true
	$Up.hide()
	$Down.disabled = true
	$Down.hide()

func showArrows():
	$Up.disabled = false
	$Up.show()
	$Down.disabled = false
	$Down.show()

func numChange():
	if numClick == 0:
		#print("0")
		num0.show()
		num1.hide()
		num2.hide()
		num3.hide()
		num4.hide()
		num5.hide()
		num6.hide()
		num7.hide()
		num8.hide()
		num9.hide()
	elif numClick == 1:
		#print("1")
		num0.hide()
		num1.show()
		num2.hide()
		num3.hide()
		num4.hide()
		num5.hide()
		num6.hide()
		num7.hide()
		num8.hide()
		num9.hide()
	elif numClick == 2:
		#print("2")
		num0.hide()
		num1.hide()
		num2.show()
		num3.hide()
		num4.hide()
		num5.hide()
		num6.hide()
		num7.hide()
		num8.hide()
		num9.hide()
	elif numClick == 3:
		#print("3")
		num0.hide()
		num1.hide()
		num2.hide()
		num3.show()
		num4.hide()
		num5.hide()
		num6.hide()
		num7.hide()
		num8.hide()
		num9.hide()
	elif numClick == 4:
		#print("4")
		num0.hide()
		num1.hide()
		num2.hide()
		num3.hide()
		num4.show()
		num5.hide()
		num6.hide()
		num7.hide()
		num8.hide()
		num9.hide()
	elif numClick == 5:
		#print("5")
		num0.hide()
		num1.hide()
		num2.hide()
		num3.hide()
		num4.hide()
		num5.show()
		num6.hide()
		num7.hide()
		num8.hide()
		num9.hide()
	elif numClick == 6:
		#print("6")
		num0.hide()
		num1.hide()
		num2.hide()
		num3.hide()
		num4.hide()
		num5.hide()
		num6.show()
		num7.hide()
		num8.hide()
		num9.hide()
	elif numClick == 7:
		#print("7")
		num0.hide()
		num1.hide()
		num2.hide()
		num3.hide()
		num4.hide()
		num5.hide()
		num6.hide()
		num7.show()
		num8.hide()
		num9.hide()
	elif numClick == 8:
		#print("8")
		num0.hide()
		num1.hide()
		num2.hide()
		num3.hide()
		num4.hide()
		num5.hide()
		num6.hide()
		num7.hide()
		num8.show()
		num9.hide()
	elif numClick == 9:
		#print("9")
		num0.hide()
		num1.hide()
		num2.hide()
		num3.hide()
		num4.hide()
		num5.hide()
		num6.hide()
		num7.hide()
		num8.hide()
		num9.show()
