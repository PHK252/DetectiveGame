extends MeshInstance3D

@export var main : Node3D
@export var casefilecam : PhantomCamera3D
@export var exitcam : PhantomCamera3D
@export var camanim : AnimationPlayer
@export var theo_theme : AudioStreamPlayer
@export var office_theme : AudioStreamPlayer
@onready var object = $"."
@onready var look_click = $"../../../../UI/Casefile"
@onready var ending_text = $"../../../../UI/Ending Text"
@onready var player = $"../../Characters/Dalton/CharacterBody3D"
@export var tutorial : CanvasLayer
@onready var alert = $"../../Characters/Dalton/CharacterBody3D/PlayerInteractor/CollisionShape3D/Alert"

var dialogue_file : String
var just_interacted := false
signal _show_tut(tut_type : String)
signal theo_out
signal theo_move
signal activate_map

signal paper_exit
signal general_interaction
signal call_recieved

signal theo_exit
signal dalton_exit
signal _hide_tut

func _ready():
	if Dialogic.VAR.get_variable("Endings.Ending_type") == "Give Kale Cure" or Dialogic.VAR.get_variable("Endings.Ending_type") == "Give Kale Cure And Choco":
		emit_signal("theo_out")
		 #"res://UI/Assets/Endings/Give Skylar Cure P1@2x.png")
		#return
	#if Dialogic.VAR.get_variable("Endings.Ending_type") != true:
		#return
	#set_instance_shader_parameter("albedo_texture", "res://StartingOffice/StartingOffice_CaseFile.png")
	Dialogic.signal_event.connect(_on_dialogic_signal)
	
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame

	match GlobalVars.day:
		1:
			global_position = Vector3(-0.322,0.655,0.965)
			set_global_rotation_degrees(Vector3(0.0,23.2,0.0))
		2:
			global_position = Vector3(-0.372,0.655,0.975)
			set_global_rotation_degrees(Vector3(0.0,18.0,0.0))
		3:
			global_position = Vector3(-0.38,0.655,0.975)
			set_global_rotation_degrees(Vector3(0.0,21.0,0.0))
			
	
	
#func _process(delta: float) -> void: for testing leave when theo walks in
	#if Input.is_action_just_pressed("call"):
		#emit_signal("theo_exit")
		#await get_tree().create_timer(2.0).timeout
		#emit_signal("dalton_exit")
		#test signal for both leave

func _on_dialogic_signal(argument: String):
	if argument == "fade_in_out":
		print("successfully_faded_audio")
		MusicFades.fade_out_audio()
		await get_tree().create_timer(3.5).timeout #if doing manually after 3.5 is safe try not to go lower
		theo_theme.stop()
		office_theme.play()
		MusicFades.fade_in_audio()
		#theo_theme.stop()

func _on_interactable_interacted(interactor):
	if just_interacted == false and GlobalVars.in_dialogue == false:
		emit_signal("general_interaction")
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		casefilecam.priority = 5
		exitcam.priority = 0
		just_interacted = true
		#object.hide()
		camanim.play("Cam_Idle")
		player.stop_player()
		player.hide()
		if Dialogic.VAR.get_variable("Endings.Ending_type") != "":
			GlobalVars.in_interaction = "Ending Texts"
			ending_text.show()
			print("enter interaction", GlobalVars.in_interaction)
			return
		GlobalVars.in_interaction = "case file"
		look_click.show()
		if GlobalVars.exit_tut == false:
			emit_signal("_show_tut", "exit")

