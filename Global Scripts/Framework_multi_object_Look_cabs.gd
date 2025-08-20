extends Node3D

#Assign first person cam and exit cam + idle animation
@export var FP_Cam: PhantomCamera3D
@export var Exit_Cam: PhantomCamera3D

#First Person cam anim + movement
@export var cam_anim: AnimationPlayer
@export var tilt_thres: int
@export var tilt_up_angle: Vector3
@export var tilt_down_angle: Vector3
#@export var mid_angle: Vector3
#@export var down_default: bool = false
#Assign player body
@export var player: CharacterBody3D
@export var alert: Sprite3D

#Assign character markers (up to 3)
@export var dalton_marker: Marker2D
@export var theo_marker: Marker2D
@export var character_marker: Marker2D

#Interaction Variables
@export var open_interact : Area2D
@export var close_interact_1 : Area2D
@export var close_interact_2 : Area2D
@export var interact_area_1: Area2D
@export var interact_area_2 : Area2D = null

@export var dialogue_file_1: String
@export var dialogue_file_2: String
@export var choice: String
@export var load_Dalton_dialogue: String
@export var load_Theo_dialogue: String
@export var load_char_dialogue: String

#Load Global Variables
@export var interact_type: String
@export var dialogue_1: String
@export var view_item_1: String

@export var dialogue_2: String
@export var view_item_2: String


@export var quick_exit: bool = false
#set defaults
@onready var mouse_pos = Vector2(0,0) 
@onready var is_open: bool = false
#set anims
@export var animation_tree : AnimationTree
@export var extra_animation: AnimationPlayer = null

@onready var cab_anim = false
@onready var tilt = ""

var kicked = false
var timed = false

#sound 
@export var close_cab_sound : AudioStreamPlayer3D
@export var open_cab_sound : AudioStreamPlayer3D
signal general_interact
signal general_quit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if extra_animation:
		extra_animation.play("RESET")
	

