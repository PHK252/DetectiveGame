extends Node3D

@export var interactable: Interactable

func _ready():
	interactable.set_deferred("monitorable", !Dialogic.VAR.get_variable("Quincy.left_quincy"))

func _on_interactable_interacted(interactor):
	if GlobalVars.in_dialogue == false and Dialogic.VAR.get_variable("Quincy.left_quincy") == false:
		if GlobalVars.in_level == false:
			Dialogic.start("Porch_Theo")
			GlobalVars.in_dialogue = true
			Dialogic.timeline_ended.connect(_on_timeline_ended)
		else:
			if Dialogic.VAR.get_variable("Quincy.is_distracted") == false and Dialogic.VAR.get_variable("Quincy.caught") == false:
				if GlobalVars.quincy_kicked_out == false and GlobalVars.quincy_time_out == false:
					Dialogic.start("Porch_Quincy")
					GlobalVars.in_dialogue = true
					Dialogic.timeline_ended.connect(_on_timeline_ended)
	else:
		return

func _on_timeline_ended():
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	GlobalVars.in_dialogue = false
