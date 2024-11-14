extends Node3D

#@onready var closet_cam = $"../SubViewportContainer/SubViewport/CameraSystem/Closet close up"
#@onready var main_cam = $"../SubViewportContainer/SubViewport/CameraSystem/closet"
@onready var player = $"../../../../Characters/Dalton/CharacterBody3D"
#@onready var note_interaction = $Note
#@onready var cam_anim = $"../SubViewportContainer/SubViewport/CameraSystem/Closet close up/AnimationPlayer"
#@onready var mouse_pos = Vector2(0,0)
#@onready var closet_open = false

@onready var dalton_maker = $"../../../../UI/Dalton_marker"
@onready var micah_marker = $"../../../../UI/Micah_marker"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_interactable_interacted(interactor):
	var case_asked = Dialogic.VAR.get_variable("Asked Questions.Micah_Asked_Case")
	print(case_asked)
	if GlobalVars.in_dialogue == false:
		if case_asked == false:
			GlobalVars.in_dialogue = true
			player.stop_player()
			var closet_dialogue = Dialogic.start("Micah_case_ask")
			Dialogic.timeline_ended.connect(_on_timeline_ended)
			Dialogic.signal_event.connect(caseUI)
			closet_dialogue.register_character(load("res://Dialogic Characters/Dalton.dch"), dalton_maker)
			closet_dialogue.register_character(load("res://Dialogic Characters/Micah.dch"), micah_marker)
		else:
			GlobalVars.in_dialogue = true
			player.stop_player()
			var closet_dialogue = Dialogic.start("Micah_case_ask", "choices")
			Dialogic.timeline_ended.connect(_on_timeline_ended)
			Dialogic.signal_event.connect(caseUI)
			closet_dialogue.register_character(load("res://Dialogic Characters/Dalton.dch"), dalton_maker)
			closet_dialogue.register_character(load("res://Dialogic Characters/Micah.dch"), micah_marker)


func _on_timeline_ended():
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	GlobalVars.in_dialogue = false
	player.start_player()
#
func caseUI(argument: String):
	if argument == "look_case":
		# connect signal to switch cams
		GlobalVars.in_interaction = "case"
		print("in UI")
		#closet_cam.priority = 15
		#main_cam.priority = 0 
		#note_interaction.show()
		#cam_anim.play("Cam_Idle")
		#player.hide()
