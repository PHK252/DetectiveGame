extends Label

@onready var debug_var  
@onready var debug_var_1  
@onready var debug_var_2  
@onready var debug_var_3
@onready var debug_var_4  
@export var label : Label
@export var timer : Timer
@export var distraction_timer : Timer
@export var cam_array : Array[PhantomCamera3D] = []
@onready var phone_and_pause_overlay = $"../Phone and Pause Overlay"
@onready var alert = $"../../SubViewportContainer/SubViewport/Dalton/CharacterBody3D/PlayerInteractor/CollisionShape3D/Alert"


func _process(delta):
	#for i in cam_array:
		#if i.is_active():
			#debug_var = i.name
#	debug_var = timer.get_time_left()
	#debug_var_1 = distraction_timer.get_time_left()
	debug_var = GlobalVars.phone_tut
	debug_var_1 = GlobalVars.in_dialogue
	debug_var_2 = phone_and_pause_overlay.in_evidence
	debug_var_3 = phone_and_pause_overlay.phone_visible
	debug_var_4 = alert.visible
	#label.text = "Time left: " + str(debug_var) + "\nDistract Time left: " + str(debug_var_1)
	label.text = "Phone tut: " + str(debug_var) + "\nIn Dialogue: " + str(debug_var_1) + "\nIn evidence: " + str(debug_var_2) + "\nIn phone tut: " + str(debug_var_3) + "\nAlert: " + str(debug_var_4)
	pass
