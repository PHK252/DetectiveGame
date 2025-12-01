extends TextureButton

@export var menu : Control
@export var label : String
@export var index : int
@onready var text_label = $RichTextLabel


signal select(label: String, index : int)

func _ready():
	text_label.text = label

func _on_pressed():
	emit_signal("select", label, index)


func _on_mouse_entered():
	if menu.selected != index:
		text_label.add_theme_color_override("default_color", Color(0.992,0.835,0.478,1.0))


func _on_mouse_exited():
	if menu.selected != index:
		text_label.add_theme_color_override("default_color", Color(0.898,0.678,0.18,1.0))