func _process(delta):
	var read_dialogue_1 : bool = GlobalVars.get(dialogue_1)
	var viewed_item_1 : bool = GlobalVars.get(view_item_1)
	var read_dialogue_2 : bool = GlobalVars.get(dialogue_2)
	var viewed_item_2 : bool = GlobalVars.get(view_item_2)
	
	if GlobalVars.current_level == "Quincy":
		kicked = GlobalVars.quincy_kicked_out
		timed = GlobalVars.quincy_time_out
	elif GlobalVars.current_level == "Juniper":
		kicked = GlobalVars.juniper_kicked_out
		timed = GlobalVars.juniper_time_out
	#var immediate_exit = quick_exit# Dialogic.VAR.get("Immediate Exit").Micah_cab # set to true in Dialogic
	#print(mouse_pos) 
	
	if GlobalVars.in_look_screen == false and GlobalVars.in_dialogue == false and GlobalVars.in_interaction == interact_type:
		mouse_pos = get_viewport().get_mouse_position()
		if mouse_pos.y >= tilt_thres:
			FP_Cam.set_rotation_degrees(tilt_up_angle)
			tilt = "down"
		elif mouse_pos.y < tilt_thres:
			FP_Cam.set_rotation_degrees(tilt_down_angle)
			tilt = "up"
		#mouse_pos = mouse_pos
		if tilt == "down" and cab_anim == false:
			FP_Cam.set_rotation_degrees(tilt_up_angle)
			interact_area_2.show()
			close_interact_1.hide()
			close_interact_2.hide()
			interact_area_1.hide()
			open_interact.hide()

		elif tilt == "up" and cab_anim == false:
			FP_Cam.set_rotation_degrees(tilt_down_angle)
			interact_area_2.hide()
			if GlobalVars.in_tea_time == false:
				if is_open == true:
					open_interact.hide()
					interact_area_1.show()
					close_interact_1.show()
					close_interact_2.show()
				else:
					open_interact.show()
					interact_area_1.hide()
					close_interact_1.hide()
					close_interact_2.hide()
			else:
				return

	if GlobalVars.in_look_screen == false and GlobalVars.in_dialogue == false and GlobalVars.in_interaction == interact_type and cab_anim == false:
		if kicked == false and timed == false and GlobalVars.in_tea_time == false:
			if Input.is_action_just_pressed("Exit") and viewed_item_1 == true and viewed_item_2 == true and read_dialogue_1 == false and read_dialogue_2 == false and GlobalVars.viewing == "":
				print("cab exit_3")
				print("V1 :" +  str(viewed_item_1))
				print("V2 :" +  str(viewed_item_2))
				print("D1 :" +  str(read_dialogue_1))
				print("D2 :" +  str(read_dialogue_2))
				print(GlobalVars.in_interaction)
				print(GlobalVars.viewing)
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
				Exit_Cam.set_tween_duration(0)
				FP_Cam.priority = 0
				Exit_Cam.priority = 30
				emit_signal("general_quit")
				#await get_tree().create_timer(.03).timeout
				cam_anim.play("RESET")
				player.show()
				var game_dialogue = Dialogic.start(choice)
				Dialogic.timeline_ended.connect(_on_timeline_ended)
				game_dialogue.register_character(load(load_Dalton_dialogue), dalton_marker)
				game_dialogue.register_character(load(load_Theo_dialogue), theo_marker)
				game_dialogue.register_character(load(load_char_dialogue), character_marker)
				GlobalVars.in_interaction = ""
				print("clear")
				GlobalVars.set(dialogue_1, true)
				GlobalVars.set(dialogue_2, true)
				interact_area_1.hide()
				interact_area_2.hide()
				open_interact.hide()
				close_interact_1.hide()
				close_interact_2.hide()
				alert.hide()
			elif Input.is_action_just_pressed("Exit") and read_dialogue_1 == false and GlobalVars.viewing == "" and ((viewed_item_1 == true and viewed_item_2 == false) or (viewed_item_1 == true and viewed_item_2 == true)):
				print("cab exit_1")
				print("V1 :" +  str(viewed_item_1))
				print("V2 :" +  str(viewed_item_2))
				print("D1 :" +  str(read_dialogue_1))
				print("D2 :" +  str(read_dialogue_2))
				print(GlobalVars.in_interaction)
				print(GlobalVars.viewing)
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
				Exit_Cam.set_tween_duration(0)
				FP_Cam.priority = 0
				Exit_Cam.priority = 30
				emit_signal("general_quit")
				#await get_tree().create_timer(.03).timeout
				cam_anim.play("RESET")
				player.show()
				var game_dialogue = Dialogic.start(dialogue_file_1)
				Dialogic.timeline_ended.connect(_on_timeline_ended)
				game_dialogue.register_character(load(load_Dalton_dialogue), dalton_marker)
				game_dialogue.register_character(load(load_Theo_dialogue), theo_marker)
				game_dialogue.register_character(load(load_char_dialogue), character_marker)
				GlobalVars.in_interaction = ""
				print("clear")
				GlobalVars.set(dialogue_1, true)
				interact_area_1.hide()
				interact_area_2.hide()
				open_interact.hide()
				close_interact_1.hide()
				close_interact_2.hide()
				alert.hide()
			elif Input.is_action_just_pressed("Exit") and read_dialogue_2 == false and GlobalVars.viewing == "" and ((viewed_item_1 == false and viewed_item_2 == true) or (viewed_item_1 == true and viewed_item_2 == true)):
				print("cab exit_2")
				print("V1 :" +  str(viewed_item_1))
				print("V2 :" +  str(viewed_item_2))
				print("D1 :" +  str(read_dialogue_1))
				print("D2 :" +  str(read_dialogue_2))
				print(GlobalVars.in_interaction)
				print(GlobalVars.viewing)
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
				Exit_Cam.set_tween_duration(0)
				FP_Cam.priority = 0
				Exit_Cam.priority = 30
				emit_signal("general_quit")
				#await get_tree().create_timer(.03).timeout
				cam_anim.play("RESET")
				player.show()
				var game_dialogue = Dialogic.start(dialogue_file_2)
				Dialogic.timeline_ended.connect(_on_timeline_ended)
				game_dialogue.register_character(load(load_Dalton_dialogue), dalton_marker)
				game_dialogue.register_character(load(load_Theo_dialogue), theo_marker)
				game_dialogue.register_character(load(load_char_dialogue), character_marker)
				GlobalVars.in_interaction = ""
				print("clear")
				GlobalVars.set(dialogue_2, true)
				interact_area_1.hide()
				interact_area_2.hide()
				open_interact.hide()
				close_interact_1.hide()
				close_interact_2.hide()
				alert.hide()
			elif Input.is_action_just_pressed("Exit") and GlobalVars.viewing == "":
				print("cab exit_4")
				print("V1 :" +  str(viewed_item_1))
				print("V2 :" +  str(viewed_item_2))
				print("D1 :" +  str(read_dialogue_1))
				print("D2 :" +  str(read_dialogue_2))
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
				Exit_Cam.set_tween_duration(0)
				FP_Cam.priority = 0
				Exit_Cam.priority = 30
				emit_signal("general_quit")
				cam_anim.play("RESET")
				player.show()
				player.start_player()
				#main_cam.set_tween_duration(1)
				GlobalVars.in_interaction = ""
				interact_area_1.hide()
				interact_area_2.hide()
				open_interact.hide()
				close_interact_1.hide()
				close_interact_2.hide()
				alert.show()
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			Exit_Cam.set_tween_duration(0)
			FP_Cam.priority = 0
			Exit_Cam.priority = 30
			emit_signal("general_quit")
			cam_anim.play("RESET")
			player.show()
			player.start_player()
			#main_cam.set_tween_duration(1)
			GlobalVars.in_interaction = ""
			alert.show()
			interact_area_1.hide()
			interact_area_2.hide()
			open_interact.hide()
			close_interact_1.hide()
			close_interact_2.hide()
			
	if GlobalVars.in_look_screen == true:
		interact_area_1.hide()
		interact_area_2.hide()
	elif GlobalVars.in_look_screen == false and FP_Cam.priority == 30 and is_open == true:
		if tilt == "up":
			interact_area_1.show()
		else:
			interact_area_2.show()

