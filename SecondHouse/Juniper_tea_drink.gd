extends Node3D

@export var dalton_marker: Marker2D
@export var theo_marker: Marker2D
@export var character_marker: Marker2D
@export var player : CharacterBody3D
@export var alert : Sprite3D

#Interaction Variables
@export var interact_area: Interactable
@export var dialogue_file: String
@export var load_Dalton_dialogue: String
@export var load_Theo_dialogue: String
@export var load_char_dialogue: String


func _ready():
	interact_area.set_deferred("monitorable", false)


func choose_drink_thought_dialogue():
	if Dialogic.VAR.get_variable("Juniper.drank") == true:
		var rng = RandomNumberGenerator.new()
		var random = rng.randi_range(0, 3)
		Dialogic.VAR.set_variable("Juniper.drink_response", random)
	else:
		Dialogic.VAR.set_variable("Juniper.drank", true)
		Dialogic.VAR.set_variable("Juniper.drink_response", 0)


func _on_tea_activate_temp_interacted(interactor):
	GlobalVars.in_dialogue = true
	var game_dialogue = Dialogic.start(dialogue_file)
	Dialogic.timeline_ended.connect(_on_timeline_ended)
	game_dialogue.register_character(load(load_Dalton_dialogue), dalton_marker)
	game_dialogue.register_character(load(load_Theo_dialogue), theo_marker)
	game_dialogue.register_character(load(load_char_dialogue), character_marker)
	player.stop_player()
	alert.hide()


func _on_timeline_ended():
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	GlobalVars.in_dialogue = false
	player.start_player()
	alert.show()

#connected via signal when Juniper is done setting drinks down
func _activate_drink():
	interact_area.set_deferred("monitorable", true)