func _on_exit_pressed():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	just_interacted = false
	casefilecam.priority = 0
	exitcam.priority = 5
	camanim.play("RESET")
	alert.hide()
	object.show()
	player.show()
	emit_signal("paper_exit")
	match GlobalVars.in_interaction:
		"case file":
			look_click.hide()
			await get_tree().create_timer(.05).timeout
			if GlobalVars.intro_dialogue == false and GlobalVars.viewed_case_file == true:
				if GlobalVars.exit_tut == false and tutorial.visible == true:
					emit_signal("_hide_tut")
				GlobalVars.in_dialogue = true
				Dialogic.timeline_ended.connect(_on_timeline_ended)
				Dialogic.signal_event.connect(enter_Theo)
				var layout = Dialogic.start("Day 1 Office timeline")
				return
			else:
				player.start_player()
				alert.show()
				GlobalVars.in_interaction = ""
				return
		"Ending Texts":
			ending_text.hide()
			var fired : bool
			var phone : bool
			match Dialogic.VAR.get_variable("Endings.Ending_type"):
				"Arrested Skylar":
					phone = true
					dialogue_file = "Ending_arrested_skylar"
				"Keep Confidential":
					phone = true
					dialogue_file = "Keep_confidential"
				"Give Skylar Cure":
					phone = true
					dialogue_file = "Ending_Give_Skylar_Cure"
				"Give Skylar Cure And Choco":
					phone = true
					dialogue_file = "Ending_Give_Skylar_Cure_choco"
				"Give Kale Cure":
					dialogue_file = "Ending_Give_Kale_Cure"
				"Give Kale Cure And Choco":
					dialogue_file = "Ending_Give_Kale_Cure_choco"
				"Chief fired":
					fired = true
					dialogue_file = "Day_3_fired_not_solved_case"
				"Quincy fired":
					fired = true
					dialogue_file = "Day_3_fired_quincy"
				_:
					print_debug("No Ending Uh Oh")
			player.stop_player()
			GlobalVars.in_dialogue = true
			Dialogic.signal_event.connect(enter_ending_Theo)
			Dialogic.signal_event.connect(walk_out)
			Dialogic.signal_event.connect(calling)
			if fired == false:
				if phone == false:
					Dialogic.timeline_ended.connect(_on_ending_timeline_ended)
				else:
					Dialogic.timeline_ended.connect(_on_phone_timeline_ended)
				Dialogic.start(dialogue_file)
				return
			Dialogic.start(dialogue_file, "call_talk")
			Dialogic.timeline_ended.connect(_on_phone_timeline_ended)
			return
			
func enter_ending_Theo(argument: String):
	if argument == "theo_walk_in":
		#Prompt theo to walk through the door
		print("Theo enters")
		emit_signal("theo_move")
		Dialogic.signal_event.disconnect(enter_ending_Theo)
		pass

#add anims
func walk_out(argument: String):
	if argument == "walk_out":
		#Prompt theo to walk through the door
		#print("Both exit")
		#emit_signal("Both_walk out")
		#walk out signals for when theo walks in only
		emit_signal("theo_exit")
		await get_tree().create_timer(0.5).timeout
		player.start_player()
		emit_signal("dalton_exit")
		Dialogic.signal_event.disconnect(walk_out)
	elif argument == "theo_exit":
		emit_signal("theo_exit")
		Dialogic.signal_event.disconnect(walk_out)

func calling(argument: String):
	if argument == "start_call":
		emit_signal("call_recieved")
		GlobalVars.in_dialogue = false
		Dialogic.signal_event.disconnect(calling)

func _on_call_start_dialogue():
#	print(dialogue_file)
	GlobalVars.in_dialogue = true
	Dialogic.timeline_ended.connect(_on_ending_timeline_ended)
	Dialogic.start(dialogue_file, "call")
	
func _on_timeline_ended():
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	player.start_player()
	alert.show()
	GlobalVars.in_level = true
	#office_theme.play()
	#theo_theme.stop()
	##Map tut if players are confused
	#if GlobalVars.map_tut == false:
		#emit_signal("_show_tut", "map")
	GlobalVars.in_dialogue = false
	emit_signal("activate_map")
	GlobalVars.in_interaction = ""
	GlobalVars.intro_dialogue = true

