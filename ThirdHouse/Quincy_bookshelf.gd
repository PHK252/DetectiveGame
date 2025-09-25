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
@export var interactable : Interactable
@export var interact_area: Area2D
@export var dialogue_file: String
@export var react_file: String
@export var thought_dialogue_file: String
@export var cue_distract_dialogue: String
@export var load_Dalton_dialogue: String
@export var load_Theo_dialogue: String
@export var load_char_dialogue: String

#Load Global Variables
@export var interact_type: String
@export var view_item: String

#set defaults
@onready var mouse_pos = Vector2(0,0)
@onready var distracted : bool
@onready var need_distraction : bool
@onready var cab_anim = false
@onready var is_open = false
var try_viewed : int
var in_thoughts = false

@export var bookshelf_move_sound : AudioStreamPlayer3D
@export var bookmark_sound : AudioStreamPlayer3D

signal book_thoughts_finished
signal thoughts_finished

signal enable_look
signal disable_look
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	mouse_pos = get_viewport().get_mouse_position()
	distracted = Dialogic.VAR.get_variable("Quincy.is_distracted") 
	need_distraction = Dialogic.VAR.get_variable("Quincy.needs_distraction")
	if try_viewed == 2:
		Dialogic.VAR.set_variable("Quincy.needs_distraction", true)
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
	emit_signal("disable_look")
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	GlobalVars.in_interaction = ""
	GlobalVars.in_dialogue = false
	player.start_player()
	alert.show()
	
func _on_reaction_ended():
	emit_signal("disable_look")
	Dialogic.timeline_ended.disconnect(_on_reaction_ended)
	GlobalVars.in_dialogue = false
	player.start_player()

func _on_interactable_interacted(interactor):
	alert.hide()
	GlobalVars.in_interaction = interact_type
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	#interact_area.hide()
	FP_Cam.priority = 30
	Exit_Cam.priority = 0 
	cam_anim.play("Cam_Idle")
	player.hide()
	player.stop_player()
		

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed == true:
			if GlobalVars.in_look_screen == false and GlobalVars.in_dialogue == false and GlobalVars.in_interaction == interact_type and GlobalVars.quincy_kicked_out == false and GlobalVars.quincy_time_out == false:
				if distracted == false:
					Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
					interact_area.hide()
					choose_quincy_cycle_dialogue()
					if need_distraction == true:
						GlobalVars.in_dialogue = true
						choose_distract_thought_dialogue()
						in_thoughts = true
						Dialogic.start(cue_distract_dialogue)
						Dialogic.timeline_ended.connect(_on_thoughts_ended)
					else:
						try_viewed += 1
					if in_thoughts == false:
						Exit_Cam.set_tween_duration(0)
						FP_Cam.priority = 0
						Exit_Cam.priority = 30 
						Exit_Cam.set_tween_duration(1)
						player.show()
						emit_signal("enable_look")
						GlobalVars.in_dialogue = true
						var game_dialogue = Dialogic.start(dialogue_file)
						Dialogic.timeline_ended.connect(_on_timeline_ended)
						game_dialogue.register_character(load(load_Dalton_dialogue), dalton_marker)
						game_dialogue.register_character(load(load_Theo_dialogue), theo_marker)
						game_dialogue.register_character(load(load_char_dialogue), character_marker)
						player.stop_player()
						alert.hide()
				else:
					Exit_Cam.set_tween_duration(0)
					interact_area.hide()
					GlobalVars.in_dialogue = true
					Dialogic.start(thought_dialogue_file)
					Dialogic.timeline_ended.connect(_on_book_thoughts_ended)
					await book_thoughts_finished
					bookmark_anim.play("Bookmark_pull")
					bookmark_sound.play()
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
					player.stop_player()
					GlobalVars.in_interaction = ""
					interact_area.hide()
					Exit_Cam.set_tween_duration(1)
					var react_dialogue = Dialogic.start(react_file)
					Dialogic.timeline_ended.connect(_on_reaction_ended)
					react_dialogue.register_character(load(load_Dalton_dialogue), dalton_marker)
					

func open() -> void:
	bookshelf_move_sound.play()
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
	bookshelf_move_sound.play()
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
	
func choose_distract_thought_dialogue():
	if Dialogic.VAR.get_variable("Quincy.first_cue") == true:
		var rng = RandomNumberGenerator.new()
		var random = rng.randi_range(1, 3)
		Dialogic.VAR.set_variable("Quincy.cue_cycle", random)
		print("cue cycle " + str(random))
	else:
		Dialogic.VAR.set_variable("Quincy.first_cue", true)
		Dialogic.VAR.set_variable("Quincy.cue_cycle", 1)
		
func choose_quincy_cycle_dialogue():
	var rng = RandomNumberGenerator.new()
	var random = rng.randi_range(1, 4)
	Dialogic.VAR.set_variable("Quincy.bookshelf_cycle", random)

func _on_thoughts_ended():
	Dialogic.timeline_ended.disconnect(_on_thoughts_ended)
	in_thoughts = false
	GlobalVars.in_dialogue = false
	emit_signal("thoughts_finished") 

func _on_book_thoughts_ended():
	Dialogic.timeline_ended.disconnect(_on_book_thoughts_ended)
	GlobalVars.in_dialogue = false
	emit_signal("book_thoughts_finished")

func _on_thoughts_finished():
	if in_thoughts == false and GlobalVars.in_dialogue== false:
		interact_area.hide()
		Exit_Cam.set_tween_duration(0)
		FP_Cam.priority = 0
		Exit_Cam.priority = 30 
		Exit_Cam.set_tween_duration(1)
		player.show()
		emit_signal("enable_look")
		GlobalVars.in_dialogue = true
		var game_dialogue = Dialogic.start(dialogue_file)
		Dialogic.timeline_ended.connect(_on_timeline_ended)
		game_dialogue.register_character(load(load_Dalton_dialogue), dalton_marker)
		game_dialogue.register_character(load(load_Theo_dialogue), theo_marker)
		game_dialogue.register_character(load(load_char_dialogue), character_marker)
		player.stop_player()
		alert.hide()


func _on_toilet_distraction():
	interactable.set_deferred("monitorable", false)


func _on_quincy_time_out_resume():
	if interactable.monitorable == false:
		interactable.set_deferred("monitorable", true)
