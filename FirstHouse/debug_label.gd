extends Label

@onready var debug_var  
@onready var debug_var_1  
@export var label : Label
@export var timer : Timer

func _process(delta):
	debug_var = timer.get_time_left()
	#debug_var_1 = Dialogic.VAR.get_variable("Asked Questions.Micah_cab")
	label.text = str(debug_var)
