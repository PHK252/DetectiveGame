extends CanvasLayer

@onready var phone_ui = $"."

#screen
@onready var home = $HomeScreen
@onready var phone = $PhoneScreen
@onready var gallery = $GalleryScreen
@onready var notes = $NotesScreen
@onready var home_button = $Home

#phone 
@onready var phone_num = $PhoneScreen/PhoneNum
@onready var phone_call = $PhoneScreen/PhoneCall
@onready var phone_contact = $PhoneScreen/ContactScreen
@onready var phone_bottom = $"PhoneScreen/Phone Bottom"

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
	default_screen()

func default_screen():
	home.show()
	phone.hide()
	gallery.hide()
	notes.hide()
	gallery_close_pics.hide()
	phone_call.hide()
	phone_contact.hide()

func _on_home_pressed():
	default_screen()
	await get_tree().process_frame
	$Home.release_focus()



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
	if GlobalVars.in_call == true and GlobalVars.calling == true:
		home.hide()
		gallery.hide()
		notes.hide()
		phone.show()
		phone_call_receiving.show()
	else:
		home.hide()
		gallery.hide()
		notes.hide()
		phone.show()
		phone_num.show()
		phone_bottom.show()
		phone_contact.hide()

func hideEverything():
	home.hide()
	gallery.hide()
	notes.hide()
	phone.hide()
	phone_num.hide()
	phone_call.hide()


	

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
	print("entered")
	if picPlace != 6:
		gallery_right.show()

func _on_left_hover_mouse_entered():
	print("entered")
	if picPlace != 0:
		gallery_left.show()

func _on_right_hover_mouse_exited():
	print("exit")
	gallery_right.hide()

func _on_left_hover_mouse_exited():
	print("exit")
	gallery_left.hide()

#Phone 

#Number input
@onready var num_input = $PhoneScreen/PhoneNum/NumInput
@onready var at_bookshelf = false
@export var dalton_marker : Marker2D
@export var quincy_marker : Marker2D
#@export var theo_marker : Marker2D
@export var phone_marker : Marker2D
@export var player : CharacterBody3D

@onready var bar_call = false

signal continue_convo
signal Book_distract_quincy

signal enable_interact
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
	elif len(num_input.text) > 0:
		num_input.text = num_input.text.erase(len(num_input.text)-1, 1)
	else:
		pass

func _on_call_pressed():
	#print("Calling")
	#emit signal(calling) for possible animation
	var called_num = num_input.text
	if called_num == "":
		#error sfx
		return
	exit_phone()
	num_input.text = ""
	
	var needs_distraction = Dialogic.VAR.get_variable("Quincy.needs_distraction")
	if GlobalVars.in_dialogue == false:
		# Dialing THEO
		if called_num == "034-2012": 
			if at_bookshelf == true and needs_distraction == true:
				var book_distract = Dialogic.start("Quincy_book_distract")
				GlobalVars.in_dialogue = true
				Dialogic.signal_event.connect(_bottle_fall_sound)
				Dialogic.signal_event.connect(_end_call)
				Dialogic.timeline_ended.connect(_on_timeline_ended)
				return
			elif bar_call == true:
				var bar_call = Dialogic.start("Quincy_bar", "Theo Call")
				GlobalVars.in_dialogue = true
				Dialogic.signal_event.connect(_bar_end_call)
				Dialogic.timeline_ended.connect(_on_timeline_ended)
				return
			else:
				if GlobalVars.current_level == "quincy":
					Dialogic.start("Theo_call", "separated")
					GlobalVars.in_dialogue = true
					Dialogic.timeline_ended.connect(_on_timeline_ended)
					return
				if GlobalVars.current_level == "Office" and GlobalVars.day == 1:
					Dialogic.start("Theo_call", "Before Case")
					GlobalVars.in_dialogue = true
					Dialogic.timeline_ended.connect(_on_timeline_ended)
					return
				Dialogic.start("Theo_call", "with Dalton")
				GlobalVars.in_dialogue = true
				Dialogic.timeline_ended.connect(_on_timeline_ended)
				return
		# Dialing JUNIPER
		if called_num == "194-108":
			Dialogic.start("Juniper_call")
			GlobalVars.in_dialogue = true
			Dialogic.timeline_ended.connect(_on_timeline_ended)
			return
		# Dialing CLYDE
		if called_num == "093-316":
			Dialogic.start("Clyde_call")
			GlobalVars.in_dialogue = true
			Dialogic.timeline_ended.connect(_on_timeline_ended)
			return
		# Dialing QUINCY
		if called_num == "221-1712":
			Dialogic.start("Phone_line_busy")
			GlobalVars.in_dialogue = true
			Dialogic.timeline_ended.connect(_on_timeline_ended)
			return
		# Dialing ISAAC
		if called_num == "034-921":
			Dialogic.start("Phone_num_gone")
			GlobalVars.in_dialogue = true
			Dialogic.timeline_ended.connect(_on_timeline_ended)
			return
		Dialogic.start("Phone_wrong_num")
		GlobalVars.in_dialogue = true
		Dialogic.timeline_ended.connect(_on_timeline_ended)
		
		
