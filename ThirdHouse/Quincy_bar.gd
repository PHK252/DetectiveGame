extends Node3D

#Assign player body
@export var player: CharacterBody3D
@export var player_interactor : Interactor
@export var alert: Sprite3D

#
@export var dalton_bar : Node3D
@export var stool_getup : AudioStreamPlayer3D
@export var interactable : Interactable
@export var interaction_type : String
@export var phone_ui : CanvasLayer

@export var dialogue_file : String
var fainted = false
var quincy_at_bar = false
var set_monitor = false
signal theo_bar_call
signal faint_time
signal make_drinks
signal theo_enter_bar
signal Switch_Dalton_marker
signal Nudge_Quincy_marker
signal return_norm_markers
signal Switch_theo_marker
signal enable_look
signal disable_look
signal DaltonVisible
func _ready():
	interactable.set_monitorable(false) 
	pass

func _process(delta):
	if fainted == false:
		if GlobalVars.bar_dialogue_Quincy_finished == true or GlobalVars.Quincy_Dalton_caught == true:
			interactable.set_monitorable(false) 
		elif quincy_at_bar == true:
			if set_monitor == false:
				interactable.set_monitorable(true) 
				player_interactor.process_mode = player_interactor.PROCESS_MODE_DISABLED 
				await get_tree().create_timer(.03).timeout
				player_interactor.process_mode = player_interactor.PROCESS_MODE_INHERIT
				set_monitor = true
		else:
			if set_monitor == true:
				if interactable:
					interactable.set_monitorable(false) 
					player_interactor.process_mode = player_interactor.PROCESS_MODE_DISABLED 
					await get_tree().create_timer(.03).timeout
					player_interactor.process_mode = player_interactor.PROCESS_MODE_INHERIT
					set_monitor = false
	#else:
		#interactable.set_monitorable(false) 


func _on_bar_interact_interacted(interactor):
	if GlobalVars.in_dialogue == false and GlobalVars.bar_dialogue_Quincy_finished == false and GlobalVars.in_interaction == "":
		emit_signal("enable_look")
		GlobalVars.in_interaction = interaction_type
		var bar_dialogue = Dialogic.start(dialogue_file)
		GlobalVars.in_dialogue = true
		Dialogic.timeline_ended.connect(_on_timeline_ended)
		Dialogic.signal_event.connect(_faint_to_livingroom)
		Dialogic.signal_event.connect(_make_drinks)
		Dialogic.signal_event.connect(_call_theo)
		emit_signal("Switch_Dalton_marker")
		emit_signal("Nudge_Quincy_marker")
		player.stop_player()
		alert.hide()

func _on_timeline_ended():
	emit_signal("disable_look")
	if fainted == false:
		if Dialogic.VAR.get_variable("Quincy.in_call") == true:
			Dialogic.timeline_ended.disconnect(_on_timeline_ended)
			GlobalVars.in_dialogue = false
		else:
			dalton_bar.visible = false
			stool_getup.play()
			emit_signal("DaltonVisible")
			Dialogic.timeline_ended.disconnect(_on_timeline_ended)
			GlobalVars.in_interaction = ""
			GlobalVars.in_dialogue = false
			player.start_player()
			alert.show()
			emit_signal("return_norm_markers")
			if Dialogic.VAR.get_variable("Quincy.refused_bar") == false:
				GlobalVars.bar_dialogue_Quincy_finished = true
			#else:
				#Dialogic.VAR.set_variable("Quincy.refused_bar", false)
				
	else:
		Dialogic.timeline_ended.disconnect(_on_timeline_ended)
		GlobalVars.in_interaction = ""
		GlobalVars.in_dialogue = false
		GlobalVars.bar_dialogue_Quincy_finished = true
	
	
	#switch cam and move characters

func _faint_to_livingroom(argument: String):
	if argument == "faint":
		fainted = true
		Dialogic.signal_event.disconnect(_faint_to_livingroom)
		emit_signal("faint_time")
		GlobalVars.in_dialogue = false
		GlobalVars.in_interaction = ""
		alert.hide()
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
		emit_signal("enable_look")
		emit_signal("theo_enter_bar")
		emit_signal("Switch_theo_marker")
		#await get_tree().create_timer(3.0).timeout
		var bar_dialogue = Dialogic.start(dialogue_file, "Bar continue")
		GlobalVars.in_dialogue = true
		Dialogic.timeline_ended.connect(_on_timeline_ended)



func _on_cutscene_cams_continue_bar():
	if Dialogic.VAR.get_variable("Quincy.drink_with_theo") == false:
		var bar_dialogue = Dialogic.start(dialogue_file, "continue2")
		GlobalVars.in_dialogue = true
		#Dialogic.timeline_ended.connect(_on_timeline_ended)
	else:
		var bar_dialogue = Dialogic.start(dialogue_file, "continue1")
		GlobalVars.in_dialogue = true
	#	Dialogic.timeline_ended.connect(_on_timeline_ended)

func _on_office_a_body_entered(body):
	if Dialogic.VAR.get_variable("Quincy.is_distracted") == false:
		if body.name == "Quincy":
			quincy_at_bar = true
			print("bar_active")

func _on_office_a_body_exited(body):
	if Dialogic.VAR.get_variable("Quincy.is_distracted") == false:
		if body.name == "Quincy":
			quincy_at_bar = false
			print("bar_deactive")
