extends CanvasLayer

@export var main : Node
@export var micah : TextureButton
@export var juniper : TextureButton
@export var quincy : TextureButton
@export var office : TextureButton
@export var secret : TextureButton

@export var map_cam : PhantomCamera3D
@export var exit_cam : PhantomCamera3D
@export var player : CharacterBody3D
#@export var dalton_marker : Marker2D
#@export var theo_marker : Marker2D
@export var alert : Sprite3D
@export var music : AudioStreamPlayer
var went_Micah : bool
var went_Juniper : bool
var went_Quincy : bool
var went_secret : bool

signal Quincy_call_recieve
signal _show_tut(tut_type : String)
signal select_level_sound
signal leave_map_sound
signal hide_player
@export var car_rev : AudioStreamPlayer3D
#@onready var micah_label = $"Micah Label"
#@onready var juniper_label = $"Juniper Label"
#@onready var quincy_label = $"Quincy Label"
#@onready var office_label = $"Office Label"
#@onready var coors = $Coors

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _on_firsthouse_button_pressed() -> void:
	emit_signal("select_level_sound")
	if car_rev:
		car_rev.play()
	GlobalVars.in_look_screen = false
	if GlobalVars.day == 1:
		if went_Juniper == true or Dialogic.VAR.get_variable("Global.first_house") == "Juniper":
			GlobalVars.in_interaction = ""
			player.start_player()
			GlobalVars.time = "afternoon"
			#Loading.load_scene(main, GlobalVars.first_house_path, "driving", "afternoon", "Day_1_ride_from_TG")
			Loading.load_scene(main, GlobalVars.first_house_path, "driving", "afternoon", Loading.choose_drive_dialogue())
		else:
			GlobalVars.in_interaction = ""
			player.start_player()
			Loading.load_scene(main, GlobalVars.first_house_path, "driving", "morning", Loading.choose_drive_dialogue())
			
			


func _on_secondhouse_button_pressed() -> void:
	emit_signal("select_level_sound")
	if car_rev:
		car_rev.play()
	GlobalVars.in_look_screen = false
	if went_Micah == true or Dialogic.VAR.get_variable("Global.first_house") == "Micah":
		GlobalVars.in_interaction = ""
		player.start_player()
		GlobalVars.time = "afternoon"
		Loading.load_scene(main, GlobalVars.second_house_path, "driving", "afternoon", Loading.choose_drive_dialogue())
	else:
		GlobalVars.in_interaction = ""
		player.start_player()
		Loading.load_scene(main, GlobalVars.second_house_path, "driving", "morning", Loading.choose_drive_dialogue())
		
		


func _on_thirdhouse_button_pressed() -> void:
	emit_signal("select_level_sound")
	
	GlobalVars.in_look_screen = false
	if GlobalVars.day == 1:
		if GlobalVars.Day_1_Quincy_call == false:
			emit_signal("hide_player")
			GlobalVars.in_interaction = ""
			map_cam.priority = 0
			exit_cam.priority = 30
			emit_signal("Quincy_call_recieve")
			if GlobalVars.phone_tut == false:
				emit_signal("_show_tut", "phone")
			visible = false
			player.show()
			alert.hide()
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			return
	else:
		if car_rev:
			car_rev.play()
		GlobalVars.in_interaction = ""
		player.start_player()
		Loading.load_scene(main, GlobalVars.third_house_path, "driving", "morning", Loading.choose_drive_dialogue())
		
		#get_tree().change_scene_to_file("res://ThirdHouse/third_house.tscn")


func _on_office_button_pressed() -> void:
	#print("office_pressed")
	emit_signal("select_level_sound")
	if car_rev:
		car_rev.play()
	match GlobalVars.day:
		1: 
			GlobalVars.time = "night"
			GlobalVars.in_look_screen = false
			Loading.load_scene(main, GlobalVars.office_path, "driving", "night", Loading.choose_drive_dialogue())
			player.start_player()
			GlobalVars.in_interaction = ""
		2: 
			GlobalVars.time = "night"
			GlobalVars.in_look_screen = false
			Loading.load_scene(main, GlobalVars.office_path, "driving", "night", Loading.choose_drive_dialogue())
			player.start_player()
			GlobalVars.in_interaction = ""
		3: 
			GlobalVars.in_look_screen = false
			GlobalVars.time = "afternoon"
			Loading.load_scene(main, GlobalVars.office_path, "driving", "afternoon", Loading.choose_drive_dialogue())
			player.start_player()
			GlobalVars.in_interaction = ""
	#get_tree().change_scene_to_file("res://StartingOffice/starting_office.tscn")


func _on_secret_button_pressed() -> void:
	emit_signal("select_level_sound")
	if car_rev:
		car_rev.play()
	GlobalVars.in_look_screen = false
	GlobalVars.in_interaction = ""
	player.start_player()
	Loading.load_scene(main, GlobalVars.secret_path, "driving", "morning", Loading.choose_drive_dialogue())
	
	
	#get_tree().change_scene_to_file("res://SecretLocation/secret_location.tscn")



func _on_exit_pressed():
	emit_signal("leave_map_sound")
	$".".hide()


func _on_check_day():
	went_Micah = Dialogic.VAR.get_variable("Global.went_to_Micah")
	went_Juniper = Dialogic.VAR.get_variable("Global.went_to_Juniper")
	went_Quincy = Dialogic.VAR.get_variable("Global.went_to_Quincy")
	went_secret = Dialogic.VAR.get_variable("Global.went_to_secret")
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
	if (went_Juniper == true and went_Micah == true and GlobalVars.day == 1) or (went_Quincy == true and GlobalVars.day == 2) or (went_secret == true and GlobalVars.day == 3):
		office.disabled = false
		office.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	else:
		office.disabled = true
		office.mouse_default_cursor_shape = Control.CURSOR_ARROW
	
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
		#micah.button_pressed = false
		#juniper.button_pressed = false
		#quincy.button_pressed = false
		#office.button_pressed = false
		#secret.button_pressed = false
		_on_check_day()


func _on_Quincy_call_start_dialogue():
	GlobalVars.in_dialogue = true
	Dialogic.timeline_ended.connect(_on_timeline_ended)
	Dialogic.start("Day_1_Quincy_Call")

func _on_timeline_ended():
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	GlobalVars.in_call = true
	player.start_player()
	alert.show()
	GlobalVars.in_dialogue = false
	GlobalVars.in_interaction = ""


#func _on_micah_mouse_entered():
	#if micah.disabled == false:
		#micah_label.show()
#
#
#func _on_micah_mouse_exited():
	#if micah.disabled == false:
		#micah_label.hide()
#
#
#func _on_office_mouse_entered():
	#if office.disabled == false:
		#office_label.show()
#
#
#func _on_office_mouse_exited():
	#if office.disabled == false:
		#office_label.hide()
#
#
#func _on_juniper_mouse_entered():
	#if juniper.disabled == false:
		#juniper_label.show()
#
#
#func _on_juniper_mouse_exited():
	#if juniper.disabled == false:
		#juniper_label.hide()
#
#func _on_quincy_mouse_entered():
	#if quincy.disabled == false:
		#quincy_label.show()
#
#
#func _on_quincy_mouse_exited():
	#if quincy.disabled == false:
		#quincy_label.hide()
#
#
#
#func _on_secret_mouse_entered():
	#if secret.disabled == false:
		#coors.show()
#
#
#func _on_secret_mouse_exited():
	#if secret.disabled == false:
		#coors.hide()
