extends MeshInstance3D

@export var map : CanvasLayer
@export var main_cam : PhantomCamera3D
@export var cam_anim : AnimationPlayer
@export var exit_cam : PhantomCamera3D
@export var player : CharacterBody3D
var is_open: bool = false

signal check_day
	
func open() -> void:
	print("Opening map UI")
	map.visible = !map.visible
	
func change_scene() -> void:
	print("scenechanged")
	
func add_highlight() -> void:
	pass
	
func remove_highlight() -> void:
	pass
	
#func _on_interactable_focused(interactor) -> void:
	#if not is_open:
		#add_highlight()
		
func _on_interactable_interacted(interactor) -> void:
	if GlobalVars.in_interaction == "":
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		main_cam.priority = 30
		exit_cam.priority = 0
		player.stop_player()
		player.hide()
		#await get_tree().create_timer(1.0)
		map.show()
		cam_anim.play("Cam_Idle")
		player.stop_player()
		player.hide()
		#GlobalVars.in_look_screen = true
		GlobalVars.viewing = "map"
		GlobalVars.in_look_screen = true
		GlobalVars.in_interaction = "level change"
	pass


func _on_exit_pressed():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	map.hide()
	GlobalVars.viewing = ""
	GlobalVars.in_look_screen = false
	GlobalVars.in_interaction = ""
	main_cam.priority = 0
	exit_cam.priority = 30
	cam_anim.play("RESET")
	player.show()
	player.start_player()

func _input(event):
	if GlobalVars.in_dialogue == false and GlobalVars.in_interaction == "level change":
		if Input.is_action_just_pressed("Exit") and GlobalVars.viewing == "map":
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			map.hide()
			main_cam.priority = 0
			exit_cam.priority = 30
			cam_anim.play("RESET")
			player.show()
			player.start_player()
			GlobalVars.viewing = ""
			GlobalVars.in_look_screen = false
			GlobalVars.in_interaction = ""
