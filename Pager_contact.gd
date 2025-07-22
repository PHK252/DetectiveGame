extends Control

@export var contact_arr : Array[Button]
@export var contact: Control
@export var home : Control
@export var back_screen: Control
@onready var focus_index_contact = 0

func _ready():
	contact_arr[focus_index_contact].grab_focus()

func _on_down_pressed():
	if focus_index_contact < 2:
		focus_index_contact += 1
		contact_arr[focus_index_contact].grab_focus()
		
	else:
		focus_index_contact = 2
		contact_arr[focus_index_contact].grab_focus()
	print(focus_index_contact)

func _on_up_pressed():
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

func _on_back_pressed():
	if contact.visible == true:
		contact.visible = false
		back_screen.visible = true
