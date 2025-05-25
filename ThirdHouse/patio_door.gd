extends Node3D

@export var animation_tree : AnimationTree
@export var collision : CollisionShape3D
@export var player : CharacterBody3D
@export var alert : Sprite3D
@export var dalton_marker : Marker2D
var is_open: bool = false
@onready var inside_open = false
var cooldown = false
var triggered = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func open() -> void:
	print("opening")
	cooldown = true
	animation_tree["parameters/conditions/is_opened"] = true
	animation_tree["parameters/conditions/is_closed"] = false
	is_open = true
	await get_tree().create_timer(2.0).timeout
	cooldown = false
	
	
func close() -> void:
	#print("Opening")
	cooldown = true
	animation_tree["parameters/conditions/is_closed"] = true
	animation_tree["parameters/conditions/is_opened"] = false
	is_open = false
	await get_tree().create_timer(2.0).timeout
	print("quickCLosing")
	animation_tree["parameters/conditions/quick_close"] = true
	await get_tree().create_timer(0.5).timeout
	animation_tree["parameters/conditions/quick_close"] = false
	animation_tree["parameters/conditions/is_closed"] = false
	cooldown = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_back_interacted(interactor):
	if is_open == false and cooldown == false:
		open()
		collision.disabled = true
		if inside_open == false:
			inside_open = true
	elif is_open == true and cooldown == false:
		close()
		collision.disabled = false

func _on_front_interacted(interactor):
	if inside_open == true:
		if is_open == false and cooldown == false:
			open()
			collision.disabled = true
		elif is_open == true and cooldown == false:
			close()
			collision.disabled = false
	else:
		if GlobalVars.in_dialogue == false:
			GlobalVars.in_dialogue = true
			var locked = Dialogic.start("Quincy_Patio_Locked")
			Dialogic.timeline_ended.connect(_on_timeline_ended)
			locked.register_character(load("res://Dialogic Characters/Dalton.dch"), dalton_marker)
			player.stop_player()
			alert.hide()

func _on_timeline_ended():
	#emit_signal("Dstopped")
	#emit_signal("Tstart")
	player.start_player()
	alert.show()
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	GlobalVars.in_dialogue = false

#func _on_interactable_interacted(interactor: Interactor) -> void:
	#print(is_open)
	#print(inside_open)
	##game code
	##__________________
	##player.stop_player()
	##GlobalVars.in_dialogue = true
	##Dialogic.timeline_ended.connect(_on_timeline_ended)
	##Dialogic.signal_event.connect(doorOpen)
	##var layout = Dialogic.start("Enter_house")
	##layout.register_character(load("res://Dialogic Characters/Dalton.dch"), dalton_marker)
	##layout.register_character(load("res://Dialogic Characters/Micah.dch"), micah_marker)
	##layout.register_character(load("res://Dialogic Characters/Theo.dch"), theo_marker)
	#
	##for debug
	##__________________
	#
	#if is_open == false and inside_open == true and GlobalVars.in_dialogue == false:
		##GlobalVars.in_dialogue == true
		##Dialogic.signal_event.connect(doorOpen)
		##Dialogic.timeline_ended.connect(_on_timeline_ended)
		##var layout = Dialogic.start("Micah_Leave")
		##layout.register_character(load("res://Dialogic Characters/Dalton.dch"), dalton_marker)
		##layout.register_character(load("res://Dialogic Characters/Micah.dch"), micah_marker)
		##layout.register_character(load("res://Dialogic Characters/Theo.dch"), theo_marker)
		#pass
	#
	#elif is_open == false and GlobalVars.in_dialogue == false and cooldown == false:
		#pass
		##print("open")
		##$Interactable.queue_free()
		##if greeting == false and quincy_house == false and triggered == false:
			##print("asking juniper to come")
			##emit_signal("juniper_greeting")
			##emit_signal("cam_greeting")
			##triggered = true
			##return
			###play knocking sound
		##
		##if (greeting == true and quincy_house == false) or quincy_house:
			##open()
			##collision.disabled = true
			##return
		#
	#if is_open == true and cooldown == false: 
		#close()
		#collision.disabled = false


#func doorOpen(argument: String):
	#if not is_open and argument == "open_door":
		##$Interactable.queue_free()
		#open()
		#collision.disabled = true
		#is_open = true

#
#func _on_side_enter_body_entered(body: Node3D) -> void:
	#if is_open == false:
		#open()
		#collision.disabled = true
