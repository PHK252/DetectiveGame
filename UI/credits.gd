extends CanvasLayer

@export var ending_label : RichTextLabel
@export var icon : TextureRect
func _ready():
	SaveLoad.clearSave(SaveLoad.SAVE_DIR + SaveLoad.SAVE_FILE_NAME)
	GlobalVars.reset_globals()
	match Dialogic.VAR.get_variable("Endings.Ending_type"):
		"Arrested Skylar":
			ending_label.text = "[center]Bare Minimum[/center]"
			icon.texture = load("res://UI/Assets/Credits/Endings/Minimum.png")
		"Keep Confidential":
			ending_label.text = "[center]Ignorance by Omission[/center]"
			icon.texture = load("res://UI/Assets/Credits/Endings/Ignorance.png")
		"Give Skylar Cure":
			ending_label.text = "[center]In Over Your Head[/center]"
			icon.texture = load("res://UI/Assets/Credits/Endings/Overhead.png")
		"Give Skylar Cure And Choco":
			ending_label.text = "[center]The Storm before the Calm[/center]"
			icon.texture = load("res://UI/Assets/Credits/Endings/Storm.png")
		"Give Kale Cure":
			ending_label.text = "[center]Human Proof[/center]"
			icon.texture = load("res://UI/Assets/Credits/Endings/Human.png")
		"Give Kale Cure And Choco":
			ending_label.text = "[center]Isaac’s Requiem[/center]"
			icon.texture = load("res://UI/Assets/Credits/Endings/Isaac.png")
		"Chief fired":
			ending_label.text = "[center]Lost Cause[/center]"
			icon.texture = load("res://UI/Assets/Credits/Endings/Lost.png")
		"Quincy fired":
			ending_label.text = "[center]Poked the Cat’s Nest[/center]"
			icon.texture = load("res://UI/Assets/Credits/Endings/Poke.png")
		_:
			print_debug("How did this happen")
	await get_tree().create_timer(5.0).timeout
	get_tree().quit()
