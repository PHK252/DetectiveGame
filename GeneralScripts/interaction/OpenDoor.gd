extends Node3D

@onready var animation_tree : AnimationTree = $bonedoor/AnimationDoor
@export var collision : CollisionShape3D
@export var alert : Sprite3D

@export var dalton_marker : Marker2D
@export var micah_marker : Marker2D
@export var theo_marker : Marker2D
@export var player :CharacterBody3D
@export var theo : CharacterBody3D
var is_open: bool = false
@onready var entered = false
@export var door_sound : AudioStreamPlayer3D
@export var door_sound_close : AudioStreamPlayer3D
var introduction_happened = false
var dalton_entered = false
var theo_entered = false

signal micah_rotate
signal greeting
signal general_interact
var is_outside = true

var cooldown = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func open() -> void:
	#if is_outside:
		#emit_signal("micah_rotate")
	cooldown = true
	print("Opening")
	door_sound.play()
	animation_tree["parameters/conditions/is_opened"] = true
	animation_tree["parameters/conditions/is_closed"] = false
	is_open = true
	await get_tree().create_timer(2.5).timeout
	collision.disabled = true
	cooldown = false
	
func close() -> void:
	print("Closing")
	
	cooldown = true
	animation_tree["parameters/conditions/is_closed"] = true
	animation_tree["parameters/conditions/is_opened"] = false
	is_open = false
	await get_tree().create_timer(2.5).timeout
	door_sound_close.play()
	collision.disabled = false
	cooldown = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_interactable_interacted(interactor: Interactor) -> void:
	if cooldown == false:
		cooldown = true
		alert.hide()
		emit_signal("general_interact")
		print(is_open)
		print(entered)
	
		
		
		#level exit
		#__________________
		if is_open == false and entered == true and GlobalVars.in_dialogue == false:
			GlobalVars.in_dialogue == true
			Dialogic.signal_event.connect(doorOpen)
			Dialogic.timeline_ended.connect(_on_timeline_ended)
			var exit = Dialogic.start("Micah_Leave")
			exit.register_character(load("res://Dialogic Characters/Dalton.dch"), dalton_marker)
			exit.register_character(load("res://Dialogic Characters/Micah.dch"), micah_marker)
			exit.register_character(load("res://Dialogic Characters/Theo.dch"), theo_marker)
		elif is_open == false and GlobalVars.in_dialogue == false:
			#print("open")
			#$Interactable.queue_free()
			if introduction_happened:
				open()
				collision.disabled = true
			else:
				emit_signal("greeting")
				emit_signal("micah_rotate")
				#Level enter
				#__________________
				#player.stop_player()
				#GlobalVars.in_dialogue = true
				introduction_happened = true
				#Dialogic.timeline_ended.connect(_on_timeline_ended)
				#Dialogic.signal_event.connect(doorOpen)
				#var enter = Dialogic.start("Enter_house")
				#enter.register_character(load("res://Dialogic Characters/Dalton.dch"), dalton_marker)
				#enter.register_character(load("res://Dialogic Characters/Micah.dch"), micah_marker)
				#enter.register_character(load("res://Dialogic Characters/Theo.dch"), theo_marker)
				print("dalton_move_knock")
			return
				
			
		if is_open == true: 
			close()
		#	collision.disabled = false
			return
		

#game code
#__________________
func _on_timeline_ended():
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	GlobalVars.in_dialogue = false

func doorOpen(argument: String):
	if not is_open and argument == "open_door":
		#$Interactable.queue_free()
		open()
		#collision.disabled = true
		is_open = true

# will need more debugging
func _on_interactable_unfocused(interactor):
	if is_open == true:
		print("close")
		#await get_tree().create_timer(3.0).timeout
		#animation_tree["parameters/conditions/is_closed"] = true
		#animation_tree["parameters/conditions/is_opened"] = false
		#is_open = false
		#entered = true
		#collision.disabled = false

func _on_character_body_3d_d_hall() -> void:
	is_outside = true

func _on_character_body_3d_d_inside() -> void:
	is_outside = false

func _on_micah_body_micah_open() -> void:
	await get_tree().create_timer(5).timeout
	open()
	collision.disabled = true
	#introduction_happened = true



func _on_door_theo_entered():
	if entered == false:
		theo_entered = true
		print("theo entered!" + str(theo_entered))
		if dalton_entered == true:
			entered = true
			close()


func _on_dalton_door_entered():
	if entered == false: 
		dalton_entered = true
		print("dalton entered!"  + str(dalton_entered))
		if theo_entered == true:
			entered = true
			close()


func _on_door_theo_leave_body_entered(body):
	if body == theo:
		print("theoleft")
		
