extends Node2D

#screen
@onready var home = $HomeScreen
@onready var phone = $PhoneScreen
@onready var gallery = $GalleryScreen
@onready var notes = $NotesScreen

#phone 
@onready var phone_num = $PhoneScreen/PhoneNum
@onready var phone_call = $PhoneScreen/PhoneCall

#Gallery 
@onready var gallery_list = $GalleryScreen/GalleryList
@onready var gallery_close_pics = $GalleryScreen/ClosePics
@onready var close_pic_1 = $"GalleryScreen/ClosePics/Close Pic1"
@onready var close_pic_2 = $"GalleryScreen/ClosePics/Close Pic2"
@onready var close_pic_3 = $"GalleryScreen/ClosePics/Close Pic3"
@onready var close_pic_4 = $"GalleryScreen/ClosePics/Close Pic4"
@onready var close_pic_5 = $"GalleryScreen/ClosePics/Close Pic5"
@onready var close_pic_6 = $"GalleryScreen/ClosePics/Close Pic6"
@onready var close_pic_7 = $"GalleryScreen/ClosePics/Close Pic7"
@onready var gallery_buttons = $GalleryScreen/ClosePics/Buttons



# Called when the node enters the scene tree for the first time.
func _ready():
	home.show()
	phone.hide()
	gallery.hide()
	notes.hide()
	gallery_close_pics.hide()
	phone_call.hide()

func _on_home_pressed():
	home.show()
	phone.hide()
	gallery.hide()
	notes.hide()


func _on_gallery_pressed():
	home.hide()
	phone.hide()
	notes.hide()
	gallery.show()
	gallery_list.show()

func _on_notes_pressed():
	home.hide()
	phone.hide()
	gallery.hide()
	notes.show()


func _on_phone_pressed():
	home.hide()
	gallery.hide()
	notes.hide()
	phone.show()
	phone_num.show()

#phone

#gallery
@onready var picArray = [close_pic_1, close_pic_2, close_pic_3, close_pic_4, close_pic_5, 
close_pic_6, close_pic_7]
@onready var picPlace = 0
@onready var gallery_right = $GalleryScreen/ClosePics/Buttons/Right
@onready var gallery_left = $GalleryScreen/ClosePics/Buttons/Left



func _on_back_pressed():
	gallery_close_pics.hide()
	gallery_list.show()
	picArray[picPlace].hide()
	picPlace = 0
	gallery_left.disabled = false
	gallery_right.disabled = false


func _on_left_pressed():
	if picPlace == 1:
		picPlace = 0
		picArray[1].hide()
		picArray[picPlace].show()
		gallery_left.disabled = true
		gallery_left.hide()
	else:
		gallery_right.disabled = false
		#gallery_right.show()
		picPlace -= 1
		picArray[picPlace + 1].hide()
	picArray[picPlace].show()
	
func _on_right_pressed():
	if picPlace == 5:
		picPlace = 6
		picArray[5].hide()
		picArray[picPlace].show()
		gallery_right.disabled = true
		gallery_right.hide()
		picArray[picPlace-1].hide()
	else:
		gallery_left.disabled = false
		#gallery_left.show()
		picPlace += 1
		picArray[picPlace-1].hide()
	picArray[picPlace].show()


func _on_pic_1_pressed():
	picPlace = 0
	gallery_close_pics.show()
	gallery_list.hide()
	gallery_buttons.show()
	picArray[0].show()
	gallery_left.disabled = true
	gallery_left.hide()



func _on_pic_2_pressed():
	picPlace = 1
	gallery_close_pics.show()
	gallery_list.hide()
	gallery_buttons.show()
	picArray[1].show()


func _on_pic_3_pressed():
	picPlace = 2
	gallery_close_pics.show()
	gallery_list.hide()
	gallery_buttons.show()
	picArray[2].show()
	
func _on_pic_4_pressed():
	picPlace = 3
	gallery_close_pics.show()
	gallery_list.hide()
	gallery_buttons.show()
	picArray[3].show()

func _on_pic_5_pressed():
	picPlace = 4
	gallery_close_pics.show()
	gallery_list.hide()
	gallery_buttons.show()
	picArray[4].show()

func _on_pic_6_pressed():
	picPlace = 5
	gallery_close_pics.show()
	gallery_list.hide()
	gallery_buttons.show()
	picArray[5].show()

func _on_pic_7_pressed():
	picPlace = 6
	gallery_close_pics.show()
	gallery_list.hide()
	gallery_buttons.show()
	picArray[6].show()
	gallery_right.disabled = true
	gallery_right.hide()


func _on_right_hover_mouse_entered():
	if picPlace != 6:
		gallery_right.show()

func _on_left_hover_mouse_entered():
	if picPlace != 0:
		gallery_left.show()

func _on_right_hover_mouse_exited():
	gallery_right.hide()

func _on_left_hover_mouse_exited():
	gallery_left.hide()

#Phone 

#Number input
@onready var num_input = $PhoneScreen/PhoneNum/NumInput

func inputNum(num: int):
	if len(num_input.text) <  11:
		num_input.text += str(num)
		if len(num_input.text) == 3:
			num_input.text += "-"

func _on_zero_pressed():
	inputNum(0)

func _on_one_pressed():
	inputNum(1)

func _on_two_pressed():
	inputNum(2)

func _on_three_pressed():
	inputNum(3)
	
func _on_four_pressed():
	inputNum(4)

func _on_five_pressed():
	inputNum(5)

func _on_six_pressed():
	inputNum(6)

func _on_seven_pressed():
	inputNum(7)

func _on_eight_pressed():
	inputNum(8)

func _on_nine_pressed():
	inputNum(9)

func _on_star_pressed():
	if len(num_input.text) <  11:
		num_input.text += "*"
		if len(num_input.text) == 3:
			num_input.text += "-"

func _on_pound_pressed():
	if len(num_input.text) <  11:
		num_input.text += "#"
		if len(num_input.text) == 3:
			num_input.text += "-"

func _on_delete_pressed():
	if len(num_input.text) == 4:
		num_input.text = num_input.text.erase(len(num_input.text)-2, 2)
	else:
		num_input.text = num_input.text.erase(len(num_input.text)-1, 1)

func _on_call_pressed():
	print("Calling")
