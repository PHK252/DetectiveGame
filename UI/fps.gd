extends CanvasLayer

@onready var fps = $RichTextLabel
var display_fps := false

func _ready():
	if GlobalVars.fps_toggle == true:
		visible = true
	else:
		visible = false
	GlobalVars.toggle_fps.connect(_on_toggle_fps)

func _process(delta: float) -> void:
	fps.text = str(Engine.get_frames_per_second())

func _on_toggle_fps(toggled : bool):
	if toggled == false:
		set_process(false)
		visible = false
	else:
		set_process(true)
		visible = true
