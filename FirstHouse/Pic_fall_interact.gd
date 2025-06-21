extends Area2D

@onready var pic_cam = $"../../../../../../SubViewport/CameraSystem/Picture"
@onready var main_cam = $"../../../../../../SubViewport/CameraSystem/livingroom"
@onready var player = $"../../../../../../SubViewport/Dalton/CharacterBody3D"
@onready var cam_anim = $"../../../../../../SubViewport/CameraSystem/Picture/AnimationPlayer"
@onready var pic_fall = $"."
@onready var pic_fall_anim = $"../../../../AnimationPlayer"


@onready var dalton_marker = $"../../../../../../../UI/Dalton_marker"
@onready var micah_marker = $"../../../../../../../UI/Micah_marker"
var pic_fell = false

#sounds
@export var frame_fall : AudioStreamPlayer3D
@export var paper_fall : AnimationPlayer

func _ready():
	pic_fall_anim.play("Default")


func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed == true and pic_fell == false:
			frame_fall.play()
			paper_fall.play("PicFloat")
			pic_fell = true
			print("weeeeeeee") 
			GlobalVars.in_look_screen = true
			pic_fall_anim.play("PicFalling")
			await pic_fall_anim.animation_finished
			GlobalVars.pic_fell = true
			await get_tree().create_timer(.5).timeout
			GlobalVars.in_look_screen = false
			pic_cam.priority = 0
			main_cam.priority = 30
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			cam_anim.play("RESET")
			player.show()
			player.stop_player()
			GlobalVars.in_interaction = ""
			pic_fall.hide()
			if GlobalVars.in_dialogue == false and GlobalVars.micah_time_out == false and GlobalVars.micah_kicked_out == false:
				print("pic entered")
				GlobalVars.in_dialogue = true
				Dialogic.timeline_ended.connect(_on_timeline_ended)
				var pic_fell_Dialogue = Dialogic.start("Micah_pic_fall")
				pic_fell_Dialogue.register_character(load("res://Dialogic Characters/Dalton.dch"), dalton_marker)
				pic_fell_Dialogue.register_character(load("res://Dialogic Characters/Micah.dch"), micah_marker)
			
func _on_timeline_ended():
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	GlobalVars.in_dialogue = false
	player.start_player()
