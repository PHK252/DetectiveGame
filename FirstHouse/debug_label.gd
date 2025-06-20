extends Label

@onready var debug_var  
@onready var label = $"."

func _process(delta):
	debug_var = Dialogic.VAR.get_variable("Asked Questions.Micah_Closet_Asked")
	label.text = str(debug_var)
