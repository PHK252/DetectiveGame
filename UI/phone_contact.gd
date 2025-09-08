extends Control
@onready var contacts_container = $VBoxContainer
@onready var theo : TextureButton= $VBoxContainer/Theo
@onready var juniper: TextureButton = $VBoxContainer/Juniper
@onready var clyde: TextureButton = $VBoxContainer/Clyde
@onready var skylar : TextureButton= $VBoxContainer/Skylar

@onready var isaac : TextureButton = $VBoxContainer/Isaac
@onready var quincy : TextureButton = $VBoxContainer/Quincy

#@export var player : CharacterBody3D
#@export var dalton_marker : Marker2D
#@export var phone_marker : Marker2D
@onready var contact_screen = $"."
@onready var phone_num = $"../PhoneNum"

@onready var visible_contacts : Array [TextureButton] = [isaac, quincy]
func _ready():
	if GlobalVars.phone_contacts.size() == 0:
		GlobalVars.phone_contacts = visible_contacts
	else:
		visible_contacts = GlobalVars.phone_contacts

	for contacts in visible_contacts:
		contacts.visible = true
	
	#print(GlobalVars.phone_contacts)
func _on_phone_ui_add_contact(char):
	if char == "theo":
		theo.show()
		visible_contacts.append(theo)

	if char == "juniper":
		juniper.show()
		visible_contacts.append(juniper)

	if char == "clyde":
		clyde.show()
		visible_contacts.append(clyde)

	if char == "skylar":
		skylar.show()
		visible_contacts.append(skylar)

	GlobalVars.phone_contacts = visible_contacts
	
func _on_keypad_pressed():
	contact_screen.hide()
	phone_num.show()


func _on_contact_pressed():
	contact_screen.show()
	phone_num.hide()
