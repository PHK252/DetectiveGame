extends SubViewportContainer

@onready var black_fade_rect := $SubViewport/ColorRect
@onready var tween := get_tree().create_tween()

func _ready():
	# Ensure black fade starts visible
	black_fade_rect.modulate.a = 1.0
	# Fade in over 2 seconds
	tween.tween_property(black_fade_rect, "modulate:a", 0.0, 2.0)
