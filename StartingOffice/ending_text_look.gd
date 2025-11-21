extends Area2D

#Assign object in 2D and 3D
@export var object_interact: Area2D
@export var  object_in_scene: MeshInstance3D

#UI Overlay
@export var UI_look: Array[CanvasLayer]

#Globals
@export var viewing : String
#@export var clicked_object : String
#@export var view_object: String

#Access Globals
#@onready var clicked_count = GlobalVars.get(clicked_object)
#@onready var viewed_object = GlobalVars.get(view_object)
var look_screen : CanvasLayer
#paper sound
@export var case_sound : AudioStreamPlayer

func _ready():
	await get_tree().process_frame
	if Dialogic.VAR.get_variable("Endings.Ending_type") != "":
		match Dialogic.VAR.get_variable("Endings.Ending_type"):
			"Quincy fired":
				look_screen = UI_look[0]
			"Chief fired":
				look_screen = UI_look[1]
			"Arrested Skylar":
				look_screen = UI_look[2]
			"Keep Confidential":
				look_screen = UI_look[3]
			"Give Skylar Cure":
				look_screen = UI_look[4]
			"Give Skylar Cure And Choco":
				look_screen = UI_look[5]
			"Give Kale Cure":
				look_screen = UI_look[6]
			"Give Kale Cure And Choco":
				look_screen = UI_look[7]
			_:
				print_debug("No Ending File")
				return

func _on_input_event(viewport, event, shape_idx):
	if GlobalVars.in_look_screen == false:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed == true:
				case_sound.play()
				object_in_scene.hide()
				object_interact.hide()
				look_screen.show()
				GlobalVars.viewing = viewing
				GlobalVars.in_look_screen = true
				#clicked_count += 1
				#GlobalVars.set(clicked_object, clicked_count)
				

func _on_exit_pressed():
	look_screen.hide()
	object_in_scene.show()
	object_interact.show()
	#if viewed_object == false and clicked_count == 1:
		##print("set")
		#GlobalVars.set(view_object, true)
	#else:
		#GlobalVars.set(view_object, true)

func _input(event):
	if Input.is_action_just_pressed("Exit") and GlobalVars.viewing == viewing:
		look_screen.hide()
		object_in_scene.show()
		object_interact.show()
		#if viewed_object == false and clicked_count == 1:
			#GlobalVars.set(view_object, true)
		#else:
			#GlobalVars.set(view_object, true)
