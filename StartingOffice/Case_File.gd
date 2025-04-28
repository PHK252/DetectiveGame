extends MeshInstance3D

@onready var object = $"."
@onready var look = $"../../../../UI/Case Look"
@onready var player = $"../../Characters/Dalton/CharacterBody3D"
@onready var dalton_marker = $"../../../../UI/Dalton's Marker"
@onready var alert = $"../../Characters/Dalton/CharacterBody3D/PlayerInteractor/CollisionShape3D/Alert"
var just_interacted = false

func _on_interactable_interacted(interactor):
	if just_interacted == false:
		just_interacted = true
		object.hide()
		look.show()
		GlobalVars.in_look_screen = true
		GlobalVars.in_interaction = "case file"

func _on_exit_pressed():
	just_interacted = false
	alert.hide()
	object.show()
	#GlobalVars.in_look_screen = false
	await get_tree().create_timer(.5).timeout
	Dialogic.timeline_ended.connect(_on_timeline_ended)
	player.stop_player()
	var layout = Dialogic.start("Day 1 Office timeline")
	layout.register_character(load("res://Dialogic Characters/Dalton.dch"), dalton_marker)
	
	
func _on_timeline_ended():
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	player.start_player()
	GlobalVars.in_dialogue = false
	print("dialogic timeline ended")
	GlobalVars.in_interaction = ""
	
func _process(delta):
	if GlobalVars.in_interaction == "case file":
		if Input.is_action_just_pressed("Exit"):
			just_interacted = false
			alert.hide()
			object.show()
			#GlobalVars.in_look_screen = false
			await get_tree().create_timer(.5).timeout
			Dialogic.timeline_ended.connect(_on_timeline_ended)
			player.stop_player()
			var layout = Dialogic.start("Day 1 Office timeline")

			layout.register_character(load("res://Dialogic Characters/Dalton.dch"), dalton_marker)
