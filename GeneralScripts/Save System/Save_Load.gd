extends Node

# Global
const SAVE_DIR = "user://savegame/"
const SAVE_FILE_NAME = "save.json"
const SECURITY_KEY = "hdksfa42442"

signal loaded

@onready var char_pos = {}
func _ready():
	verify_save_directory(SAVE_DIR)
	
func verify_save_directory(path : String):
	DirAccess.make_dir_absolute(path)

func saveGame(path: String):
	Dialogic.Save.save()
	#var file = FileAccess.open(path, FileAccess.WRITE)
	var file = FileAccess.open_encrypted_with_pass(path, FileAccess.WRITE, SECURITY_KEY)
	print(_get_char_pos())
	var chars_pos : Dictionary = _get_char_pos()
	
	var data: Dictionary = {
		"Globals":{
			"dialogue_flip" : GlobalVars.forward, 
			"game_day" : GlobalVars.day,
			"game_time": GlobalVars.time,
			"current_level": GlobalVars.current_level,
			"first_house": GlobalVars.first_house
		},
		"Phone":{
			"contact": GlobalVars.phone_contacts,
			"clock_time" : GlobalVars.clock_time,
			"micah_notes": GlobalVars.micah_notes,
			"juniper_notes": GlobalVars.juniper_notes,
			"quincy_notes": GlobalVars.quincy_notes,
			"evidence": GlobalVars.evidence_container,
	
		},
		"Office_Vars":{
			"theo_entrance" : GlobalVars.intro_dialogue,
			#contact
			"clicked_contact": GlobalVars.clicked_contact,
			"viewed_contact": GlobalVars.viewed_contact,
			"has_contact": GlobalVars.has_contact,
			#Isaac
			"clicked_partner": GlobalVars.clicked_partner,
			"viewed_partner": GlobalVars.viewed_partner,
			#News
			"clicked_news": GlobalVars.clicked_news,
			"viewed_news": GlobalVars.viewed_news,
			#team
			"clicked_team": GlobalVars.clicked_team,
			"viewed_team": GlobalVars.viewed_team,
			#missing
			"clicked_missing": GlobalVars.clicked_missing,
			"viewed_missing": GlobalVars.viewed_missing,
			#case
			"clicked_case_file": GlobalVars.clicked_case_file,
			"viewed_case_file": GlobalVars.viewed_case_file,
		},
		"Micah_Vars":{
			"micah_kicked_out" : GlobalVars.micah_kicked_out,
			"micah_time_out" : GlobalVars.micah_time_out,
			#closet
			"clicked_tool_note": GlobalVars.clicked_tool_note,
			"clicked_id_card": GlobalVars.clicked_id_card,
			"closet_dialogue": GlobalVars.closet_dialogue,
			"viewed_tool_note": GlobalVars.viewed_tool_note,
			"viewed_id_card": GlobalVars.viewed_id_card,
			#Bookshelf 
			"clicked_book_note": GlobalVars.clicked_book_note,
			"book_dialogue": GlobalVars.book_dialogue,
			"viewed_Micah_bookmark": GlobalVars.viewed_Micah_bookmark,
			#cabinet
			"clicked_cab": GlobalVars.clicked_cab,
			"opened_cab": GlobalVars.opened_cab,
			#picture
			"pic_fell": GlobalVars.pic_fell,
			"clicked_Micah_pic": GlobalVars.clicked_Micah_pic,
			"Micah_pic_dialogue": GlobalVars.Micah_pic_dialogue,
			"viewed_Micah_pic": GlobalVars.viewed_Micah_pic,
			#fridge
			"viewed_Micah_fridge": GlobalVars.viewed_Micah_fridge,
			#window
			"window_dialogue": GlobalVars.window_dialogue,
			"viewed_Micah_window": GlobalVars.viewed_Micah_window,
			#Micah_Case
			"opened_micah_case": GlobalVars.opened_micah_case,
			"Micah_in_case": GlobalVars.Micah_in_case,
			"clicked_case_Micah": GlobalVars.clicked_case_Micah,
			"clicked_case_letter_note": GlobalVars.clicked_case_letter_note,
			"viewed_Micah_letter": GlobalVars.viewed_Micah_letter,
			"viewed_Micah_key": GlobalVars.viewed_Micah_key,
			"viewed_Micah_hair": GlobalVars.viewed_Micah_hair,
		},
		"Juniper_Vars":{
			"juniper_kicked_out" : GlobalVars.juniper_kicked_out,
			"juniper_time_out" : GlobalVars.juniper_time_out,
			"in_tea_time" : GlobalVars.in_tea_time,
			#House
			"viewed_Juniper_house_pic": GlobalVars.viewed_Juniper_house_pic,
			"house_dialogue_Juniper": GlobalVars.house_dialogue_Juniper,
			#cafe
			"viewed_Juniper_cafe_pic": GlobalVars.viewed_Juniper_cafe_pic,
			"cafe_dialogue_Juniper": GlobalVars.cafe_dialogue_Juniper,
			#window
			"viewed_Juniper_window": GlobalVars.viewed_Juniper_window,
			"window_thoughts_Juniper": GlobalVars.window_thoughts_Juniper,
			#Resumes + Employee Info
			"viewed_Juniper_employee": GlobalVars.viewed_Juniper_employee,
			"viewed_Juniper_resume": GlobalVars.viewed_Juniper_resume,
			#"viewed_Juniper_empinfo": GlobalVars.viewed_Juniper_empinfo,
			"resume_dialogue_Juniper": GlobalVars.resume_dialogue_Juniper,
			"employee_dialogue_Juniper": GlobalVars.employee_dialogue_Juniper,
			"clicked_employee_Juniper": GlobalVars.clicked_employee_Juniper,
			"clicked_resume_Juniper": GlobalVars.clicked_resume_Juniper,
			#Med_bills
			"bills_dialogue_Juniper": GlobalVars.bills_dialogue_Juniper,
			"view_bills_juniper": GlobalVars.view_bills_juniper,
			"clicked_bills_Juniper": GlobalVars.clicked_bills_Juniper,
			#Cab2
			"pills_dialogue_Juniper": GlobalVars.pills_dialogue_Juniper,
			"pie_dialogue_Juniper": GlobalVars.pie_dialogue_Juniper,
			"viewed_pills_juniper": GlobalVars.viewed_pills_juniper,
			"viewed_pie_juniper": GlobalVars.viewed_pie_juniper,
			#Cab1
			"cran_dialogue_Juniper": GlobalVars.cran_dialogue_Juniper,
			"recipe_dialogue_Juniper": GlobalVars.recipe_dialogue_Juniper,
			"viewed_cran_juniper": GlobalVars.viewed_cran_juniper,
			"viewed_recipe_juniper": GlobalVars.viewed_recipe_juniper,
			"clicked_recipe_Juniper": GlobalVars.clicked_recipe_Juniper,
			#Juniper_Case
			"opened_jun_case": GlobalVars.opened_jun_case,
			"Juniper_in_case": GlobalVars.Juniper_in_case,
			"view_apron_juniper": GlobalVars.view_apron_juniper,
			"view_letter_juniper": GlobalVars.view_letter_juniper,
			"view_nametag_juniper": GlobalVars.view_nametag_juniper,
			"clicked_letter_Juniper": GlobalVars.clicked_letter_Juniper,
			"clicked_case_Juniper": GlobalVars.clicked_case_Juniper,
			"clicked_nametag_Juniper": GlobalVars.clicked_nametag_Juniper,
		},
		"Quincy_Vars":{
			"quincy_time_out" : GlobalVars.quincy_time_out,
			"quincy_kicked_out" : GlobalVars.quincy_kicked_out,
			"quincy_fainted" : GlobalVars.quincy_fainted,
			"Quincy_toilet_distracted" : GlobalVars.Quincy_toilet_distracted,
			"Quincy_Dalton_caught" : GlobalVars.Quincy_Dalton_caught,
			#fam_portrait 
			"viewed_Quincy_famPic": GlobalVars.viewed_Quincy_famPic,
			"famPic_dialogue_Quincy": GlobalVars.famPic_dialogue_Quincy,
			"viewed_Quincy_coor": GlobalVars.viewed_Quincy_coor,
			"coor_dialogue_Quincy": GlobalVars.coor_dialogue_Quincy,
			"clicked_coor_Quincy": GlobalVars.clicked_coor_Quincy,
			#fish
			"viewed_Quincy_fish": GlobalVars.viewed_Quincy_fish,
			"fish_dialogue_Quincy": GlobalVars.fish_dialogue_Quincy,
			#poker
			"viewed_Quincy_poker": GlobalVars.viewed_Quincy_poker,
			"poker_thoughts_Quincy": GlobalVars.poker_thoughts_Quincy,
			#journal
			"viewed_Juniper_employee": GlobalVars.viewed_Juniper_employee,
			"viewed_Juniper_resume": GlobalVars.viewed_Juniper_resume,
			"clicked_resume_Juniper": GlobalVars.clicked_resume_Juniper,
			#phone
			"viewed_Quincy_phone": GlobalVars.viewed_Quincy_phone,
			"phone_dialogue_Quincy": GlobalVars.phone_dialogue_Quincy,
			"clicked_phone_Quincy": GlobalVars.clicked_phone_Quincy,
			#bar
			"bar_dialogue_Quincy_finished": GlobalVars.bar_dialogue_Quincy_finished,
			#Office pic
			"viewed_Quincy_offPic": GlobalVars.viewed_Quincy_offPic,
			"clicked_offPic_Quincy": GlobalVars.clicked_offPic_Quincy,
			"offPic_dialogue_Quincy": GlobalVars.offPic_dialogue_Quincy,
			#computer
			"Quincy_in_computer": GlobalVars.Quincy_in_computer,
			#Safe
			"Quincy_Safe_UI": GlobalVars.Quincy_Safe_UI,
			"safe_dialogue_Quincy": GlobalVars.safe_dialogue_Quincy,
			"viewed_Quincy_bookmark": GlobalVars.viewed_Quincy_bookmark,
			"viewed_Quincy_pager": GlobalVars.viewed_Quincy_pager,
			"clicked_pager_Quincy": GlobalVars.clicked_pager_Quincy,
			"viewed_Quincy_news": GlobalVars.viewed_Quincy_news,
			"clicked_news_Quincy": GlobalVars.clicked_news_Quincy,
			"viewed_Quincy_usb": GlobalVars.viewed_Quincy_usb,
			"viewed_Quincy_proposal": GlobalVars.viewed_Quincy_proposal,
			"clicked_proposal_Quincy": GlobalVars.clicked_proposal_Quincy,
			#Quincy_Case"
			"Quincy_in_case": GlobalVars.Quincy_in_case,
			"opened_quincy_case": GlobalVars.opened_quincy_case,
			"viewed_Quincy_letter": GlobalVars.viewed_Quincy_letter,
			"viewed_Quincy_hammer": GlobalVars.viewed_Quincy_hammer,
			"clicked_case_Quincy": GlobalVars.clicked_case_Quincy,
			"clicked_letter_Quincy": GlobalVars.clicked_letter_Quincy,
			#chocolate
			"viewed_Quincy_chocolate": GlobalVars.viewed_Quincy_chocolate,
			"chocolate_dialogue": GlobalVars.chocolate_dialogue,
		},
		"Secret_Vars":{
			"has_secret" : GlobalVars.has_secret,
			#Cure
			"view_secret_cure": GlobalVars.view_secret_cure,
			#USB
			"view_secret_usb": GlobalVars.view_secret_usb,
			#Runa_letter
			"view_secret_runa_letter": GlobalVars.view_secret_runa_letter,
			"clicked_runa_letter": GlobalVars.clicked_runa_letter,
			#Isaac_Letter
			"view_secret_isaac_letter": GlobalVars.view_secret_isaac_letter,
			"clicked_isaac_letter": GlobalVars.clicked_isaac_letter,
		}
	}
	
	data["character_positions"] = chars_pos 
	var json_string = JSON.stringify(data, "\t", false)
	file.store_line(json_string)
	file.close()

