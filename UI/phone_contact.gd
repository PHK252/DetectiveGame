extends Control

@onready var theo = $VBoxContainer/Theo
@onready var juniper = $VBoxContainer/Juniper
@onready var clyde = $VBoxContainer/Clyde
@onready var skylar = $VBoxContainer/Skylar
#@export var player : CharacterBody3D
#@export var dalton_marker : Marker2D
#@export var phone_marker : Marker2D
@onready var contact_screen = $"."
@onready var phone_num = $"../PhoneNum"

func _on_phone_ui_add_contact(char):
	if char == "theo":
		theo.show()

	if char == "juniper":
		juniper.show()

	if char == "clyde":
		clyde.show()

	if char == "skylar":
		skylar.show()

func _on_keypad_pressed():
	contact_screen.hide()
	phone_num.show()


func _on_contact_pressed():
	contact_screen.show()
	phone_num.hide()
