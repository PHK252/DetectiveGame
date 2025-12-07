extends Control
@onready var contacts_container = $VBoxContainer
@onready var theo : TextureButton= $VBoxContainer/Theo
@onready var juniper: TextureButton = $VBoxContainer/Juniper
@onready var clyde: TextureButton = $VBoxContainer/Clyde
@onready var skylar : TextureButton= $VBoxContainer/Skylar

@onready var isaac : TextureButton = $VBoxContainer/Isaac
@onready var quincy : TextureButton = $VBoxContainer/Quincy

@onready var theo_visible = false
@onready var juniper_visible = false
@onready var clyde_visible = false
@onready var contact_screen = $"."
@onready var phone_num = $"../PhoneNum"

@onready var visible_contacts : Array [TextureButton] = [isaac, quincy]
func _ready():
	if GlobalVars.phone_contacts.size() == 0:
		GlobalVars.phone_contacts = visible_contacts
	else:
		visible_contacts = GlobalVars.phone_contacts
	
	if is_instance_valid(visible_contacts):
		for contacts in visible_contacts:
			contacts.visible = true
	
	#print(GlobalVars.phone_contacts)

func _add_contact(char):
	if char == "theo":
		theo.show()
		theo_visible = true
		visible_contacts.append(theo)

	if char == "juniper":
		juniper.show()
		juniper_visible = true
		visible_contacts.append(juniper)

	if char == "clyde":
		clyde.show()
		visible_contacts.append(clyde)
		clyde_visible = true
	#if char == "skylar":
		#skylar.show()
		#visible_contacts.append(skylar)

	GlobalVars.phone_contacts = visible_contacts
	
func _on_keypad_pressed():
	contact_screen.hide()
	phone_num.show()


func _on_contact_pressed():
	contact_screen.show()
	phone_num.hide()


func _on_visibility_changed():
	if visible == true:
		if Dialogic.VAR.get_variable("Global.got_theo_ad") and theo.visible != true:
			_add_contact("theo")
		if Dialogic.VAR.get_variable("Juniper.leave") and juniper.visible != true:
			_add_contact("juniper")
		if Dialogic.VAR.get_variable("Asked Questions.Micah_viewed_ID") and clyde.visible != true:
			_add_contact("clyde")
