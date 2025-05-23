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
func _ready() -> void:
	doughnut.visible = false

func _on_interactable_interacted(interactor: Interactor) -> void:
	if just_interacted == false:
		if eat_times <= 11:
			alert.hide()
			eat_times += 1
			just_interacted = true
			emit_signal("time_to_eat")
			await get_tree().create_timer(2.5).timeout
			doughnut.visible = true
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
	if eat_times > 0 and eat_times <= 5:
		var rng = RandomNumberGenerator.new()
		var random = rng.randi_range(1, 3)
		if random == 1:
			dialogue = "first"
		if random == 2:
			dialogue = "second"
		if random == 3:
			dialogue = "third"
	elif eat_times >= 6:
		if eat_times == 6:
			dialogue = "fourth"
		if eat_times == 7:
			dialogue = "five"
		if eat_times == 8:
			dialogue = "six"
		if eat_times == 9:
			dialogue = "seven"
		if eat_times == 10:
			dialogue = "eight"
		if eat_times == 11:
			dialogue = "nine"
		 
