extends MeshInstance3D

@export var casefilecam : PhantomCamera3D
@export var exitcam : PhantomCamera3D
@export var camanim : AnimationPlayer
@onready var object = $"."
@onready var look_click = $"../../../../UI/Casefile"
@onready var player = $"../../Characters/Dalton/CharacterBody3D"
@onready var dalton_marker = $"../../../../UI/Dalton's Marker"
@onready var theo_marker = $"../../../../UI/Theo's Marker"
@onready var alert = $"../../Characters/Dalton/CharacterBody3D/PlayerInteractor/CollisionShape3D/Alert"

var just_interacted = false

func _on_interactable_interacted(interactor):
	if just_interacted == false and GlobalVars.in_dialogue == false:
		casefilecam.priority = 5
		exitcam.priority = 0
		just_interacted = true
		#object.hide()
		camanim.play("Cam_Idle")
		player.stop_player()
		player.hide()
		look_click.show()
		#GlobalVars.in_look_screen = true
		GlobalVars.in_interaction = "case file"

#func _on_exit_pressed():
	#just_interacted = false
	#alert.hide()
	#look_click.hide()
	#casefilecam.priority = 0
	#exitcam.priority = 5
	#camanim.play("RESET")
	#player.show()
	#if GlobalVars.intro_dialogue == false and GlobalVars.viewed_case_file == true:
		#GlobalVars.in_dialogue = true
		#Dialogic.timeline_ended.connect(_on_timeline_ended)
		#player.show()
		#var layout = Dialogic.start("Day 1 Office timeline")
		#layout.register_character(load("res://Dialogic Characters/Dalton.dch"), dalton_marker)
		#layout.register_character(load("res://Dialogic Characters/Theo.dch"), theo_marker)
	#else:
		#player.start_player()
	#
	#
	
func _on_timeline_ended():
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	player.start_player()
	alert.show()
	GlobalVars.in_dialogue = false
	print("dialogic timeline ended")
	GlobalVars.in_interaction = ""
	GlobalVars.intro_dialogue = true
	
func _process(delta):
	if GlobalVars.in_interaction == "case file":
		if Input.is_action_just_pressed("Exit"):
			just_interacted = false
			look_click.hide()
			casefilecam.priority = 0
			exitcam.priority = 5
			camanim.play("RESET")
			alert.hide()
			object.show()
			player.show()
			#await get_tree().create_timer(.5).timeout
			if GlobalVars.intro_dialogue == false and GlobalVars.viewed_case_file == true:
				GlobalVars.in_dialogue = true
				Dialogic.timeline_ended.connect(_on_timeline_ended)
				player.show()
				var layout = Dialogic.start("Day 1 Office timeline")
				layout.register_character(load("res://Dialogic Characters/Dalton.dch"), dalton_marker)
				layout.register_character(load("res://Dialogic Characters/Theo.dch"), theo_marker)
			else:
				player.start_player()
				alert.show()
