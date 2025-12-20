extends Node3D

@onready var animation_tree : AnimationTree = $bonedoor/AnimationDoor
@export var collision : CollisionShape3D
@export var alert : Sprite3D
@export var interaction : Interactable
@export var dalton_marker : Marker2D
@export var micah_marker : Marker2D
@export var theo_marker : Marker2D
@export var player :CharacterBody3D
@export var theo : CharacterBody3D
var is_open: bool = false
@onready var entered = false
@export var door_sound : AudioStreamPlayer3D
@export var door_sound_close : AudioStreamPlayer3D
var introduction_happened = false
var dalton_entered = false
var theo_entered = false
var dalton_left = false
var theo_left = false

signal micah_rotate
signal greeting
signal general_interact

signal door_open
signal activate_leave
var is_outside = true

var cooldown = false
var theo_close_door := false
var dalton_close_door := false
signal greet_done
signal entered_micah

var greeting_done := false

signal stop_control
signal start_control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func open() -> void:
	#if is_outside:
		#emit_signal("micah_rotate")
	if is_open == false:
		cooldown = true
		print("Opening")
		door_sound.play()
		animation_tree["parameters/conditions/is_opened"] = true
		animation_tree["parameters/conditions/is_closed"] = false
		is_open = true
		await get_tree().create_timer(0.5).timeout
		collision.disabled = true
		cooldown = false
	
func close() -> void:
	print("Closing")
	if is_open == true:
		emit_signal("stop_control")
		cooldown = true
		animation_tree["parameters/conditions/is_closed"] = true
		animation_tree["parameters/conditions/is_opened"] = false
		is_open = false
		await get_tree().create_timer(2.5).timeout
		emit_signal("start_control")
		door_sound_close.play()
		collision.disabled = false
		
		cooldown = false
		dalton_close_door = false
		theo_close_door = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_interactable_interacted(interactor: Interactor) -> void:
	print(cooldown)
	if cooldown == false:
		cooldown = true
		alert.hide()
		emit_signal("general_interact")
		print(is_open)
		print(entered)
		print(GlobalVars.in_dialogue)
		#level exit
		#__________________
		if is_open == false and entered == true and GlobalVars.in_dialogue == false:
			GlobalVars.in_dialogue = true
			Dialogic.signal_event.connect(doorOpen)
			Dialogic.signal_event.connect(notleave)
			Dialogic.timeline_ended.connect(_on_exit_timeline_ended)
			player.stop_player()
			Dialogic.start("Micah_Leave")
		elif is_open == false and GlobalVars.in_dialogue == false and introduction_happened == false:
			#print("open")
			#$Interactable.queue_free()
			#if introduction_happened:
				#open()
				#collision.disabled = true
			emit_signal("greeting")
			emit_signal("micah_rotate")
			#Level enter
			#__________________
			player.stop_player()
			GlobalVars.in_dialogue = true
			Dialogic.timeline_ended.connect(_on_timeline_ended)
			Dialogic.signal_event.connect(doorOpen)
			var enter = Dialogic.start("Enter_house")
			enter.register_character(load("res://Dialogic Characters/Dalton.dch"), dalton_marker)
			enter.register_character(load("res://Dialogic Characters/Micah.dch"), micah_marker)
			enter.register_character(load("res://Dialogic Characters/Theo.dch"), theo_marker)
			print("dalton_move_knock")
			return
		
		
		if is_open == false and greeting_done: 
			if is_outside == true:
				open()
				return
				
		if is_open == true and greeting_done: 
			close()
		#	collision.disabled = false
			return
		

#game code
#__________________
func _on_timeline_ended():
	emit_signal("greet_done")
	greeting_done = true
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	GlobalVars.in_dialogue = false
	player.start_player()

func _on_exit_timeline_ended():
	Dialogic.timeline_ended.disconnect(_on_exit_timeline_ended)
	GlobalVars.in_dialogue = false
	player.start_player()

