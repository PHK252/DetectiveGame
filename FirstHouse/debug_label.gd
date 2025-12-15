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
	debug_var = Dialogic.VAR.get_variable("Asked Questions.Micah_Asked_Case")
	debug_var_1 = Dialogic.VAR.get_variable("Asked Questions.viewed_pic")
	debug_var_2 = Dialogic.VAR.get_variable("Asked Questions.Micah_Closet_Asked")
	#debug_var_3 = phone_and_pause_overlay.phone_visible
	#debug_var_4 = alert.visible
	#label.text = "Time left: " + str(debug_var) + "\nDistract Time left: " + str(debug_var_1)
	label.text = "Asked Case: " + str(debug_var) + "\nViewed Pic: " + str(debug_var_1) + "\nCloset: " + str(debug_var_2)
	pass
