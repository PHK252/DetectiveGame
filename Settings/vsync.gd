extends HBoxContainer

@export var targ_fps : HBoxContainer
var allow_cap := false
@export var op_button : OptionButton

func _ready() -> void:
	targ_fps.visible = false
	_apply_fps_cap(0)

func _on_option_button_item_selected(index: int) -> void:
	match index:
		0:
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
			targ_fps.visible = false
			_apply_fps_cap(0)
		1:
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ADAPTIVE)
			targ_fps.visible = false
			_apply_fps_cap(0)
		2:
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
			targ_fps.visible = true
			
func _apply_fps_cap(fps: int) -> void:
	Engine.max_fps = fps

func _on_fps_button_item_selected(index: int) -> void:
	match index:
		0:
			_apply_fps_cap(30)
		1:
			_apply_fps_cap(60)
		2:
			_apply_fps_cap(0)

func _on_reset_graphics_pressed() -> void:
	op_button.selected = 0
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	targ_fps.visible = false
	_apply_fps_cap(0)
