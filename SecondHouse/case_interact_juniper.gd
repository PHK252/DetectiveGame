extends Node3D

@onready var case_cam = $"../../CaseCam"
@onready var main_cam = $"../../CamWindows"
@onready var player = $"../../../../../Characters/Dalton/CharacterBody3D"
@onready var cam_anim = $"../../CaseCam/AnimationPlayer"
@onready var mouse_pos = Vector2(0,0) 
@onready var case_interact = $"../../../../../UI/Case"

@onready var dalton_maker = $"../../../../../UI/Dalton Marker"
@onready var juniper_marker = $"../../../../../UI/Juniper Marker"
#@onready var theo_marker = $"../../../../../UI/Theo Marker"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	mouse_pos = get_viewport().get_mouse_position()
	#print(mouse_pos) 
	if GlobalVars.in_look_screen == false and GlobalVars.in_dialogue == false:
		if mouse_pos.y >= 130:
			case_cam.set_rotation_degrees(Vector3(-90, 0, 0))
		elif mouse_pos.y < 45:
			case_cam.set_rotation_degrees(Vector3(-70, 0, 0))
		else:
			case_cam.set_rotation_degrees(Vector3(-80, 0, 0))
	else:
		case_cam.set_rotation_degrees(Vector3(-80, 0, 0))
	
	if GlobalVars.in_look_screen == false and GlobalVars.in_dialogue == false and GlobalVars.in_interaction == "case":
		if Input.is_action_just_pressed("Exit") and GlobalVars.viewed_Juniper_case == true and GlobalVars.case_dialogue_Juniper == false and GlobalVars.viewing == "":
			GlobalVars.in_dialogue = true
			case_cam.priority = 0
			main_cam.priority = 12
			await get_tree().create_timer(.03).timeout
			cam_anim.play("RESET")
			player.show()
			var case_dialogue = Dialogic.start("Juniper_Case")
			Dialogic.timeline_ended.connect(_on_timeline_ended)
			case_dialogue.register_character(load("res://Dialogic Characters/Dalton.dch"), dalton_maker)
			case_dialogue.register_character(load("res://Dialogic Characters/Juniper.dch"), juniper_marker)
			GlobalVars.in_interaction = ""
			GlobalVars.case_dialogue_Juniper = true
			case_interact.hide()
		elif Input.is_action_just_pressed("Exit") and GlobalVars.viewing == "":
			print("enter")
			case_cam.priority = 0
			main_cam.priority = 12
			await get_tree().create_timer(.03).timeout
			cam_anim.play("RESET")
			player.show()
			player.start_player()
			GlobalVars.in_interaction = ""
			case_interact.hide()
			
			#activate dialogue

	if GlobalVars.in_look_screen == true:
		case_interact.hide()
	elif GlobalVars.in_look_screen == false and case_cam.priority == 15:
		case_interact.show()


func _on_timeline_ended():
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	GlobalVars.in_dialogue = false
	player.start_player()

func _on_case_interacted(interactor):
	if GlobalVars.in_look_screen == false:
		GlobalVars.in_interaction = "case"
		case_cam.priority = 15
		main_cam.priority = 0 
		case_interact.show()
		cam_anim.play("Cam_Idle")
		player.hide()
		player.stop_player()
