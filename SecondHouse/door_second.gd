extends Node3D

@export var animation_tree : AnimationTree
@export var collision : CollisionShape3D

#@onready var dalton_marker = $"../../../UI/Dalton_marker"
#@onready var micah_marker = $"../../../UI/Micah_marker"
#@onready var theo_marker = $"../../../UI/Theo_marker"
@export var player = CharacterBody3D
var is_open: bool = false
@onready var entered = false
signal j_door_open
signal j_door_closed
var cooldown = false

@export var quincy_house: bool

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
		open()
		collision.disabled = true
		return
		
	if is_open == true and cooldown == false: 
		close()
		collision.disabled = false
	
	

#game code
#__________________
#func _on_timeline_ended():
	#Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	#GlobalVars.in_dialogue = false

func doorOpen(argument: String):
	if not is_open and argument == "open_door":
		#$Interactable.queue_free()
		open()
		collision.disabled = true
		is_open = true

# will need more debugging
func _on_interactable_unfocused(interactor):
	if is_open == true:
		print("close")
		await get_tree().create_timer(3.0).timeout
		animation_tree["parameters/conditions/is_closed"] = true
		animation_tree["parameters/conditions/is_opened"] = false
		is_open = false
		entered = true
		collision.disabled = false
		
func _on_kitchen_point_body_entered(body: CharacterBody3D) -> void:
	if body.is_in_group("player"):
		print("entered")
		if GlobalVars.ghost_open and is_open == false:
			open()
			GlobalVars.ghost_open = false
