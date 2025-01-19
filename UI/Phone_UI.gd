extends Node2D

@onready var home = $PhoneHomeBack
@onready var phone = $PhoneCallNumbers
@onready var gallery = $PhoneGallery
@onready var notes = $PhoneNotes

@onready var gallery_button = $Gallery
@onready var notes_button = $Notes
@onready var phone_button = $Phone

# Called when the node enters the scene tree for the first time.
func _ready():
	home.show()
	phone.hide()
	gallery.hide()
	notes.hide()


func _on_home_pressed():
	home.show()
	phone.hide()
	gallery.hide()
	notes.hide()
	gallery_button.show()
	notes_button.show()
	phone_button.show()


func _on_gallery_pressed():
	home.hide()
	phone.hide()
	gallery.show()
	notes.hide()
	gallery_button.hide()
	notes_button.hide()
	phone_button.hide()

func _on_notes_pressed():
	home.hide()
	phone.hide()
	gallery.hide()
	notes.show()
	gallery_button.hide()
	notes_button.hide()
	phone_button.hide()

func _on_phone_pressed():
	home.hide()
	phone.show()
	gallery.hide()
	notes.hide()
	gallery_button.hide()
	notes_button.hide()
	phone_button.hide()