func doorOpen(argument: String):
	if not is_open and argument == "open_door":
		emit_signal("door_open")
		Dialogic.signal_event.disconnect(doorOpen)
		introduction_happened = true
		#$Interactable.queue_free()
		open()
		#collision.disabled = true
		is_open = true

func notleave(argument : String):
	if argument == "notyet":
		Dialogic.signal_event.disconnect(doorOpen)
		Dialogic.signal_event.disconnect(notleave)
		cooldown = false
# will need more debugging
#func _on_interactable_unfocused(interactor):
	#if is_open == true:
		#print("close")
		##await get_tree().create_timer(3.0).timeout
		##animation_tree["parameters/conditions/is_closed"] = true
		##animation_tree["parameters/conditions/is_opened"] = false
		##is_open = false
		##entered = true
		##collision.disabled = false

func _on_character_body_3d_d_hall() -> void:
	is_outside = true

func _on_character_body_3d_d_inside() -> void:
	is_outside = false

func _on_micah_body_micah_open() -> void:
	#await get_tree().create_timer(5).timeout
	#open()
	#collision.disabled = true
	#introduction_happened = true
	pass



func _on_door_theo_entered():
	if entered == false:
		theo_entered = true
		print("theo entered!" + str(theo_entered))
		#if dalton_entered == true:
			#entered = true
			#emit_signal("entered_micah")
			#close()


func _on_dalton_door_entered():
	if entered == false: 
		dalton_entered = true
		print("dalton entered! "  + str(dalton_entered))
		#if theo_entered == true:
			#entered = true
			#emit_signal("entered_micah")
			#close()


func _on_door_dalton_leave_body_entered(body):
	#print("dalt reg leave")
	if entered == true:
		if body.is_in_group("player"):
			dalton_left = true
			#if theo_left == true:
				#close()
				#entered = false
				#emit_signal("activate_leave")
				#if interaction.monitorable == true:
					#interaction.set_deferred("monitorable", false)
		
#signal when theo leaves, body not registering
func _on_doorcamarea_body_entered(body):
	#print("theo reg leave")
	if entered == true:
		if body.is_in_group("theo"):
			theo_left = true
			#if dalton_left == true:
				#close()
				#entered = false
				#emit_signal("activate_leave")
				#if interaction.monitorable == true:
					#interaction.set_deferred("monitorable", false)


func _on_doorcamarea_dalton_body_exited(body):
	if entered == true:
		if body.is_in_group("player"):
			dalton_left = false


func _on_theo_doorcamarea_body_exited(body):
	if entered == true:
		if body.is_in_group("theo"):
			theo_left = false


func _on_door_point_body_exited(body):
	if entered == false: 
		if body.is_in_group("theo") and theo_entered:
			theo_close_door = true
			print("theo close",theo_close_door)
		if body.is_in_group("player") and dalton_entered:
			dalton_close_door = true
			print("dalton close", dalton_close_door)
		if theo_close_door and dalton_close_door:
			entered = true
			emit_signal("entered_micah")
			close()
	else:
		if body.is_in_group("theo") and theo_left:
			theo_close_door = true
			print("theo close",theo_close_door)
		if body.is_in_group("player") and dalton_left:
			dalton_close_door = true
			print("dalton close", dalton_close_door)
		if theo_close_door and dalton_close_door:
			close()
			entered = false
			emit_signal("activate_leave")
			if interaction.monitorable == true:
				interaction.set_deferred("monitorable", false)


func _on_door_point_body_entered(body):
	if entered == false: 
		if body.is_in_group("theo") and theo_entered:
			theo_close_door = false
			print("theo close",theo_close_door)
		if body.is_in_group("player") and dalton_entered:
			dalton_close_door = false
			print("dalton close", dalton_close_door)
	else:
		if body.is_in_group("theo") and theo_left:
			theo_close_door = false
			print("theo close",theo_close_door)
		if body.is_in_group("player") and dalton_left:
			dalton_close_door = false
			print("dalton close", dalton_close_door)
