extends MeshInstance3D

@export var interactable : Interactable
@export var door_interactable : Interactable
@export var map_ui : CanvasLayer

@export var main_cam : PhantomCamera3D
@export var cam_anim : AnimationPlayer
@export var exit_cam : PhantomCamera3D
@export var player : CharacterBody3D

var is_open: bool = false

func _ready():
	if GlobalVars.day == 1:
		interactable.set_deferred("monitorable", false)
	else:
		interactable.set_deferred("monitorable", true)

func _on_map_leave_interacted(interactor):
	if GlobalVars.in_interaction == "":
		print("map_interact")
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		main_cam.priority = 30
		exit_cam.priority = 0
		player.stop_player()
		player.hide()
		map_ui.show()
		cam_anim.play("Cam_Idle")
		player.stop_player()
		player.hide()
		GlobalVars.viewing = "map"
		GlobalVars.in_look_screen = true
		GlobalVars.in_interaction = "level change"


func _on_exit_pressed():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	map_ui.hide()
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
			map_ui.hide()
			main_cam.set_tween_duration(0)
			main_cam.priority = 0
			exit_cam.priority = 30
			main_cam.set_tween_duration(1)
			cam_anim.play("RESET")
			player.show()
			player.start_player()
			GlobalVars.viewing = ""
			GlobalVars.in_look_screen = false
			GlobalVars.in_interaction = ""


func _on_main_door_activate_car():
	door_interactable.set_deferred("monitorable", false)
	interactable.set_deferred("monitorable", true)

func _office_activate_map():
	interactable.set_deferred("monitorable", true)