func _on_ending_timeline_ended():
	Dialogic.timeline_ended.disconnect(_on_ending_timeline_ended)
	MusicFades.fade_out_audio()
	SceneTransitions.fade_change_scene(GlobalVars.credits)
	await get_tree().create_timer(1.0).timeout
	main.queue_free()
	pass
	
func _on_phone_timeline_ended():
	Dialogic.timeline_ended.disconnect(_on_phone_timeline_ended)
	#Anim
	pass

func _input(event):
	if Input.is_action_just_pressed("Exit") and GlobalVars.in_dialogue == false and (GlobalVars.in_interaction == "case file" or GlobalVars.in_interaction == "Ending Texts"):
		print("exit")
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		just_interacted = false
		casefilecam.priority = 0
		exitcam.priority = 5
		camanim.play("RESET")
		alert.hide()
		object.show()
		player.show()
		emit_signal("paper_exit")
		match GlobalVars.in_interaction:
			"case file":
				look_click.hide()
				await get_tree().create_timer(.05).timeout
				if GlobalVars.intro_dialogue == false and GlobalVars.viewed_case_file == true:
					if GlobalVars.exit_tut == false and tutorial.visible == true:
						emit_signal("_hide_tut")
					GlobalVars.in_dialogue = true
					Dialogic.timeline_ended.connect(_on_timeline_ended)
					Dialogic.signal_event.connect(enter_Theo)
					var layout = Dialogic.start("Day 1 Office timeline")
					return
				else:
					player.start_player()
					alert.show()
					GlobalVars.in_interaction = ""
					return
			"Ending Texts":
				ending_text.hide()
				if GlobalVars.viewing == "ending text":
					alert.hide()
					var fired : bool
					var phone : bool
					match Dialogic.VAR.get_variable("Endings.Ending_type"):
						"Arrested Skylar":
							phone = true
							dialogue_file = "Ending_arrested_skylar"
						"Keep Confidential":
							phone = true
							dialogue_file = "Keep_confidential"
						"Give Skylar Cure":
							phone = true
							dialogue_file = "Ending_Give_Skylar_Cure"
						"Give Skylar Cure And Choco":
							phone = true
							dialogue_file = "Ending_Give_Skylar_Cure_choco"
						"Give Kale Cure":
							dialogue_file = "Ending_Give_Kale_Cure"
						"Give Kale Cure And Choco":
							dialogue_file = "Ending_Give_Kale_Cure_choco"
						"Chief fired":
							fired = true
							dialogue_file = "Day_3_fired_not_solved_case"
						"Quincy fired":
							fired = true
							dialogue_file = "Day_3_fired_quincy"
						_:
							print_debug("No Ending Uh Oh")
					player.stop_player()
					GlobalVars.in_dialogue = true
					Dialogic.signal_event.connect(enter_ending_Theo)
					Dialogic.signal_event.connect(walk_out)
					Dialogic.signal_event.connect(calling)
					GlobalVars.in_interaction = ""
					if fired == false:
						if phone == false:
							Dialogic.timeline_ended.connect(_on_ending_timeline_ended)
						else:
							Dialogic.timeline_ended.connect(_on_phone_timeline_ended)
						Dialogic.start(dialogue_file)
						return
					Dialogic.start(dialogue_file, "call_talk")
					Dialogic.timeline_ended.connect(_on_phone_timeline_ended)
					await get_tree().process_frame
					GlobalVars.viewing = ""
					return
				else:
					player.start_player()
					alert.show()
					GlobalVars.in_interaction = ""
					return

func enter_Theo(argument: String):
	if argument == "enter_theo":
		#Prompt theo to walk through the door
		print("Theo enters")
		emit_signal("theo_move")
		Dialogic.signal_event.disconnect(enter_Theo)
		office_theme.stop()
		theo_theme.play()
		pass
	


func _on_change_texture(texture):
	print("change")
	get_active_material(0).set_shader_parameter("texture_albedo", load(texture))
	#set_instance_shader_parameter("shader_paramater/texture_albedo", load(texture))
