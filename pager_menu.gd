extends Control

@export var menu_arr : Array[Button]
@export var contact: Control
@export var home : Control
@export var menu : Control
@export var messages: Control
@onready var focus_index_menu = 0
var unhandled = false
@onready var up = false

signal home_default
signal contact_default
signal messages_default

func _ready():
	if menu.visible == true:
		menu_arr[focus_index_menu].grab_focus()

func _on_down_pressed():
	if menu.visible == true:
		if focus_index_menu < 1:
			focus_index_menu += 1
			menu_arr[focus_index_menu].grab_focus()
		else:
			focus_index_menu = 1
			menu_arr[focus_index_menu].grab_focus()

func _on_up_pressed():
	if menu.visible == true:
		if focus_index_menu > 0:
			focus_index_menu -= 1
			menu_arr[focus_index_menu].grab_focus()
		else:
			focus_index_menu = 0 
			menu_arr[focus_index_menu].grab_focus()
		print(focus_index_menu)

func _on_home_pressed():
	if menu.visible == true:
		menu.visible = false
		home.visible = true
		emit_signal("home_default")

func _on_back_pressed():
	if menu.visible == true:
		menu.visible = false
		home.visible = true
		emit_signal("home_default")



#Menu buttons keep focus when keyboard buttons are pressed
func _on_unhandled_down():
	if menu.visible == true:
		menu_arr[focus_index_menu].grab_focus()


func _on_enter_pressed():
	if menu.visible == true:
		_menu_nav()

func _on_check_pressed():
	if menu.visible == true:
		_menu_nav()

func _menu_nav():
	if focus_index_menu == 0:
		#to messages
		menu.visible = false
		messages.visible = true
		emit_signal("messages_default")
	else:
		#to contact
		menu.visible = false
		contact.visible = true
		emit_signal("contact_default")


func _on_menu_default():
	if menu.visible == true:
		focus_index_menu = 0
		menu_arr[focus_index_menu].grab_focus()
