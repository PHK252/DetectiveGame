extends Node3D

@export var animation_tree : AnimationTree
@export var collision : CollisionShape3D

@export var dalton_marker : Marker2D
@export var theo_marker : Marker2D
@export var quincy_marker : Marker2D
@export var player = CharacterBody3D
@export var alert : Sprite3D
@export var interactable : Interactable
var is_open: bool = false
@onready var entered = false
var cooldown = false
var triggered = false
@export var bathroom_enter_dialogue : String
@export var clog_exit_dialogue : String
@onready var greeting = false
@export var quincy_house: bool
@export var quincy_house_inside: bool
@onready var in_bathroom 
@onready var distracted 
@onready var player_in_bathroom = false
@onready var quincy_close_door = false

signal Quincy_enter_bathroom

#sounds
@export var open_sound : AudioStreamPlayer3D
@export var close_sound : AudioStreamPlayer3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func open() -> void:
	print("opening")
	cooldown = true
	collision.set_deferred("disabled", true)
	animation_tree["parameters/conditions/is_opened"] = true
	animation_tree["parameters/conditions/is_closed"] = false
	is_open = true
	open_sound.play()
	#emit_signal("j_door_open")
	await get_tree().create_timer(2.0).timeout
	cooldown = false
	
	
func close() -> void:
	#print("Opening")
	cooldown = true
	animation_tree["parameters/conditions/is_closed"] = true
	animation_tree["parameters/conditions/is_opened"] = false
	collision.set_deferred("disabled", false)
	is_open = false
	#emit_signal("j_door_closed")
	await get_tree().create_timer(2.0).timeout
	close_sound.play()
	if quincy_house:
		print("quickCLosing")
		animation_tree["parameters/conditions/quick_close"] = true
		await get_tree().create_timer(0.5).timeout
		animation_tree["parameters/conditions/quick_close"] = false
		animation_tree["parameters/conditions/is_closed"] = false
	cooldown = false
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_interactable_interacted(interactor: Interactor) -> void:
	in_bathroom = Dialogic.VAR.get_variable("Quincy.in_bathroom")
	distracted = Dialogic.VAR.get_variable("Quincy.is_distracted")
	print("player " + str(player_in_bathroom))
	print("distract "+ str(distracted))
	if is_open == false and GlobalVars.in_dialogue == false:
		if in_bathroom == false:
			if distracted == false and player_in_bathroom == false:
				Dialogic.timeline_ended.connect(_on_timeline_ended)
				player.stop_player()
				alert.hide()
				GlobalVars.in_dialogue = true
				var bathroom = Dialogic.start(bathroom_enter_dialogue)
				bathroom.register_character(load("res://Dialogic Characters/Dalton.dch"), dalton_marker)
				bathroom.register_character(load("res://Dialogic Characters/Quincy.dch"), quincy_marker)
				bathroom.register_character(load("res://Dialogic Characters/Theo.dch"), theo_marker)
			else:
				open()
		else:
			close()
	else:
		pass
	
func _on_timeline_ended():
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	player.start_player()
	alert.show()
	GlobalVars.in_dialogue = false
	open()
	#asked = true
func _on_exit_timeline_ended():
	Dialogic.timeline_ended.disconnect(_on_exit_timeline_ended)
	player.start_player()
	alert.hide()
	GlobalVars.in_dialogue = false


func _on_bathroom_body_entered(body):
	if body.is_in_group("player"):
		if is_open == true:
			close()
			player_in_bathroom = true



func _on_bathroom_door_body_exited(body):
	if body.is_in_group("player"):
		if player_in_bathroom == true:
			if Dialogic.VAR.get_variable("Quincy.clogged_toilet") == true:
				print("bathroom exit")
				player_in_bathroom = false
				GlobalVars.in_dialogue = true
				player.stop_player()
				alert.hide()
				Dialogic.timeline_ended.connect(_on_exit_timeline_ended)
				Dialogic.signal_event.connect(_quincy_enter_bathroom)
				var clogged = Dialogic.start(clog_exit_dialogue)
				clogged.register_character(load("res://Dialogic Characters/Dalton.dch"), dalton_marker)
				clogged.register_character(load("res://Dialogic Characters/Quincy.dch"), quincy_marker)
				clogged.register_character(load("res://Dialogic Characters/Theo.dch"), theo_marker)
			else:
				close()
			


func _quincy_enter_bathroom(argument: String):
	if argument == "quincy_clean":
		Dialogic.signal_event.disconnect(_quincy_enter_bathroom)
		emit_signal("Quincy_enter_bathroom")
		print("quincy clean")
		quincy_close_door = true
		await get_tree().create_timer(3.0).timeout
		close()
		pass


func _on_interactable_body_entered(body):
	in_bathroom = Dialogic.VAR.get_variable("Quincy.in_bathroom")
	distracted = Dialogic.VAR.get_variable("Quincy.is_distracted")
	if body.is_in_group("player"):
		if distracted == true and in_bathroom == true:
			alert.hide()


func _on_phone_ui_book_distract_quincy():
	interactable.set_deferred("monitorable", false)


func _on_quincy_time_out_resume():
	if interactable.monitorable == false:
		interactable.set_deferred("monitorable", true)
