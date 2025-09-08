extends CanvasLayer

@export var micah : TextureButton
@export var juniper : TextureButton
@export var quincy : TextureButton
@export var office : TextureButton
@export var secret : TextureButton

var went_Micah : bool
var went_Juniper : bool
var went_Quincy : bool
var went_secret : bool
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_firsthouse_button_pressed() -> void:
	if GlobalVars.day == 1:
		if went_Juniper == true:
			Loading.load_scene(self, GlobalVars.first_house_path, true, "afternoon", "yes")
		else:
			if Dialogic.VAR.get_variable("Asked Questions.Micah_Asked_Theo_Question") == true:
				Loading.load_scene(self, GlobalVars.first_house_path, true, "morning", "yes_diner")
			else:
				Loading.load_scene(self, GlobalVars.first_house_path, true, "morning", "yes_diner")


func _on_secondhouse_button_pressed() -> void:
	if went_Micah == true:
		Loading.load_scene(self, GlobalVars.second_house_path, true, "afternoon", "yes")
	else:
		Loading.load_scene(self, GlobalVars.second_house_path, true, "morning", "yes")
	#get_tree().change_scene_to_file("res://SecondHouse/second_house.tscn")


func _on_thirdhouse_button_pressed() -> void:
	if GlobalVars.day == 1:
		#exit to phone call
		pass
	else:
		Loading.load_scene(self, GlobalVars.third_house_path, false, "", "")
		#get_tree().change_scene_to_file("res://ThirdHouse/third_house.tscn")


func _on_office_button_pressed() -> void:
	if GlobalVars.day == 1: 
		if went_Juniper and went_Micah == false:
			#thought to go to next house
			pass
		else:
			Loading.load_scene(self, GlobalVars.office_path, true, "night", "yes_day_1")
	if GlobalVars.day == 2: 
		Loading.load_scene(self, GlobalVars.office_path, true, "night", "yes_day_1")
	if GlobalVars.day == 2: 
		Loading.load_scene(self, GlobalVars.office_path, true, "afternoon", "yes_day_1")
	#get_tree().change_scene_to_file("res://StartingOffice/starting_office.tscn")


func _on_secret_button_pressed() -> void:
	Loading.load_scene(self, GlobalVars.secret_path, true, "morning", "yes_secret")
	#get_tree().change_scene_to_file("res://SecretLocation/secret_location.tscn")



func _on_exit_pressed():
	$".".hide()


func _on_check_day():
	went_Micah = Dialogic.VAR.get_variable("Global.went_to_Micah")
	went_Juniper = Dialogic.VAR.get_variable("Global.went_to_Juniper")
	went_Quincy = Dialogic.VAR.get_variable("Global.went_to_Quincy")
	went_Quincy = Dialogic.VAR.get_variable("Global.went_to_Quincy")
	if went_Juniper == true and juniper.disabled == false:
		juniper.disabled = true
	if went_Micah == true and micah.disabled == false:
		micah.disabled = true
	if went_Quincy == true and quincy.disabled == false:
		quincy.disabled = true
	if went_secret == true and secret.disabled == false:
		secret.disabled = true
	#if GlobalVars.current_level == "Micah":
		#micah.disabled = true
	#else:
		#micah.disabled = false
	#if GlobalVars.current_level == "Juniper":
		#juniper.disabled = true
	#else:
		#juniper.disabled = false
	#if GlobalVars.current_level == "Quincy":
		#quincy.disabled = true
	#else:
		#quincy.disabled = false
	if GlobalVars.current_level == "Office":
		office.disabled = true
	else:
		office.disabled = false
	
	#if GlobalVars.current_level == "Secret":
		#secret.disabled = true
	#else:
		#secret.disabled = false
	var secret_coor = Dialogic.VAR.get_variable("Quincy.has_secret_coor")
	if secret_coor == true and GlobalVars.day == 3:
		secret.show()
	else:
		secret.hide()


func _on_visibility_changed():
	if visible:
		_on_check_day()
