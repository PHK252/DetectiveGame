extends Node3D

@onready var team_pic = $UI/TeamPic
@onready var partner_pic = $UI/PartnerPic
@onready var news = $UI/News
@onready var contact = $UI/Contact
@onready var missing = $"UI/Missing Persons"
@onready var alert = $Characters/Dalton/CharacterBody3D/PlayerInteractor/CollisionShape3D/Alert
# Called when the node enters the scene tree for the first time.
func _ready():
	team_pic.hide()
	partner_pic.hide()
	news.hide()
	contact.hide()
	missing.hide()
	GlobalVars.current_level = "Office"
	
	alert.hide()
	#$"UI/TeamPic Look".hide()
	#var layout = Dialogic.start("Office_contact_ad")
	#layout.register_character(load("res://Dialogic Characters/Dalton.dch"), $Dalton/CharacterBody3D/Marker2D)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("Quit"):
			get_tree().quit()
