extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_firsthouse_button_pressed() -> void:
	var went_Micah = Dialogic.VAR.get_variable("Global.went_to_Micah")
	if went_Micah == true:
		if GlobalVars.day == "Day 1":
			#load Dalton thoughts to redirect to Juniper
			pass
		elif GlobalVars.day == "Day 2":
			#load Dalton thoughts to redirect to Quincy
			pass
		else:
			#load Dalton thoughts to redirect to endings or secret
			pass
	else:
		if GlobalVars.day == "Day 1":
			LoadManager.load_scene(GlobalVars.first_house_path)
	#get_tree().change_scene_to_file("res://FirstHouse/first_house.tscn")


func _on_secondhouse_button_pressed() -> void:
	var went_Juniper = Dialogic.VAR.get_variable("Global.went_to_Juniper")
	if went_Juniper == true:
		if GlobalVars.day == "Day 1":
			#load Dalton thoughts to redirect to Micah
			pass
		elif GlobalVars.day == "Day 2":
			#load Dalton thoughts to redirect to Quincy
			pass
		else:
			#load Dalton thoughts to redirect to endings or secret
			pass
	else:
		if GlobalVars.day == "Day 1":
			LoadManager.load_scene(GlobalVars.second_house_path)
	#get_tree().change_scene_to_file("res://SecondHouse/second_house.tscn")


func _on_thirdhouse_button_pressed() -> void:
	if GlobalVars.current_level == "Quincy":
		$Quincy.disabled = true
	else:
		$Quincy.disabled = false
	if GlobalVars.day == "Day 1":
		#Go to load dialogue and choice to redirect during load cutscene
		pass
	elif GlobalVars.day == "Day 3":
		#load Dalton thoughts to redirect to endings or secret
		pass
	else:
		LoadManager.load_scene(GlobalVars.third_house_path)
		#get_tree().change_scene_to_file("res://ThirdHouse/third_house.tscn")


func _on_office_button_pressed() -> void:
	LoadManager.load_scene(GlobalVars.office_path)
	#get_tree().change_scene_to_file("res://StartingOffice/starting_office.tscn")


func _on_secret_button_pressed() -> void:
	LoadManager.load_scene(GlobalVars.secret_path)
	#get_tree().change_scene_to_file("res://SecretLocation/secret_location.tscn")



func _on_exit_pressed():
	$".".hide()


func _on_check_day():
	if GlobalVars.current_level == "Micah":
		$Micah.disabled = true
	else:
		$Micah.disabled = false
	if GlobalVars.current_level == "Juniper":
		$Juniper.disabled = true
	else:
		$Juniper.disabled = false
	if GlobalVars.current_level == "Quincy":
		$Quincy.disabled = true
	else:
		$Quincy.disabled = false
	if GlobalVars.current_level == "Office":
		$Office.disabled = true
	else:
		$Office.disabled = false
	if GlobalVars.current_level == "Secret":
		$Secret.disabled = true
	else:
		$Secret.disabled = false
	var secret = Dialogic.VAR.get_variable("Quincy.has_secret_coor")
	if secret == true and GlobalVars.day == "Day 3":
		$"Secret Location".show()
	else:
		$"Secret Location".hide()
