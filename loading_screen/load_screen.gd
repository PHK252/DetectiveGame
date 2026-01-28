extends CanvasLayer

signal end_dialogue

var loading_scene_file = "res://loading_screen/load_screen.tscn"
signal loading_screen_has_full_coverage
#@onready var animationPlayer : AnimationPlayer = $AnimationPlayer
#Driving animation
var drive_loading : AnimatedSprite2D
var drive_anim : AnimationPlayer

var drive_sound : AudioStreamPlayer 

#Sleeping animation
var sleep_loading : AnimatedSprite2D
var sleep_anim : AnimationPlayer

#Default
var d_back_loading : Node2D
var d_loading_anim : AnimationPlayer
var d_loading_Dalton_marker : Marker2D
var d_loading_theo_marker : Marker2D
var d_loading_sprite : AnimatedSprite2D

#Date
var date_loading : Node2D
var date_label : RichTextLabel
var blink_anim : AnimationPlayer
#@onready var progressBar : ProgressBar = $AnimationPlayer/Panel/ProgressBar
var _progress: Array = []
var loaded = false
var load_status = 0
var in_loading : bool
var current_anim : AnimationPlayer    
var percent_label : Label

#func _update_progress_bar(new_value: float) -> void:
	#progressBar.set_value_no_signal(new_value * 100)
	
#func _start_outro_animation() -> void:
	#if animationPlayer.is_playing():
		#await Signal(animationPlayer, "animation_finished")
	#animationPlayer.play("end_load")
	#await Signal(animationPlayer, "animation_finished")
	#self.queue_free()

func load_scene(current_scene, next_scene, type : String, time : String, dialogue : String, glitch_in : bool = false, glitch_out : bool = false, dialogic_save : bool = true):
	if get_tree().paused == true:
		get_tree().paused = false
	in_loading = true
	if glitch_in == true:
		SceneTransitions.glitch_to_load()
		await SceneTransitions.glitch.animation_finished
	else:
		print("loading")
		SceneTransitions.fade_to_load()
		await SceneTransitions.fade.animation_finished
	print("loading2")
	var loading_scene = load(loading_scene_file)
	var scene_instance = loading_scene.instantiate()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().get_root().add_child(scene_instance)
	
	current_scene.queue_free()
	
	#
	ResourceLoader.load_threaded_request(next_scene, "", false)
	#driving
	drive_loading = scene_instance.get_node("Drinving Loading/Morning/Driving")
	drive_anim = scene_instance.get_node("Drinving Loading/Morning")
	d_loading_theo_marker = scene_instance.get_node("Drinving Loading/Theo")
	d_loading_Dalton_marker = scene_instance.get_node("Drinving Loading/Dalton")
	drive_sound = scene_instance.get_node("Drinving Loading/drive_sound")
	# default
	d_back_loading = scene_instance.get_node("Default Loading")
	d_loading_anim = scene_instance.get_node("Default Loading/AnimationPlayer")
	d_loading_sprite = scene_instance.get_node("Default Loading/AnimationPlayer/Sprite2D")
	
	#Sleep
	sleep_loading = scene_instance.get_node("Sleep Loading/AnimationPlayer/Sleep")
	sleep_anim = scene_instance.get_node("Sleep Loading/AnimationPlayer")
	
	#Date 
	date_loading = scene_instance.get_node("Date Loading")
	blink_anim = scene_instance.get_node("Date Loading/AnimationPlayer")
	date_label = scene_instance.get_node("Date Loading/RichTextLabel")
	
	percent_label = scene_instance.get_node("Label")
	if type == "driving":
		drive_sound.play()
		toggle_drive(true)
		toggle_default(false)
		toggle_sleep(false)
		if time == "morning":
			current_anim = drive_anim
			current_anim.play("Day_anim")
			#await get_tree().create_timer(.2).timeout
		elif time == "afternoon":
			current_anim = drive_anim
			current_anim.play("Sunset_anim")
			#await get_tree().create_timer(.2).timeout
		elif time == "night":
			current_anim = drive_anim
			current_anim.play("Night_Anim")
	elif type == "Sleep":
		toggle_drive(false)
		toggle_default(false)
		toggle_sleep(true)
		if time == "To Dream":
			current_anim = sleep_anim
			current_anim.play("Sleep")
			await current_anim.animation_finished
			current_anim.play("Sleep_loop")
		elif time == "Out Dream":
			current_anim = sleep_anim
			current_anim.play("Wake")
			await current_anim.animation_finished
			sleep_anim.play("Wake_loop")
		else:
			current_anim = sleep_anim
			current_anim.play("Sleep_Wake")
			await current_anim.animation_finished
			sleep_anim.play("Wake_loop")
	else:
		toggle_drive(false)
		toggle_default(true)
		toggle_sleep(false)
		current_anim = d_loading_anim
		current_anim.play("Load")
		if glitch_in == true:
			await get_tree().create_timer(2.0).timeout
	if dialogue != "":
		var driving_dialogue = Dialogic.start(dialogue)
		driving_dialogue.register_character(load("res://Dialogic Characters/Dalton Driving.dch"), d_loading_Dalton_marker)
		driving_dialogue.register_character(load("res://Dialogic Characters/Theo Driving.dch"), d_loading_theo_marker)
		Dialogic.timeline_ended.connect(_on_timeline_ended)
		GlobalVars.in_dialogue = true
		await get_tree().create_timer(.2).timeout
	else:
		pass
	await get_tree().create_timer(.2).timeout
	while loaded == false:
		#var progress = _progress[0]
		#percent_label.text = str(int(progress * 100)) + "%"
		load_status = ResourceLoader.load_threaded_get_status(next_scene, _progress)
		print(load_status)
		match load_status:
			0,2:
				print_debug("ERROR: Loading Failed")
				percent_label.text = "failed"
				return
			1:
				var progress = _progress[0]
				await get_tree().process_frame
				percent_label.text = str(int(progress * 100)) + "%"
				print(str(int(progress * 100)) + "%")
			3:
				loaded = true
				if GlobalVars.in_dialogue == true:
					await Signal(self, "end_dialogue") 
					print("awaiting")
				var new_scene = ResourceLoader.load_threaded_get(next_scene)
				if type == "date":
					await get_tree().create_timer(2.0).timeout
					toggle_default(false)
					date_loading.show()
					date_label.text = time
					blink_anim.play("Blink")
					await blink_anim.animation_finished
					date_loading.hide()
				else:
					await get_tree().create_timer(1.6).timeout
				if glitch_out == true:
					SceneTransitions.glitch_change_packed_scene(new_scene)
					await get_tree().create_timer(3.0).timeout
				else:
					SceneTransitions.fade_change_packed_scene(new_scene)
					await get_tree().create_timer(1.0).timeout
				current_anim.stop()
				toggle_drive(false)
				toggle_default(false)
				scene_instance.queue_free()
				in_loading = false
				loaded = false
				#drive_sound.stop() not needed i think
				print(GlobalVars.dalton_pos)
				if GlobalVars.from_save_file == true:
					return
				SaveLoad.saveGame(SaveLoad.SAVE_DIR + SaveLoad.SAVE_FILE_NAME)
				#await get_tree().process_frame
				print(GlobalVars.current_level)
				
				return
