extends Node3D

#Assign first person cam and exit cam + idle animation
@export var FP_Cam: PhantomCamera3D
@export var Exit_Cam: PhantomCamera3D

#First Person cam anim + movement
@export var cam_anim: AnimationPlayer
@export var bookmark_anim : AnimationPlayer
@export var doorL_anim : AnimationTree
@export var doorR_anim : AnimationTree
@export var collision : CollisionShape3D
@export var collision_2 : CollisionShape3D
@export var bookmark : MeshInstance3D
@export var tilt_up_thres: int
@export var tilt_down_thres: int
@export var tilt_up_angle: Vector3
@export var tilt_down_angle: Vector3
@export var mid_angle: Vector3
@export var down_default: bool = false
#Assign player body
@export var player: CharacterBody3D
@export var alert: Sprite3D

#Assign character markers (up to 3)
@export var dalton_marker: Marker2D
@export var theo_marker: Marker2D
@export var character_marker: Marker2D

#Interaction Variables
@export var interact_area: Area2D
@export var dialogue_file: String
@export var thought_dialogue_file: String
@export var load_Dalton_dialogue: String
@export var load_Theo_dialogue: String
@export var load_char_dialogue: String

#Load Global Variables
@export var interact_type: String
@export var view_item: String

#set defaults
@onready var mouse_pos = Vector2(0,0)
@onready var distracted = false
@onready var cab_anim = false
@onready var is_open = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	mouse_pos = get_viewport().get_mouse_position()
	distracted = Dialogic.VAR.get_variable("Quincy.is_distracted") 
	if GlobalVars.in_look_screen == false and GlobalVars.in_dialogue == false:
		if mouse_pos.y >= tilt_up_thres:
			FP_Cam.set_rotation_degrees(tilt_up_angle)
		elif mouse_pos.y < tilt_down_thres:
			FP_Cam.set_rotation_degrees(tilt_down_angle)
		else:
			FP_Cam.set_rotation_degrees(mid_angle)
				#pass
	else:
		if down_default == true:
			FP_Cam.set_rotation_degrees(tilt_up_angle)
		else:
			FP_Cam.set_rotation_degrees(mid_angle)
	
	if GlobalVars.in_look_screen == false and GlobalVars.in_dialogue == false and GlobalVars.in_interaction == interact_type:
		if Input.is_action_just_pressed("Exit"):
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			Exit_Cam.set_tween_duration(0)
			FP_Cam.priority = 0
			Exit_Cam.priority = 30
			await get_tree().create_timer(.03).timeout
			cam_anim.play("RESET")
			player.show()
			player.start_player()
			#main_cam.set_tween_duration(1)
			GlobalVars.in_interaction = ""
			interact_area.hide()
			alert.show()
			#activate dialogue

	if GlobalVars.in_look_screen == true:
		interact_area.hide()
	elif GlobalVars.in_look_screen == false and FP_Cam.priority == 30:
		interact_area.show()


func _on_timeline_ended():
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	GlobalVars.in_dialogue = false
	player.start_player()
	alert.show()

func _on_thoughts_ended():
	Dialogic.timeline_ended.disconnect(_on_thoughts_ended)
	GlobalVars.in_dialogue = false
	interact_area.show()

func _on_interactable_interacted(interactor):
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	alert.hide()
	GlobalVars.in_interaction = interact_type
	FP_Cam.priority = 30
	Exit_Cam.priority = 0 
	cam_anim.play("Cam_Idle")
	player.hide()
	player.stop_player()
	if distracted == true:
		GlobalVars.in_dialogue = true
		Dialogic.timeline_ended.connect(_on_thoughts_ended)
		Dialogic.start(thought_dialogue_file)
		


func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed == true:
			if GlobalVars.in_look_screen == false and GlobalVars.in_dialogue == false and GlobalVars.in_interaction == interact_type:
				if distracted == false:
					alert.hide()
					Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
					GlobalVars.in_dialogue = true
					FP_Cam.priority = 0
					Exit_Cam.priority = 30
					await get_tree().create_timer(.03).timeout
					cam_anim.play("RESET")
					player.show()
					player.start_player()
					GlobalVars.in_interaction = ""
					var game_dialogue = Dialogic.start(dialogue_file)
					#Dialogic.VAR.get("Asked Questions").Micah_cab = 1 #need quincy version
					Dialogic.timeline_ended.connect(_on_timeline_ended)
					game_dialogue.register_character(load(load_Dalton_dialogue), dalton_marker)
					game_dialogue.register_character(load(load_Theo_dialogue), theo_marker)
					game_dialogue.register_character(load(load_char_dialogue), character_marker)
					#GlobalVars.set(view_item, true)
					interact_area.hide()
				else:
					interact_area.hide()
					bookmark_anim.play("Bookmark_pull")
					GlobalVars.set(view_item, true)
					Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
					await bookmark_anim.animation_finished
					open()
					bookmark.hide()
					await doorL_anim.animation_finished
					FP_Cam.priority = 0
					Exit_Cam.priority = 30
					cam_anim.play("RESET")
					player.show()
					player.start_player()
					GlobalVars.in_interaction = ""
					interact_area.hide()
					

func open() -> void:
	#open_sound.play()
	cab_anim = true
	doorL_anim["parameters/conditions/is_opened"] = true
	doorL_anim["parameters/conditions/is_closed"] = false
	doorR_anim["parameters/conditions/is_opened"] = true
	doorR_anim["parameters/conditions/is_closed"] = false
	is_open = true
	await get_tree().create_timer(2.1).timeout
	cab_anim = false
	collision.disabled = true
	collision_2.disabled = true
	
func close() -> void:
	#close_sound.play()
	cab_anim = true
	doorL_anim["parameters/conditions/is_opened"] = false
	doorL_anim["parameters/conditions/is_closed"] = true
	doorR_anim["parameters/conditions/is_opened"] = false
	doorR_anim["parameters/conditions/is_closed"] = true
	is_open = false
	await get_tree().create_timer(2.1).timeout
	cab_anim = false
	collision.disabled = false
	collision_2.disabled = false
	
