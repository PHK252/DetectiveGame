extends Node2D

#screens
@onready var login = $Login
@onready var home = $Home
@onready var mail = $Mail

#Overlays
@onready var Home_dropdown_overlay = $Home/Dropdown
@onready var Mail_face_id_overlay = $"Mail/Face ID"
@onready var Mail_new_mail_overlay = $"Mail/New Message"
@onready var Mail_error_overlay = $Mail/Error

#Home buttons
@onready var Home_icon = $Home/Icon

#Mail Screens
@onready var Mail_inbox = $Mail/Inbox
@onready var Mail_read = $Mail/Read


#Mail buttons
@onready var Mail_Exit = $"Mail/Mail exit"
@onready var Mail_New_Message = $Mail/NewMessage
@onready var Mail_Inbox_Message_1 = $Mail/Inbox/Message1
@onready var Mail_Inbox_Message_2 = $Mail/Inbox/Message2
@onready var Mail_Inbox_Message_3 = $Mail/Inbox/Message3
@onready var Mail_Inbox_Message_4 = $Mail/Inbox/Message4
@onready var Mail_Inbox_Message_5 = $Mail/Inbox/Message5
@onready var Mail_Read_back = $Mail/Read/Back
@onready var Mail_Read_forward = $Mail/Read/Forward
@onready var Mail_Read_delete = $"Mail/Read/Mail Delete"
@onready var Mail_Read_download = $Mail/Read/Download
@onready var Mail_Read_lock = $Mail/Read/Lock
@onready var Mail_message_1 = $Mail/Read/Message1
@onready var Mail_message_2 = $Mail/Read/Message2



@onready var Mail_button_array = [Mail_Exit, Mail_New_Message, Mail_Inbox_Message_1, Mail_Inbox_Message_2, Mail_Inbox_Message_3,
Mail_Inbox_Message_4, Mail_Inbox_Message_5, Mail_Read_back, Mail_Read_forward, Mail_Read_delete, Mail_Read_download, Mail_Read_lock]

# Called when the node enters the scene tree for the first time.
func _ready():
	login.show()
	home.hide()
	mail.hide()
	Home_dropdown_overlay.hide()
	Mail_face_id_overlay.hide()
	Mail_new_mail_overlay.hide()
	Mail_error_overlay.hide()

#Login
func _on_enter_pressed():
	login.hide()
	home.show()

func _on_hint_pressed():
	$Login/HintText.show()
	await get_tree().create_timer(1.5).timeout
	$Login/HintText.hide()

func _on_sleep_pressed():
	get_tree().quit()


func _on_restart_pressed():
	get_tree().quit()


func _on_shutdown_pressed():
	get_tree().quit()


#Home
func _on_icon_toggled(toggled_on):
	if toggled_on == true:
		Home_dropdown_overlay.show()
	else:
		Home_dropdown_overlay.hide()

func _on_dropdown_1_pressed():
	#Log out
	Home_dropdown_overlay.hide()
	Home_icon.set_pressed(false)
	login.show()
	home.hide()

func _on_dropdown_2_pressed():
	get_tree().quit()


func _on_dropdown_3_pressed():
	get_tree().quit()


func _on_dropdown_4_pressed():
	get_tree().quit()


func _on_dropdown_5_pressed():
	get_tree().quit()

func _on_mail_pressed():
	Home_dropdown_overlay.hide()
	Home_icon.set_pressed(false)
	mail.show()
	Mail_inbox.show()
	Mail_read.hide()
	home.hide()

#Mail

#inbox
func _on_mail_exit_pressed():
	mail.hide()
	Mail_inbox.hide()
	Mail_error_overlay.hide()
	Mail_new_mail_overlay.hide()
	home.show()

func _on_message_1_pressed():
	faceScan()

func _on_message_2_pressed():
	faceScan()

func _on_message_3_pressed():
	faceScan()

func _on_message_4_pressed():
	Mail_inbox.hide()
	Mail_read.show()
	Mail_message_1.show()

func _on_message_5_pressed():
	Mail_inbox.hide()
	Mail_read.show()
	Mail_message_2.show()

#new message
func _on_new_message_pressed():
	disableMailButtons()
	Mail_new_mail_overlay.show()

func _on_confirm_pressed():
	Mail_error_overlay.hide()
	enableMailButtons()

func _on_exit_pressed():
	Mail_new_mail_overlay.hide()
	enableMailButtons()

func _on_error_exit_pressed():
	Mail_error_overlay.hide()
	
	
func _on_send_pressed():
	disableMailButtons()
	Mail_error_overlay.show()

func _on_delete_pressed():
	disableMailButtons()
	#change to confirm delete
	Mail_error_overlay.show()

#read

func _on_back_pressed():
	Mail_inbox.show()
	Mail_read.hide()
	Mail_message_1.hide()
	Mail_message_2.hide()

func _on_mail_delete_pressed():
	faceScan()

func _on_download_pressed():
	faceScan()

func _on_lock_pressed():
	faceScan()

func _on_forward_pressed():
	faceScan()

#local functions
func disableMailButtons():
	for i in Mail_button_array:
		i.mouse_filter = 2 
		
func enableMailButtons():
	for i in Mail_button_array:
		i.mouse_filter = 0

func faceScan():
	disableMailButtons()
	Mail_face_id_overlay.show()
	$"Mail/Face ID/FaceID Anim".play("Face-ID")
	await $"Mail/Face ID/FaceID Anim".animation_finished
	Mail_face_id_overlay.hide()
	enableMailButtons()
