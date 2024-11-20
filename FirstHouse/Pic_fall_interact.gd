extends Area2D

@onready var pic_cam = $"../../../SubViewport/CameraSystem/Picture"
@onready var main_cam = $"../../../SubViewport/CameraSystem/livingroom"
@onready var player = $"../../../../Characters/Dalton/CharacterBody3D"
@onready var cam_anim = $"../../../SubViewport/CameraSystem/Picture/AnimationPlayer"
@onready var pic_fall = $"."

@onready var dalton_marker = $"../../../../UI/Dalton_marker"
@onready var micah_marker = $"../../../../UI/Micah_marker"



func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed == true:
			print("weeeeeeee")
			#play anim
			await get_tree().create_timer(1.0).timeout
			#Exit to third person for dialogue
			GlobalVars.pic_fell = true
			main_cam.set_tween_duration(0)
			pic_cam.priority = 0
			main_cam.priority = 12
			await get_tree().create_timer(.03).timeout
			cam_anim.play("RESET")
			player.show()
			player.start_player()
			#main_cam.set_tween_duration(1)
			GlobalVars.in_interaction = ""
			pic_fall.hide()
			if GlobalVars.in_dialogue == false:
				GlobalVars.in_dialogue = true
				Dialogic.timeline_ended.connect(_on_timeline_ended)
				var pic_fell_Dialogue = Dialogic.start("Micah_pic_fall")
				pic_fell_Dialogue.register_character(load("res://Dialogic Characters/Dalton.dch"), dalton_marker)
				pic_fell_Dialogue.register_character(load("res://Dialogic Characters/Micah.dch"), micah_marker)
			
func _on_timeline_ended():
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	GlobalVars.in_dialogue = false
	player.start_player()
