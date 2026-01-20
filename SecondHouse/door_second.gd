extends Node3D

@export var animation_tree : AnimationTree
@export var collision : CollisionShape3D

@export var dalton_marker : Marker2D
@export var character_marker : Marker2D
@export var theo_marker : Marker2D
@export var player : CharacterBody3D
@export var player_interactor : Interactor
@export var alert : Sprite3D
@export var interior_door : bool

@export var interaction : Interactable
var is_open: bool = false
@onready var entered = false
signal j_door_open
signal j_door_closed
var cooldown = false
var triggered = false
var entered_quincy_house = false
var entered_juniper_house = false
var leaving = false
var auto_close = false

var dalton_entered = false
var theo_entered = false

@onready var greeting = false
signal juniper_greeting
signal cam_greeting
signal j_dialogue
signal activate_car
signal dalton_knock
signal entered_juniper
signal quincy_reposition 
signal theo_follow
signal retarget(target: int)
@export var timer : Timer
@export var quincy_house: bool
@export var quincy_house_inside: bool

#sounds
@export var open_sound : AudioStreamPlayer3D
@export var open_sound_int : AudioStreamPlayer3D
@export var close_sound : AudioStreamPlayer3D
@export var close_sound_int : AudioStreamPlayer3D

#lookat Q signals
signal enable_look
signal disable_look

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if GlobalVars.in_level == true:
		greeting = true

func open() -> void:
	print("opening")
	cooldown = true
	animation_tree["parameters/conditions/is_opened"] = true
	animation_tree["parameters/conditions/is_closed"] = false
	is_open = true
	if quincy_house:
		open_sound.play()
	if interior_door:
		open_sound_int.play()
	emit_signal("j_door_open")
	await get_tree().create_timer(2.0).timeout
	cooldown = false
	
	
func close() -> void:
	#print("Opening")
	cooldown = true
	animation_tree["parameters/conditions/is_closed"] = true
	animation_tree["parameters/conditions/is_opened"] = false
	is_open = false
	emit_signal("j_door_closed")
	await get_tree().create_timer(2.0).timeout
	if quincy_house:
		close_sound.play()
		print("quickCLosing")
		animation_tree["parameters/conditions/quick_close"] = true
		await get_tree().create_timer(0.5).timeout
		animation_tree["parameters/conditions/quick_close"] = false
		animation_tree["parameters/conditions/is_closed"] = false
	if interior_door:
		close_sound_int.play()
	cooldown = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_interactable_interacted(interactor: Interactor) -> void:
	print(is_open)
	print(entered)
	#game code
	#__________________
	#player.stop_player()
	#GlobalVars.in_dialogue = true
	#Dialogic.timeline_ended.connect(_on_timeline_ended)
	#Dialogic.signal_event.connect(doorOpen)
	#var layout = Dialogic.start("Enter_house")
	#layout.register_character(load("res://Dialogic Characters/Dalton.dch"), dalton_marker)
	#layout.register_character(load("res://Dialogic Characters/Micah.dch"), micah_marker)
	#layout.register_character(load("res://Dialogic Characters/Theo.dch"), theo_marker)
	
	#for debug
	#__________________
	if interior_door == true:
		if is_open == false:
			open()
			collision.disabled = true
			return
		else:
			close()
			collision.disabled = false
			return
	
	if is_open == false and entered_quincy_house == true and GlobalVars.in_dialogue == false:
		GlobalVars.in_dialogue == true
		player.stop_player()
		alert.hide()
		emit_signal("enable_look")
		Dialogic.signal_event.connect(doorOpen)
		Dialogic.timeline_ended.connect(_on_timeline_ended)
		var quincy_leave = Dialogic.start("Quincy_leaving")
		quincy_leave.register_character(load("res://Dialogic Characters/Dalton.dch"), dalton_marker)
		quincy_leave.register_character(load("res://Dialogic Characters/Quincy.dch"), character_marker)
		quincy_leave.register_character(load("res://Dialogic Characters/Theo.dch"), theo_marker)
	elif is_open == false and entered == true and GlobalVars.in_dialogue == false:
		open()
		#GlobalVars.in_dialogue == true
		#Dialogic.signal_event.connect(doorOpen)
		#Dialogic.timeline_ended.connect(_on_timeline_ended)
		#var layout = Dialogic.start("Micah_Leave")
		#layout.register_character(load("res://Dialogic Characters/Dalton.dch"), dalton_marker)
		#layout.register_character(load("res://Dialogic Characters/Micah.dch"), micah_marker)
		#layout.register_character(load("res://Dialogic Characters/Theo.dch"), theo_marker)
		pass
	
	elif is_open == false and GlobalVars.in_dialogue == false and cooldown == false:
		#print("open")
		if greeting == false and quincy_house == false and triggered == false:
			emit_signal("cam_greeting")
			triggered = true
			GlobalVars.in_dialogue = true
			player.stop_player()
			alert.hide()
			var knock = Dialogic.start("Juniper_Greeting")
			Dialogic.signal_event.connect(open_door)
			Dialogic.signal_event.connect(knock_dalton)
			Dialogic.timeline_ended.connect(_on_knock_ended)
			knock.register_character(load("res://Dialogic Characters/Dalton.dch"), dalton_marker)
			knock.register_character(load("res://Dialogic Characters/Theo.dch"), theo_marker)
			knock.register_character(load("res://Dialogic Characters/Juniper.dch"), character_marker)
			if interaction.monitorable == true:
				print("disable door")
				player_interactor.process_mode = player_interactor.PROCESS_MODE_DISABLED 
				interaction.set_deferred("monitorable", false)
				await get_tree().process_frame
				player_interactor.process_mode = player_interactor.PROCESS_MODE_INHERIT
			#play knocking sound
		elif greeting == true and quincy_house == false and entered_juniper_house == true:
			GlobalVars.in_dialogue == true
			player.stop_player()
			alert.hide()
			Dialogic.signal_event.connect(doorOpen)
			Dialogic.timeline_ended.connect(_on_timeline_ended)
			var juniper_leave = Dialogic.start("Juniper_Leave")
			juniper_leave.register_character(load("res://Dialogic Characters/Dalton.dch"), dalton_marker)
			juniper_leave.register_character(load("res://Dialogic Characters/Juniper.dch"), character_marker)
			juniper_leave.register_character(load("res://Dialogic Characters/Theo.dch"), theo_marker)
		
		if quincy_house or quincy_house_inside:
			open()
			collision.disabled = true
			return
		
	if is_open == true and cooldown == false and (greeting == true or quincy_house or quincy_house_inside): 
		close()
		collision.disabled = false
	
	

