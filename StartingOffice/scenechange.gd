extends CanvasLayer

@export var micah : TextureButton
@export var juniper : TextureButton
@export var quincy : TextureButton
@export var office : TextureButton
@export var secret : TextureButton

@export var map_cam : PhantomCamera3D
@export var exit_cam : PhantomCamera3D
@export var player : CharacterBody3D
@export var dalton_marker : Marker2D
@export var theo_marker : Marker2D
@export var alert : Sprite3D

var went_Micah : bool
var went_Juniper : bool
var went_Quincy : bool
var went_secret : bool

signal Quincy_call_recieve
signal _show_tut(tut_type : String)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_firsthouse_button_pressed() -> void:
	GlobalVars.in_look_screen = false
	if GlobalVars.day == 1:
		if went_Juniper == true:
			Loading.load_scene(self, GlobalVars.first_house_path, true, "afternoon", Loading.choose_drive_dialogue())
			player.start_player()
			GlobalVars.in_interaction = ""
		else:
			Loading.load_scene(self, GlobalVars.first_house_path, true, "morning", Loading.choose_drive_dialogue())
			player.start_player()
		GlobalVars.in_interaction = ""


func _on_secondhouse_button_pressed() -> void:
	GlobalVars.in_look_screen = false
	if went_Micah == true:
		Loading.load_scene(self, GlobalVars.second_house_path, true, "afternoon", Loading.choose_drive_dialogue())
		player.start_player()
		GlobalVars.in_interaction = ""
	else:
		Loading.load_scene(self, GlobalVars.second_house_path, true, "morning", Loading.choose_drive_dialogue())
		player.start_player()
		GlobalVars.in_interaction = ""


func _on_thirdhouse_button_pressed() -> void:
	GlobalVars.in_look_screen = false
	if GlobalVars.day == 1:
		if GlobalVars.Day_1_Quincy_call == false:
			map_cam.priority = 0
			exit_cam.priority = 30
			emit_signal("Quincy_call_recieve")
			if GlobalVars.phone_tut == false:
				emit_signal("_show_tut", "phone")
			visible = false
			player.show()
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			return
	else:
		Loading.load_scene(self, GlobalVars.third_house_path, true, "morning", Loading.choose_drive_dialogue())
		player.start_player()
		#get_tree().change_scene_to_file("res://ThirdHouse/third_house.tscn")


func _on_office_button_pressed() -> void:
	#print("office_pressed")
	if GlobalVars.day == 1: 
		if went_Juniper == false or went_Micah == false:
			#thought to go to next house
			pass
		else:
			GlobalVars.in_look_screen = false
			Loading.load_scene(self, GlobalVars.office_path, true, "night", Loading.choose_drive_dialogue())
			player.start_player()
			GlobalVars.in_interaction = ""
	if GlobalVars.day == 2: 
		GlobalVars.in_look_screen = false
		Loading.load_scene(self, GlobalVars.office_path, true, "night", Loading.choose_drive_dialogue())
		player.start_player()
		GlobalVars.in_interaction = ""
	if GlobalVars.day == 3: 
		GlobalVars.in_look_screen = false
		Loading.load_scene(self, GlobalVars.office_path, true, "afternoon", Loading.choose_drive_dialogue())
		player.start_player()
		GlobalVars.in_interaction = ""
	#get_tree().change_scene_to_file("res://StartingOffice/starting_office.tscn")


func _on_secret_button_pressed() -> void:
	GlobalVars.in_look_screen = false
	Loading.load_scene(self, GlobalVars.secret_path, true, "morning", Loading.choose_drive_dialogue())
	player.start_player()
	GlobalVars.in_interaction = ""
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
		juniper.mouse_default_cursor_shape = Control.CURSOR_ARROW
	if went_Micah == true and micah.disabled == false:
		micah.disabled = true
		micah.mouse_default_cursor_shape = Control.CURSOR_ARROW
	if went_Quincy == true and quincy.disabled == false:
		quincy.disabled = true
		quincy.mouse_default_cursor_shape = Control.CURSOR_ARROW
	if went_secret == true and secret.disabled == false:
		secret.disabled = true
		secret.mouse_default_cursor_shape = Control.CURSOR_ARROW
	if GlobalVars.Day_1_Quincy_call == true:
		if GlobalVars.day == 1:
			quincy.visible = false
		else:
			quincy.visible = true
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
		office.mouse_default_cursor_shape = Control.CURSOR_ARROW
	else:
		office.disabled = false
		office.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	
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
		micah.button_pressed = false
		juniper.button_pressed = false
		quincy.button_pressed = false
		office.button_pressed = false
		secret.button_pressed = false
		_on_check_day()


func _on_Quincy_call_start_dialogue():
	GlobalVars.in_dialogue = true
	Dialogic.timeline_ended.connect(_on_timeline_ended)
	var layout = Dialogic.start("Day_1_Quincy_Call")
	layout.register_character(load("res://Dialogic Characters/Dalton.dch"), dalton_marker)
	layout.register_character(load("res://Dialogic Characters/Quincy.dch"), dalton_marker)
	layout.register_character(load("res://Dialogic Characters/Theo.dch"), theo_marker)

func _on_timeline_ended():
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	GlobalVars.in_call = true
	player.start_player()
	#alert.show()
	GlobalVars.in_dialogue = false
	GlobalVars.in_interaction = ""

func _on_Quincy_declined_call():
	player.start_player()
	GlobalVars.in_interaction = ""
	pass # Replace with function body.
