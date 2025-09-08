extends Node

# Global
const SAVE_DIR = "user://savegame/"
const SAVE_FILE_NAME = "save.json"
const SECURITY_KEY = "hdksfa42442"

@onready var char_pos = {}
func _ready():
	verify_save_directory(SAVE_DIR)
	
func verify_save_directory(path : String):
	DirAccess.make_dir_absolute(path)

func saveGame(path: String):
	var file = FileAccess.open_encrypted_with_pass(path, FileAccess.WRITE, SECURITY_KEY)
	var data: Dictionary = {
		
		#"Character_positions": {
				#"dalton_pos" : dalton.global_position,
		#}
		"Globals":{
			"dialogue_flip" : GlobalVars.forward, 
			"game_day" : GlobalVars.day,
			"game_time": GlobalVars.time,
			"current_level": GlobalVars.current_level,
			"first_house": GlobalVars.first_house
		},
		"Phone":{
			"contact": GlobalVars.phone_contacts,
			"micah_notes": GlobalVars.micah_notes,
			"juniper_notes": GlobalVars.juniper_notes,
			"quincy_notes": GlobalVars.quincy_notes,
			"evidence": GlobalVars.evidence_container,
		},
		"Office_Vars":{
			"theo_entrance" : GlobalVars.intro_dialogue,
			"contact":{
				"clicked_contact": GlobalVars.clicked_contact,
				"viewed_contact": GlobalVars.viewed_contact,
				"has_contact": GlobalVars.has_contact,
			},
			"Isaac":{
				"clicked_partner": GlobalVars.clicked_partner,
				"viewed_partner": GlobalVars.viewed_partner,
			},
			"News":{
				"clicked_news": GlobalVars.clicked_news,
				"viewed_news": GlobalVars.viewed_news,
			},
			"Team":{
				"clicked_team": GlobalVars.clicked_team,
				"viewed_team": GlobalVars.viewed_team,
			},
			"Missing":{
				"clicked_missing": GlobalVars.clicked_missing,
				"viewed_missing": GlobalVars.viewed_missing,
			},
			"Case_file":{
				"clicked_case_file": GlobalVars.clicked_case_file,
				"viewed_case_file": GlobalVars.viewed_case_file,
			},
		},
		"Micah_Vars":{
			"micah_kicked_out" : GlobalVars.micah_kicked_out,
			"micah_time_out" : GlobalVars.micah_time_out,
			"closet":{
				"clicked_tool_note": GlobalVars.clicked_tool_note,
				"clicked_id_card": GlobalVars.clicked_id_card,
				"closet_dialogue": GlobalVars.closet_dialogue,
				"viewed_tool_note": GlobalVars.viewed_tool_note,
				"viewed_id_card": GlobalVars.viewed_id_card,
			},
			"bookshelf":{
				"clicked_book_note": GlobalVars.clicked_book_note,
				"book_dialogue": GlobalVars.book_dialogue,
				"viewed_Micah_bookmark": GlobalVars.viewed_Micah_bookmark,
			},
			"cabinet":{
				"clicked_cab": GlobalVars.clicked_cab,
				"opened_cab": GlobalVars.opened_cab,
			},
			"picture":{
				"pic_fell": GlobalVars.pic_fell,
				"clicked_Micah_pic": GlobalVars.clicked_Micah_pic,
				"Micah_pic_dialogue": GlobalVars.Micah_pic_dialogue,
				"viewed_Micah_pic": GlobalVars.viewed_Micah_pic,
			},
			"fridge":{
				"viewed_Micah_fridge": GlobalVars.viewed_Micah_fridge,
			},
			"window":{
				"window_dialogue": GlobalVars.window_dialogue,
				"viewed_Micah_window": GlobalVars.viewed_Micah_window,
			},
			"Micah_Case":{
				"opened_micah_case": GlobalVars.opened_micah_case,
				"Micah_in_case": GlobalVars.Micah_in_case,
				"clicked_case_Micah": GlobalVars.clicked_case_Micah,
				"clicked_case_letter_note": GlobalVars.clicked_case_letter_note,
				"viewed_Micah_letter": GlobalVars.viewed_Micah_letter,
				"viewed_Micah_key": GlobalVars.viewed_Micah_key,
				"viewed_Micah_hair": GlobalVars.viewed_Micah_hair,
			},
		},
		"Juniper_Vars":{
			"juniper_kicked_out" : GlobalVars.juniper_kicked_out,
			"juniper_time_out" : GlobalVars.juniper_time_out,
			"in_tea_time" : GlobalVars.in_tea_time,
			"House":{
				"viewed_Juniper_house_pic": GlobalVars.viewed_Juniper_house_pic,
				"house_dialogue_Juniper": GlobalVars.house_dialogue_Juniper,
			},
			"cafe":{
				"viewed_Juniper_cafe_pic": GlobalVars.viewed_Juniper_cafe_pic,
				"cafe_dialogue_Juniper": GlobalVars.cafe_dialogue_Juniper,
			},
			"window":{
				"viewed_Juniper_window": GlobalVars.viewed_Juniper_window,
				"window_thoughts_Juniper": GlobalVars.window_thoughts_Juniper,
			},
			"Resumes + Employee Info":{
				"viewed_Juniper_employee": GlobalVars.viewed_Juniper_employee,
				"viewed_Juniper_resume": GlobalVars.viewed_Juniper_resume,
				#"viewed_Juniper_empinfo": GlobalVars.viewed_Juniper_empinfo,
				"resume_dialogue_Juniper": GlobalVars.resume_dialogue_Juniper,
				"employee_dialogue_Juniper": GlobalVars.employee_dialogue_Juniper,
				"clicked_employee_Juniper": GlobalVars.clicked_employee_Juniper,
				"clicked_resume_Juniper": GlobalVars.clicked_resume_Juniper,
			},
			"Med_bills":{
				"bills_dialogue_Juniper": GlobalVars.bills_dialogue_Juniper,
				"view_bills_juniper": GlobalVars.view_bills_juniper,
				"clicked_bills_Juniper": GlobalVars.clicked_bills_Juniper,
			},
			"Cab2":{
				"pills_dialogue_Juniper": GlobalVars.pills_dialogue_Juniper,
				"pie_dialogue_Juniper": GlobalVars.pie_dialogue_Juniper,
				"viewed_pills_juniper": GlobalVars.viewed_pills_juniper,
				"viewed_pie_juniper": GlobalVars.viewed_pie_juniper,
			},
			"Cab1":{
				"cran_dialogue_Juniper": GlobalVars.cran_dialogue_Juniper,
				"recipe_dialogue_Juniper": GlobalVars.recipe_dialogue_Juniper,
				"viewed_cran_juniper": GlobalVars.viewed_cran_juniper,
				"viewed_recipe_juniper": GlobalVars.viewed_recipe_juniper,
				"clicked_recipe_Juniper": GlobalVars.clicked_recipe_Juniper,
			},
			"Juniper_Case":{
				"opened_jun_case": GlobalVars.opened_jun_case,
				"Juniper_in_case": GlobalVars.Juniper_in_case,
				"view_apron_juniper": GlobalVars.view_apron_juniper,
				"view_letter_juniper": GlobalVars.view_letter_juniper,
				"view_nametag_juniper": GlobalVars.view_nametag_juniper,
				"clicked_letter_Juniper": GlobalVars.clicked_letter_Juniper,
				"clicked_case_Juniper": GlobalVars.clicked_case_Juniper,
				"clicked_nametag_Juniper": GlobalVars.clicked_nametag_Juniper,
			},
		},
		#Quincy's here
		"Secret_Vars":{
			"has_secret" : GlobalVars.has_secret,
			"Cure":{
				"view_secret_cure": GlobalVars.view_secret_cure,
			},
			"USB":{
				"view_secret_usb": GlobalVars.view_secret_usb,
			},
			"Runa_letter":{
				"view_secret_runa_letter": GlobalVars.view_secret_runa_letter,
				"clicked_runa_letter": GlobalVars.clicked_runa_letter,
			},
			"Isaac_Letter":{
				"view_secret_runa_letter": GlobalVars.view_secret_runa_letter,
				"clicked_runa_letter": GlobalVars.clicked_runa_letter,
			},
		}
			
		
	}
	var jstr = JSON.stringify((data))
	file.store_line(jstr)

