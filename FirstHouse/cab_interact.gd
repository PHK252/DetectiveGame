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


@onready var dalton_maker = $"../../../../UI/Dalton_marker"
@onready var micah_marker = $"../../../../UI/Micah_marker"
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
	
	#var dialogue_pick = Dialogic.VAR.get_variable("Asked Questions.Micah_cab")
	if GlobalVars.in_look_screen == false and GlobalVars.in_dialogue == false and GlobalVars.in_interaction == "cab" and cab_open == false:
		#print("whjat")
		if Input.is_action_just_pressed("Exit") and GlobalVars.clicked_cab == 1 and GlobalVars.opened_cab == true:
			#print("first")
			GlobalVars.in_dialogue = true
			cab_cam.priority = 0
			main_cam.priority = 12
			await get_tree().create_timer(.03).timeout
			cam_anim.play("RESET")
			player.show()
			#player.start_player()
			GlobalVars.in_interaction = ""
			var cab_dialogue = Dialogic.start("Micah_cabinet")
			Dialogic.VAR.get("Asked Questions").Micah_cab = 1
			Dialogic.timeline_ended.connect(_on_timeline_ended)
			cab_dialogue.register_character(load("res://Dialogic Characters/Dalton.dch"), dalton_maker)
			cab_dialogue.register_character(load("res://Dialogic Characters/Micah.dch"), micah_marker)
			
		elif Input.is_action_just_pressed("Exit") and GlobalVars.clicked_cab > 1 and GlobalVars.opened_cab == true:
			#print("subs")
			pick_dialogue()
			main_cam.set_tween_duration(0)
			cab_cam.priority = 0
			main_cam.priority = 12
			await get_tree().create_timer(.03).timeout
			cam_anim.play("RESET")
			player.show()
			#player.start_player()
			GlobalVars.in_interaction = ""
			var cab_dialogue = Dialogic.start("Micah_cabinet")
			GlobalVars.in_dialogue = true
			Dialogic.timeline_ended.connect(_on_timeline_ended)
			cab_dialogue.register_character(load("res://Dialogic Characters/Dalton.dch"), dalton_maker)
			cab_dialogue.register_character(load("res://Dialogic Characters/Micah.dch"), micah_marker)
		elif Input.is_action_just_pressed("Exit") and GlobalVars.opened_cab == false:
			#print("no click")
			main_cam.set_tween_duration(0)
			cab_cam.priority = 0
			main_cam.priority = 12
			await get_tree().create_timer(.03).timeout
			cam_anim.play("RESET")
			player.show()
			player.start_player()
			main_cam.set_tween_duration(1)
			GlobalVars.in_interaction = ""
		
		
	#if GlobalVars.in_look_screen == true:
		#bookmark_interact.hide()
	#elif GlobalVars.in_look_screen == false and fridge_cam.priority == 15:
		#bookmark_interact.show()
	if clickable and Input.is_action_just_pressed("mouse_click"):
		if cab_open == false and GlobalVars.clicked_cab == 0:
			open_cabinet()
			await get_tree().create_timer(5.0).timeout
			GlobalVars.in_dialogue = true
			Dialogic.start("Micah_cabinet_thoughts")
			Dialogic.timeline_ended.connect(_on_thoughts_ended)
		elif cab_open == false:
			open_cabinet()
			await get_tree().create_timer(5.0).timeout
			close_cabinet()
			
			#book_dialogue.register_character(load("res://Dialogic Characters/Dalton.dch"), dalton_maker)
			#book_dialogue.register_character(load("res://Dialogic Characters/Micah.dch"), micah_marker)
			
	#if cab_open == true and Input.is_action_just_pressed("mouse_click"):
		#close_cabinet()
		
		
func _on_timeline_ended():
	#print("end")
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	GlobalVars.in_dialogue = false
	player.start_player()
	GlobalVars.opened_cab = false
	
func pick_dialogue():
	var rng = RandomNumberGenerator.new()
	var random = rng.randf_range(0.0, 10.0)
	var num = int(random)
	print(num)
	if num % 2 == 1:
		Dialogic.VAR.get("Asked Questions").Micah_cab = 2
	else:
		Dialogic.VAR.get("Asked Questions").Micah_cab = 3

func _on_thoughts_ended():
	Dialogic.timeline_ended.disconnect(_on_thoughts_ended)
	GlobalVars.in_dialogue = false
	await get_tree().create_timer(.5).timeout
	close_cabinet()
	#player.start_player()

func _on_interactable_interacted(interactor):
	if GlobalVars.in_dialogue == false:
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
	
	anim_bags["parameters/conditions/restart"] = false
	anim_tree["parameters/conditions/restart"] = false
	
	anim_bags["parameters/conditions/is_looping"] = false
	anim_bags["parameters/conditions/finish"] = true
	anim_tree["parameters/conditions/cab_closed_action"] = true
	anim_tree["parameters/conditions/cabinet_opened"] = false
	await get_tree().create_timer(1.0).timeout
	clickable = false
	cab_open = false
	
func open_cabinet():
	GlobalVars.clicked_cab += 1 
	GlobalVars.opened_cab = true
	anim_bags["parameters/conditions/restart"] = true
	anim_bags["parameters/conditions/is_falling"] = true
	anim_bags["parameters/conditions/finish"] = false
	anim_bags["parameters/conditions/is_looping"] = true

	anim_tree["parameters/conditions/restart"] = true
	anim_tree["parameters/conditions/cabinet_opened"] = true
	anim_tree["parameters/conditions/cab_closed_action"] = false
	await get_tree().create_timer(2.5).timeout
	for member in bag_group:
		member.show()
	clickable = true
	cab_open = true
	
