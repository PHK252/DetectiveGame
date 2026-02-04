extends MeshInstance3D

@export var doughnut: Node3D
signal time_to_eat
var just_interacted = false
@export var alert : Sprite3D
@onready var eat_times = 0
@onready var dialogue =""
@export var dialogue_file : String
@export var dalton_marker : Marker2D
@export var player : CharacterBody3D
@onready var enough = false

signal doughnut_gone

@export var interactable : Area3D
@export var coll_shape : CollisionShape3D
var stop_interact := false

func _ready() -> void:
	doughnut.visible = false
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	if GlobalVars.day == 3:
		coll_shape.disabled = true
		interactable.monitoring = false

func _on_interactable_interacted(interactor: Interactor) -> void:
	if just_interacted == false:
		if enough == false: #max doughnuts are 8
			alert.hide()
			eat_times += 1
			just_interacted = true
			emit_signal("time_to_eat")
			await get_tree().create_timer(2.5).timeout
			doughnut.visible = true
			emit_signal("doughnut_gone")
			await get_tree().create_timer(2.0).timeout
			doughnut.visible = false
			await get_tree().create_timer(1.8).timeout
			player.stop_player()
			choose_dialogue()
			print(eat_times)
			GlobalVars.in_dialogue = true
			Dialogic.timeline_ended.connect(_on_timeline_ended)
			var layout = Dialogic.start("Office_Donuts", dialogue)
			layout.register_character(load("res://Dialogic Characters/Dalton.dch"), dalton_marker)
		else:
			alert.hide()
			player.stop_player()
			GlobalVars.in_dialogue = true
			Dialogic.timeline_ended.connect(_on_timeline_ended)
			var layout = Dialogic.start("Office_Donuts", "no more")
			layout.register_character(load("res://Dialogic Characters/Dalton.dch"), dalton_marker)

func _on_timeline_ended():
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	GlobalVars.in_dialogue = false
	just_interacted = false
	player.start_player()
	alert.show()

		

func choose_dialogue():
	if eat_times <= 8:
		if eat_times == 1:
			dialogue = "first"
		if eat_times == 2:
			dialogue = "second"
		if eat_times == 3:
			dialogue = "third"
		if eat_times == 4:
			dialogue = "fourth"
		if eat_times == 5:
			dialogue = "fifth"
		if eat_times == 6:
			dialogue = "sixth"
		if eat_times == 7:
			dialogue = "seventh"
		if eat_times == 8:
			dialogue = "eigth"
		if eat_times == 9:
			dialogue = "nineth"
		 

func _on_doughnut_box_no_more_doughnuts() -> void:
	enough = true
