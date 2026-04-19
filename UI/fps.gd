extends CanvasLayer


@onready var fps = $RichTextLabel
var display_fps := false

func _ready():
	if GlobalVars.fps_toggle == true:
		fps.visible = true
	else:
		fps.visible = false
	GlobalVars.toggle_fps.connect(_on_toggle_fps)
	

func _process(delta: float) -> void:
	fps.text = str(Engine.get_frames_per_second())

func _on_toggle_fps(toggled : bool):
	if toggled == false:
		set_process(false)
		fps.visible = false
	else:
		set_process(true)
		fps.visible = true
