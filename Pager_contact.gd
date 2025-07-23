extends Control

@export var contact_arr : Array[Button]
@export var contact: Control
@export var home : Control
@export var back_screen: Control
@onready var focus_index_contact = 0

signal menu_default
signal home_default

func _ready():
	if contact.visible == true:
		contact_arr[focus_index_contact].grab_focus()

func _on_down_pressed():
	if contact.visible == true:
		if focus_index_contact < 2:
			focus_index_contact += 1
			contact_arr[focus_index_contact].grab_focus()
			
		else:
			focus_index_contact = 2
			contact_arr[focus_index_contact].grab_focus()
		print(focus_index_contact)

func _on_up_pressed():
	if contact.visible == true:
		if focus_index_contact > 0:
			focus_index_contact -= 1
			contact_arr[focus_index_contact].grab_focus()
		else:
			focus_index_contact = 0 
			contact_arr[focus_index_contact].grab_focus()
		print(focus_index_contact)

func _on_home_pressed():
	if contact.visible == true:
		contact.visible = false
		home.visible = true
		emit_signal("home_default")

func _on_back_pressed():
	if contact.visible == true:
		contact.visible = false
		back_screen.visible = true
		emit_signal("menu_default")


func _on_menu_contact_default():
	if contact.visible == true:
		focus_index_contact = 0 
		contact_arr[focus_index_contact].grab_focus()

#Menu buttons keep focus when keyboard buttons are pressed
func _on_unhandled_down():
	if contact.visible == true:
		contact_arr[focus_index_contact].grab_focus()
