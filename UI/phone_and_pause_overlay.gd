extends Control

@onready var phone_ui = $"CanvasLayer/Phone UI"
@onready var call_anim = $CanvasLayer/AnimationPlayer
@onready var call_normal = $"CanvasLayer/Call Normal"
@onready var receiving_call = $"CanvasLayer/Receiving call"
@onready var evidence = $CanvasLayer/Evidence
@onready var evidence_anim = $CanvasLayer/Evidence/AnimationPlayer

@export var player : CharacterBody3D
#temp var to check if called
@onready var called = false
@onready var phone_up = false

var in_evidence

signal start_dialogue
signal start_call_day_3
signal start_call_end
signal declined_call
signal buzz
signal stop_buzz
signal _show_tut(tut_type : String)
signal awaiting_tut
var accepted = false
var prev_mouse_mode : int
var exit = InputMap.action_get_events("Exit")
var interact = InputMap.action_get_events("interact")
# Called when the node enters the scene tree for the first time.
func _ready():
	##phone_ui.hide()
	#await get_tree().create_timer(3).timeout
	#GlobalVars.emit_phone_call()
	pass
func _process(delta):
	if GlobalVars.in_dialogue == true or  GlobalVars.in_look_screen == true or GlobalVars.in_interaction != "":
		call_normal.disabled = true
	else:
		call_normal.disabled = false
	if GlobalVars.phone_tut == false and in_evidence == true:
		if GlobalVars.in_dialogue == true:
			await get_tree().create_timer(.5).timeout
			if GlobalVars.in_dialogue == true:
				return
			awaiting_tut.emit()

func _on_receiving_call_pressed():
	GlobalVars.phone_up = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	phone_ui.show()
	phone_ui.set_receiving_call()

			
func _on_call_normal_pressed():
	if GlobalVars.in_dialogue == false and GlobalVars.in_look_screen == false:
		if GlobalVars.phone_up == false:
			if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
				prev_mouse_mode = 2
			elif Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
				prev_mouse_mode = 0
			await get_tree().process_frame
			InputMap.action_erase_events("Exit")
			InputMap.action_erase_events("interact")
			#print(prev_mouse_mode)
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			phone_ui.show()
			GlobalVars.phone_up = true
			player.stop_player() 
		else:
			#print(prev_mouse_mode)
			InputMap.action_add_event("Exit", exit[0])
			InputMap.action_add_event("interact", interact[0])
			Input.set_mouse_mode(prev_mouse_mode)
			phone_ui.hide()
			GlobalVars.phone_up = false
			if GlobalVars.in_interaction == "":
				player.start_player() 
	else:
		print("error")

func exit_call_screen():
	InputMap.action_add_event("Exit", exit[0])
	InputMap.action_add_event("interact", interact[0])
	Input.set_mouse_mode(prev_mouse_mode)

func _on_call_received():
	GlobalVars.calling = true
	call_anim.play("Shake")
	emit_signal("buzz")
	call_normal.hide()
	receiving_call.show()

func call_end():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	GlobalVars.phone_up = false
	GlobalVars.calling = false
	call_anim.stop()
	call_normal.show()
	emit_signal("stop_buzz")
	receiving_call.hide()
	phone_ui.hide()
	called = true


func _on_accept_pressed():
	GlobalVars.in_call = true
	call_end()
	if GlobalVars.day == 1:
		GlobalVars.Day_1_Quincy_call = true
		emit_signal("start_dialogue")
		return
	if Dialogic.VAR.get_variable("Endings.Ending_type") != "":
		print("emitting")
		emit_signal("start_call_end")
		return
	if GlobalVars.day == 3:
		GlobalVars.Day_3_Chief_call = true
		emit_signal("start_call_day_3")
		return



func _on_decline_pressed():
	emit_signal("declined_call")
	call_end()   


func _on_case_added_notes_overlay():
	in_evidence = true
	evidence.visible = true
	if call_normal.disabled == true:
		evidence.modulate.a = 0.365
	else:
		evidence.modulate.a = 0.784
	evidence_anim.play("Notes_added")
	await get_tree().create_timer(3.6).timeout
	evidence_anim.stop()
	evidence.visible = false
	if GlobalVars.phone_tut == false:
		if GlobalVars.in_dialogue == false:
			emit_signal("_show_tut", "phone")
		else:
			await awaiting_tut 
			emit_signal("_show_tut", "phone")
	in_evidence = false
