extends CanvasLayer

@onready var front = $"Object front"
@onready var back = $"Object Back"



func _ready():
	back.hide()

func _process(delta):
	if Input.is_action_just_pressed("Exit"):
		$".".hide()
		GlobalVars.in_look_screen = false

func _on_object_front_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed == true:
			back.show()
			front.hide()

func _on_object_back_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed == true:
			back.hide()
			front.show()



func _on_exit_pressed():
	$".".hide()
	GlobalVars.in_look_screen = false
