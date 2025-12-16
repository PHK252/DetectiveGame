extends CanvasLayer

@onready var front = $"Object front"
@onready var back = $"Object Back"
@export var just_front : bool = false
@export var show_mouse_exit : bool = false
signal paper_sound

signal _show_tut(tut_type : String)

func _ready():
	front.show()
	back.hide()


func _input(event):
	if Input.is_action_just_pressed("Exit"):
		$".".hide()
		GlobalVars.in_look_screen = false
		await get_tree().create_timer(.03).timeout
		GlobalVars.viewing = ""
		if show_mouse_exit == true or GlobalVars.in_interaction == "case":
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			return
		#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_object_front_gui_input(event):
	if event is InputEventMouseButton:
		if just_front == false:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed == true:
				emit_signal("paper_sound")
				back.show()
				front.hide()
		else:
			return

func _on_object_back_gui_input(event):
	if event is InputEventMouseButton:
		if just_front == false:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed == true:
				emit_signal("paper_sound")
				back.hide()
				front.show()
		else:
			return

func _on_exit_pressed():
	$".".hide()
	GlobalVars.in_look_screen = false
	GlobalVars.viewing = ""
	if show_mouse_exit == true:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		return
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _on_visibility_changed():
	if visible == true:
		if GlobalVars.flip_tut == false:
			emit_signal("_show_tut", "flip")


func _on_paper_sound_needed() -> void:
	if visible == true:
		emit_signal("paper_sound")
