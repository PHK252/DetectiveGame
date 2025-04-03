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
@onready var clicked_bookmark_Juniper = 0
@onready var book_dialogue_Juniper = false
@onready var house_dialogue_Juniper = false
@onready var cafe_dialogue_Juniper = false
@onready var window_thoughts_Juniper = false

@onready var viewed_Juniper_case = false
@onready var clicked_case_Juniper = 0
@onready var case_dialogue_Juniper = false
@onready var viewed_Juniper_resume = false
@onready var clicked_resume_Juniper = 0
@onready var resume_dialogue_Juniper = false
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
	set_mouse_default()
	set_mouse_pointing()

func emit_phone_call():
	emit_signal("phone_call_receiving")
	calling = true
