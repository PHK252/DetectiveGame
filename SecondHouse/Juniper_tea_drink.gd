extends Node3D


@export var FP_Cam: PhantomCamera3D
@export var Exit_Cam: PhantomCamera3D

@export var cam_anim: AnimationPlayer

@export var dalton_marker: Marker2D
@export var theo_marker: Marker2D
@export var character_marker: Marker2D
@export var player : CharacterBody3D
@export var alert : Sprite3D

#Interaction Variables
@export var interact_type : String
@export var interact_area: Area2D
@export var interactable: Interactable
@export var dialogue_file: String
@export var load_Dalton_dialogue: String
@export var load_Theo_dialogue: String
@export var load_char_dialogue: String


func _ready():
	interactable.set_deferred("monitorable", false)


func choose_drink_thought_dialogue():
	if Dialogic.VAR.get_variable("Juniper.times_drank") != 0:
		var rng = RandomNumberGenerator.new()
		var random = rng.randi_range(0, 3)
		Dialogic.VAR.set_variable("Juniper.drink_response", random)


func _on_tea_activate_temp_interacted(interactor):
	if GlobalVars.in_interaction == "":
		#emit_signal("general_interact")
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		alert.hide()
		GlobalVars.in_interaction = interact_type
		FP_Cam.priority = 30
		Exit_Cam.priority = 0 
		interact_area.show()
		cam_anim.play("Cam_Idle")
		player.hide()
		player.stop_player()



func _on_timeline_ended():
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	GlobalVars.in_dialogue = false

#connected via signal when Juniper is done setting drinks down
func _activate_drink():
	GlobalVars.in_tea_time = false
	interactable.set_deferred("monitorable", true)
	#var game_dialogue = Dialogic.start(dialogue_file)
	#game_dialogue.register_character(load(load_Dalton_dialogue), dalton_marker)
	#game_dialogue.register_character(load(load_Theo_dialogue), theo_marker)
	#game_dialogue.register_character(load(load_char_dialogue), character_marker)


func _on_tea_drink_input_event(viewport, event, shape_idx):
	if GlobalVars.in_look_screen == false and GlobalVars.in_dialogue == false :
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed == true:
				#add soundFX
				GlobalVars.in_dialogue = true
				choose_drink_thought_dialogue()
				var game_dialogue = Dialogic.start(dialogue_file)
				Dialogic.timeline_ended.connect(_on_timeline_ended)
				player.stop_player()
				alert.hide()

func _input(event):
	if Input.is_action_just_pressed("Exit") and GlobalVars.in_interaction == interact_type:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		Exit_Cam.set_tween_duration(0)
		FP_Cam.priority = 0
		Exit_Cam.priority = 30
		#emit_signal("general_quit")
		await get_tree().create_timer(.03).timeout
		cam_anim.play("RESET")
		player.show()
		player.start_player()
		#main_cam.set_tween_duration(1)
		GlobalVars.in_interaction = ""
		interact_area.hide()
		alert.show()
