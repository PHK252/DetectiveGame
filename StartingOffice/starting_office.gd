extends Node3D

@onready var team_pic = $UI/TeamPic
@onready var partner_pic = $UI/PartnerPic
@onready var news = $UI/News
@onready var contact = $UI/Contact
@onready var missing = $"UI/Missing Persons"
@onready var alert = $SubViewportContainer/SubViewport/Characters/Dalton/CharacterBody3D/PlayerInteractor/CollisionShape3D/Alert


func _ready():
	GlobalVars.current_level = "Office"
#	SaveLoad.saveGame(SaveLoad.SAVE_DIR + SaveLoad.SAVE_FILE_NAME)
	#SaveLoad.loadGame(SaveLoad.SAVE_DIR + SaveLoad.SAVE_FILE_NAME)
	team_pic.hide()
	partner_pic.hide()
	news.hide()
	contact.hide()
	missing.hide()
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	alert.hide()
	#$"UI/TeamPic Look".hide()
	#var layout = Dialogic.start("Office_contact_ad")
	#layout.register_character(load("res://Dialogic Characters/Dalton.dch"), $Dalton/CharacterBody3D/Marker2D)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("Quit"):
			get_tree().quit()

#func _input(event):
	#if Input.is_key_pressed(KEY_S):
		#SaveLoad.saveGame(SaveLoad.SAVE_DIR + SaveLoad.SAVE_FILE_NAME)
		#print("Dalton " + str(GlobalVars.dalton_pos))
	#
	#if Input.is_key_pressed(KEY_L):
		#SaveLoad.loadGame(SaveLoad.SAVE_DIR + SaveLoad.SAVE_FILE_NAME)
		#print("Dalton " + str(GlobalVars.dalton_pos))

#choosing dialogue if there is any
func choose_office_dialogue():
	match GlobalVars.day:
		1:
			if Dialogic.VAR.get_variable("Global.went_to_Micah") == false or Dialogic.VAR.get_variable("Global.went_to_Juniper") == false:
				print_debug("something went wrong with office dialogue")
				return ""
			if Dialogic.VAR.get_variable("Global.first_house") == "" and Dialogic.VAR.get_variable("Character Aff Points.Theo") > 0:
				return "Day_1_ride_to_first"
			if Dialogic.VAR.get_variable("Global.first_house") == "Micah" and Dialogic.VAR.get_variable("Asked Questions.Micah_Asked_Theo_Question") == true:
				return "Day_1_ride_from_TG"
			if Dialogic.VAR.get_variable("Asked Questions.Micah_kicked_out") == true:
				return "Day_1_ride_from_kicked_Micah"
			if Dialogic.VAR.get_variable("Juniper.kicked_out") == true:
				return "Day_1_ride_from_kicked_Juniper"
			if Dialogic.VAR.get_variable("Asked Questions.Micah_timed_out") == true:
				return "Day_1_ride_from_timed_Micah"
			if Dialogic.VAR.get_variable("Juniper.timed_out") == true:
				return "Day_1_ride_from_timed_Juniper" 
			if Dialogic.VAR.get_variable("Character Aff Points.Theo") > 3 and Dialogic.VAR.get_variable("Asked Questions.Micah_Solved_Case") == true and Dialogic.VAR.get_variable("Juniper.found_skylar") == true:
				return "Day_1_ride_to_back_to_station"
			return ""
		2: 
			if Dialogic.VAR.get_variable("Quincy.solved_rever") == true:
				return "Day_2_ride_from_Quincy_REVER" 
			if Dialogic.VAR.get_variable("Quincy.kicked_out") == true:
				return "Day_2_ride_kicked_from_Quincy" 
			if Dialogic.VAR.get_variable("Quincy.failed_distract") == true:
				return "Day_2_ride_from_Quincy_Theo_call"
			if Dialogic.VAR.get_variable("Character Aff Points.Theo") > 3: 
				if Dialogic.VAR.get_variable("Quincy.first_greeting") == false and Dialogic.VAR.get_variable("Quincy.second_greeting") == false:
					return "Day_2_ride_to_Quincy"
				if Dialogic.VAR.get_variable("Quincy.solved_case") == true and Dialogic.VAR.get_variable("Quincy.solved_rever") == false: 
					return "Day_2_ride_from_Quincy"
			return ""
			
		3: 
			if Dialogic.VAR.get_variable("Quincy.has_secret_coor") == true:
				return "Day_3_to_Secret"
			return ""
		_:
			return ""
