extends Node

#Global
#subject to lengthen
var default_cursor = preload("res://UI/Assets/Cursors/Default Cursor small.png") 
var pointing_hand = preload("res://UI/Assets/Cursors/Pointing hand small.png")
var i_beam = preload("res://UI/Assets/Cursors/I beam dark small.png")

signal phone_call_receiving 
signal open_micah_case
signal open_juniper_case
signal open_quincy_case
signal unpaused
#don't save/ false on load
@onready var in_call = false
@onready var calling = false
@onready var player_move = true
@onready var in_look_screen = false
@onready var in_dialogue = false
@onready var phone_up = false
@onready var in_interaction = ""
@onready var viewing = ""

## The actual Globals
@onready var forward : bool
@onready var day : int = 1
@onready var time : String 
@onready var current_level = ""
@onready var first_house = "" # might not need



var load_global_arr = []
var load_global_name_arr = ["forward", "day", "time", "current_level", "first_house"]
func _load_global_arr():
	load_global_arr = [GlobalVars.forward, GlobalVars.day, GlobalVars.time, GlobalVars.current_level, GlobalVars.first_house]
	return load_global_arr
##Phone stuff
#for contacts
@onready var phone_contacts: Array[TextureButton] = []
# clock
@onready var clock_time : Array[int]
#for phone notes
@onready var micah_notes : String
@onready var juniper_notes : String
@onready var quincy_notes : String
# don't save these
var note_char = ""
var note_event = ""
var note_condition = ""

#for evidence collection
@onready var evidence_container : VBoxContainer
#don't save these
var evi_char = ""
var evi_remove_char = ""
var evidence = ""

var load_phone_name_arr = ["phone_contacts", "clock_time", "micah_notes", "juniper_notes", "quincy_notes", "evidence_container"]

##Office Vars
@onready var intro_dialogue = false
#contact
@onready var clicked_contact = 0
@onready var viewed_contact = false
@onready var has_contact = false
#Isaac
@onready var clicked_partner = 0
@onready var viewed_partner = false
#News
@onready var clicked_news = 0
@onready var viewed_news = false
#Team
@onready var clicked_team = 0
@onready var viewed_team = false
#Missing
@onready var clicked_missing = 0
@onready var viewed_missing = false
#Case File
@onready var clicked_case_file = 0
@onready var viewed_case_file = false

var load_Office_name_arr = ["intro_dialogue", "clicked_contact", "viewed_contact", "has_contact", "clicked_partner", "viewed_partner",
"clicked_news", "viewed_news", "clicked_team", "viewed_team", "clicked_missing", "viewed_missing", "clicked_case_file", "viewed_case_file"]

##Micah Vars
@onready var micah_kicked_out = false
@onready var micah_time_out = false
#Closet
@onready var clicked_tool_note = 0
@onready var clicked_id_card = 0
@onready var closet_dialogue = false
@onready var viewed_tool_note = false
@onready var viewed_id_card = false
#bookshelf
@onready var clicked_book_note = 0
@onready var book_dialogue = false
@onready var viewed_Micah_bookmark = false
#Cabinet
@onready var clicked_cab = 0
@onready var opened_cab = false
#Pic
@onready var pic_fell = false
@onready var clicked_Micah_pic = 0
@onready var Micah_pic_dialogue = false
@onready var viewed_Micah_pic = false
#Fridge
@onready var viewed_Micah_fridge = false
#Window
@onready var window_dialogue = false
@onready var viewed_Micah_window = false
#Case
@onready var opened_micah_case = false
@onready var Micah_in_case = false
@onready var clicked_case_Micah = 0
@onready var clicked_case_letter_note = 0
@onready var viewed_Micah_letter = false
@onready var viewed_Micah_key = false
@onready var viewed_Micah_hair = false

var load_Micah_name_arr = ["micah_kicked_out", "micah_time_out", "clicked_tool_note", "clicked_id_card", "closet_dialogue", "viewed_tool_note",
"viewed_id_card", "clicked_book_note", "book_dialogue", "viewed_Micah_bookmark", "clicked_cab", "opened_cab", "pic_fell", "clicked_Micah_pic", "Micah_pic_dialogue", "viewed_Micah_pic", "viewed_Micah_fridge", "window_dialogue", "viewed_Micah_window", 
"opened_micah_case", "Micah_in_case", "clicked_case_Micah", "clicked_case_letter_note", "viewed_Micah_letter", "viewed_Micah_key", "viewed_Micah_hair"]

