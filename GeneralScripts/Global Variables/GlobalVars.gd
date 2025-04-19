extends Node

#Global
#subject to lengthen
var default_cursor = preload("res://UI/Assets/Cursors/Default Cursor.png") 
var pointing_hand = preload("res://UI/Assets/Cursors/Pointing Cursor.png")

signal phone_call_receiving 

@onready var in_call = false
@onready var calling = false
@onready var player_move = true
@onready var in_look_screen = false
@onready var in_dialogue = false
@onready var clicked_contact = 0
@onready var clicked_partner = 0
@onready var clicked_news = 0
@onready var clicked_team = 0
@onready var clicked_missing = 0
@onready var clicked_tool_note = 0
@onready var clicked_book_note = 0
@onready var clicked_cab = 0
@onready var viewed_case_file = 0
@onready var clicked_Micah_pic = 0

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
@onready var viewed_Micah_bookmark = false
@onready var viewed_Micah_pic = false
@onready var viewed_Micah_fridge = false
@onready var viewed_Micah_window = false

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
@onready var viewed_Juniper_case = false
@onready var viewed_pie_juniper = false
@onready var viewed_bills_juniper = false
@onready var viewed_Juniper_resume = false
@onready var viewed_Juniper_empinfo = false

@onready var viewed_Quincy_offPic = false
@onready var viewed_Quincy_famPic = false
@onready var viewed_Quincy_coor = false
@onready var viewed_Quincy_journal = false
@onready var viewed_Quincy_phone = false
@onready var viewed_Quincy_fish = false
@onready var viewed_Quincy_poker = false
@onready var viewed_Quincy_case = false
@onready var viewed_Quincy_bookmark = false

@onready var offPic_dialogue_Quincy = false
@onready var famPic_dialogue_Quincy = false
@onready var coor_dialogue_Quincy = false
@onready var journal_dialogue_Quincy = false
@onready var phone_dialogue_Quincy = false
@onready var fish_dialogue_Quincy = false
@onready var poker_thoughts_Quincy = false
@onready var case_dialogue_Quincy = false
@onready var bar_dialogue_Quincy_finsihed = false

@onready var clicked_offPic_Quincy = 0
@onready var clicked_journal_Quincy = 0
#@onready var clicked_famPic_Quincy = 0
@onready var clicked_coor_Quincy = 0
@onready var clicked_phone_Quincy = 0
@onready var clicked_case_Quincy = 0

@onready var Quincy_in_case = false
@onready var Quincy_in_computer = false

@onready var clicked_recipe_Juniper = 0
@onready var clicked_case_Juniper = 0
@onready var clicked_bills_Juniper = 0
@onready var case_dialogue_Juniper = false
@onready var clicked_resume_Juniper = 0
@onready var clicked_employee_Juniper = 0

@onready var opened_cab = false
@onready var pic_fell = false
@onready var Micah_in_case = false
@onready var in_interaction = ""
@onready var viewing = ""
@onready var first_house = ""

#not quite sure if we need this one
#@onready var second_house = ""
@onready var has_secret = false
@onready var has_contact = false
@onready var current_level = ""
var player_pos
var first_house_path = "res://FirstHouse/first_house.tscn"
var cam_changed = false
var clue_progress = 1
var ghost_open = false

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
