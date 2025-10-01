extends Label

@onready var debug_var  
@onready var debug_var_1  
@export var label : Label
@export var timer : Timer
@export var distraction_timer : Timer
@export var cam_array : Array[PhantomCamera3D] = []

func _process(delta):
	#for i in cam_array:
		#if i.is_active():
			#debug_var = i.name
#	debug_var = timer.get_time_left()
	#debug_var_1 = distraction_timer.get_time_left()
	#label.text = "Time left: " + str(debug_var) + "\nDistract Time left: " + str(debug_var_1)
	pass
