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

var clue1 : bool
var clue2 : bool
var clue3 : bool
var clue4 : bool

func _ready() -> void:
	if GlobalVars.time == "morning":
		clue1 = Dialogic.VAR.get_variable("Asked Questions.Micah_Solved_Case")
		clue2 = Dialogic.VAR.get_variable("Juniper.found_skylar")
		clue3 = Dialogic.VAR.get_variable("Quincy.solved_case")
		if Dialogic.VAR.get_variable("Endings.Ending_type") != "":
			if Dialogic.VAR.get_variable("Endings.Ending_type") != "Quincy fired" and  Dialogic.VAR.get_variable("Endings.Ending_type") != "Chief fired" and Dialogic.VAR.get_variable("Endings.Ending_type") != "Arrested Skylar":
				clue4 = true
		if clue1 and clue2 and clue3 and clue4:
			GlobalVars.clue_progress = 4
		elif clue1 and clue2 and clue3:
			GlobalVars.clue_progress = 3
		elif clue1 and clue2:
			GlobalVars.clue_progress = 2
		elif clue1:
			GlobalVars.clue_progress = 1
		else:
			GlobalVars.clue_progress = 0
			return
		if GlobalVars.clue_progress == 1:
			clue_1.visible = true
			pin_1.visible = true
		elif GlobalVars.clue_progress == 2:
			thread.visible = true 
			clue_1.visible = true
			pin_1.visible = true
			clue_2.visible = true
			pin_2.visible = true
		elif GlobalVars.clue_progress == 3:
			thread.visible = true 
			thread_1.visible = true 
			clue_1.visible = true
			pin_1.visible = true
			clue_2.visible = true
			pin_2.visible = true
			clue_3.visible = true
			pin_3.visible = true
		elif GlobalVars.clue_progress == 4:
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
		else:
			return
		
	
