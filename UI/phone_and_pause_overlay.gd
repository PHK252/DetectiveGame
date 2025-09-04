extends Control

@onready var phone_ui = $"CanvasLayer/Phone UI"
@onready var pause = $"CanvasLayer/Pause Screen"
@onready var call_anim = $CanvasLayer/AnimationPlayer
@onready var call_normal = $"CanvasLayer/Call Normal"
@onready var receiving_call = $"CanvasLayer/Receiving call"

@export var player : CharacterBody3D
#temp var to check if called
@onready var called = false
@onready var phone_up = false

var prev_mouse_mode : int
var exit = InputMap.action_get_events("Exit")
var interact = InputMap.action_get_events("interact")
# Called when the node enters the scene tree for the first time.
func _ready():
	# phone call code
	#await get_tree().create_timer(3).timeout
	#GlobalVars.emit_phone_call()
	pass
func _process(delta):
	if GlobalVars.in_dialogue == true and GlobalVars.in_look_screen == true:
		call_normal.disabled = true
	if GlobalVars.in_call == false and called == false:
		GlobalVars.phone_call_receiving.connect(_on_call_received)
		GlobalVars.in_call = true
	else:
		pass


func _on_pause_pressed():
	pause.show()


func _on_receiving_call_pressed():
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

func _on_call_received():
	call_anim.play("Shake")
	call_normal.hide()
	receiving_call.show()

func call_end():
	GlobalVars.phone_call_receiving.disconnect(_on_call_received)
	call_anim.stop()
	call_normal.show()
	receiving_call.hide()
	called = true


func _on_accept_pressed():
	call_end()

func _on_decline_pressed():
	call_end()   
