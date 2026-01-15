extends VBoxContainer

var allow_cap := false
@export var op_button : Node
@export var pause_screen : Panel
@export var pause_menu : Node
var open := false
signal set_selected
signal set_mirror
var selected

func _ready() -> void:
	pass
	
#func _on_option_button_item_selected(index: int) -> void:
	#op_button.release_focus()
	#match index:
		#0:
			#DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
			##targ_fps.visible = false
			##_apply_fps_cap(0)
		#1:
			#DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ADAPTIVE)
			##targ_fps.visible = false
			##_apply_fps_cap(0)
		#2:
			#DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
			##targ_fps.visible = true
			
#func _apply_fps_cap(fps: int) -> void:
	#Engine.max_fps = fps
#
#func _on_fps_button_item_selected(index: int) -> void:
	#match index:
		#0:
			#_apply_fps_cap(30)
		#1:
			#_apply_fps_cap(60)
		#2:
			#_apply_fps_cap(0)

func _on_reset_graphics_pressed() -> void:
	emit_signal("set_selected", "Enabled", 0, true)
	selected = 0
	GlobalVars.vsync = 0
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	#targ_fps.visible = false
	#_apply_fps_cap(0)

#func _on_option_panel_clicked(event):
	#if event is InputEventMouseButton:
		#if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			#op_button.release_focus()
#
#
#func _on_option_button_clicked(event):
	#if event is InputEventMouseButton:
		#if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			#if open == true:
				#op_button.release_focus()
#
#func _on_option_button_toggled(toggled_on):
	#open = toggled_on
func _on_pause_menu_visibility_changed():
	pass
	#if pause_screen.visible == true:
		#pause_menu.op_array[selected].set_pressed_no_signal(true)

func _on_menu_on_select_option(index):
	match index:
		0:
			selected = 0
			GlobalVars.vsync = 0
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
		1:
			selected = 1
			GlobalVars.vsync = 1
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		2:
			selected = 2
			GlobalVars.vsync = 2
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ADAPTIVE)
