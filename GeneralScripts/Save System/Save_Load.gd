extends Node

# Global
const SAVE_DIR = "user://savegame/"
const SAVE_FILE_NAME = "save.json"
const SECURITY_KEY = "hdksfa42442"

func _ready():
	verify_save_directory(SAVE_DIR)
	
func verify_save_directory(path : String):
	DirAccess.make_dir_absolute(path)

func saveGame(path: String):
	var file = FileAccess.open_encrypted_with_pass(path, FileAccess.WRITE, SECURITY_KEY)
	var data: Dictionary = {
		#Stores Variables
		"TheoPoints" : Dialogic.VAR.Theo,
		"MicahPoints": Dialogic.VAR.Micah,
		"JuniperPoints": Dialogic.VAR.Juniper,
		"QuincyPoints": Dialogic.VAR.Quincy,
		"SkylarPoints": Dialogic.VAR.Skylar,
		"first_house" : GlobalVars.first_house,
		"has_secret" : GlobalVars.has_secret,
		"has_contact" : GlobalVars.has_contact
		
	}
	var jstr = JSON.stringify((data))
	file.store_line(jstr)

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
