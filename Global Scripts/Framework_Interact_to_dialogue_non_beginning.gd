extends Node3D
#Assign player body
@export var player: CharacterBody3D
@export var alert: Sprite3D
@export var interaction : Interactable
@export var interaction_type : String
#Dialogue Stuff
@export var dialogue_file: String
@export var interact_type: String
signal _show_tut(tut_type : String)
signal gen_interact

func _on_interactable_interacted(interactor):
	if GlobalVars.in_interaction == "" and GlobalVars.in_dialogue == false:
		emit_signal("gen_interact")
		GlobalVars.in_interaction = interaction_type
		GlobalVars.in_dialogue = true
		Dialogic.start(dialogue_file)
		Dialogic.timeline_ended.connect(_on_timeline_ended)
		alert.hide()
		GlobalVars.in_interaction = interact_type
		player.stop_player()



func _on_timeline_ended():
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	GlobalVars.in_dialogue = false
	player.start_player()
	GlobalVars.in_interaction = ""
	if interaction:
		interaction.set_deferred("monitorable", false)
		interaction.queue_free()
		alert.hide()
		return
	alert.show()
