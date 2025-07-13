extends Node3D

#Assign player body
@export var player: CharacterBody3D
@export var alert: Sprite3D

#Assign character markers (up to 3)
@export var dalton_marker: Marker2D
@export var theo_marker: Marker2D
@export var character_marker: Marker2D
@export var load_Dalton_dialogue: String
@export var load_Theo_dialogue: String
@export var load_char_dialogue: String
@export var interactable : Interactable
@export var interaction_type : String
@export var phone_ui : CanvasLayer

@export var dialogue_file : String
var fainted = false

signal theo_bar_call
signal faint_time
signal make_drinks
signal theo_enter_bar
signal Switch_Dalton_marker
signal Nudge_Quincy_marker
signal return_norm_markers
signal Switch_theo_marker

func _process(delta):
	if fainted == false:
		if GlobalVars.bar_dialogue_Quincy_finsihed == true or GlobalVars.Quincy_Dalton_caught == true:
			interactable.set_monitorable(false) 
		else:
			interactable.set_monitorable(true) 

func _on_bar_interact_interacted(interactor):
	if GlobalVars.in_dialogue == false and GlobalVars.bar_dialogue_Quincy_finsihed == false and GlobalVars.in_interaction == "":
		GlobalVars.in_interaction = interaction_type
		var bar_dialogue = Dialogic.start(dialogue_file)
		GlobalVars.in_dialogue = true
		Dialogic.timeline_ended.connect(_on_timeline_ended)
		Dialogic.signal_event.connect(_faint_to_livingroom)
		Dialogic.signal_event.connect(_make_drinks)
		Dialogic.signal_event.connect(_call_theo)
		bar_dialogue.register_character(load(load_Dalton_dialogue), dalton_marker)
		bar_dialogue.register_character(load(load_Theo_dialogue), theo_marker)
		bar_dialogue.register_character(load(load_char_dialogue), character_marker)
		emit_signal("Switch_Dalton_marker")
		emit_signal("Nudge_Quincy_marker")
		player.stop_player()
		alert.hide()

func _on_timeline_ended():
	if fainted == false:
		if Dialogic.VAR.get_variable("Quincy.in_call") == true:
			Dialogic.timeline_ended.disconnect(_on_timeline_ended)
			GlobalVars.in_dialogue = false
		else:
			Dialogic.timeline_ended.disconnect(_on_timeline_ended)
			GlobalVars.in_interaction = ""
			GlobalVars.in_dialogue = false
			player.start_player()
			alert.show()
			emit_signal("return_norm_markers")
			GlobalVars.bar_dialogue_Quincy_finsihed = true
	else:
		Dialogic.timeline_ended.disconnect(_on_timeline_ended)
		GlobalVars.in_interaction = ""
		GlobalVars.in_dialogue = false
		GlobalVars.bar_dialogue_Quincy_finsihed = true
	
	
	#switch cam and move characters

func _faint_to_livingroom(argument: String):
	if argument == "faint":
		fainted = true
		Dialogic.signal_event.disconnect(_faint_to_livingroom)
		#Scene transtion 
		emit_signal("faint_time")
		#signal to play ending dialogue
		GlobalVars.in_dialogue = false
		GlobalVars.in_interaction = ""
		pass
	elif argument == "disconnect":
		Dialogic.signal_event.disconnect(_faint_to_livingroom)

func _make_drinks(argument: String):
	if argument == "make_drink":
		Dialogic.signal_event.disconnect(_make_drinks)
		emit_signal("make_drinks")
		pass
	elif argument == "disconnect":
		Dialogic.signal_event.disconnect(_make_drinks)

func _call_theo(argument: String):
	if argument == "call_cue":
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		Dialogic.signal_event.disconnect(_call_theo)
		GlobalVars.phone_up = true
		phone_ui.show()
		emit_signal("theo_bar_call")
	elif argument == "disconnect":
		Dialogic.signal_event.disconnect(_call_theo)



func _on_bar_continue_convo():
	if GlobalVars.in_dialogue == false:
		emit_signal("theo_enter_bar")
		emit_signal("Switch_theo_marker")
		var bar_dialogue = Dialogic.start(dialogue_file, "Bar continue")
		GlobalVars.in_dialogue = true
		Dialogic.timeline_ended.connect(_on_timeline_ended)
		bar_dialogue.register_character(load(load_Dalton_dialogue), dalton_marker)
		bar_dialogue.register_character(load(load_Theo_dialogue), theo_marker)
		bar_dialogue.register_character(load(load_char_dialogue), character_marker)
	


func _on_cutscene_cams_continue_bar():
	if Dialogic.VAR.get_variable("Quincy.drink_with_theo") == false:
		var bar_dialogue = Dialogic.start(dialogue_file, "continue2")
		GlobalVars.in_dialogue = true
		#Dialogic.timeline_ended.connect(_on_timeline_ended)
		bar_dialogue.register_character(load(load_Dalton_dialogue), dalton_marker)
		bar_dialogue.register_character(load(load_char_dialogue), character_marker)
	else:
		var bar_dialogue = Dialogic.start(dialogue_file, "continue1")
		GlobalVars.in_dialogue = true
	#	Dialogic.timeline_ended.connect(_on_timeline_ended)
		bar_dialogue.register_character(load(load_Dalton_dialogue), dalton_marker)
		bar_dialogue.register_character(load(load_Theo_dialogue), theo_marker)
		bar_dialogue.register_character(load(load_char_dialogue), character_marker)
