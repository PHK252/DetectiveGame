extends TextureButton

@onready var rich_text_label = $RichTextLabel
@onready var timer = $"../Timer"
@onready var debug = $"../Debug"

func _on_toggled(toggled_on):
	if toggled_on:
		get_tree().paused = true
	else:
		get_tree().paused = false

func _process(delta):
	rich_text_label.text = str(timer.time_left) + str(debug.time_left)
