extends Node3D

@onready var fridge_cam = $"../../../SubViewport/CameraSystem/Fridge"
@onready var main_cam = $"../../../SubViewport/CameraSystem/livingroom"
@onready var player = $"../../../../Characters/Dalton/CharacterBody3D"
@onready var cam_anim = $"../../../SubViewport/CameraSystem/Fridge/AnimationPlayer"
@onready var mouse_pos = Vector2(0,0) 
@onready var fridge_open = false
#@onready var bookmark_interact = $Bookmark_interact
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	mouse_pos = get_viewport().get_mouse_position()
	#print(mouse_pos) 
	if GlobalVars.in_look_screen == false and GlobalVars.in_dialogue == false:
		if mouse_pos.y >= 550:
			fridge_cam.set_rotation_degrees(Vector3(-33.5, -87.1, -1.3))
		else:
			fridge_cam.set_rotation_degrees(Vector3(-20.1, -87.1, -1.3))
	else:
		fridge_cam.set_rotation_degrees(Vector3(-20.1, -87.1, -1.3))
	
	if GlobalVars.in_look_screen == false and GlobalVars.in_dialogue == false and GlobalVars.in_interaction == "fridge":
		if Input.is_action_just_pressed("Exit"):
			main_cam.set_tween_duration(0)
			fridge_cam.priority = 0
			main_cam.priority = 12
			await get_tree().create_timer(.03).timeout
			cam_anim.play("RESET")
			player.show()
			player.start_player()
			main_cam.set_tween_duration(1)
			GlobalVars.in_interaction = ""
			#bookmark_interact.hide()
			
			#activate dialogue
#
	#if GlobalVars.in_look_screen == true:
		#bookmark_interact.hide()
	#elif GlobalVars.in_look_screen == false and fridge_cam.priority == 15:
		#bookmark_interact.show()


func _on_interactable_interacted(interactor):

	GlobalVars.in_interaction = "fridge"
	fridge_cam.priority = 15
	main_cam.priority = 0 
	#bookmark_interact.show()
	cam_anim.play("Cam_Idle")
	player.hide()
	player.stop_player()
	if fridge_open == false:
		#play animation
		#fridge_open = true
		pass