##Juniper Vars
@onready var juniper_kicked_out = false
@onready var juniper_time_out = false
@onready var in_tea_time = false
#House
@onready var viewed_Juniper_house_pic = false
@onready var house_dialogue_Juniper = false
#Cafe
@onready var viewed_Juniper_cafe_pic = false
@onready var cafe_dialogue_Juniper = false
#Window
@onready var viewed_Juniper_window = false
@onready var window_thoughts_Juniper = false
#Bookmark
@onready var viewed_Juniper_Bookmark = false
@onready var book_dialogue_Juniper = false
@onready var clicked_bookmark_Juniper = 0
#Employee + Resumes table
@onready var viewed_Juniper_employee = false
@onready var viewed_Juniper_resume = false
@onready var resume_dialogue_Juniper = false
@onready var employee_dialogue_Juniper = false
#@onready var viewed_Juniper_empinfo = false
@onready var clicked_employee_Juniper = 0
@onready var clicked_resume_Juniper = 0
#Med bills
@onready var bills_dialogue_Juniper = false
@onready var view_bills_juniper = false
@onready var clicked_bills_Juniper = 0
#Cab 2 (close to window)
@onready var pills_dialogue_Juniper = false
@onready var pie_dialogue_Juniper = false
@onready var viewed_pills_juniper = false
@onready var viewed_pie_juniper = false
#Cab 1 (Far from window)
@onready var cran_dialogue_Juniper = false
@onready var recipe_dialogue_Juniper = false
@onready var viewed_cran_juniper = false
@onready var viewed_recipe_juniper = false
@onready var clicked_recipe_Juniper = 0
#Case
@onready var opened_jun_case = false
@onready var Juniper_in_case = false
@onready var view_apron_juniper = false
@onready var view_letter_juniper = false
@onready var view_nametag_juniper = false
@onready var clicked_letter_Juniper = 0
@onready var clicked_case_Juniper = 0
@onready var clicked_nametag_Juniper = 0

var load_Juniper_name_arr =  ["juniper_kicked_out", "juniper_time_out", "in_tea_time", "viewed_Juniper_house_pic", "house_dialogue_Juniper", "viewed_Juniper_cafe_pic", "cafe_dialogue_Juniper", "viewed_Juniper_window", "window_thoughts_Juniper", "viewed_Juniper_employee",
"viewed_Juniper_resume", "resume_dialogue_Juniper", "employee_dialogue_Juniper", "clicked_employee_Juniper", "clicked_resume_Juniper", "bills_dialogue_Juniper", "view_bills_juniper", "clicked_bills_Juniper", "pills_dialogue_Juniper", "pie_dialogue_Juniper", 
"viewed_pills_juniper", "viewed_pie_juniper", "cran_dialogue_Juniper", "recipe_dialogue_Juniper", "viewed_cran_juniper", "viewed_recipe_juniper", "clicked_recipe_Juniper", "opened_jun_case", "Juniper_in_case", "view_apron_juniper", 
"view_letter_juniper", "view_nametag_juniper", "clicked_letter_Juniper", "clicked_case_Juniper", "clicked_nametag_Juniper"]

##Quincy Vars
@onready var quincy_time_out = false
@onready var quincy_kicked_out = false
@onready var quincy_fainted = false
@onready var Quincy_toilet_distracted = false
@onready var Quincy_Dalton_caught = false 
#Fam Portrait
@onready var viewed_Quincy_famPic = false
@onready var famPic_dialogue_Quincy = false
@onready var viewed_Quincy_coor = false
@onready var coor_dialogue_Quincy = false
@onready var clicked_coor_Quincy = 0
#Fish
@onready var fish_dialogue_Quincy = false
@onready var viewed_Quincy_fish = false
#Poker
@onready var poker_thoughts_Quincy = false
@onready var viewed_Quincy_poker = false
#Journal
@onready var journal_dialogue_Quincy = false
@onready var viewed_Quincy_journal = false
@onready var clicked_journal_Quincy = 0
#Phone
@onready var viewed_Quincy_phone = false
@onready var phone_dialogue_Quincy = false
@onready var clicked_phone_Quincy = 0
#Case
@onready var Quincy_in_case = false
@onready var opened_quincy_case = false
@onready var viewed_Quincy_letter = false
@onready var viewed_Quincy_hammer = false
@onready var clicked_case_Quincy = 0
@onready var clicked_letter_Quincy = 0
#bar
@onready var bar_dialogue_Quincy_finished = false
#Office Pic
@onready var viewed_Quincy_offPic = false
@onready var clicked_offPic_Quincy = 0
@onready var offPic_dialogue_Quincy = false
#computer
@onready var Quincy_in_computer = false
#Safe
@onready var Quincy_Safe_UI = false
@onready var safe_dialogue_Quincy = false
@onready var viewed_Quincy_bookmark = false
@onready var viewed_Quincy_pager = false
@onready var clicked_pager_Quincy = 0
@onready var viewed_Quincy_news = false
@onready var clicked_news_Quincy = 0
@onready var viewed_Quincy_usb = false
@onready var viewed_Quincy_proposal = false
@onready var clicked_proposal_Quincy = 0
#chocolate
@onready var viewed_Quincy_chocolate = false
@onready var chocolate_dialogue = false

