extends Node3D

@export var player : CharacterBody3D
@export var dalton_marker : Marker2D
@export var micah_marker : Marker2D

#@onready var player = $"../../../../../../Dalton/CharacterBody3D"
#@onready var dalton_maker = $"../../../../../../../UI/Dalton_marker"
#@onready var micah_marker = $"../../../../../../../UI/Micah_marker"
@onready var asked = false

func _on_interactable_interacted(interactor):
	if asked == false:
		GlobalVars.in_dialogue = true
		#player.stop_player()
		var ask_victims = Dialogic.start("Micah_Ask_Victims")
		Dialogic.timeline_ended.connect(_on_timeline_ended)
		ask_victims.register_character(load("res://Dialogic Characters/Dalton.dch"), dalton_marker)
		ask_victims.register_character(load("res://Dialogic Characters/Micah.dch"), micah_marker)

func _on_timeline_ended():
	#player.start_player()
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	GlobalVars.in_dialogue = false
	asked = true

func _process(delta):
	if asked == true:
		#print("hide")
		$Interactable.set_monitorable(false)
