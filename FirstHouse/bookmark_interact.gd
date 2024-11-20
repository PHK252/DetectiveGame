extends Area2D

@onready var object = $"."
@onready var bookmark = $"../../../bookmark"
@onready var look = $"../../../../../UI/Bookmark"
@onready var anim = $"../../../bookmark/AnimationPlayer"
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _on_input_event(viewport, event, shape_idx):
	if GlobalVars.in_look_screen == false:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed == true:
				anim.play("Bookmark_pull")
				await anim.animation_finished
				await get_tree().create_timer(.5).timeout
				bookmark.hide()
				anim.play("RESET")
				object.hide()
				look.show()
				GlobalVars.viewing = "bookmark"
				GlobalVars.in_look_screen = true
				#GlobalVars.clicked_tool_note = GlobalVars.clicked_tool_note + 1

	

func _on_exit_pressed():
	#if GlobalVars.viewed_Micah_bookmark == false and GlobalVars.clicked_tool_note == 1:
	bookmark.show()
		#GlobalVars.in_dialogue = true
		#Dialogic.timeline_ended.connect(_on_timeline_ended)
		#Dialogic.start("Micah_closet_note_thoughts")
	GlobalVars.viewed_Micah_bookmark = true
	
	GlobalVars.viewing = ""
	GlobalVars.in_look_screen = false


#func _on_timeline_ended():
	#Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	#GlobalVars.in_dialogue = false

func _input(event):
	if Input.is_action_just_pressed("Exit") and GlobalVars.viewing == "bookmark":
		bookmark.show()
		GlobalVars.viewing = ""
		GlobalVars.in_look_screen = false
		GlobalVars.viewed_Micah_bookmark = true
	#if GlobalVars.viewed_tool_note == false and GlobalVars.clicked_tool_note == 1:
			#GlobalVars.in_dialogue = true
			#Dialogic.timeline_ended.connect(_on_timeline_ended)
			#Dialogic.start("Micah_closet_note_thoughts")
			#GlobalVars.viewed_tool_note = true
	
