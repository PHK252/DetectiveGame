extends Area2D

#Assign object in 2D and 3D
@export var object_interact: Area2D

#Globals
@export var viewing : String
@export var view_object: String

#Access Globals
@onready var viewed_object = GlobalVars.get(view_object)

#Dialogue if there is a single thought behind those eyes
@export var dialogue_file : String

@export var extra_anim : AnimationPlayer = null
@export var anim_track : String = ""

func _on_input_event(viewport, event, shape_idx):
	if GlobalVars.in_look_screen == false:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed == true:
				print("clicked")
				object_interact.hide()
				GlobalVars.viewing = viewing
				GlobalVars.in_dialogue = true
				Dialogic.timeline_ended.connect(_on_timeline_ended)
				Dialogic.start(dialogue_file)


func _on_timeline_ended():
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	GlobalVars.in_dialogue = false
	object_interact.show()
	GlobalVars.viewing = ""
	if extra_anim:
		extra_anim.play(anim_track)
		await extra_anim.animation_finished
		GlobalVars.set(view_object, true)
	else:
		GlobalVars.set(view_object, true)
