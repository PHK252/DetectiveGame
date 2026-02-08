extends ScrollContainer

func _ready():
	if get_v_scroll_bar():
		get_v_scroll_bar().mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
