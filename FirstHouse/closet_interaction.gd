extends Node3D

@onready var closet_cam = $"../SubViewportContainer/SubViewport/CameraSystem/Closet close up"
@onready var main_cam = $"../SubViewportContainer/SubViewport/CameraSystem/closet"
@onready var player = $"../Characters/Dalton/CharacterBody3D"
@onready var closet_anim = $AnimationPlayer
@onready var note_interaction = $Note
@onready var cam_anim = $"../SubViewportContainer/SubViewport/CameraSystem/Closet close up/AnimationPlayer"
@onready var mouse_pos = Vector2(0,0)
@onready var closet_open = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	mouse_pos = get_viewport().get_mouse_position()
	#print(mouse_pos) 
	if GlobalVars.in_look_screen == false and GlobalVars.in_dialogue == false:
		if mouse_pos.y >= 700:
			closet_cam.set_rotation_degrees(Vector3(-25, 93.8, 1.4))
		elif mouse_pos.y < 120:
			closet_cam.set_rotation_degrees(Vector3(-5, 93.8, 1.4))
		else:
			closet_cam.set_rotation_degrees(Vector3(-15, 93.8, 1.4))
				#pass
	else:
		closet_cam.set_rotation_degrees(Vector3(-25, 93.8, 1.4))

	if GlobalVars.in_look_screen == false and GlobalVars.in_dialogue == false:
		if Input.is_action_just_pressed("Exit"):
				closet_cam.priority = 0
				main_cam.priority = 12
				await get_tree().create_timer(.03).timeout
				cam_anim.play("RESET")
				player.show()
				player.start_player()
				
				note_interaction.hide()
	
	if GlobalVars.in_look_screen == true:
		note_interaction.hide()
	elif GlobalVars.in_look_screen == false and closet_cam.priority == 15:
		note_interaction.show()

func _on_interactable_interacted(interactor):
	#doors don't work quite right yet
	if closet_open == false:
		closet_anim.play("ClosetLOpen")
		await closet_anim.animation_finished
		closet_anim.play("ClosetOpenR")
		await closet_anim.animation_finished
		closet_open = true
		#Dialogue start
		await get_tree().create_timer(3).timeout
	
	# connect signal to switch cams
	closet_cam.priority = 15
	main_cam.priority = 0 
	note_interaction.show()
	cam_anim.play("Cam_Idle")
	player.stop_player()
	player.hide()

#
