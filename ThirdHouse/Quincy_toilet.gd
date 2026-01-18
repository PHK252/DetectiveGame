extends Node3D

#Assign first person cam and exit cam + idle animation
@export var FP_Cam: PhantomCamera3D
@export var Exit_Cam: PhantomCamera3D

#First Person cam anim + movement
@export var cam_anim: AnimationPlayer
@export var tilt_up_thres: int
@export var tilt_down_thres: int
@export var tilt_up_angle: Vector3
@export var tilt_down_angle: Vector3
@export var mid_angle: Vector3
@export var down_default: bool = false
#Assign player body
@export var player: CharacterBody3D
@export var player_interactor: Interactor
@export var alert: Sprite3D

#Assign character markers (up to 3)
@export var dalton_marker: Marker2D
@export var theo_marker: Marker2D
@export var character_marker: Marker2D
@export var load_Dalton_dialogue: String
@export var load_Theo_dialogue: String
@export var load_char_dialogue: String

#Interaction Variables
@export var interact_area_1: Area2D
#@export var interact_area_2: Area2D
@export var distraction_dialogue_file: String


#@export var flood_anim : AnimationPlayer
#@export var anim_track : String
#Load Global Variables
@export var interact_type: String
@export var view_item: String
@export var interactable : Interactable

#set defaults
@onready var mouse_pos = Vector2(0,0)
@onready var need_distraction : bool
@onready var distracted : bool

@export var towel: Node3D
signal distraction

@export var flush : AudioStreamPlayer3D

func _ready() -> void:
	towel.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	mouse_pos = get_viewport().get_mouse_position()
	need_distraction = Dialogic.VAR.get_variable("Quincy.needs_distraction")
	#distracted = Dialogic.VAR.get_variable("Quincy.in_bathroom") 
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
			GlobalVars.in_interaction = ""
			interact_area_1.hide()
			#interact_area_2.hide()
			alert.show()
			
			#activate dialogue
		#if GlobalVars.get(view_item) == true:
			#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			#Exit_Cam.set_tween_duration(0)
			#FP_Cam.priority = 0
			#Exit_Cam.priority = 30
			#await get_tree().create_timer(.03).timeout
			#cam_anim.play("RESET")
			#player.show()
			#player.start_player()
			#GlobalVars.in_interaction = ""
			#interact_area_1.hide()
			#interact_area_2.hide()
			#alert.show()
			#flood_anim.play(anim_track)
	#if Dialogic.VAR.get_variable("Quincy.clogged_toilet") == true:
		#interactable.set_monitorable(false)
	#else:
		#interactable.set_monitorable(true)
	
	if GlobalVars.in_look_screen == true:
		interact_area_1.hide()
		#interact_area_2.hide()
#
	#elif GlobalVars.in_look_screen == false and FP_Cam.priority == 30:
		#interact_area_1.show()
		#interact_area_2.show()


func _on_distracted_thoughts_ended():
	Dialogic.timeline_ended.disconnect(_on_distracted_thoughts_ended)
	GlobalVars.in_dialogue = false
	if Dialogic.VAR.get_variable("Quincy.clogged_toilet") == true:
		interact_area_1.hide()
		#interact_area_2.hide()
	else:
		interact_area_1.show()
		#interact_area_2.show()
	

func _on_regular_thoughts_ended():
	Dialogic.timeline_ended.disconnect(_on_regular_thoughts_ended)
	GlobalVars.in_dialogue = false
	#player.start_player()
	#alert.show()

func _on_interactable_interacted(interactor):
	#print("Clogged toilet? " + str(Dialogic.VAR.get_variable("Quincy.clogged_toilet")))
	#if distracted == true:
		#GlobalVars.in_dialogue = true
		#Dialogic.timeline_ended.connect(_on_thoughts_ended)
		#Dialogic.start(thought_dialogue_file)
		#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		#alert.hide()
		#GlobalVars.in_interaction = interact_type
		#FP_Cam.priority = 30
		#Exit_Cam.priority = 0 
		#
		#player.hide()
		#player.stop_player()
	if GlobalVars.in_look_screen == false and GlobalVars.in_dialogue == false and GlobalVars.in_interaction == "":
		player.hide()
		player.stop_player()
		FP_Cam.priority = 30
		Exit_Cam.priority = 0
		cam_anim.play("Cam_Idle")
		GlobalVars.in_interaction = interact_type
		if need_distraction == true and Dialogic.VAR.get_variable("Quincy.clogged_toilet") == false: 
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			interact_area_1.show()
			#interact_area_2.show()
		elif need_distraction == false and Dialogic.VAR.get_variable("Quincy.clogged_toilet") == false:
			GlobalVars.in_dialogue = true
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			Dialogic.timeline_ended.connect(_on_regular_thoughts_ended)
			Dialogic.start(distraction_dialogue_file)
			player.stop_player()
			alert.hide()
		else:
			pass

func _clog_toilet(argument : String):
	if argument == "clog_time":
		player.show()
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		FP_Cam.priority = 0
		Exit_Cam.priority = 30 
		Dialogic.signal_event.disconnect(_clog_toilet)
		print("clogging")
		GlobalVars.set(view_item, true)
		emit_signal("distraction")
		await get_tree().create_timer(2).timeout
		towel.visible = true
		await get_tree().create_timer(3).timeout
		towel.visible = false
		if interactable:
			interactable.set_monitorable(false)
		player_interactor.process_mode = player_interactor.PROCESS_MODE_DISABLED 
		await get_tree().create_timer(.03).timeout
		player_interactor.process_mode = player_interactor.PROCESS_MODE_INHERIT
		GlobalVars.in_interaction = ""
		GlobalVars.in_dialogue = false
		GlobalVars.in_look_screen = false
		cam_anim.play("RESET")
		await get_tree().create_timer(1.2).timeout
		flush.play()
		player.start_player()
		#flood_anim.play(anim_track)
		pass
	else:
		Dialogic.signal_event.disconnect(_clog_toilet)
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _on_towels_input_event(viewport, event, shape_idx):
	if GlobalVars.in_look_screen == false and GlobalVars.in_dialogue == false:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed == true:
				GlobalVars.in_dialogue = true
				interact_area_1.hide()
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
				Dialogic.timeline_ended.connect(_on_distracted_thoughts_ended)
				Dialogic.signal_event.connect(_clog_toilet)
				Dialogic.start(distraction_dialogue_file)
				player.stop_player()
				alert.hide()