var load_Quincy_name_arr = ["quincy_time_out", "quincy_kicked_out", "quincy_fainted", "Quincy_toilet_distracted", "Quincy_Dalton_caught", "viewed_Quincy_famPic", "famPic_dialogue_Quincy", "viewed_Quincy_coor", "coor_dialogue_Quincy", "clicked_coor_Quincy",
"viewed_Quincy_fish", "fish_dialogue_Quincy", "viewed_Quincy_poker", "poker_thoughts_Quincy", "viewed_Juniper_employee", "viewed_Juniper_resume", "clicked_resume_Juniper", "viewed_Quincy_phone", "phone_dialogue_Quincy", "clicked_phone_Quincy",
"bar_dialogue_Quincy_finished", "viewed_Quincy_offPic", "clicked_offPic_Quincy", "offPic_dialogue_Quincy", "Quincy_in_computer", "Quincy_Safe_UI", "safe_dialogue_Quincy", "viewed_Quincy_bookmark", "viewed_Quincy_pager", "clicked_pager_Quincy",
"viewed_Quincy_news", "clicked_news_Quincy", "viewed_Quincy_usb", "viewed_Quincy_proposal", "clicked_proposal_Quincy", "Quincy_in_case", "opened_quincy_case", "viewed_Quincy_letter", "viewed_Quincy_hammer", "clicked_case_Quincy",
 "clicked_letter_Quincy", "viewed_Quincy_chocolate", "chocolate_dialogue"]

func _dalton_caught_clear_state():
	#dalton_pos = Vector3()
	Quincy_Dalton_caught = true 
	quincy_time_out = false
	quincy_kicked_out = false
	quincy_fainted = false
	Quincy_toilet_distracted = false
	viewed_Quincy_famPic = false
	famPic_dialogue_Quincy = false
	viewed_Quincy_coor = false
	coor_dialogue_Quincy = false
	clicked_coor_Quincy = 0
	fish_dialogue_Quincy = false
	viewed_Quincy_fish = false
	poker_thoughts_Quincy = false
	viewed_Quincy_poker = false
	journal_dialogue_Quincy = false
	viewed_Quincy_journal = false
	clicked_journal_Quincy = 0
	viewed_Quincy_phone = false
	phone_dialogue_Quincy = false
	clicked_phone_Quincy = 0
	Quincy_in_case = false
	opened_quincy_case = false
	viewed_Quincy_letter = false
	viewed_Quincy_hammer = false
	clicked_case_Quincy = 0
	clicked_letter_Quincy = 0
	bar_dialogue_Quincy_finished = false
	viewed_Quincy_offPic = false
	clicked_offPic_Quincy = 0
	offPic_dialogue_Quincy = false
	Quincy_in_computer = false
	Quincy_Safe_UI = false
	safe_dialogue_Quincy = false
	viewed_Quincy_bookmark = false
	viewed_Quincy_pager = false
	clicked_pager_Quincy = 0
	viewed_Quincy_news = false
	clicked_news_Quincy = 0
	viewed_Quincy_usb = false
	viewed_Quincy_proposal = false
	clicked_proposal_Quincy = 0
	viewed_Quincy_chocolate = false
	chocolate_dialogue = false
	Dialogic.VAR.reset("Quincy")
	await get_tree().process_frame
	Dialogic.VAR.set_variable("Quincy.caught", true)
	SaveLoad.saveGame(SaveLoad.SAVE_DIR + SaveLoad.SAVE_FILE_NAME)

