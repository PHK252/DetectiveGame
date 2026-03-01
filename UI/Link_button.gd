extends TextureButton

@export var link : String
@export var mail : bool = false

var subject = "Bug Report"
var body = "Hello%0A%0ABUGBUGBUGBUGs"

func _on_pressed():
	if !mail:
		OS.shell_open(link)
		return
	OS.shell_open("mailto:k20.game.studio@gmail.com?subject=" + subject + "&body=" + body)
