extends Label

@onready var debug_var  
@onready var debug_var_1  
@export var label : Label
@export var timer : Timer
@export var cam_array : Array[PhantomCamera3D] = []

func _process(delta):
	#for i in cam_array:
		#if i.is_active():
			#debug_var = i.name
	#debug_var = timer.get_time_left()
	##debug_var_1 = Dialogic.VAR.get_variable("Asked Questions.Micah_cab")
	#label.text = str(debug_var)
	pass
