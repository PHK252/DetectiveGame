extends Node3D

#Assign player body
@export var player: CharacterBody3D
@export var alert: Sprite3D

#Assign character markers (up to 3)
@export var dalton_marker: Marker2D
@export var theo_marker: Marker2D
@export var character_marker: Marker2D
@export var load_Dalton_dialogue: String
@export var load_Theo_dialogue: String
@export var load_char_dialogue: String

@export var dialogue_file : String

#func _process(delta):
	#if GlobalVars.bar_dialogue_Quincy_finsihed == true:
		#interact_area.hide()
	#else:
		#interact_area.show()

func _on_bar_interact_interacted(interactor):
	if GlobalVars.in_dialogue == false and GlobalVars.bar_dialogue_Quincy_finsihed == false and GlobalVars.in_interaction == false:
		GlobalVars.in_interaction = true
		var game_dialogue = Dialogic.start(dialogue_file)
		GlobalVars.in_dialogue = true
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
	GlobalVars.bar_dialogue_Quincy_finsihed = true
	#switch cam and move characters
