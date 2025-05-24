extends MeshInstance3D

@export var map : CanvasLayer
@export var main_cam : PhantomCamera3D
@export var cam_anim : AnimationPlayer
@export var exit_cam : PhantomCamera3D
@export var map_click : Area2D
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
		main_cam.priority = 5
		exit_cam.priority = 0

		cam_anim.play("Cam_Idle")
		player.stop_player()
		player.hide()
		map_click.show()
		#GlobalVars.in_look_screen = true
		GlobalVars.in_interaction = "level change"
	pass

#func _on_interactable_unfocused(interactor) -> void:
	#if not is_open:
		#remove_highlight()


func _on_map_click_input_event(viewport, event, shape_idx):
	if GlobalVars.in_look_screen == false:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed == true:
				map_click.hide()
				map.show()
				GlobalVars.viewing = "map"
				GlobalVars.in_look_screen = true


func _on_exit_pressed():
	map.hide()
	map_click.show()
	GlobalVars.viewing = ""
	GlobalVars.in_look_screen = false

func _input(event):
	if GlobalVars.in_dialogue == false and GlobalVars.in_interaction == "level change":
		if GlobalVars.in_look_screen == false:
			if Input.is_action_just_pressed("Exit") and GlobalVars.viewing == "":
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
				map_click.hide()
				main_cam.priority = 0
				exit_cam.priority = 5
				cam_anim.play("RESET")
				player.show()
				player.start_player()
				GlobalVars.in_interaction = ""
		else:
			if Input.is_action_just_pressed("Exit") and GlobalVars.viewing == "map":
				map.hide()
				map_click.show()
				await get_tree().create_timer(.05).timeout
				GlobalVars.viewing = ""
				GlobalVars.in_look_screen = false