#game code
#__________________
#func _on_timeline_ended():
	#Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	#GlobalVars.in_dialogue = false

func doorOpen(argument: String):
	if not is_open and argument == "open_door":
		Dialogic.signal_event.disconnect(doorOpen)
		if not timer.is_stopped():
			timer.stop()
		if entered_quincy_house == true:
			leaving = true
			emit_signal("quincy_reposition")
			emit_signal("theo_follow")
		elif entered_juniper_house == true:
			leaving = true
		open()
		collision.disabled = true
		is_open = true
	else:
		Dialogic.signal_event.disconnect(doorOpen)

		
func _on_kitchen_point_body_entered(body: CharacterBody3D) -> void:
	if body.is_in_group("player"):
		print("entered")
		if GlobalVars.ghost_open and is_open == false:
			open()
			GlobalVars.ghost_open = false


func _on_side_enter_body_entered(body: Node3D) -> void:
	if quincy_house:
		if is_open == false:
			open()
			collision.disabled = true
			is_open = true

func _on_main_enter_body_entered(body: Node3D) -> void:
	#if quincy_house:
		#if is_open == false:
			#open()
			#collision.disabled = true
			pass
			
			
#emit a signal on arrival to open

func _on_character_body_3d_juniper_open_door() -> void:
	open()
	collision.disabled = true
	await get_tree().create_timer(2.0).timeout
	emit_signal("j_dialogue")
	emit_signal("retarget", 2)

func _on_juniper_interact_finish_greeting() -> void:
	greeting = true
	auto_close = true

func _on_quincy_interact_finish_greeting() -> void:
	emit_signal("disable_look")
	open()
	collision.disabled = true
	


func _on_quincy_interact_close_door():
	close()
	collision.set_deferred("disabled", false) 
	entered_quincy_house = true
	is_open = false

func _on_juniper_interact_close_door():
	close()
	collision.set_deferred("disabled", false) 
	entered_juniper_house = true
	is_open = false


func _on_timeline_ended():
	emit_signal("disable_look")
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	GlobalVars.in_dialogue = false
	player.start_player()

func _on_knock_ended():
	Dialogic.timeline_ended.disconnect(_on_knock_ended)
	#GlobalVars.in_dialogue = false

func _on_after_faint_open_door():
	open()
	collision.disabled = true
	is_open = true
	leaving = true


func _on_exit_house(body):
	var dalton_left = false
	var theo_left = false

	if leaving == true:
		if body.is_in_group("player"):
			dalton_left = true
			#if dalton_left == true:# and theo_left == true:
				#close()
				#collision.set_deferred("disabled", false) 
				#emit_signal("activate_car")
				#is_open = false
		print("Theo ", theo_left)
		print("Dalton ", dalton_left)
		
		if body.is_in_group("theo"):
			theo_left = true
			await get_tree().create_timer(1.0).timeout
			close()
			collision.set_deferred("disabled", false) 
			emit_signal("activate_car")
			is_open = false
			print("Theo ", theo_left)
			print("Dalton ", dalton_left)
		
		if dalton_left == true and theo_left == true:
			print("CLOSEING")
			close()
			collision.set_deferred("disabled", false) 
			emit_signal("activate_car")
			is_open = false
			print("Theo ", theo_left)
			print("Dalton ", dalton_left)


func open_door(arg : String):
	if arg == "open_door":
		Dialogic.signal_event.disconnect(open_door)
		print("asking juniper to come")
		emit_signal("juniper_greeting")

func knock_dalton(arg : String):
	if arg == "knock":
		Dialogic.signal_event.disconnect(knock_dalton)
		print("asking juniper to come")
		emit_signal("dalton_knock")



func _on_juniper_house_body_entered(body):
	if auto_close == true:
		if body.is_in_group("player") and greeting == true:
			dalton_entered = true
			if dalton_entered == true and theo_entered == true:
				_on_juniper_interact_close_door()
				entered_juniper_house = true
				auto_close = false
				emit_signal("entered_juniper")
		
		if body.is_in_group("theo") and greeting == true:
			theo_entered = true
			if dalton_entered == true and theo_entered == true:
				_on_juniper_interact_close_door()
				entered_juniper_house = true
				auto_close = false
				emit_signal("entered_juniper")


func _on_juniper_interact_reactivate_door():
	if interaction.monitorable == false:
		print("enable door")
		interaction.set_deferred("monitorable", true)


func _on_tea_time():
	interaction.set_deferred("monitorable", false)


func _on_caught_open_doors():
	if is_open == false:
		open()
		collision.set_deferred("disabled", true)
		return


func _on_auto_open():
	leaving = true
	open()
	collision.set_deferred("disabled", true)
	interaction.set_monitorable(false)
	interaction.queue_free()
