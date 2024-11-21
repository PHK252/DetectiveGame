extends Node3D

@onready var cab_cam = $"../../../SubViewport/CameraSystem/Cabinet"
@onready var main_cam = $"../../../SubViewport/CameraSystem/Kitchen"
@onready var player = $"../../../../Characters/Dalton/CharacterBody3D"
@onready var cam_anim = $"../../../SubViewport/CameraSystem/Cabinet/AnimationPlayer"
@onready var mouse_pos = Vector2(0,0) 
@onready var cab_open = false
@export var anim_tree = AnimationTree
@export var anim_bags = AnimationTree
@onready var is_looking = false
@onready var clickable = false
@onready var bag_group = get_tree().get_nodes_in_group("plastic_bags")

#@onready var bookmark_interact = $Bookmark_interact
# Called when the node enters the scene tree for the first time.
func _ready():
	
	if cab_open == false:
		for member in bag_group:
			member.hide()
		anim_tree["parameters/conditions/cab_closed"] = true
		anim_bags["parameters/conditions/is_falling"] = false
		anim_bags["parameters/conditions/is_looping"] = false
	else:
		pass
		#anim_tree["parameters/conditions/cab_closed"] = true

	#if first time loaded then cabinet open true, if cab open true then play 
	# open state cab +looping animation of bags falling, if mouse clicked (interact)
	#then go to default bag fall animation + close cabinet

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	mouse_pos = get_viewport().get_mouse_position()
	if GlobalVars.in_look_screen == false and GlobalVars.in_dialogue == false:
		if mouse_pos.y >= 550:
			cab_cam.set_rotation_degrees(Vector3(-27.5, 35.6, -1.3))
		else:
			cab_cam.set_rotation_degrees(Vector3(-1.8, 35.6, -1.3))
	else:
		cab_cam.set_rotation_degrees(Vector3(-1.8, 35.6, -1.3))
	
	if GlobalVars.in_look_screen == false and GlobalVars.in_dialogue == false and GlobalVars.in_interaction == "cab":
		if Input.is_action_just_pressed("Exit"):
			main_cam.set_tween_duration(0)
			cab_cam.priority = 0
			main_cam.priority = 12
			await get_tree().create_timer(.03).timeout
			cam_anim.play("RESET")
			player.show()
			player.start_player()
			main_cam.set_tween_duration(1)
			GlobalVars.in_interaction = ""
			#bookmark_interact.hide()
			
			#activate dialogue
		
		
	#if GlobalVars.in_look_screen == true:
		#bookmark_interact.hide()
	#elif GlobalVars.in_look_screen == false and fridge_cam.priority == 15:
		#bookmark_interact.show()
	if clickable and Input.is_action_just_pressed("mouse_click"):
		if cab_open == false:
			open_cabinet()
			await get_tree().create_timer(3.5).timeout
			GlobalVars.in_dialogue = true
			var cab_thoughts = Dialogic.start("Micah_cabinet_thoughts")
			Dialogic.timeline_ended.connect(_on_thoughts_ended)
			#book_dialogue.register_character(load("res://Dialogic Characters/Dalton.dch"), dalton_maker)
			#book_dialogue.register_character(load("res://Dialogic Characters/Micah.dch"), micah_marker)
			
	#if cab_open == true and Input.is_action_just_pressed("mouse_click"):
		#close_cabinet()

func _on_thoughts_ended():
	Dialogic.timeline_ended.disconnect(_on_thoughts_ended)
	GlobalVars.in_dialogue = false
	await get_tree().create_timer(1.5).timeout
	close_cabinet()
	#player.start_player()

func _on_interactable_interacted(interactor):
	is_looking = true
	GlobalVars.in_interaction = "cab"
	cab_cam.priority = 15
	main_cam.priority = 0 
	#bookmark_interact.show()
	cam_anim.play("Cam_Idle")
	player.hide()
	player.stop_player()
	if cab_open == false:
		#play animation
		#fridge_open = true
		clickable = true
		
func close_cabinet():
	
	for member in bag_group:
		member.hide()
	
	anim_bags["parameters/conditions/is_looping"] = false
	anim_bags["parameters/conditions/finish"] = true
	anim_tree["parameters/conditions/cab_closed_action"] = true
	await get_tree().create_timer(2.5).timeout
	clickable = false
	cab_open = false
	
func open_cabinet():
	anim_bags["parameters/conditions/is_falling"] = true
	anim_bags["parameters/conditions/is_looping"] = true
	anim_bags["parameters/conditions/finish"] = false
	anim_tree["parameters/conditions/cabinet_opened"] = true
	await get_tree().create_timer(2.5).timeout
	for member in bag_group:
		member.show()
	clickable = true
	cab_open = true
	
