extends MeshInstance3D

@export var interactable : Interactable
@export var door_interactable : Interactable
@export var map_ui : CanvasLayer

@export var main_cam : PhantomCamera3D
@export var cam_anim : AnimationPlayer
@export var exit_cam : PhantomCamera3D
@export var player : CharacterBody3D

#sitstuff
@export var theo_car : Node3D
@export var theo_player : AnimationPlayer
@export var dalton_car : Node3D
@export var dalton_player : AnimationPlayer
@export var theo_norm : Node3D

var is_open: bool = false

signal door_open
signal door_close

func _ready():
	interactable.set_deferred("monitorable", Dialogic.VAR.get_variable("Quincy.left_quincy"))
	pass # to test
	#

func _on_map_leave_interacted(interactor):
	if GlobalVars.in_interaction == "":
		
		print("map_interact")
		emit_signal("door_open")
		theo_norm.visible = false
		dalton_player.play("SitNoDrink")
		theo_player.play("SitOutside_001")
		theo_car.visible = true
		dalton_car.visible = true
		
		main_cam.priority = 30
		exit_cam.priority = 0
		player.stop_player()
		player.hide()
		await get_tree().create_timer(1).timeout
		map_ui.show()
		cam_anim.play("Cam_Idle")
		player.stop_player()
		player.hide()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		GlobalVars.in_look_screen = true
		GlobalVars.viewing = "map"
		GlobalVars.in_look_screen = true
		GlobalVars.in_interaction = "level change"


func _on_exit_pressed():
	emit_signal("door_close")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	map_ui.hide()
	GlobalVars.viewing = ""
	GlobalVars.in_look_screen = false
	GlobalVars.in_interaction = ""
	main_cam.priority = 0
	exit_cam.priority = 30
	theo_norm.visible = true
	theo_car.visible = false
	dalton_car.visible = false
	dalton_player.stop()
	theo_player.stop()
	cam_anim.play("RESET")
	player.show()
	player.start_player()

func _input(event):
	if GlobalVars.in_dialogue == false and GlobalVars.in_interaction == "level change":
		if Input.is_action_just_pressed("Exit") and GlobalVars.viewing == "map":
			emit_signal("door_close")
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			GlobalVars.viewing = ""
			GlobalVars.in_look_screen = false
			GlobalVars.in_interaction = ""
			map_ui.hide()
			main_cam.priority = 0
			exit_cam.priority = 30
			theo_norm.visible = true
			theo_car.visible = false
			dalton_car.visible = false
			dalton_player.stop()
			theo_player.stop()
			cam_anim.play("RESET")
			player.show()
			player.start_player()



func _on_main_door_activate_car():
	if door_interactable:
		door_interactable.set_deferred("monitorable", false)
	interactable.set_deferred("monitorable", true)
