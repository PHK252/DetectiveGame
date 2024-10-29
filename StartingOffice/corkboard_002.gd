extends MeshInstance3D

@onready var cork_cam = $"../../CameraSystem/Corkboard cam"
@onready var cam_anim = $"../../CameraSystem/Corkboard cam/AnimationPlayer"
@onready var main_cam = $"../../CameraSystem/PhantomCamera3D"
@onready var player = $"../../../../Dalton/CharacterBody3D"
@onready var mouse_pos = Vector2(0,0)
#@onready var current_rot = Vector3(-3, 179.1, .4)
#signal up
#signal down

var is_open: bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	#cork_cam.set_rotation_degrees(Vector3(-3, 179.1, .4))
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	mouse_pos = get_viewport().get_mouse_position()
	if mouse_pos.y >= 137:
		cork_cam.set_rotation_degrees(Vector3(-20, 176.6, .4))
	elif mouse_pos.y < 50:

		cork_cam.set_rotation_degrees(Vector3(4, 176.6, .4))
	else:
		cork_cam.set_rotation_degrees(Vector3(-3, 176.6, .4))
	pass
	
	if Input.is_action_just_pressed("Exit"):
		cork_cam.priority = 0
		main_cam.priority = 1
		await get_tree().create_timer(.03).timeout
		player.show()
	

func _on_interactable_interacted(interactor):
	cork_cam.set_rotation_degrees(Vector3(-3, 176.6, .4))
	cork_cam.priority = 1
	main_cam.priority = 0
	player.hide()
	


func _on_corkboard_cam_became_active():
	cam_anim.play("Cam_idle")

func _on_interactable_focused(interactor):
	#await get_tree().create_timer(5).timeout
	player.stop_player()
#An failed attempt at rotation tweening

#func _input(event):
	#if event is InputEventMouseMotion:

		#var first_down  = true
		##tilting down
		#if event.relative.y > 0 and first_down == true: 
			#first_down == false
			#print("one down")
			#down.emit()
			##if(cork_cam.rotation.x < -3):
				##cam_anim.play_backwards("Tilt_up")
				##await cam_anim.animation_finished 
				###cam_anim.play("Tilt_down")
				###await cam_anim.animation_finished
				###cam_anim.pause()
				###return
			#cam_anim.play("Tilt_down")
			#await cam_anim.animation_finished 
			##print("end down")
			#cam_anim.pause()
#
			#await up
			#print ("up")
			#return
			##return
			##print("down?")
		#if event.relative.y < 0: 
			#up.emit()
			##if(cork_cam.rotation.x > -3):
				##cam_anim.play_backwards("Tilt_down")
				##await cam_anim.animation_finished
				###cam_anim.play("Tilt_up")
				###await cam_anim.animation_finished
				###cam_anim.pause()
				###return
			#cam_anim.play("Tilt_up")
			#await cam_anim.animation_finished
			#cam_anim.pause()
			#await down
			#return
		##mouse_pos = get_viewport().get_mouse_position()
		##cam_tilt()
	###print(mouse_pos)
#func cam_tilt():
	#if mouse_pos.y >= 137:
		#var mouse_pos_stop = mouse_pos.y
		#cam_anim.get_animation("Tilt_down").track_set_key_value(0, 1, cork_cam.rotation)
		#cam_anim.play("Tilt_down")
		#await cam_anim.animation_finished 
		##cam_anim.stop()
		#if  mouse_pos.y >= mouse_pos_stop:
			#cam_anim.stop()
			#return
