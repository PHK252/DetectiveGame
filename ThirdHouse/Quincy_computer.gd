extends Node3D

@export var player: CharacterBody3D
#@onready var note_interaction = $Note
@export var UI : CanvasLayer
@export var alert : Sprite3D

@export var dalton_marker: Marker2D

@export var dialogue_file: String
@export var load_Dalton_dialogue: String

@export var interact_type: String
# Called when the node enters the scene tree for the first time.
func _ready():
	UI.hide()
	pass # Replace with function body.


func _on_interactable_interacted(interactor):
	if GlobalVars.in_dialogue == false:
		alert.hide()
		GlobalVars.in_dialogue = true
		player.stop_player()
		var computer_dialogue = Dialogic.start(dialogue_file)
		Dialogic.signal_event.connect(compUI)
		Dialogic.timeline_ended.connect(_on_timeline_ended)
		computer_dialogue.register_character(load(load_Dalton_dialogue), dalton_marker)


func _on_timeline_ended():
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	GlobalVars.in_dialogue = false
	if GlobalVars.Quincy_in_computer == false:
		player.start_player()
		alert.show()
#
func compUI(argument: String):
	if argument == "turn_on":
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		player.hide()
		GlobalVars.Quincy_in_computer = true
		player.stop_player()
		GlobalVars.in_interaction = "computer"
		UI.show()
		Dialogic.signal_event.disconnect(compUI)
		

func _input(event):
	if Input.is_action_just_pressed("Exit") and GlobalVars.in_interaction == dialogue_file: 
		#print("funk")
		UI.hide()
		GlobalVars.Quincy_in_computer = false
		player.start_player()
		player.show()
		GlobalVars.in_interaction = ""
