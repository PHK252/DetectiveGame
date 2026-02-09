extends Label

@onready var debug_var  
@onready var debug_var_1  
@onready var debug_var_2  
@onready var debug_var_3
@onready var debug_var_4
@onready var debug_var_5
@onready var debug_var_6
@export var label : Label
@export var timer : Timer
@export var distraction_timer : Timer
@export var quincy : CharacterBody3D
@export var cam_array : Array[PhantomCamera3D] = []
@onready var phone_and_pause_overlay = $"../Phone and Pause Overlay"
#@onready var alert = $"../../SubViewportContainer/SubViewport/Dalton/CharacterBody3D/PlayerInteractor/CollisionShape3D/Alert"

#
func _process(delta):
	##for i in cam_array:
		##if i.is_active():
			##debug_var = i.name
	##debug_var = GlobalVars.phone_tut
	debug_var = timer.get_time_left()
	if distraction_timer:
		debug_var_1 = distraction_timer.get_time_left()
	###debug_var = Dialogic.VAR.get_variable("Asked Questions.Micah_Asked_Case")
	#debug_var_2 = Dialogic.VAR.get_variable("Character Aff Points.Theo")
	debug_var_3 = Dialogic.VAR.get_variable("Asked Questions.Micah_Closet_Asked")
	debug_var_4 = Dialogic.VAR.get_variable("Asked Questions.Micah_Asked_Case")
	debug_var_5 = Dialogic.VAR.get_variable("Asked Questions.viewed_pic")
	debug_var_2 = Dialogic.VAR.get_variable("Quincy.in_bathroom")
	debug_var_2 = quincy.in_danger
	
	#debug_var_3 = Dialogic.VAR.get_variable("Character Aff Points.Micah")
	#debug_var_4 = Dialogic.VAR.get_variable("Character Aff Points.Juniper")
	#debug_var_5 = Dialogic.VAR.get_variable("Character Aff Points.Quincy")
	#debug_var_6 = Dialogic.VAR.get_variable("Character Aff Points.Skylar")
	###debug_var_4 = alert.visible
	label.text = "Time left: " + str(debug_var) + "\n Distract: " + str(debug_var_1)  + "\nTheo: " + str(debug_var_2) + "\nCloset: " + str(debug_var_3) + "\nCase: " + str(debug_var_4) + "\nPic: " + str(debug_var_5) + "\nSkylar: " + str(debug_var_6) 
	##label.text = "Time out:  " + str(debug_var) + "\nDistract time " + str(debug_var_1) + "\nIn Danger: " + str(debug_var_2) + "\nCatch: " + str(debug_var_3
	#pass
