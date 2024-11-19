extends Node3D

@onready var closet_cam = $"../SubViewportContainer/SubViewport/CameraSystem/Closet close up"
@onready var main_cam = $"../SubViewportContainer/SubViewport/CameraSystem/closet"
@onready var player = $"../Characters/Dalton/CharacterBody3D"
@onready var closet_anim = $newcloset_animated/AnimationPlayer
@onready var note_interaction = $Note
@onready var cam_anim = $"../SubViewportContainer/SubViewport/CameraSystem/Closet close up/AnimationPlayer"
@onready var mouse_pos = Vector2(0,0)
@onready var closet_open = false
@export var collision : CollisionShape3D
@export var collision2 : CollisionShape3D

@onready var dalton_maker = $"../UI/Dalton_marker"
@onready var micah_marker = $"../UI/Micah_marker"
@onready var theo_marker = $"../UI/Theo_marker"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	mouse_pos = get_viewport().get_mouse_position()
	#print(mouse_pos) 
	if GlobalVars.in_look_screen == false and GlobalVars.in_dialogue == false:
		if mouse_pos.y >= 700:
			closet_cam.set_rotation_degrees(Vector3(-25, 93.8, 1.4))
		elif mouse_pos.y < 120:
			closet_cam.set_rotation_degrees(Vector3(-5, 93.8, 1.4))
		else:
			closet_cam.set_rotation_degrees(Vector3(-15, 93.8, 1.4))
				#pass
	else:
		closet_cam.set_rotation_degrees(Vector3(-25, 93.8, 1.4))

	if GlobalVars.in_look_screen == false and GlobalVars.in_dialogue == false and GlobalVars.in_interaction == "closet":
		if Input.is_action_just_pressed("Exit") and GlobalVars.viewed_tool_note == true and GlobalVars.closet_dialogue == false:
			main_cam.set_tween_duration(0)
			closet_cam.priority = 0
			main_cam.priority = 12
			await get_tree().create_timer(.03).timeout
			cam_anim.play("RESET")
			player.show()
			var closet_dialogue = Dialogic.start("Micah_closet_note")
			Dialogic.timeline_ended.connect(_on_timeline_ended)
			closet_dialogue.register_character(load("res://Dialogic Characters/Dalton.dch"), dalton_maker)
			closet_dialogue.register_character(load("res://Dialogic Characters/Micah.dch"), micah_marker)
			GlobalVars.in_interaction = ""
			GlobalVars.closet_dialogue = true
			note_interaction.hide()
			main_cam.set_tween_duration(1)
		elif Input.is_action_just_pressed("Exit"): 
			main_cam.set_tween_duration(0)
			closet_cam.priority = 0
			main_cam.priority = 12
			await get_tree().create_timer(.03).timeout
			cam_anim.play("RESET")
			player.show()
			player.start_player()
			GlobalVars.in_interaction = ""
			note_interaction.hide()
			main_cam.set_tween_duration(1)
	
	if GlobalVars.in_look_screen == true:
		note_interaction.hide()
	elif GlobalVars.in_look_screen == false and closet_cam.priority == 15:
		note_interaction.show()

func _on_interactable_interacted(interactor):
	collision.disabled = false
	collision2.disabled = false
	main_cam.priority = 12
	var tool_asked = Dialogic.VAR.get_variable("Asked Questions.Micah_Closet_Asked")
	if GlobalVars.in_dialogue == false:
		if closet_open == false and tool_asked == false:
			GlobalVars.in_dialogue = true
			player.stop_player()
			closet_anim.play("NewClosetOpen")
			await closet_anim.animation_finished
			closet_open = true
			#Dialogue start
			var closet_dialogue = Dialogic.start("Micah_closet_ask")
			Dialogic.timeline_ended.connect(_on_timeline_ended)
			Dialogic.signal_event.connect(closetLook)
			closet_dialogue.register_character(load("res://Dialogic Characters/Dalton.dch"), dalton_maker)
			closet_dialogue.register_character(load("res://Dialogic Characters/Micah.dch"), micah_marker)
			closet_dialogue.register_character(load("res://Dialogic Characters/Theo.dch"), theo_marker)
			#await get_tree().create_timer(3).timeout
		elif closet_open == true and tool_asked == false:
			GlobalVars.in_dialogue = true
			player.stop_player()
			var closet_dialogue = Dialogic.start("Micah_closet_ask", "choices")
			Dialogic.timeline_ended.connect(_on_timeline_ended)
			Dialogic.signal_event.connect(closetLook)
			closet_dialogue.register_character(load("res://Dialogic Characters/Dalton.dch"), dalton_maker)
			closet_dialogue.register_character(load("res://Dialogic Characters/Micah.dch"), micah_marker)
			closet_dialogue.register_character(load("res://Dialogic Characters/Theo.dch"), theo_marker)
		elif closet_open == true and tool_asked == true:
			GlobalVars.in_dialogue = true
			player.stop_player()
			var closet_dialogue = Dialogic.start("Micah_closet_ask", "tool choices")
			Dialogic.timeline_ended.connect(_on_timeline_ended)
			Dialogic.signal_event.connect(closetLook)
			closet_dialogue.register_character(load("res://Dialogic Characters/Dalton.dch"), dalton_maker)
			closet_dialogue.register_character(load("res://Dialogic Characters/Micah.dch"), micah_marker)
			closet_dialogue.register_character(load("res://Dialogic Characters/Theo.dch"), theo_marker)

func _on_timeline_ended():
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	GlobalVars.in_dialogue = false
	player.start_player()
#
func closetLook(argument: String):
	if argument == "look":
		# connect signal to switch cams
		GlobalVars.in_interaction = "closet"
		closet_cam.priority = 15
		main_cam.priority = 0 
		note_interaction.show()
		cam_anim.play("Cam_Idle")
		player.hide()
	#if argument == "exit":
		#print("sign nn")
		#player.start_player()
