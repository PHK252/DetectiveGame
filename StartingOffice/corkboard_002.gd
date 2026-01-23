extends MeshInstance3D

@export var main : Node3D
@onready var cork_cam = $"../../CameraSystem/Corkboard cam"
@onready var cam_anim = $"../../CameraSystem/Corkboard cam/AnimationPlayer"
@onready var main_cam = $"../../CameraSystem/PhantomCamera3D"
@onready var player = $"../../Characters/Dalton/CharacterBody3D"
@onready var team_pic = $"../../../../UI/TeamPic"
@onready var partner_pic = $"../../../../UI/PartnerPic"
@onready var news = $"../../../../UI/News"
@onready var contact = $"../../../../UI/Contact"
@onready var missing = $"../../../../UI/Missing Persons"
@onready var mouse_pos = Vector2(0,0)
@export var exit_cork : AudioStreamPlayer
@onready var tilt = ""

var is_open: bool = false
signal general_interaction 
# Called when the node enters the scene tree for the first time.
func _ready():
	#cork_cam.set_rotation_degrees(Vector3(-3, 179.1, .4))
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	mouse_pos = main.mouse_pos
	#print(mouse_pos)
	if GlobalVars.in_look_screen == false and GlobalVars.in_dialogue == false and GlobalVars.in_interaction == "cork":
		if cork_cam.priority == 5:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		if mouse_pos.y >= 900:
			cork_cam.set_rotation_degrees(Vector3(-20, 176.6, .4))
			tilt = "down"
		elif mouse_pos.y < 180:
			cork_cam.set_rotation_degrees(Vector3(4, 176.6, .4))
			tilt = "up"
		else:
			cork_cam.set_rotation_degrees(Vector3(-3, 176.6, .4))
			tilt = "mid"
		if tilt == "mid":
			#cork_cam.set_rotation_degrees(Vector3(-3, 176.6, .4))
			team_pic.show()
			partner_pic.show()
			news.show()
			contact.show()
			missing.show()
		else:
			team_pic.hide()
			partner_pic.hide()
			news.hide()
			contact.hide()
			missing.hide()
		
	if GlobalVars.in_look_screen == false and GlobalVars.in_dialogue == false and GlobalVars.viewing == "":
		if Input.is_action_just_pressed("Exit") and cork_cam.priority == 5:
			print("enter")
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			exit_cork.play()
			cork_cam.priority = 0
			main_cam.priority = 5
			await get_tree().create_timer(.03).timeout
			player.show()
			player.start_player()
			GlobalVars.in_interaction = ""
			team_pic.hide()
			partner_pic.hide()
			news.hide()
			contact.hide()
			missing.hide()
	
	if GlobalVars.in_look_screen == true:
		team_pic.hide()
		partner_pic.hide()
		news.hide()
		contact.hide()
		missing.hide()
	#elif GlobalVars.in_look_screen == false and cork_cam.priority == 1:
		#if tilt == "mid":
			#print(cork_cam.priority)
			#team_pic.show()
			#partner_pic.show()
			#news.show()
			#contact.show()
			#missing.show()
	

func _on_interactable_interacted(interactor):
	if cork_cam.priority != 5:
		emit_signal("general_interaction")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	print("interact cork")
	cork_cam.priority = 5
	main_cam.priority = 0
	player.stop_player()
	player.hide()
	GlobalVars.in_interaction = "cork"
	team_pic.show()
	partner_pic.show()
	news.show()
	contact.show()
	missing.show()
	


func _on_corkboard_cam_became_active():
	cam_anim.play("Cam_idle")