func _get_char_pos():
	match GlobalVars.current_level:
		"Beginning":
			var split_dalton_pos : Dictionary = _split_pos_vector(GlobalVars.dalton_pos)
			return {"dalton_pos": split_dalton_pos}
		"Office":
			var split_dalton_pos : Dictionary = _split_pos_vector(GlobalVars.dalton_pos)
			var split_theo_pos : Dictionary = _split_pos_vector(GlobalVars.theo_pos)
			return {"dalton_pos": split_dalton_pos, "theo_pos" : split_theo_pos}
		"micah":
			var split_dalton_pos : Dictionary = _split_pos_vector(GlobalVars.dalton_pos)
			var split_theo_pos : Dictionary = _split_pos_vector(GlobalVars.theo_pos)
			var split_micah_pos : Dictionary = _split_pos_vector(GlobalVars.micah_pos)
			return {"dalton_pos": split_dalton_pos, "theo_pos" : split_theo_pos, "micah_pos" : split_micah_pos}
		"juniper":
			var split_dalton_pos : Dictionary = _split_pos_vector(GlobalVars.dalton_pos)
			var split_theo_pos : Dictionary = _split_pos_vector(GlobalVars.theo_pos)
			var split_juniper_pos : Dictionary = _split_pos_vector(GlobalVars.juniper_pos)
			return {"dalton_pos": split_dalton_pos, "theo_pos" : split_theo_pos, "juniper_pos" : split_juniper_pos}
		"quincy":
			var split_dalton_pos : Dictionary = _split_pos_vector(GlobalVars.dalton_pos)
			var split_theo_pos : Dictionary = _split_pos_vector(GlobalVars.theo_pos)
			var split_quincy_pos : Dictionary = _split_pos_vector(GlobalVars.quincy_pos)
			return {"dalton_pos": split_dalton_pos, "theo_pos" : split_theo_pos, "quincy_pos" : split_quincy_pos}
		"secret":
			var split_dalton_pos : Dictionary = _split_pos_vector(GlobalVars.dalton_pos)
			var split_theo_pos : Dictionary = _split_pos_vector(GlobalVars.theo_pos)
			return {"dalton_pos": split_dalton_pos, "theo_pos" : split_theo_pos}
		"Transition":
			var split_dalton_pos : Dictionary = _split_pos_vector(GlobalVars.dalton_pos)
			return {"dalton_pos": split_dalton_pos}
		"Flashback_day_1":
			var split_isaac_pos : Dictionary = _split_pos_vector(GlobalVars.isaac_pos)
			return {"isaac_pos": split_isaac_pos}
		"Flashback_day_2":
			return {}
		"interrogation":
			return {}
		"loading":
			return {}
	return {}