func _get_char_pos():
	match GlobalVars.current_level:
		"Beginning":
			#get Dalton pos
			return
		"Office":
			#get Dalton pos
			#get Theo pos
			return
		"micah":
			#get Dalton pos
			#get Theo pos
			#get micah pos
			return
		"juniper":
			#get Dalton pos
			#get Theo pos
			#get juniper
			return
		"quincy":
			#get Dalton pos
			#get Theo pos
			#get quincy
			return
		"secret":
			#get Dalton pos
			#get Theo pos
			#get Skylar
			return
		"Transition":
			#get Dalton pos
			return
		"Flashback_day_1":
			#get Isaac pos
			return
		"Flashback_day_2":
			return
		"interrogation":
			return
			
func loadGame():
	print("load")
	var file = FileAccess.open(SAVE_DIR, FileAccess.READ)
	if FileAccess.file_exists(SAVE_DIR) == true:
		if not file.eof_reached():
			var current_line = JSON.parse_string(file.get_line())
			if current_line:
				#Calls Variables
				
				Dialogic.VAR.Theo = current_line["TheoPoints"]
				Dialogic.VAR.Micah = current_line["MicahPoints"]
				Dialogic.VAR.Juniper = current_line["JuniperPoints"]
				Dialogic.VAR.Quincy = current_line["QuincyPoints"]
				Dialogic.VAR.Skylar = current_line["SkylarPoints"]
				GlobalVars.first_house = current_line["first_house"]
				GlobalVars.has_secret = current_line["has_secret"]
				GlobalVars.has_contact = current_line["has_contact"]
				pass

func clearSave():
	#Reset to Default
	
	#Inventory.flower = false
	#Inventory.string = false
	#Inventory.batteries = false
	#Inventory.has_anything = false
	#Inventory.unlock_fourth = false
	#LevelManager.level1_complete = false
	#LevelManager.level2_complete = false
	#LevelManager.level3_complete = false
	#EndingManager.ending1 = false
	#EndingManager.ending2 = false
	#EndingManager.ending3 = false
	#EndingManager.ending4 = false
	#print("clear")
	saveGame(SAVE_DIR)
