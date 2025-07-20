extends CanvasLayer

@onready var scroll_container = $Messages/ScrollContainer
@onready var max_scroll = scroll_container.get_v_scroll_bar().max_value

func _ready():
	#sets messages to most recent first
	scroll_container.call_deferred("set_v_scroll", max_scroll)
