extends TextureButton

@export var title : RichTextLabel
@export var sub1 : RichTextLabel
@export var sub2 : RichTextLabel

@onready var pressed_color = Color(0.541, 0.537, 0.484)
@onready var norm_color = Color(0.663, 0.659, 0.608)

#func _on_mouse_entered():
	#title.add_theme_color_override("default_color", pressed_color) 
	#sub1.add_theme_color_override("default_color", pressed_color) 
	#sub2.add_theme_color_override("default_color", pressed_color) 
##$Label.add_color_override("font_color", "x")
#
#
#func _on_mouse_exited():
	#title.add_theme_color_override("default_color", norm_color) 
	#sub1.add_theme_color_override("default_color", norm_color) 
	#sub2.add_theme_color_override("default_color", norm_color) 