##Secret Vars
@onready var has_secret = false
#Cure
@onready var view_secret_cure = false
#USB
@onready var view_secret_usb = false
#Runa Letter
@onready var view_secret_runa_letter = false
@onready var clicked_runa_letter = 0
#Isaac Letter
@onready var view_secret_isaac_letter = false
@onready var clicked_isaac_letter = 0

var load_Secret_name_arr = ["has_secret", "view_secret_cure", "view_secret_usb", "view_secret_runa_letter", "clicked_runa_letter", "view_secret_isaac_letter", "clicked_isaac_letter"]

## Character positions
@onready var dalton_pos : Vector3
@onready var theo_pos : Vector3
@onready var micah_pos : Vector3
@onready var juniper_pos : Vector3
@onready var quincy_pos : Vector3
@onready var isaac_pos : Vector3

##add to save
#handled in beginning office
var movement_tut = false
var interact_tut = false
var dialogue_tut = false
#handled in office
var flip_tut = false
var exit_tut = false
var phone_tut = false # or first level
#handled in first level
var run_tut = false

var Day_1_Quincy_call = false
var Day_3_Chief_call = false

signal pixelation_changed(new_value)
signal shadow_changed(new_value)
signal brightness_changed(new_value)

#settings variables
var stretch_factor : int = 6:
	set(value):
		stretch_factor = value
		emit_signal("pixelation_changed", value)

var optional_shadow := true:
	set(value):
		optional_shadow = value
		emit_signal("shadow_changed", value)

var brightness := 1.0:
	set(value):
		brightness = value
		emit_signal("brightness_changed", value)

###Save Up until Here?
var from_save_file = false
var to_quit = false
var player_pos
var main_menu := "res://UI/Main Menu.tscn"
var first_house_path := "res://FirstHouse/first_house.tscn"
var second_house_path := "res://SecondHouse/second_house.tscn"
var third_house_path := "res://ThirdHouse/third_house.tscn"
var secret_path := "res://SecretLocation/secret_location.tscn"
var office_path := "res://StartingOffice/starting_office.tscn"
var beginning_office := "res://Cutscenes/cluttered_office.tscn"
var dream_trans := "res://dream_stuff/dreamTransition.tscn"
var flashback_1_1 := "res://Cutscenes/Flashback_01.tscn"
var flashback_1_2 := "res://dream_stuff/Flashback_Runa.tscn"
var flashback_2 := "res://Cutscenes/Flashback_02.tscn"
var interrogation := "res://Cutscenes/Interrogation.tscn"

#get current level path for loading
func get_current_level_path(level : String):
	match level:
		"Beginning":
			return beginning_office
		"Office":
			return office_path
		"micah":
			return first_house_path
		"juniper":
			return second_house_path
		"quincy":
			return third_house_path
		"secret":
			return secret_path
		"Transition":
			return dream_trans
		"Flashback_day_1":
			return flashback_1_1
		"Flashback_day_2":
			return flashback_2
		"interrogation":
			return interrogation
		_:
			print_debug("Level does not exist")
		

var cam_changed = false
var clue_progress = 1
var ghost_open = false

var master_volume : int
var music_volume : int
var effect_volume : int


func set_mouse_default():
	#print("set default")
	Input.set_custom_mouse_cursor(GlobalVars.default_cursor, Input.CURSOR_ARROW, Vector2(10,10))

func set_mouse_pointing():
	#print("set pointing")
	Input.set_custom_mouse_cursor(GlobalVars.pointing_hand, Input.CURSOR_POINTING_HAND, Vector2(20,22.5))

func set_mouse_I_beam():
	Input.set_custom_mouse_cursor(GlobalVars.i_beam, Input.CURSOR_IBEAM)

func _ready():
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	set_mouse_default()
	set_mouse_pointing()
	set_mouse_I_beam()

#func emit_phone_call():
	#emit_signal("phone_call_receiving")
	#calling = true

func emit_open_micah_case():
	emit_signal("open_micah_case")
	opened_micah_case = true

func emit_open_jun_case():
	emit_signal("open_juniper_case")
	opened_jun_case = true
	
func emit_open_quincy_case():
	emit_signal("open_quincy_case")
	opened_quincy_case = true


func emit_add_note(char : String, event : String, condition : String):
	note_char = char
	note_event = event
	note_condition = condition

func emit_add_evidence(char : String, evi : String):
	evi_char = char
	evidence = evi

func emit_remove_evidence(char : String, evi : String):
	evi_remove_char = char
	evidence = evi
