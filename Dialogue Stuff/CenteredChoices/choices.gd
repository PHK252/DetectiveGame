extends HBoxContainer

@export var focus_choice : DialogicNode_ChoiceButton

func _ready():
	GlobalVars.unpaused.connect(_focus_choice)

func _focus_choice():
	focus_choice.grab_focus()
