extends Label

@onready var debug_var  
@onready var debug_var_1  
@onready var label = $"."

func _process(delta):
	debug_var = Dialogic.VAR.get_variable("Character Aff Points.Micah")
	debug_var_1 = Dialogic.VAR.get_variable("Asked Questions.Micah_cab")
	#label.text = str(debug_var) + str(debug_var_1)