func _split_pos_vector(char_pos : Vector3):
	return {"x" : char_pos.x, "y" : char_pos.y, "z" : char_pos.z}
	
func _load_pos_vector(main_dic : Dictionary, char_pos_dic : String):
	var x_pos = float(main_dic["character_positions"][char_pos_dic]["x"])
	var y_pos = float(main_dic["character_positions"][char_pos_dic]["y"])
	var z_pos = float(main_dic["character_positions"][char_pos_dic]["z"])
	return Vector3(x_pos, y_pos, z_pos)
	
func _load_char_pos(main_dic : Dictionary):
	#print(main_dic["character_positions"])
	#print("From load" + str(typeof(_load_pos_vector(main_dic, "dalton_pos"))))
	match GlobalVars.current_level:
		"Beginning":
			var loaded_dalt_pos = _load_pos_vector(main_dic, "dalton_pos")
			GlobalVars.dalton_pos = loaded_dalt_pos
		"Office":
			var loaded_dalt_pos = _load_pos_vector(main_dic, "dalton_pos")
			var loaded_theo_pos = _load_pos_vector(main_dic, "theo_pos")
			GlobalVars.dalton_pos = loaded_dalt_pos
			GlobalVars.theo_pos = loaded_theo_pos
		"micah":
			var loaded_dalt_pos = _load_pos_vector(main_dic, "dalton_pos")
			var loaded_theo_pos = _load_pos_vector(main_dic, "theo_pos")
			var loaded_micah_pos = _load_pos_vector(main_dic, "micah_pos")
			GlobalVars.dalton_pos = loaded_dalt_pos
			GlobalVars.theo_pos = loaded_theo_pos
			GlobalVars.micah_pos = loaded_micah_pos 
		"juniper":
			var loaded_dalt_pos = _load_pos_vector(main_dic, "dalton_pos")
			var loaded_theo_pos = _load_pos_vector(main_dic, "theo_pos")
			var loaded_juniper_pos = _load_pos_vector(main_dic, "juniper_pos")
			GlobalVars.dalton_pos = loaded_dalt_pos
			GlobalVars.theo_pos = loaded_theo_pos
			GlobalVars.micah_pos = loaded_juniper_pos
		"quincy":
			var loaded_dalt_pos = _load_pos_vector(main_dic, "dalton_pos")
			var loaded_theo_pos = _load_pos_vector(main_dic, "theo_pos")
			var loaded_quincy_pos = _load_pos_vector(main_dic, "quincy_pos")
			GlobalVars.dalton_pos = loaded_dalt_pos
			GlobalVars.theo_pos = loaded_theo_pos
			GlobalVars.quincy_pos = loaded_quincy_pos
		"secret":
			var loaded_dalt_pos = _load_pos_vector(main_dic, "dalton_pos")
			var loaded_theo_pos = _load_pos_vector(main_dic, "theo_pos")
			GlobalVars.dalton_pos = loaded_dalt_pos
			GlobalVars.theo_pos = loaded_theo_pos
		"Transition":
			var loaded_dalt_pos = _load_pos_vector(main_dic, "dalton_pos")
			GlobalVars.dalton_pos = loaded_dalt_pos
		"Flashback_day_1":
			var loaded_isaac_pos = _load_pos_vector(main_dic, "isaac_pos")
			GlobalVars.isaac_pos = loaded_isaac_pos
		"Flashback_day_2":
			return 
		"interrogation":
			return 
		"loading":
			return
		_:
			return
	return
