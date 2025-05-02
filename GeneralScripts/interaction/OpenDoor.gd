extends Node3D

@onready var animation_tree : AnimationTree = $bonedoor/AnimationDoor
@export var collision : CollisionShape3D

@onready var dalton_marker = $"../../../UI/Dalton_marker"
@onready var micah_marker = $"../../../UI/Micah_marker"
@onready var theo_marker = $"../../../UI/Theo_marker"
@onready var player = $"../../Characters/Dalton/CharacterBody3D"
var is_open: bool = false
@onready var entered = false
@export var door_sound : AudioStreamPlayer3D
@export var door_sound_close : AudioStreamPlayer3D
var introduction_happened = false

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
	cooldown = false
	
func close() -> void:
	print("Closing")
	
	cooldown = true
	animation_tree["parameters/conditions/is_closed"] = true
	animation_tree["parameters/conditions/is_opened"] = false
	is_open = false
	await get_tree().create_timer(2.5).timeout
	door_sound_close.play()
	cooldown = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_interactable_interacted(interactor: Interactor) -> void:
	if cooldown == false:
		cooldown = true
		emit_signal("general_interact")
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
			GlobalVars.in_dialogue == true
			Dialogic.signal_event.connect(doorOpen)
			Dialogic.timeline_ended.connect(_on_timeline_ended)
			var layout = Dialogic.start("Micah_Leave")
			layout.register_character(load("res://Dialogic Characters/Dalton.dch"), dalton_marker)
			layout.register_character(load("res://Dialogic Characters/Micah.dch"), micah_marker)
			layout.register_character(load("res://Dialogic Characters/Theo.dch"), theo_marker)
		elif is_open == false and GlobalVars.in_dialogue == false:
			#print("open")
			#$Interactable.queue_free()
			if introduction_happened:
				open()
				collision.disabled = true
			else:
				emit_signal("greeting")
				emit_signal("micah_rotate")
				print("dalton_move_knock")
			
			return
				
			
		if is_open == true: 
			close()
			collision.disabled = false
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
		collision.disabled = true
		is_open = true
		entered = true

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
	introduction_happened = true
