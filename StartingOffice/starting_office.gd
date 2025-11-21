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
@onready var pause = $Pause
var dialogue_file: String
#settings
@export var sub_v_container : SubViewportContainer
@export var subviewport : SubViewportContainer
@export var lights : Array[Light3D]
@export var world_env : WorldEnvironment
@export var inputManager : InputManager

var call := false

signal change_texture(texture: String)
signal theo_out
signal theo_move
signal theo_there
signal call_recieve

func _ready():
	GlobalVars.current_level = "Office"
	sub_v_container.stretch_shrink = GlobalVars.stretch_factor
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
	if Dialogic.VAR.get_variable("Interogation.ending") == true:
		choose_ending()
	dialogue_file = choose_office_dialogue()
	if dialogue_file != "":
		if GlobalVars.in_dialogue == false:
			await get_tree().create_timer(4.0).timeout
			player.stop_player()
			GlobalVars.in_dialogue = true
			Dialogic.timeline_ended.connect(_on_timeline_ended)
			Dialogic.signal_event.connect(enter_Theo)
			Dialogic.signal_event.connect(walk_out)
			Dialogic.signal_event.connect(calling)
			Dialogic.signal_event.connect(exit_Theo)
			var layout = Dialogic.start(dialogue_file)
			layout.register_character(load("res://Dialogic Characters/Dalton.dch"), dalton_marker)
			layout.register_character(load("res://Dialogic Characters/Chief.dch"), dalton_marker)
			layout.register_character(load("res://Dialogic Characters/Theo.dch"), theo_marker)
	else:
		return

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event):
	if Input.is_action_just_pressed("Quit"):
		if pause.visible == false:
			pause.visible = true
	
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
	GlobalVars.in_dialogue = false
	if call == true:
		return
	player.start_player()
	



#choosing dialogue if there is any
func choose_office_dialogue():
	match GlobalVars.day:
		1:
			if Dialogic.VAR.get_variable("Global.went_to_Micah") == false or Dialogic.VAR.get_variable("Global.went_to_Juniper") == false:
				print_debug("D1: something went wrong with office dialogue or it's your first time here")
				return ""
			if Dialogic.VAR.get_variable("Juniper.found_skylar") == true:
				return "End_day_1_got_name"
			if Dialogic.VAR.get_variable("Asked Questions.has_hair") == true or Dialogic.VAR.get_variable("Juniper.has_pie") == true:
				return "End_day_1_got_hair_no_name"
			if Dialogic.VAR.get_variable("Asked Questions.Micah_kicked_out") == true and Dialogic.VAR.get_variable("Juniper.kicked_out") == true:
				return "End_day_1_got_kicked"
			return "End_day_1_got_nothing"
		2: 
			if Dialogic.VAR.get_variable("Global.went_to_Quincy") == false:
				if Dialogic.VAR.get_variable("Juniper.found_skylar") == true or Dialogic.VAR.get_variable("Asked Questions.has_hair") == true or Dialogic.VAR.get_variable("Juniper.has_pie") == true:
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
			call = true
			if Dialogic.VAR.get_variable("Quincy.solved_rever") == true:
				call = false
				if Dialogic.VAR.get_variable("Quincy.Quincy_saw_coors") == true:
					emit_signal("theo_there")
					return "Day_3_gave_coor_case_rever_theo"
				emit_signal("theo_there")
				return "Secret_To_Location"
			if Dialogic.VAR.get_variable("Quincy.solved_case") == true and Dialogic.VAR.get_variable("Juniper.found_skylar") == true:
				if Dialogic.VAR.get_variable("Quincy.Quincy_saw_coors") == true:
					emit_signal("theo_out")
					return "Day_3_gave_coor_case"
				emit_signal("theo_there")
				return "Day_3_case"
			if Dialogic.VAR.get_variable("Asked Questions.has_hair") == true or Dialogic.VAR.get_variable("Juniper.has_pie") == true:
				emit_signal("theo_there")
				return "Day_3_hair"
			if Dialogic.VAR.get_variable("Quincy.caught") == true:
				call = false
				Dialogic.VAR.set_variable("Endings.Ending_type", "Quincy fired")
				emit_signal("change_texture", "res://UI/Assets/Endings/Quincy Fire@2x.png")
				emit_signal("theo_out")
				return "Day_3_fired_quincy"
			call = false
			Dialogic.VAR.set_variable("Endings.Ending_type", "Chief fired")
			emit_signal("theo_out")
			emit_signal("change_texture", "res://UI/Assets/Endings/Chief Fire@2x.png")
			return "Day_3_fired_not_solved_case"
		_:
			print_debug("Day does not exist")
			return ""

func choose_ending():
	emit_signal("change_texture", "res://UI/Assets/Endings/Give Kale Cure Choco P1@2x.png")
	#match Dialogic.VAR.get_variable("Endings.Ending_type"):
		#"Arrested Skylar":
			#return "Ending_arrested_skylar"
		#"Keep Confidential":
			#return "Keep_confidential"
		#"Give Skylar Cure":
			#return "Ending_Give_Skylar_Cure"
		#"Give Skylar Cure And Choco":
			#return "Ending_Give_Skylar_Cure_choco"
		#"Give Kale Cure":
			#return "Ending_Give_Kale_Cure"
		#"Give Kale Cure And Choco":
			#return "Ending_Give_Kale_Cure_choco"
		#_:
			#print_debug("No Ending Uh Oh")
			#return
##Dialogue Signals
func enter_Theo(argument: String):
	if argument == "theo_walk_in":
		#Prompt theo to walk through the door
		print("Theo enters")
		emit_signal("theo_move")
		Dialogic.signal_event.disconnect(enter_Theo)
		pass
func exit_Theo(argument: String):
	if argument == "theo_exit":
		#Prompt theo to exit
		print("Theo exits")
		#emit_signal("theo_move")
		Dialogic.signal_event.disconnect(exit_Theo)
		pass
#add anims
func walk_out(argument: String):
	if argument == "To_Intero":
		#Prompt theo to walk through the door
		print("Both exit")
		#emit_signal("Both_walk out")
		Dialogic.signal_event.disconnect(walk_out)
		Loading.load_scene(self, GlobalVars.interrogation, false, "", "")
		pass
	elif argument == "fade":
		#Fade to Credits
		Dialogic.signal_event.disconnect(walk_out)

func calling(argument: String):
	if argument == "start_call":
		emit_signal("call_recieve")
		GlobalVars.in_dialogue = false
		#Dialogic.paused = true
		#Dialogic.Styles.get_layout_node().hide()
		Dialogic.signal_event.disconnect(calling)


func _on_start_call():
	GlobalVars.in_dialogue = true
	call = false
	#Dialogic.paused = false
	#Dialogic.Styles.get_layout_node().show()
	Dialogic.timeline_ended.connect(_on_timeline_ended)
	Dialogic.start(dialogue_file, "call")
#settings changes

func _set_pixelation() -> void:
	sub_v_container.stretch_shrink = GlobalVars.stretch_factor

func _set_shadow() -> void:
	world_env.environment.ssao_enabled = GlobalVars.optional_shadow
	#optional lights for other levels
	#for light in lights:
		#light.shadow_enabled = GlobalVars.optional_shadow
	

func _on_brightness_brightness_shift() -> void:
	world_env.environment.adjustment_brightness = GlobalVars.brightness