func toggle_default(state : bool):
	d_back_loading.visible = state
	d_loading_sprite.visible = state

func toggle_drive(state : bool):
	drive_loading.visible = state

func toggle_sleep(state : bool):
	sleep_loading.visible = state

func _on_timeline_ended():
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	GlobalVars.in_dialogue = false
	emit_signal("end_dialogue")

#choosing dialogue if there is any
func choose_drive_dialogue():
	match GlobalVars.day:
		1:
			if Dialogic.VAR.get_variable("Global.first_house") == "" and Dialogic.VAR.get_variable("Character Aff Points.Theo") > 0:
				return "Day_1_ride_to_first"
			if Dialogic.VAR.get_variable("Global.first_house") == "Micah" and Dialogic.VAR.get_variable("Asked Questions.Micah_Asked_Theo_Question") == true:
				return "Day_1_ride_from_TG"
			if Dialogic.VAR.get_variable("Asked Questions.Micah_kicked_out") == true:
				return "Day_1_ride_from_kicked_Micah"
			if Dialogic.VAR.get_variable("Juniper.kicked_out") == true:
				return "Day_1_ride_from_kicked_Juniper"
			if Dialogic.VAR.get_variable("Asked Questions.Micah_timed_out") == true:
				return "Day_1_ride_from_timed_Micah"
			if Dialogic.VAR.get_variable("Juniper.timed_out") == true:
				return "Day_1_ride_from_timed_Juniper" 
			if Dialogic.VAR.get_variable("Character Aff Points.Theo") > 3 and Dialogic.VAR.get_variable("Asked Questions.Micah_Solved_Case") == true and Dialogic.VAR.get_variable("Juniper.found_skylar") == true:
				return "Day_1_ride_to_back_to_station"
			return ""
		2: 
			if Dialogic.VAR.get_variable("Quincy.solved_rever") == true:
				return "Day_2_ride_from_Quincy_REVER" 
			if Dialogic.VAR.get_variable("Quincy.kicked_out") == true:
				return "Day_2_ride_kicked_from_Quincy" 
			if Dialogic.VAR.get_variable("Quincy.failed_distract") == true:
				return "Day_2_ride_from_Quincy_Theo_call"
			if Dialogic.VAR.get_variable("Character Aff Points.Theo") > 3: 
				if Dialogic.VAR.get_variable("Quincy.first_greeting") == false and Dialogic.VAR.get_variable("Quincy.second_greeting") == false:
					return "Day_2_ride_to_Quincy"
				if Dialogic.VAR.get_variable("Quincy.solved_case") == true and Dialogic.VAR.get_variable("Quincy.solved_rever") == false: 
					return "Day_2_ride_from_Quincy"
			return ""
		3: 
			if Dialogic.VAR.get_variable("Quincy.has_secret_coor") == true:
				return "Day_3_to_Secret"
			return ""
		_:
			return ""
	pass
