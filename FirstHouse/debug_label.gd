extends Label

@onready var debug_var  
@onready var label = $"."

func _process(delta):
	debug_var = GlobalVars.in_interaction
	label.text = str(debug_var)
