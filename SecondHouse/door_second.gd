extends Node3D

@export var animation_tree : AnimationTree
@export var collision : CollisionShape3D

#@onready var dalton_marker = $"../../../UI/Dalton_marker"
#@onready var micah_marker = $"../../../UI/Micah_marker"
#@onready var theo_marker = $"../../../UI/Theo_marker"
@export var player = CharacterBody3D
var is_open: bool = false
@onready var entered = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func open() -> void:
	#print("Opening")
	animation_tree["parameters/conditions/is_opened"] = true
	animation_tree["parameters/conditions/is_closed"] = false
	is_open = true

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
	elif is_open == false and GlobalVars.in_dialogue == false:
		#print("open")
		#$Interactable.queue_free()
		open()
		collision.disabled = true

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
