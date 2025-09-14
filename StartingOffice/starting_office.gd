extends Node3D

@onready var team_pic = $UI/TeamPic
@onready var partner_pic = $UI/PartnerPic
@onready var news = $UI/News
@onready var contact = $UI/Contact
@onready var missing = $"UI/Missing Persons"
@onready var alert = $SubViewportContainer/SubViewport/Characters/Dalton/CharacterBody3D/PlayerInteractor/CollisionShape3D/Alert
@export var player : CharacterBody3D
@export var dalton_marker : Marker2D
@export var theo_marker : Marker2D

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
	var dialogue_file = choose_office_dialogue()
	if dialogue_file != "":
		if GlobalVars.in_dialogue == false:
			player.stop_player()
			GlobalVars.in_dialogue = true
			Dialogic.timeline_ended.connect(_on_timeline_ended)
			var layout = Dialogic.start(dialogue_file)
			layout.register_character(load("res://Dialogic Characters/Dalton.dch"), dalton_marker)
			layout.register_character(load("res://Dialogic Characters/Chief.dch"), dalton_marker)
			layout.register_character(load("res://Dialogic Characters/Theo.dch"), theo_marker)
	else:
		return

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

	
func _on_timeline_ended():
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	player.start_player()
	GlobalVars.in_dialogue = false


#choosing dialogue if there is any
func choose_office_dialogue():
	match GlobalVars.day:
		1:
			if Dialogic.VAR.get_variable("Global.went_to_Micah") == false or Dialogic.VAR.get_variable("Global.went_to_Juniper") == false:
				print_debug("D1: something went wrong with office dialogue or it's your first time here")
				return ""
			if Dialogic.VAR.get_variable("Juniper.found_skylar") == true:
				return "End_day_1_got_name"
			if Dialogic.VAR.get_variable("Asked Questions.has_hair") == true:
				return "End_day_1_got_hair_no_name"
			if Dialogic.VAR.get_variable("Asked Questions.Micah_kicked_out") == true and Dialogic.VAR.get_variable("Juniper.kicked_out") == true:
				return "End_day_1_got_kicked"
			return "End_day_1_got_nothing"
		2: 
			if Dialogic.VAR.get_variable("Global.went_to_Quincy") == false:
				if Dialogic.VAR.get_variable("Juniper.found_skylar") == true or Dialogic.VAR.get_variable("Asked Questions.has_hair") == true:
					return "Beginning_day_2_got_name_or_hair"
				if Dialogic.VAR.get_variable("Asked Questions.Micah_kicked_out") == true and Dialogic.VAR.get_variable("Juniper.kicked_out") == true:
					return "Beginning_day_2_got_kicked"
				return "Beginning_day_2_got_nothing"
			else:
				if Dialogic.VAR.get_variable("Quincy.kicked_out") == true:
					return "End_day_2_got_kicked"
				if Dialogic.VAR.get_variable("Quincy.solved_rever") == true:
					return "End_day_2_got_REVER" 
				if Dialogic.VAR.get_variable("Quincy.solved_case") == true and Dialogic.VAR.get_variable("Juniper.found_skylar") == true:
					return "End_day_2_got_case"
				return "End_day_2_got_hair"
		3: 
			if Dialogic.VAR.get_variable("Quincy.solved_rever") == true:
				if Dialogic.VAR.get_variable("Quincy.Quincy_saw_coors") == true:
					return "Day_3_gave_coor_case_rever_theo"
				return "Secret_To_Location"
			if Dialogic.VAR.get_variable("Quincy.solved_case") == true and Dialogic.VAR.get_variable("Juniper.found_skylar") == true:
				if Dialogic.VAR.get_variable("Quincy.Quincy_saw_coors") == true:
					return "Day_3_gave_coor_case"
				return "Day_3_case"
			if Dialogic.VAR.get_variable("Asked Questions.has_hair") == true:
				return "Day_3_hair"
			if Dialogic.VAR.get_variable("Quincy.caught") == true:
				return "Day_3_fired_quincy"
			return "Day_3_fired_not_solved_case"
		_:
			print_debug("Day does not exist")
			return ""
