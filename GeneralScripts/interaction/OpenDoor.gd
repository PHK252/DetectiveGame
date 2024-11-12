extends Node3D

@onready var animation_tree : AnimationTree = $bonedoor/AnimationDoor
@export var collision : CollisionShape3D

@onready var dalton_marker = $"../../../UI/Dalton_marker"
@onready var micah_marker = $"../../../UI/Micah_marker"
@onready var player = $"../../../Characters/Dalton/CharacterBody3D"
var is_open: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func open() -> void:
	print("Opening")
	animation_tree["parameters/conditions/is_opened"] = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_interactable_interacted(interactor: Interactor) -> void:
	#game code
	#__________________
	#player.stop_player()
	#GlobalVars.in_dialogue = true
	#Dialogic.timeline_ended.connect(_on_timeline_ended)
	#Dialogic.signal_event.connect(doorOpen)
	#var layout = Dialogic.start("Enter_house")
	#layout.register_character(load("res://Dialogic Characters/Dalton.dch"), dalton_marker)
	#layout.register_character(load("res://Dialogic Characters/Micah.dch"), micah_marker)
	
	#for debug
	#__________________
	if not is_open:
		$Interactable.queue_free()
		open()
		collision.disabled = true
		is_open = true


#game code
#__________________
#func _on_timeline_ended():
	#Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	#GlobalVars.in_dialogue = false
	#player.start_player()
#
#func doorOpen(argument: String):
	#if not is_open and argument == "open_door":
		#$Interactable.queue_free()
		#open()
		#collision.disabled = true
		#is_open = true
