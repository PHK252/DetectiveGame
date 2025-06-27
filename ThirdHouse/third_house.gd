extends Node3D

@export var interactables : Array[Interactable] = []
@export var player : CharacterBody3D
@export var alert : Sprite3D
@export var timed_out_dialogue_file : String

@export var load_Dalton_dialogue : String
@export var load_Theo_dialogue : String
@export var load_char_dialogue : String

@export var dalton_marker : Marker2D
@export var theo_marker : Marker2D
@export var character_marker : Marker2D

var time_out = false
var in_time_out_dialogue = false

func _ready():
	GlobalVars.current_level = "Quincy"
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta):
	if Input.is_action_just_pressed("Quit"):
			get_tree().quit()

	#Kicked out 
	if Dialogic.VAR.get_variable("Quincy.kicked_out") == true:
		GlobalVars.quincy_kicked_out = true
		disable_interaction(interactables)
			#alert.hide()
			#player.stop_player()
			#in_kicked_out_dialogue = true
			#var kicked_out_dialogue = Dialogic.start(kicked_out_dialogue_file)
			#Dialogic.timeline_ended.connect(_on_timeline_ended_kicked)
			#kicked_out_dialogue.register_character(load(load_Dalton_dialogue), dalton_marker)
			#kicked_out_dialogue.register_character(load(load_Theo_dialogue), theo_marker)
			#kicked_out_dialogue.register_character(load(load_char_dialogue), character_marker)
	
	#timed out
	if time_out == true:
		if in_time_out_dialogue == false and GlobalVars.in_interaction == "" and Dialogic.VAR.get_variable("Quincy.timed_out") == false and GlobalVars.quincy_kicked_out == false:
			alert.hide()
			in_time_out_dialogue = true
			var time_out_dialogue = Dialogic.start(timed_out_dialogue_file)
			Dialogic.timeline_ended.connect(_on_timeline_ended_timed)
			time_out_dialogue.register_character(load(load_Dalton_dialogue), dalton_marker)
			time_out_dialogue.register_character(load(load_Theo_dialogue), theo_marker)
			time_out_dialogue.register_character(load(load_char_dialogue), character_marker)

#timeout set to 10 minutes right now
func _on_timer_timeout():
	if GlobalVars.quincy_kicked_out == false:
		GlobalVars.quincy_time_out = true
		disable_interaction(interactables)
		time_out = true
		print("LEVEL TIMEOUT")
		player.stop_player()
		alert.hide()
		if GlobalVars.in_interaction == "":
			in_time_out_dialogue = true
			var time_out_dialogue = Dialogic.start(timed_out_dialogue_file)
			Dialogic.timeline_ended.connect(_on_timeline_ended_timed)
			time_out_dialogue.register_character(load(load_Dalton_dialogue), dalton_marker)
			time_out_dialogue.register_character(load(load_Theo_dialogue), theo_marker)
			time_out_dialogue.register_character(load(load_char_dialogue), character_marker)
		else:
			pass
		 

func _on_timeline_ended_timed():
	Dialogic.timeline_ended.disconnect(_on_timeline_ended_timed)
	GlobalVars.in_dialogue = false
	player.start_player()
	alert.hide()
	

func _on_timeline_ended_kicked():
	Dialogic.timeline_ended.disconnect(_on_timeline_ended_kicked)
	GlobalVars.in_dialogue = false
	player.start_player()
	alert.hide()

func disable_interaction(arr: Array):
	for i in arr:
		i.set_monitorable(false)
		i.queue_free()
