extends Control

@export var ending_label : RichTextLabel

func _ready():
	match Dialogic.VAR.get_variable("Endings.Ending_type"):
		"Arrested Skylar":
			ending_label.text = "Bare Minimum"
		"Keep Confidential":
			ending_label.text = "Ignorance by Omission"
		"Give Skylar Cure":
			ending_label.text = "In Over Your Head"
		"Give Skylar Cure And Choco":
			ending_label.text = "The Storm before the Calm"
		"Give Kale Cure":
			ending_label.text = "Human Proof"
		"Give Kale Cure And Choco":
			ending_label.text = "Isaac’s Requiem"
		"Chief fired":
			ending_label.text = "Lost Cause"
		"Quincy fired":
			ending_label.text = "Poked the Cat’s Nest"
		_:
			print_debug("How did this happen")
