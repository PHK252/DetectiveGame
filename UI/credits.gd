extends CanvasLayer

@export var ending_label : RichTextLabel

func _ready():
	match Dialogic.VAR.get_variable("Endings.Ending_type"):
		"Arrested Skylar":
			ending_label.text = "[center]Bare Minimum[/center]"
		"Keep Confidential":
			ending_label.text = "[center]Ignorance by Omission[/center]"
		"Give Skylar Cure":
			ending_label.text = "[center]In Over Your Head[/center]"
		"Give Skylar Cure And Choco":
			ending_label.text = "[center]The Storm before the Calm[/center]"
		"Give Kale Cure":
			ending_label.text = "[center]Human Proof[/center]"
		"Give Kale Cure And Choco":
			ending_label.text = "[center]Isaac’s Requiem[/center]"
		"Chief fired":
			ending_label.text = "[center]Lost Cause[/center]"
		"Quincy fired":
			ending_label.text = "[center]Poked the Cat’s Nest[/center]"
		_:
			print_debug("How did this happen")
	await get_tree().create_timer(5.0).timeout
	get_tree().quit()
