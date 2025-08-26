extends CanvasLayer


var loading_scene = preload("res://loading_screen/load_screen.tscn")
signal loading_screen_has_full_coverage
#@onready var animationPlayer : AnimationPlayer = $AnimationPlayer
##Driving animation
var drive_loading : AnimatedSprite2D
var drive_anim : AnimationPlayer


#Default
var d_back_loading : Node2D
var d_loading_anim : AnimationPlayer
var d_loading_sprite : Sprite2D

#@onready var progressBar : ProgressBar = $AnimationPlayer/Panel/ProgressBar
var _progress: Array = []
var loaded = false
var load_status = 0

var current_anim : AnimationPlayer    
#func _update_progress_bar(new_value: float) -> void:
	#progressBar.set_value_no_signal(new_value * 100)
	
#func _start_outro_animation() -> void:
	#if animationPlayer.is_playing():
		#await Signal(animationPlayer, "animation_finished")
	#animationPlayer.play("end_load")
	#await Signal(animationPlayer, "animation_finished")
	#self.queue_free()

func load_scene(current_scene, next_scene, driving : bool, time : String, dialogue : String):
	SceneTransitions.fade_to_load()
	await SceneTransitions.fade.animation_finished
	var scene_instance = loading_scene.instantiate()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().get_root().add_child(scene_instance)
	current_scene.queue_free()
	ResourceLoader.load_threaded_request(next_scene)
	#driving
	drive_loading = scene_instance.get_node("Drinving Loading/Morning/Driving")
	drive_anim = scene_instance.get_node("Drinving Loading/Morning")
	
	# default
	
	d_back_loading = scene_instance.get_node("Default Loading")
	d_loading_anim = scene_instance.get_node("Default Loading/AnimationPlayer")
	d_loading_sprite = scene_instance.get_node("Default Loading/AnimationPlayer/Sprite2D")
	if driving == true:
		if time:
			toggle_drive(true)
			toggle_default(false)
			current_anim = drive_anim
			current_anim.play("Day_anim")
		else:
			toggle_drive(true)
			toggle_default(false)
			current_anim = drive_anim
			drive_anim.play("Day_anim")
	else:
		
		toggle_drive(false)
		toggle_default(true)
		current_anim = d_loading_anim
		current_anim.play("Load")
		print("play")

	#if dialogue != "":
			##play dialogue
			#return
	#else:
		#return
	await get_tree().create_timer(.5).timeout
	while loaded == false or GlobalVars.in_dialogue == true:
		load_status = ResourceLoader.load_threaded_get_status(next_scene, _progress)
		if load_status == ResourceLoader.THREAD_LOAD_LOADED and GlobalVars.in_dialogue == false:
			loaded = true
			print("loaded")
			await get_tree().create_timer(5.0).timeout
			current_anim.stop()
			toggle_drive(false)
			toggle_default(false)
			var new_scene = ResourceLoader.load_threaded_get(next_scene)
			SceneTransitions.fade_change_packed_scene(new_scene)
			scene_instance.queue_free()
		#elif load_status == 0 or 2:
			#print_debug("Error: Loading failed")
		#else:
			#print_debug("Loading" + str(floor(_progress[0]*100)))
	
func toggle_default(state : bool):
	#d_loading_anim.visible = state
	d_back_loading.visible = state
	d_loading_sprite.visible = state

func toggle_drive(state : bool):
	drive_loading.visible = state
