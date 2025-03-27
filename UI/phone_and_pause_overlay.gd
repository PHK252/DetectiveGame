extends Control

@onready var phone_ui = $"CanvasLayer/Phone UI"
@onready var pause = $CanvasLayer/CanvasLayer
@onready var call_anim = $CanvasLayer/AnimationPlayer
@onready var call_normal = $"CanvasLayer/Call Normal"
@onready var receiving_call = $"CanvasLayer/Receiving call"

#temp var to check if called
@onready var called = false

# Called when the node enters the scene tree for the first time.
func _ready():
	# phone call code
	#await get_tree().create_timer(3).timeout
	#GlobalVars.emit_phone_call()
	pass
func _process(delta):
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
	phone_ui.show()

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
