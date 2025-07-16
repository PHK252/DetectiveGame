extends Node3D

@export var animation_tree : AnimationTree
@export var collision : CollisionShape3D

@export var dalton_marker : Marker2D
@export var character_marker : Marker2D
@export var theo_marker : Marker2D
@export var player = CharacterBody3D
var is_open: bool = false
@onready var entered = false
signal j_door_open
signal j_door_closed
var cooldown = false
var triggered = false
var entered_quincy_house = false
var leaving = false

@onready var greeting = false
signal juniper_greeting
signal cam_greeting
signal j_dialogue

@export var quincy_house: bool
@export var quincy_house_inside: bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func open() -> void:
	print("opening")
	cooldown = true
	animation_tree["parameters/conditions/is_opened"] = true
	animation_tree["parameters/conditions/is_closed"] = false
	is_open = true
	emit_signal("j_door_open")
	await get_tree().create_timer(2.0).timeout
	cooldown = false
	
	
func close() -> void:
	#print("Opening")
	cooldown = true
	animation_tree["parameters/conditions/is_closed"] = true
	animation_tree["parameters/conditions/is_opened"] = false
	is_open = false
	emit_signal("j_door_closed")
	await get_tree().create_timer(2.0).timeout
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
	print(is_open)
	print(entered)
	#game code
	#__________________
	#player.stop_player()
	#GlobalVars.in_dialogue = true
	#Dialogic.timeline_ended.connect(_on_timeline_ended)
	#Dialogic.signal_event.connect(doorOpen)
	#var layout = Dialogic.start("Enter_house")
	#layout.register_character(load("res://Dialogic Characters/Dalton.dch"), dalton_marker)
	#layout.register_character(load("res://Dialogic Characters/Micah.dch"), micah_marker)
	#layout.register_character(load("res://Dialogic Characters/Theo.dch"), theo_marker)
	
	#for debug
	#__________________
	
	if is_open == false and entered == true and GlobalVars.in_dialogue == false:
		open()
		#GlobalVars.in_dialogue == true
		#Dialogic.signal_event.connect(doorOpen)
		#Dialogic.timeline_ended.connect(_on_timeline_ended)
		#var layout = Dialogic.start("Micah_Leave")
		#layout.register_character(load("res://Dialogic Characters/Dalton.dch"), dalton_marker)
		#layout.register_character(load("res://Dialogic Characters/Micah.dch"), micah_marker)
		#layout.register_character(load("res://Dialogic Characters/Theo.dch"), theo_marker)
		pass
	
	elif is_open == false and GlobalVars.in_dialogue == false and cooldown == false:
		#print("open")
		#$Interactable.queue_free()
		if greeting == false and quincy_house == false and triggered == false:
			print("asking juniper to come")
			emit_signal("juniper_greeting")
			emit_signal("cam_greeting")
			triggered = true
			return
			#play knocking sound
		
		if (greeting == true and quincy_house == false) or quincy_house or quincy_house_inside:
			open()
			collision.disabled = true
			return
		
	if is_open == true and cooldown == false and (greeting == true or quincy_house or quincy_house_inside): 
		close()
		collision.disabled = false
	
	if is_open == false and entered_quincy_house == true:
		GlobalVars.in_dialogue == true
		player.stop_player()
		Dialogic.signal_event.connect(doorOpen)
		Dialogic.timeline_ended.connect(_on_timeline_ended)
		var quincy_leave = Dialogic.start("Quincy_leaving")
		quincy_leave.register_character(load("res://Dialogic Characters/Dalton.dch"), dalton_marker)
		quincy_leave.register_character(load("res://Dialogic Characters/Quincy.dch"), character_marker)
		quincy_leave.register_character(load("res://Dialogic Characters/Theo.dch"), theo_marker)

#game code
#__________________
#func _on_timeline_ended():
	#Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	#GlobalVars.in_dialogue = false

func doorOpen(argument: String):
	if not is_open and argument == "open_door":
		if entered_quincy_house == true:
			leaving = true
		open()
		collision.disabled = true
		is_open = true

		
func _on_kitchen_point_body_entered(body: CharacterBody3D) -> void:
	if body.is_in_group("player"):
		print("entered")
		if GlobalVars.ghost_open and is_open == false:
			open()
			GlobalVars.ghost_open = false


func _on_side_enter_body_entered(body: Node3D) -> void:
	if quincy_house:
		if is_open == false:
			open()
			collision.disabled = true

func _on_main_enter_body_entered(body: Node3D) -> void:
	#if quincy_house:
		#if is_open == false:
			#open()
			#collision.disabled = true
			pass
			
			
#emit a signal on arrival to open

func _on_character_body_3d_juniper_open_door() -> void:
	open()
	collision.disabled = true
	await get_tree().create_timer(2.0).timeout
	emit_signal("j_dialogue")

func _on_juniper_interact_finish_greeting() -> void:
	greeting = true

func _on_quincy_interact_finish_greeting() -> void:
	open()
	collision.disabled = true
	


func _on_quincy_interact_close_door():
	close()
	collision.set_deferred("disabled", false) 
	entered_quincy_house = true

func _on_timeline_ended():
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	GlobalVars.in_dialogue = false
	player.start_player()


func _on_after_faint_open_door():
	open()
	collision.disabled = true
	is_open = true
	leaving = true


func _on_exit_house(body):
	var dalton_left = false
	var theo_left = false
	if leaving == true:
		if body.is_in_group("player"):
			dalton_left = true
			if dalton_left == true and theo_left == true:
				close()
				collision.set_deferred("disabled", false) 
				is_open = false
		
		if body.is_in_group("theo"):
			theo_left = true
			if dalton_left == true and theo_left == true:
				close()
				collision.set_deferred("disabled", false) 
				is_open = false
