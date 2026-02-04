extends TextureButton

var paused := false

func _on_pause_visibility_changed():
	if !paused:
		paused = true
	else:
		paused = false
	texture_normal.pause = paused
	texture_pressed.pause = paused
	texture_hover.pause = paused
		
