extends Node3D

@export var animation_tree : AnimationTree
@export var collision : CollisionShape3D
@export var patio_lock : CollisionShape3D
@export var player : CharacterBody3D
@export var alert : Sprite3D
@export var dalton_marker : Marker2D
var is_open: bool = false
@onready var inside_open = false
var cooldown = false
var triggered = false

#sounds
@export var open_sound : AudioStreamPlayer3D
@export var close_sound : AudioStreamPlayer3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Dialogic.VAR.get_variable("Quincy.left_quincy") == true:
		patio_lock.disabled = true
		return
	patio_lock.disabled = !is_open
	

func open() -> void:
	print("opening")
	cooldown = true
	animation_tree["parameters/conditions/is_opened"] = true
	animation_tree["parameters/conditions/is_closed"] = false
	is_open = true
	open_sound.play()
	await get_tree().create_timer(2.0).timeout
	cooldown = false
	
	
func close() -> void:
	#print("Opening")
	cooldown = true
	animation_tree["parameters/conditions/is_closed"] = true
	animation_tree["parameters/conditions/is_opened"] = false
	is_open = false
	await get_tree().create_timer(2.0).timeout
	close_sound.play()
	print("quickCLosing")
	animation_tree["parameters/conditions/quick_close"] = true
	await get_tree().create_timer(0.5).timeout
	animation_tree["parameters/conditions/quick_close"] = false
	animation_tree["parameters/conditions/is_closed"] = false
	cooldown = false



func _on_back_interacted(interactor):
	if is_open == false and cooldown == false:
		open()
		collision.disabled = true
		if inside_open == false:
			inside_open = true
			patio_lock.disabled = !inside_open
	elif is_open == true and cooldown == false:
		close()
		collision.disabled = false

func _on_front_interacted(interactor):
	if inside_open == true:
		if is_open == false and cooldown == false:
			open()
			collision.disabled = true
		elif is_open == true and cooldown == false:
			close()
			collision.disabled = false
	else:
		if GlobalVars.in_dialogue == false:
			GlobalVars.in_dialogue = true
			var locked = Dialogic.start("Quincy_Patio_Locked")
			Dialogic.timeline_ended.connect(_on_timeline_ended)
			locked.register_character(load("res://Dialogic Characters/Dalton.dch"), dalton_marker)
			player.stop_player()
			alert.hide()

func _on_timeline_ended():
	#emit_signal("Dstopped")
	#emit_signal("Tstart")
	player.start_player()
	alert.show()
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	GlobalVars.in_dialogue = false




func _on_main_level_end():
	patio_lock.disabled = true
