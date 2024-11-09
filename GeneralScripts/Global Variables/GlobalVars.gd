extends Node

#Global
#subject to lengthen
@onready var player_move = true
@onready var in_look_screen = false
@onready var in_dialogue = false
@onready var clicked_contact = 0
@onready var clicked_partner = 0
@onready var clicked_news = 0
@onready var clicked_team = 0
@onready var clicked_missing = 0
@onready var clicked_tool_note = 0
@onready var viewed_case_file = 0
@onready var viewed_contact = false
@onready var viewed_partner = false
@onready var viewed_news = false
@onready var viewed_team = false
@onready var viewed_missing = false
@onready var viewed_tool_note = false
@onready var viewing = ""
@onready var first_house = ""
#not quite sure if we need this one
#@onready var second_house = ""
@onready var has_secret = false
@onready var has_contact = false
@onready var current_level = ""
var player_pos
