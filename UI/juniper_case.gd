extends CanvasLayer

@onready var case_ui = $"."
@onready var text_edit = $Label
@onready var password = "8008569420"

@export var case_cam: PhantomCamera3D
@export var main_cam: PhantomCamera3D
@export var player: CharacterBody3D
@export var alert: Sprite3D
#@onready var note_interaction = $Note
@export var cam_anim : AnimationPlayer

@export var interact_area_1 : Area2D
@export var interact_area_2 : Area2D
@export var interact_area_3 : Area2D
@export var interact_area_4 : Area2D

@export var dialogue_file: String
@export var load_Dalton_dialogue: String
@export var load_Theo_dialogue: String
@export var load_char_dialogue: String

@export var dalton_marker: Marker2D
@export var theo_marker: Marker2D
@export var character_marker: Marker2D

signal locked_sound
signal unlocked_sound

func key_press(num : int):
	if len(text_edit.text) <  10:
		text_edit.text += str(num)

func _on_zero_pressed():
	key_press(0)
	print("0")

func _on_one_pressed():
	key_press(1)
	print("1")

func _on_two_pressed():
	key_press(2)
	print("2")

func _on_three_pressed():
	key_press(3)
	print("3")

func _on_four_pressed():
	key_press(4)
	print("4")

func _on_five_pressed():
	key_press(5)
	print("5")

func _on_six_pressed():
	key_press(6)
	print("6")

func _on_seven_pressed():
	key_press(7)
	print("7")

func _on_eight_pressed():
	key_press(8)
	print("8")

func _on_nine_pressed():
	key_press(9)
	print("9")

func _on_x_pressed():
	text_edit.text = ""
	print("x")

func _on_enter_pressed():
	if text_edit.text == password:
		emit_signal("unlocked_sound")
		GlobalVars.open_juniper_case.connect(_open_case) 
		print("Open")
		GlobalVars.emit_open_jun_case()
		await get_tree().create_timer(1.5).timeout
		#print("opened case " + str(GlobalVars.opened_jun_case))
		text_edit.text = ""
	else:
		emit_signal("locked_sound")
		print("nu uh")
		text_edit.text = "xxxxxxxxxx"
		await get_tree().create_timer(1.5).timeout
		text_edit.text = ""
	print("enter")

	


func _open_case():
	GlobalVars.in_look_screen = false
	GlobalVars.Juniper_in_case = false
	case_ui.hide()
	#play anim
	$"../../SubViewportContainer/SubViewport/SecondHouseUpdate/Armature/Skeleton3D/topcase".hide()
	await get_tree().create_timer(.03).timeout
	GlobalVars.viewing = ""
	var case_interlude = Dialogic.VAR.get_variable("Character Aff Points.Juniper")
	var finished = Dialogic.VAR.get_variable("Juniper.Juniper_case_interlude_finished")
	if case_interlude > 1 and finished == false:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		GlobalVars.in_dialogue = true
		await get_tree().create_timer(1.5).timeout
		GlobalVars.in_interaction = ""
		case_cam.priority = 0
		main_cam.priority = 30
		cam_anim.play("RESET")
		player.show()
		var game_dialogue = Dialogic.start(dialogue_file)
		Dialogic.timeline_ended.connect(_on_timeline_ended)
		game_dialogue.register_character(load(load_Dalton_dialogue), dalton_marker)
		game_dialogue.register_character(load(load_Theo_dialogue), theo_marker)
		game_dialogue.register_character(load(load_char_dialogue), character_marker)
		#Dialogic.VAR.set_variable("Juniper.Juniper_case_interlude_finished", true)
	else:
		interact_area_1.show()
		interact_area_2.show()
		interact_area_3.show()
		interact_area_4.show()
	GlobalVars.open_juniper_case.disconnect(_open_case)

func _on_timeline_ended():
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	GlobalVars.in_dialogue = false
	if GlobalVars.Juniper_in_case == false:
		player.start_player()
		alert.show()
