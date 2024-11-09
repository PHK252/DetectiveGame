extends Node3D

@onready var book_cam = $"../../../SubViewport/CameraSystem/Bookshelf Close"
@onready var main_cam = $"../../../SubViewport/CameraSystem/bookshelf"
@onready var player = $"../../../../Characters/Dalton/CharacterBody3D"
@onready var cam_anim = $"../../../SubViewport/CameraSystem/Bookshelf Close/AnimationPlayer"
@onready var mouse_pos = Vector2(0,0) 
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	mouse_pos = get_viewport().get_mouse_position()
	#print(mouse_pos) 
	if GlobalVars.in_look_screen == false and GlobalVars.in_dialogue == false:
		if mouse_pos.y >= 700:
			book_cam.set_rotation_degrees(Vector3(-25.3, -90, 0))
		elif mouse_pos.y < 120:
			book_cam.set_rotation_degrees(Vector3(10, -90, 0))
		else:
			book_cam.set_rotation_degrees(Vector3(-9.3, -90, 0))
				#pass
	else:
		book_cam.set_rotation_degrees(Vector3(-9.3, -90, 0))
	if GlobalVars.in_look_screen == false and GlobalVars.in_dialogue == false and GlobalVars.in_interaction == "book":
		if Input.is_action_just_pressed("Exit"):
			main_cam.set_tween_duration(0)
			book_cam.priority = 0
			main_cam.priority = 12
			await get_tree().create_timer(.03).timeout
			cam_anim.play("RESET")
			player.show()
			player.start_player()
			main_cam.set_tween_duration(1)
			GlobalVars.in_interaction = ""
			#pic_fall.hide()




func _on_interactable_interacted(interactor):
	GlobalVars.in_interaction = "book"
	book_cam.priority = 15
	main_cam.priority = 0 
	#note_interaction.show()
	cam_anim.play("Cam_Idle")
	player.hide()
	player.stop_player()