func _on_bookshelf_area_body_entered(body):
	at_bookshelf = true

func _on_bookshelf_area_body_exited(body):
	at_bookshelf = false


func _on_isaac_pressed(): #UPDATE TIMELINE
	exit_phone()
	Dialogic.start("Phone_num_gone")
	GlobalVars.in_dialogue = true
	Dialogic.timeline_ended.connect(_on_timeline_ended)


func _on_quincy_pressed(): #UPDATE TIMELINE
	exit_phone()
	Dialogic.start("Phone_line_busy")
	GlobalVars.in_dialogue = true
	Dialogic.timeline_ended.connect(_on_timeline_ended)

func _on_juniper_pressed(): #UPDATE TIMELINE
	exit_phone()
	Dialogic.start("Juniper_call")
	GlobalVars.in_dialogue = true
	Dialogic.timeline_ended.connect(_on_timeline_ended)

func _on_clyde_pressed(): #UPDATE TIMELINE
	exit_phone()
	Dialogic.start("Clyde_call")
	GlobalVars.in_dialogue = true
	Dialogic.timeline_ended.connect(_on_timeline_ended)

func _on_skylar_pressed(): #UPDATE TIMELINE
	exit_phone()
	Dialogic.start("Phone_wrong_num")
	GlobalVars.in_dialogue = true
	Dialogic.timeline_ended.connect(_on_timeline_ended)

func _on_theo_pressed(): #UPDATE TIMELINE
	exit_phone()
	var needs_distraction = Dialogic.VAR.get_variable("Quincy.needs_distraction")
	if at_bookshelf == true and needs_distraction == true:
		var book_distract = Dialogic.start("Quincy_book_distract")
		GlobalVars.in_dialogue = true
		Dialogic.signal_event.connect(_bottle_fall_sound)
		Dialogic.signal_event.connect(_end_call)
		Dialogic.timeline_ended.connect(_on_timeline_ended)
	elif bar_call == true:
		var bar_call = Dialogic.start("Quincy_bar", "Theo Call")
		GlobalVars.in_dialogue = true
		Dialogic.signal_event.connect(_bar_end_call)
		Dialogic.timeline_ended.connect(_on_timeline_ended)
	else:
		if GlobalVars.in_dialogue == false:
			if GlobalVars.current_level == "quincy":
				Dialogic.start("Theo_call", "separated")
				GlobalVars.in_dialogue = true
				Dialogic.timeline_ended.connect(_on_timeline_ended)
				return
			if GlobalVars.current_level == "Office" and GlobalVars.day == 1:
				Dialogic.start("Theo_call", "Before Case")
				GlobalVars.in_dialogue = true
				Dialogic.timeline_ended.connect(_on_timeline_ended)
				return
			Dialogic.start("Theo_call", "with Dalton")
			GlobalVars.in_dialogue = true
			Dialogic.timeline_ended.connect(_on_timeline_ended)

func exit_phone():
	phone_ui.hide()
	emit_signal("enable_interact")
	GlobalVars.phone_up = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	phone.hide()
	home_button.disabled = false
	home.show()

func _on_timeline_ended():
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	GlobalVars.in_dialogue = false
	player.start_player()

#Incoming Call
@onready var phone_call_receiving = $PhoneScreen/PhoneCall
@onready var phone_anim = $PhoneScreen/PhoneCall/AnimationPlayer

func set_receiving_call():
	#hideEverything()
	home.hide()
	notes.hide()
	gallery.hide()
	phone.show()
	phone_num.hide()
	phone_contact.hide()
	phone_bottom.hide()
	phone_call_receiving.show()
	home_button.disabled = true
	phone_anim.play("Call")

func set_nums():
	#hideEverything()
	home.hide()
	notes.hide()
	gallery.hide()
	phone.show()
	phone_num.show()
	phone_call_receiving.hide()
	phone_bottom.show()


func _on_accept_pressed():
	phone_ui.hide()
	home.show()
	phone_call.hide()
	phone.hide()
	#await get_tree().create_timer(.3).timeout
	#GlobalVars.in_call = false


func _on_decline_pressed():
	#hideEverything()
	home.show()
	phone.hide()
	phone_call.hide()
	#await get_tree().create_timer(.3).timeout
	GlobalVars.in_call = false


func _on_bar_theo_bar_call():
	bar_call = true

func _bar_end_call(argument : String):
	if argument == "call_end":
		GlobalVars.in_dialogue = false
		bar_call = false
		Dialogic.signal_event.disconnect(_bar_end_call)
		emit_signal("continue_convo")
	elif argument == "disconnect":
		Dialogic.signal_event.disconnect(_bar_end_call)
	
func _bottle_fall_sound(argument: String):
	if argument == "bar_distract":
		#play sound
		Dialogic.signal_event.disconnect(_bottle_fall_sound)
		emit_signal("Book_distract_quincy")
	elif argument == "end":
		Dialogic.signal_event.disconnect(_bottle_fall_sound)

func _end_call(argument: String):
	if argument == "end_call":
		#play sound
		#GlobalVars.in_dialogue = false
		Dialogic.signal_event.disconnect(_end_call)
	elif argument == "end":
		Dialogic.signal_event.disconnect(_end_call)