func _on_interactable_interacted(interactor: Interactor) -> void:
	if GlobalVars.in_dialogue == false and GlobalVars.in_interaction == "":
		emit_signal("general_interact")
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		alert.hide()
		GlobalVars.in_interaction = interact_type
		FP_Cam.priority = 30
		Exit_Cam.priority = 0 
		cam_anim.play("Cam_Idle")
		player.hide()
		player.stop_player()



func open() -> void:
	open_cab_sound.play()
	cab_anim = true
	animation_tree["parameters/conditions/is_opened"] = true
	animation_tree["parameters/conditions/is_closed"] = false
	is_open = true
	if extra_animation:
		extra_animation.play("Open")
		open_interact.hide()
		await extra_animation.animation_finished
		interact_area_1.show()
		await get_tree().create_timer(2.1).timeout
		close_interact_1.show()
		close_interact_2.hide()
		print(GlobalVars.viewing)
		cab_anim = false
		print("finished")
	else:
		open_interact.hide()
		interact_area_1.show()
		await get_tree().create_timer(2.1).timeout
		close_interact_1.show()
		close_interact_2.show()
		await get_tree().create_timer(.2).timeout
		cab_anim = false
	
func close() -> void:
	cab_anim = true
	animation_tree["parameters/conditions/is_closed"] = true
	animation_tree["parameters/conditions/is_opened"] = false
	is_open = false
	if extra_animation:
		extra_animation.play("Close")
		close_interact_1.hide()
		close_interact_2.hide()
		interact_area_1.hide()
		await get_tree().create_timer(1.0).timeout
		close_cab_sound.play()
		await get_tree().create_timer(1.1).timeout
		open_interact.show()
		await get_tree().create_timer(.2).timeout
		cab_anim = false
	else:
		close_interact_1.hide()
		close_interact_2.hide()
		interact_area_1.hide()
		await get_tree().create_timer(1.0).timeout
		close_cab_sound.play()
		await get_tree().create_timer(1.1).timeout
		open_interact.show()
		await get_tree().create_timer(.2).timeout
		cab_anim = false
	
	

func _on_dialogue1_ended():
	Dialogic.timeline_ended.disconnect(_on_dialogue1_ended)
	GlobalVars.in_dialogue = false
	player.start_player()
	alert.show()

func _on_dialogue2_ended():
	Dialogic.timeline_ended.disconnect(_on_dialogue2_ended)
	GlobalVars.in_dialogue = false
	player.start_player()
	alert.show()

func _on_timeline_ended():
	print("disconnect")
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	#print(Dialogic.timeline_ended.is_connected())
	GlobalVars.in_dialogue = false
	player.start_player()
	alert.show()

func _on_to_open_drawer_input_event(viewport, event, shape_idx):
	if GlobalVars.in_look_screen == false:
		if event is InputEventMouseButton:
			open()


func _on_cab_close_1_input_event(viewport, event, shape_idx):
		if GlobalVars.in_look_screen == false:
			if event is InputEventMouseButton:
				close()


func _on_cab_close_2_input_event(viewport, event, shape_idx):
		if GlobalVars.in_look_screen == false:
			if event is InputEventMouseButton:
				close()



func _on_input_event(viewport, event, shape_idx):
	var read_dialogue_1 : bool = GlobalVars.get(dialogue_1)
	var viewed_item_1 : bool = GlobalVars.get(view_item_1)
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed == true:
			print("click")
			if GlobalVars.in_look_screen == false and GlobalVars.in_dialogue == false and GlobalVars.in_interaction == interact_type and cab_anim == false:
				if quick_exit == true:
					print("pass")
					alert.hide()
					Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
					GlobalVars.in_dialogue = true
					FP_Cam.priority = 0
					Exit_Cam.priority = 30
					emit_signal("general_quit")
					await get_tree().create_timer(.03).timeout
					cam_anim.play("RESET")
					player.show()
					player.start_player()
					GlobalVars.in_interaction = ""
					var game_dialogue = Dialogic.start(dialogue_file_1)
					#Dialogic.VAR.get("Asked Questions").Micah_cab = 1
					Dialogic.timeline_ended.connect(_on_timeline_ended)
					game_dialogue.register_character(load(load_Dalton_dialogue), dalton_marker)
					game_dialogue.register_character(load(load_Theo_dialogue), theo_marker)
					game_dialogue.register_character(load(load_char_dialogue), character_marker)
					GlobalVars.in_interaction = ""
					GlobalVars.set(dialogue_1, true)
					GlobalVars.set(view_item_1, true)
					interact_area_1.hide()
					interact_area_2.hide()
					open_interact.hide()
					close_interact_1.hide()
					close_interact_2.hide()
					alert.hide()
