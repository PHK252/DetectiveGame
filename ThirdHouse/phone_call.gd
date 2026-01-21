extends Node

@export var phone: Node3D
signal PhoneCall

func _ready() -> void:
	phone.visible = false
	
#func _process(delta: float) -> void:
	#if Input.is_action_just_pressed("call"):
		#emit_signal("PhoneCall")
		#await get_tree().create_timer(2.0).timeout
		#phone.visible = true
		#await get_tree().create_timer(9.0).timeout
		#phone.visible = false
