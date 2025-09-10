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
@onready var day : int 
@onready var time : String 
@onready var current_level = ""
@onready var first_house = ""

var load_global_arr = []
var load_global_name_arr = ["forward", "day", "time", "current_level", "first_house"]
func _load_global_arr():
	load_global_arr = [GlobalVars.forward, GlobalVars.day, GlobalVars.time, GlobalVars.current_level, GlobalVars.first_house]
	return load_global_arr
##Phone stuff
#for contacts
@onready var phone_contacts: Array[TextureButton] = []
# clock
@onready var clock_time : Array[int] = [] 
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
var evidence = ""


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


##Micah Vars
@onready var micah_time_out = false
@onready var micah_kicked_out = false
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



###Save Up until Here?
var player_pos
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

func _ready():
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
	set_mouse_default()
	set_mouse_pointing()

func emit_phone_call():
	emit_signal("phone_call_receiving")
	calling = true

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
