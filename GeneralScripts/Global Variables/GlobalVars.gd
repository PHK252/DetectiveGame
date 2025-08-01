extends Node

#Global
#subject to lengthen
var default_cursor = preload("res://UI/Assets/Cursors/Default Cursor.png") 
var pointing_hand = preload("res://UI/Assets/Cursors/Pointing Cursor.png")

signal phone_call_receiving 
signal open_micah_case
signal open_juniper_case
signal open_quincy_case

@onready var micah_time_out = false
@onready var micah_kicked_out = false

@onready var quincy_time_out = false
@onready var quincy_kicked_out = false
@onready var quincy_fainted = false

@onready var juniper_kicked_out = false
@onready var juniper_time_out = false

@onready var forward : bool
@onready var day = ""

@onready var in_call = false
@onready var calling = false
@onready var player_move = true
@onready var in_look_screen = false
@onready var in_dialogue = false
@onready var intro_dialogue = false
@onready var clicked_contact = 0
@onready var clicked_partner = 0
@onready var clicked_news = 0
@onready var clicked_team = 0
@onready var clicked_missing = 0
@onready var clicked_tool_note = 0
@onready var clicked_id_card = 0
@onready var clicked_book_note = 0
@onready var clicked_case_letter_note = 0
@onready var clicked_cab = 0
@onready var viewed_case_file = false
@onready var clicked_case_file = 0
@onready var clicked_Micah_pic = 0
@onready var clicked_case_Micah = 0

@onready var closet_dialogue = false
@onready var Micah_pic_dialogue = false
@onready var book_dialogue = false
@onready var window_dialogue = false
@onready var viewed_contact = false
@onready var viewed_partner = false
@onready var viewed_news = false
@onready var viewed_team = false
@onready var viewed_missing = false
@onready var viewed_tool_note = false
@onready var viewed_id_card = false
@onready var viewed_Micah_bookmark = false
@onready var viewed_Micah_pic = false
@onready var viewed_Micah_fridge = false
@onready var viewed_Micah_window = false
@onready var viewed_Micah_letter = false
@onready var viewed_Micah_key = false
@onready var viewed_Micah_hair = false

@onready var viewed_Juniper_house_pic = false
@onready var viewed_Juniper_cafe_pic = false
@onready var viewed_Juniper_window = false
@onready var viewed_Juniper_Bookmark = false
@onready var viewed_Juniper_employee = false
@onready var clicked_bookmark_Juniper = 0
@onready var book_dialogue_Juniper = false
@onready var house_dialogue_Juniper = false
@onready var cafe_dialogue_Juniper = false
@onready var window_thoughts_Juniper = false
@onready var bills_dialogue_Juniper = false
@onready var pills_dialogue_Juniper = false
@onready var pie_dialogue_Juniper = false
@onready var cran_dialogue_Juniper = false
@onready var recipe_dialogue_Juniper = false
@onready var resume_dialogue_Juniper = false
@onready var employee_dialogue_Juniper = false

@onready var viewed_recipe_juniper = false
@onready var viewed_cran_juniper = false
@onready var viewed_pills_juniper = false
#@onready var viewed_Juniper_case = false
@onready var viewed_pie_juniper = false
@onready var viewed_bills_juniper = false
@onready var viewed_Juniper_resume = false
@onready var viewed_Juniper_empinfo = false
@onready var Juniper_in_case = false

@onready var view_apron_juniper = false
@onready var view_letter_juniper = false
@onready var view_bills_juniper = false
@onready var view_nametag_juniper = false

@onready var viewed_Quincy_offPic = false
@onready var viewed_Quincy_famPic = false
@onready var viewed_Quincy_coor = false
@onready var viewed_Quincy_journal = false
@onready var viewed_Quincy_phone = false
@onready var viewed_Quincy_fish = false
@onready var viewed_Quincy_poker = false
@onready var viewed_Quincy_letter = false
@onready var viewed_Quincy_hammer = false
@onready var viewed_Quincy_bookmark = false
@onready var viewed_Quincy_pager = false
@onready var viewed_Quincy_news = false
@onready var viewed_Quincy_usb = false
@onready var viewed_Quincy_proposal = false
@onready var viewed_Quincy_chocolate = false


@onready var offPic_dialogue_Quincy = false
@onready var famPic_dialogue_Quincy = false
@onready var coor_dialogue_Quincy = false
@onready var journal_dialogue_Quincy = false
@onready var phone_dialogue_Quincy = false
@onready var fish_dialogue_Quincy = false
@onready var poker_thoughts_Quincy = false
@onready var safe_dialogue_Quincy = false
@onready var bar_dialogue_Quincy_finished = false
@onready var Quincy_toilet_distracted = false
@onready var chocolate_dialogue = false

@onready var clicked_offPic_Quincy = 0
@onready var clicked_journal_Quincy = 0
@onready var clicked_proposal_Quincy = 0
@onready var clicked_coor_Quincy = 0
@onready var clicked_pager_Quincy = 0
@onready var clicked_news_Quincy = 0
@onready var clicked_phone_Quincy = 0
@onready var clicked_case_Quincy = 0
@onready var clicked_letter_Quincy = 0

@onready var Quincy_in_case = false
@onready var Quincy_Safe_UI = false
@onready var Quincy_in_computer = false
@onready var Quincy_Dalton_caught = false 

@onready var clicked_recipe_Juniper = 0
@onready var clicked_letter_Juniper = 0
@onready var clicked_case_Juniper = 0
@onready var clicked_bills_Juniper = 0
@onready var clicked_nametag_Juniper = 0
#@onready var case_dialogue_Juniper = false
@onready var clicked_resume_Juniper = 0
@onready var clicked_employee_Juniper = 0

@onready var opened_cab = false
@onready var pic_fell = false
@onready var Micah_in_case = false
@onready var in_interaction = ""
@onready var viewing = ""
@onready var first_house = ""

@onready var opened_jun_case = false
@onready var opened_micah_case = false
@onready var opened_quincy_case = false
#not quite sure if we need this one
#@onready var second_house = ""
@onready var has_secret = false
@onready var has_contact = false
@onready var current_level = ""
var player_pos
var first_house_path = "res://FirstHouse/first_house.tscn"
var second_house_path = "res://SecondHouse/second_house.tscn"
var third_house_path = "res://ThirdHouse/third_house.tscn"
var secret_path = "res://SecretLocation/secret_location.tscn"
var office_path = "res://StartingOffice/starting_office.tscn"
var cam_changed = false
var clue_progress = 1
var ghost_open = false

var phone_up = false

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
