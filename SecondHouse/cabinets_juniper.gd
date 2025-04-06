extends Node3D

@export var animation_tree : AnimationTree
#@onready var dalton_marker = $"../../../UI/Dalton_marker"
#@onready var micah_marker = $"../../../UI/Micah_marker"
#@onready var theo_marker = $"../../../UI/Theo_marker"
var is_open: bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func open() -> void:
	print("Opening")
	animation_tree["parameters/conditions/is_opened"] = true
	animation_tree["parameters/conditions/is_closed"] = false
	is_open = true
	
func close() -> void:
	print("Opening")
	animation_tree["parameters/conditions/is_closed"] = true
	animation_tree["parameters/conditions/is_opened"] = false
	is_open = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_interactable_interacted(interactor: Interactor) -> void:
	#print(is_open)
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
	
	if is_open == false:
		#print("open")
		#$Interactable.queue_free()
		open()
		return
		
	if is_open == true: 
		close()
	
