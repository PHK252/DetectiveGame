extends Area2D

#@onready var main_cam = $"../../../../../../SubViewport/CameraSystem/livingroom"
#@onready var player = $"../../../../../../../Characters/Dalton/CharacterBody3D"
#@onready var cam_anim = $"../../../../../../SubViewport/CameraSystem/Picture/AnimationPlayer"
@onready var pic_look = $"."
@onready var pic_look_UI = $"../../../../../../../UI/Pic_look"
#
#@onready var dalton_marker = $"../../../../../../../UI/Dalton_marker"
#@onready var micah_marker = $"../../../../../../../UI/Micah_marker"
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed == true:
			GlobalVars.in_look_screen = true
			pic_look.hide()
			pic_look_UI.show()
			GlobalVars.viewing = "pic"
			GlobalVars.in_look_screen = true
			GlobalVars.clicked_Micah_pic = GlobalVars.clicked_Micah_pic + 1

func _on_exit_pressed():
	GlobalVars.viewed_Micah_pic = true
	GlobalVars.viewing = ""

func _input(event):
	if Input.is_action_just_pressed("Exit") and GlobalVars.viewing == "pic":
			GlobalVars.viewed_Micah_pic = true
			#print(GlobalVars.viewing)
			await get_tree().create_timer(.5).timeout
			GlobalVars.viewing = ""