func loadGame(path : String):
	Dialogic.Save.load()
	if FileAccess.file_exists(path):
		#var file = FileAccess.open(path, FileAccess.WRITE)
		var file = FileAccess.open_encrypted_with_pass(path, FileAccess.READ, SECURITY_KEY)
		if file == null:
			printerr(FileAccess.get_open_error())
			return
		
		var content = file.get_as_text()
		file.close()
		
		var data = JSON.parse_string(content)
		if data == null:
			printerr("Cannot parse %s as a json_string : (%s)" % [path, content])
			return
		
		#load here
		_load_arr(data, "Globals", GlobalVars.load_global_name_arr)
		_load_arr(data, "Phone", GlobalVars.load_phone_name_arr)
		_load_arr(data, "Office_Vars", GlobalVars.load_Office_name_arr)
		_load_arr(data, "Micah_Vars", GlobalVars.load_Micah_name_arr)
		_load_arr(data, "Juniper_Vars", GlobalVars.load_Juniper_name_arr)
		_load_char_pos(data) #TO DEBUG
		
		emit_signal("loaded")
		
	else:
		printerr("Cannot open non_existent file at %s!" % [path])
		return


func _load_arr(main_dic: Dictionary, sub_dic: String, load_name : Array):
	if main_dic[sub_dic].size() != load_name.size():
		printerr("Mismatch load arr to dic size: " + str(load_name))
		return
	var accessed_dictionary = main_dic[sub_dic]
	var keyed_dic = accessed_dictionary.keys()
	for variable in range(load_name.size()):
		GlobalVars.set(load_name[variable], main_dic[sub_dic][keyed_dic[variable]]) 
	print_debug(sub_dic + " loaded successfully")


func clearSave(path : String):
	Dialogic.Save.delete_slot("Default")
	if FileAccess.file_exists(path):
		#var file = FileAccess.open(path, FileAccess.WRITE)
		var file = FileAccess.open_encrypted_with_pass(path, FileAccess.WRITE, SECURITY_KEY)
		if file == null:
			printerr("File does not exist" + str(FileAccess.get_open_error()))
			return
		file.store_string(JSON.stringify({}))
		print("length: " + str(file.get_length()))
		file.close()
		print("Save cleared successfully.")

func check_save_file_empty(path : String):
	#var file = FileAccess.open(path, FileAccess.WRITE)
	var file = FileAccess.open_encrypted_with_pass(path, FileAccess.READ, SECURITY_KEY)
	if file == null:
		printerr("File does not exist" + str(FileAccess.get_open_error()))
		return
	print(file.get_length())
	var is_empty = file.get_length() == 2
	file.close()
	return is_empty
