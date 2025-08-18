extends TextureButton

@export var label : RichTextLabel
@export var info : String
@export var need_upper: bool = true

var placeholder_text = "ADDITIONAL INFORMATION WILL APPEAR HERE."


func _on_mouse_entered():
	if need_upper == true:
		label.text = info.to_upper()
	else:
		label.text = info


func _on_mouse_exited():
	label.text = placeholder_text
