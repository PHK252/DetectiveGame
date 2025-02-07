extends Node

@export var clue_1 = Node3D
@export var pin_1 = Node3D
@export var clue_2 = Node3D
@export var pin_2 = Node3D
@export var clue_3 = Node3D
@export var pin_3 = Node3D
@export var clue_4 = Node3D
@export var pin_4 = Node3D

@export var thread = Node3D
@export var thread_1 = Node3D
@export var thread_2 = Node3D

func _ready() -> void:
	if GlobalVars.clue_progress == 0:
		clue_1.visible = true
		pin_1.visible = true
	elif GlobalVars.clue_progress == 1:
		thread.visible = true 
		clue_1.visible = true
		pin_1.visible = true
		clue_2.visible = true
		pin_2.visible = true
	elif GlobalVars.clue_progress == 2:
		thread.visible = true 
		thread_1.visible = true 
		clue_1.visible = true
		pin_1.visible = true
		clue_2.visible = true
		pin_2.visible = true
		clue_3.visible = true
		pin_3.visible = true
	elif GlobalVars.clue_progress == 3:
		thread.visible = true 
		thread_1.visible = true 
		thread_2.visible = true 
		clue_1.visible = true
		pin_1.visible = true
		clue_2.visible = true
		pin_2.visible = true
		clue_3.visible = true
		pin_3.visible = true
		clue_4.visible = true
		pin_4.visible = true
	
