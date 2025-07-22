extends CanvasLayer

@export var messages : Control

signal messages_default

func _on_messages_visibility_changed():
	await get_tree().process_frame
	if messages.visible == true:
		emit_signal("messages_default")
